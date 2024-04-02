description: StackState Kubernetes Troubleshooting
---

# Open Telemetry Collector

The OpenTelemetry Collector offers a vendor-agnostic implementation of how to receive, process and export telemetry data. Applications instrumented with Open Telemetry SDKs can use the collector to send telemetry data to StackState (traces and metrics). 

Your applications, when set up with OpenTelemetry SDKs, can use the collector to send telemetry data, like traces and metrics, straight to StackState. The collector is set up to receive this data by default via OTLP, the native open telemetry protocol. It can also receive data in other formats provided by other instrumentation SDKs like Jaeger and Zipkin for traces, and Influx and Prometheus for metrics.

Usually, the collector is running close to your application, like in the same Kubernetes cluster, making the process efficient.

For StackState integration, it's simple: StackState offers an OTLP endpoint using the gRPC protocol and uses bearer tokens for authentication. This means configuring your OpenTelemetry collector to send data to StackState is easy and standardized.

## Pre-requisites

1. A Kubernetes cluster with an application that is [instrumented with Open Telemetry](setup/otel/instrumentation/README.md)
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
* `<your-stackstate-host>` with the hostname of your StackState, for example `play.stackstate.com`.
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
      endpoint: <your-stackstate-host>:443
  processors:
    resource:
      attributes:
      - key: k8s.cluster.name
        action: upsert # Update or insert, some instrumentations add their own cluster name which may be different
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
  service:
    extensions:
      - health_check
      - bearertokenauth
    pipelines:
      logs: {}
      traces:
        receivers: [otlp]
        processors: [filter/dropMissingK8sAttributes, memory_limiter, resource, batch]
        exporters: [debug, spanmetrics, otlp/trafficmirror]
      metrics:
        receivers: [otlp, spanmetrics, prometheus]
        processors: [memory_limiter, resource, batch]
        exporters: [debug, otlp/trafficmirror]
```
{% end code %}

TODO: Detailed explanation of the different sections
TODO: Include tail sampling for spans by default?

### Create secret for the API key

The collector needs a Kubernetes secret with the StackState API key. Create that in the same namespace (here we are using the `open-telemetry` namespace) where the collector will be installed (replace `<stackstate-api-key>` with your API key):

```bash
kubectl create secret generic open-telemetry-collector \
    --namespace open-telemetry \
    --from-literal=API_KEY='<stackstate-api-key>' 
```

TODO: Where to get the api key?

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

Use the [generic configuration for the SDKs](./instrumentation/sdk-exporter-config.md) to export data to the collector. Follow the [language specific instrumentation instructions](./instrumentation/README.md) to enable the SDK for your applications.

## Related resources

The Open Telemetry documentation provides much more details on the configuration and alternative installation options:

- Open Telemetry Collector configuration: https://opentelemetry.io/docs/collector/configuration/
- Kubernetes installation of the collector: https://opentelemetry.io/docs/kubernetes/helm/collector/
- Using the Kubernetes operator instead of the collector Helm chart: https://opentelemetry.io/docs/kubernetes/operator/