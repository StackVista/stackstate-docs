---
description: StackState Kubernetes Troubleshooting
---

# Open Telemetry Collector

The OpenTelemetry Collector offers a vendor-agnostic implementation of how to receive, process and export telemetry data. Applications instrumented with Open Telemetry SDKs can use the collector to send telemetry data to StackState (traces and metrics). 

Your applications, when set up with OpenTelemetry SDKs, can use the collector to send telemetry data, like traces and metrics, straight to StackState. The collector is set up to receive this data by default via OTLP, the native open telemetry protocol. It can also receive data in other formats provided by other instrumentation SDKs like Jaeger and Zipkin for traces, and Influx and Prometheus for metrics.

Usually, the collector is running close to your application, like in the same Kubernetes cluster, making the process efficient.

For StackState integration, it's simple: StackState offers an OTLP endpoint using the gRPC protocol and uses bearer tokens for authentication. This means configuring your OpenTelemetry collector to send data to StackState is easy and standardized.

## Pre-requisites

1. A Kubernetes cluster with an application that is [instrumented with Open Telemetry](./languages/README.md)
2. An API key for StackState
3. Permissions to deploy the open telemetry collector in a namespace on the cluster (i.e. create resources like deployments and configmaps in a namespace). To be able to enrich the data with Kubernetes attributes permission is needed to create a [cluster role](https://github.com/open-telemetry/opentelemetry-helm-charts/blob/main/charts/opentelemetry-collector/templates/clusterrole.yaml) and role binding.

## Kubernetes configuration and deployment

To install and configure the collector for usage with StackState we'll use the [Open Telemetry Collector helm chart](https://opentelemetry.io/docs/kubernetes/helm/collector/) and add the configuration needed for StackState:

1. [Configure the collector](#configure-the-collector)
   1. helm chart configuration
   2. generating metrics from traces
   3. sending the data to StackState
   4. combine it all together in pipelines
2. [Create a Kubernetes secret for the StackState API key](#create-secret-for-the-api-key)
3. [Deploy the collector](#deploy-the-collector)
4. [Configure your instrumented applicatins to send telemetry to the collector](#configure-applications)

### Configure the collector

Here is the full values file needed, continue reading below the file for an explanation of the different parts. Or skip ahead to the next step, but make sure to replace:
* `<otlp-stackstate-endpoint>` with the OTLP endpoint of your StackState. If, for example, you access StackState on `play.stackstate.com` the OTLP endpoint is `otlp-play.stackstate.com`. So simply prefixing `otlp-` to the normal StackState url will do.
* `<your-cluster-name>` with the cluster name you configured in StackState, the same cluster name used when installing the StackState agent.

{% code title="otel-collector.yaml" lineNumbers="true" %}
```yaml
extraEnvsFrom:
  - secretRef:
      name: open-telemetry-collector
mode: deployment
ports:
  metrics:
    enabled: true
presets:
  kubernetesAttributes:
    enabled: true
    extractAllPodLabels: true
config:
  extensions:
    bearertokenauth:
      scheme: StackState
      token: "${env:API_KEY}"
  exporters:
    otlp/stackstate:
      auth:
        authenticator: bearertokenauth
      endpoint: <otlp-stackstate-endpoint>:443
  processors:
    resource:
      attributes:
      - key: k8s.cluster.name
        action: upsert
        value: <your-cluster-name>
      - key: service.instance.id
        from_attribute: k8s.pod.uid
        action: insert
    filter/dropMissingK8sAttributes:
      error_mode: ignore
      traces:
        span:
          - resource.attributes["k8s.node.name"] == nil
          - resource.attributes["k8s.pod.uid"] == nil
          - resource.attributes["k8s.namespace.name"] == nil
          - resource.attributes["k8s.pod.name"] == nil
  connectors:
    spanmetrics:
      metrics_expiration: 5m
      namespace: otel_span
  service:
    extensions:
      - health_check
      - bearertokenauth
    pipelines:
      logs: {}
      traces:
        receivers: [otlp]
        processors: [filter/dropMissingK8sAttributes, memory_limiter, resource, batch]
        exporters: [debug, spanmetrics, otlp/stackstate]
      metrics:
        receivers: [otlp, spanmetrics, prometheus]
        processors: [memory_limiter, resource, batch]
        exporters: [debug, otlp/stackstate]
```
{% end code %}

The `config` section customizes the collector config itself and is discussed in the next section. The other parts are:

* `extraEnvsFrom`: Sets environment variables from the specified secret, in the next step this secret is created for storing the StackState API key
* `mode`: Run the collector as a Kubernetes deployment, when to use the other modes is discussed [here](https://opentelemetry.io/docs/kubernetes/helm/collector/).
* `ports`: Used to enable the metrics port such that the collector can scrape its own metrics
* `presets`: Used to enable the default configuration for adding Kubernetes metadata as attributes, this includes Kubernetes labels and metadat like namespace, pod, deployment etc. Enabling the metadata also introduces the cluster role and role binding mentioned in the pre-requisites.

#### Configuration

The `service` section determines what components of the collector are enabled. The configuration for those components comes from the other sections (extensions, receivers, connectors, processors and exporters). The `extensions` section enables:
* `health_check`, doesn't need additional configuration but adds an endpoint for Kubernetes liveness and readiness probes
* `bearertokenauth`, this extension adds an authentication header to each request with the StackState API key. In its configuration we can see it is getting the StackState API key from the environment variable `API_KEY`.

The `pipelines` section defines pipelines for the 3 possible types of data. Here we disable the `logs` pipeline, StackState doesn't support that yet. 

For both traces and metrics a pipeline is defined. The metrics pipeline defines:
* `receivers`, to receive metrics from instrumented applications (via the OTLP protocol, `otlp`), from spans (the `spanmetrics` connector) and by scraping Prometheus endpoints (the `prometheus` receiver). The latter is configured by default in the collector Helm chart to scrape the collectors own metrics
* `processors`: The `memory_limiter` helps to prevent out-of-memory errors. The `batch` processor helps better compress the data and reduce the number of outgoing connections required to transmit the data. The `resource` processor adds additional resource attributes (discussed separately)
* `exporters`: The `debug` exporter simply logs to stdout which helps when troubleshooting. The `otlp/stackstate` exporter sends telemetry data to StackState using the OTLP protocol. It is configured to use the bearertokenauth extension for authentication to send data to the StackState OTLP endpoint.

For traces the pipeline looks very similar:
* `receivers`: Only receives traces from instrumented applications over OTLP
* `processors`: All the same processors are used as for metrics, but additionally a `filter/dropMissingK8sAttributes` is included. This filter is configured to remove all trace spans for which no complete set of Kubernetes metadata could be added. StackState needs the Kubernetes attributes, so spans without these attributes are not needed.
* `exporters`: Again the same exporters as for metrics but also the `spanmetrics` connector appears as an exporter. Connectors can be used to generate one data type from another, in this case metrics from spans (`otel_span_duration` and `otel_span_calls`). It is configured to not report time series anymore when no spans have been observed for 5 minutes. StackState expects the span metrics to be prefixed with `otel_span_`, which is taken care of by the `namespace` configuration.

The `resource` processor is also configured for both metrics and traces. It adds extra resource attributes:

* The `k8s.cluster.name` is added by providing the cluster name in the configuration. StackState needs the cluster name and Open Telemetry does not have a consistent way of determining it. Because some SDKs, in some environments, provide a cluster name that does not match what StackState expects the cluster name is an `upsert` (overwrites any pre-existing value).
* The `service.instance.id` is added based on the pod uid. It is recommended to always provide a service instance id, and the pod uid is an easy way to get a unique identifier if the SDKs don't provide one.

### Create secret for the API key

The collector needs a Kubernetes secret with the StackState API key. Create that in the same namespace (here we are using the `open-telemetry` namespace) where the collector will be installed (replace `<stackstate-api-key>` with your API key):

```bash
kubectl create secret generic open-telemetry-collector \
    --namespace open-telemetry \
    --from-literal=API_KEY='<stackstate-api-key>' 
```

You can find the API key for StackState on the Kubernetes Stackpack installation screen:

1. Open StackState
2. Navigate to StackPacks and select the Kubernetes StackPack
3. Open one of the installed instances
4. Scroll down to the first set of installation instructions. It shows the API key as `STACKSTATE_RECEIVER_API_KEY` in text and as `'stackstate.apiKey'` in the command.
  
### Deploy the collector

To deploy the collector first make sure you have the Open Telmetry helm charts repository configured:

```bash
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
```

Now install the collector, using configuration defined in the previous steps:

```bash
helm upgrade --install opentelemetry-collector open-telemetry/opentelemetry-collector \
  --values otel-collector.yaml \
  --namespace open-telemetry
```

### Configure applications

The collector as it is configured now is ready to receive and send telemetry data. The only thing left to do is to update the SDK configuration for your applications to send their telemetry via the collector to the agent.

Use the [generic configuration for the SDKs](./languages/sdk-exporter-config.md) to export data to the collector. Follow the [language specific instrumentation instructions](./languages/README.md) to enable the SDK for your applications.

## Related resources

The Open Telemetry documentation provides much more details on the configuration and alternative installation options:

- Open Telemetry Collector configuration: https://opentelemetry.io/docs/collector/configuration/
- Kubernetes installation of the collector: https://opentelemetry.io/docs/kubernetes/helm/collector/
- Using the Kubernetes operator instead of the collector Helm chart: https://opentelemetry.io/docs/kubernetes/operator/