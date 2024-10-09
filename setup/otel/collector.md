---
description: SUSE Observability
---

# Open Telemetry Collector

The OpenTelemetry Collector offers a vendor-agnostic implementation to receive, process and export telemetry data. Applications instrumented with Open Telemetry SDKs can use the collector to send telemetry data to SUSE Observability (traces and metrics). 

Your applications, when set up with OpenTelemetry SDKs, can use the collector to send telemetry data, like traces and metrics, straight to SUSE Observability. The collector is set up to receive this data by default via OTLP, the native open telemetry protocol. It can also receive data in other formats provided by other instrumentation SDKs like Jaeger and Zipkin for traces, and Influx and Prometheus for metrics.

Usually, the collector is running close to your application, like in the same Kubernetes cluster, making the process efficient.

For SUSE Observability integration, it's simple: SUSE Observability offers an OTLP endpoint using the gRPC protocol and uses bearer tokens for authentication. This means configuring your OpenTelemetry collector to send data to SUSE Observability is easy and standardized.

## Pre-requisites

1. A Kubernetes cluster with an application that is [instrumented with Open Telemetry](./languages/README.md)
2. An API key for SUSE Observability
3. Permissions to deploy the open telemetry collector in a namespace on the cluster (i.e. create resources like deployments and configmaps in a namespace). To be able to enrich the data with Kubernetes attributes permission is needed to create a [cluster role](https://github.com/open-telemetry/opentelemetry-helm-charts/blob/main/charts/opentelemetry-collector/templates/clusterrole.yaml) and role binding.

## Kubernetes configuration and deployment

To install and configure the collector for usage with SUSE Observability we'll use the [Open Telemetry Collector helm chart](https://opentelemetry.io/docs/kubernetes/helm/collector/) and add the configuration needed for SUSE Observability:

1. [Configure the collector](#configure-the-collector)
   1. helm chart configuration
   2. generating metrics from traces
   3. sending the data to SUSE Observability
   4. combine it all together in pipelines
2. [Create a Kubernetes secret for the SUSE Observability API key](#create-secret-for-the-api-key)
3. [Deploy the collector](#deploy-the-collector)
4. [Configure your instrumented applicatins to send telemetry to the collector](#configure-applications)

### Configure the collector

Here is the full values file needed, continue reading below the file for an explanation of the different parts. Or skip ahead to the next step, but make sure to replace:
* `<otlp-stackstate-endpoint>` with the OTLP endpoint of your SUSE Observability. If, for example, you access SUSE Observability on `play.stackstate.com` the OTLP endpoint is `otlp-play.stackstate.com`. So simply prefixing `otlp-` to the normal SUSE Observability url will do.
* `<your-cluster-name>` with the cluster name you configured in SUSE Observability. **This must be the same cluster name used when installing the SUSE Observability agent**. Using a differnt cluster name will result in an empty traces perspective for Kubernetes components.

{% hint style="warning" %}
The Kubernetes attributes and the span metrics namespace are required for SUSE Observability to provide full functionality.
{% endhint %}

{% hint style="info" %}
The suggested configuration includes tail sampling for traces. Sampling can be fully customized and, depending on your applications and the volume of traces, it may be needed to [change this configuration](#trace-sampling). For example an increase (or decrease) in `max_total_spans_per_second`. It is highly recommended to keep sampling enabled to keep resource usage and cost under control.
{% endhint %}

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
      scheme: SUSEObservability
      token: "${env:API_KEY}"
  exporters:
    otlp/stackstate:
      auth:
        authenticator: bearertokenauth
      endpoint: <otlp-stackstate-endpoint>:443
  processors:
    tail_sampling:
      decision_wait: 10s
      policies:
      - name: rate-limited-composite
        type: composite
        composite:
          max_total_spans_per_second: 500
          policy_order: [errors, slow-traces, rest]
          composite_sub_policy:
          - name: errors
            type: status_code
            status_code: 
              status_codes: [ ERROR ]
          - name: slow-traces
            type: latency
            latency:
              threshold_ms: 1000
          - name: rest
            type: always_sample
          rate_allocation:
          - policy: errors
            percent: 33
          - policy: slow-traces
            percent: 33
          - policy: rest
            percent: 34
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
    routing/traces:
      error_mode: ignore
      match_once: false
      table: 
      - statement: route()
        pipelines: [traces/sampling, traces/spanmetrics]
  service:
    extensions:
      - health_check
      - bearertokenauth
    pipelines:
      traces:
        receivers: [otlp]
        processors: [filter/dropMissingK8sAttributes, memory_limiter, resource]
        exporters: [routing/traces]
      traces/spanmetrics:
        receivers: [routing/traces]
        processors: []
        exporters: [spanmetrics]
      traces/sampling:
        receivers: [routing/traces]
        processors: [tail_sampling, batch]
        exporters: [debug, otlp/stackstate]
      metrics:
        receivers: [otlp, spanmetrics, prometheus]
        processors: [memory_limiter, resource, batch]
        exporters: [debug, otlp/stackstate]
```
{% endcode %}

The `config` section customizes the collector config itself and is discussed in the next section. The other parts are:

* `extraEnvsFrom`: Sets environment variables from the specified secret, in the next step this secret is created for storing the SUSE Observability API key (Receiver / [Ingestion API Key](../../use/security/k8s-ingestion-api-keys.md))
* `mode`: Run the collector as a Kubernetes deployment, when to use the other modes is discussed [here](https://opentelemetry.io/docs/kubernetes/helm/collector/).
* `ports`: Used to enable the metrics port such that the collector can scrape its own metrics
* `presets`: Used to enable the default configuration for adding Kubernetes metadata as attributes, this includes Kubernetes labels and metadata like namespace, pod, deployment etc. Enabling the metadata also introduces the cluster role and role binding mentioned in the pre-requisites.

#### Configuration

The `service` section determines what components of the collector are enabled. The configuration for those components comes from the other sections (extensions, receivers, connectors, processors and exporters). The `extensions` section enables:
* `health_check`, doesn't need additional configuration but adds an endpoint for Kubernetes liveness and readiness probes
* `bearertokenauth`, this extension adds an authentication header to each request with the SUSE Observability API key. In its configuration, we can see it is getting the SUSE Observability API key from the environment variable `API_KEY`.

The `pipelines` section defines pipelines for the traces and metrics. The metrics pipeline defines:
* `receivers`, to receive metrics from instrumented applications (via the OTLP protocol, `otlp`), from spans (the `spanmetrics` connector) and by scraping Prometheus endpoints (the `prometheus` receiver). The latter is configured by default in the collector Helm chart to scrape the collectors own metrics
* `processors`: The `memory_limiter` helps to prevent out-of-memory errors. The `batch` processor helps better compress the data and reduce the number of outgoing connections required to transmit the data. The `resource` processor adds additional resource attributes (discussed separately)
* `exporters`: The `debug` exporter simply logs to stdout which helps when troubleshooting. The `otlp/stackstate` exporter sends telemetry data to SUSE Observability using the OTLP protocol. It is configured to use the bearertokenauth extension for authentication to send data to the SUSE Observability OTLP endpoint.

For traces, there are 3 pipelines that are connected:
* `traces`: The pipeline that receives traces from SDKs (via the `otlp` receiver) and does the initial processing using the same processors as for metrics. It exports into a router which routes all spans to both other traces pipelines. This setup makes it possible to calculate span metrics for all spans while applying sampling to the traces that are exported.
* `traces/spanmetrics`: Use the `spanmetrics` connector as an exporter to generate metrics from the spans  (`otel_span_duration` and `otel_span_calls`). It is configured to not report time series anymore when no spans have been observed for 5 minutes. SUSE Observability expects the span metrics to be prefixed with `otel_span_`, which is taken care of by the `namespace` configuration.
* `traces/sampling`: The pipeline that exports traces to SUSE Observability using the OTLP protocol, but uses the tail sampling processor to make the trace volume that is sent to SUSE Observability predictable to keep the cost predictable as well. Sampling is discussed in a [separate section](#trace-sampling).

The `resource` processor is configured for both metrics and traces. It adds extra resource attributes:

* The `k8s.cluster.name` is added by providing the cluster name in the configuration. SUSE Observability needs the cluster name and Open Telemetry does not have a consistent way of determining it. Because some SDKs, in some environments, provide a cluster name that does not match what SUSE Observability expects the cluster name is an `upsert` (overwrites any pre-existing value).
* The `service.instance.id` is added based on the pod uid. It is recommended to always provide a service instance id, and the pod uid is an easy way to get a unique identifier if the SDKs don't provide one.

#### Trace Sampling

It is highly recommended to use sampling for traces:

* To manage resource usage by only processing and storing the most relevant traces
* To manage costs and have predictable costs
* To reduce noise and focus on the important traces only, for example by filtering out health checks

There are 2 approaches for sampling, head sampling and tail sampling. This [Open Telemetry docs page](https://opentelemetry.io/docs/concepts/sampling/) discusses the pros and cons of both approaches in detail. The collector configuration provided here uses tail sampling to support these requirements:

1. Have predictable cost by having a predictable trace volume
2. Have a large sample of all errors
3. Have a large sample of all slow traces
4. Have a sample of all other traces to see the normal application behavior

Criteria 2 and 3 can only be fulfilled by tail sampling. Let's look at the sampling policies used in the configuration of the tail sampler now:

* There is only one top-level policy, it is a `composite` policy. It uses a rate limit, allowing at most 500 traces per second, giving a predictable trace volume. It uses other policies as sub-policies to make the actual sampling decissions.
* The `errors` policy is of type `status_code` and is configured to only sample traces that contain errors. 33% of the rate limit is reserved for errors, via the `rate_allocation` section of the composite policy.
* The `slow-traces` policy is of type `latency` and filters all traces slower than 1 second. 33% of the rate limits is reserved for the slow traces.
* The `rest` policy is of the `always_sample` type. It will sample all traces until it hits the rate limit enforced by the composite policy, which is 34% of the total rate limit of 500 traces.

There are many more policies available that can be added to the configuration when needed. For example, it is possible to filter traces based on certain attributes (only for a specific application or customer). The tail sampler can also be replaced with the probabilistic sampler. For all configuration options please use the documentation of these processors:
* [Tail sampling](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/tailsamplingprocessor)
* [Probabilistic sampling](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/probabilisticsamplerprocessor)

### Create a secret for the API key

The collector needs a Kubernetes secret with the SUSE Observability API key. Create that in the same namespace (here we are using the `open-telemetry` namespace) where the collector will be installed (replace `<stackstate-api-key>` with your API key):

```bash
kubectl create secret generic open-telemetry-collector \
    --namespace open-telemetry \
    --from-literal=API_KEY='<stackstate-api-key>' 
```

SUSE Observability supports two types of keys:
- Receiver API Key
- Ingestion API Key

#### Receiver API Key

You can find the API key for SUSE Observability on the Kubernetes Stackpack installation screen:

1. Open SUSE Observability
2. Navigate to StackPacks and select the Kubernetes StackPack
3. Open one of the installed instances
4. Scroll down to the first set of installation instructions. It shows the API key as `STACKSTATE_RECEIVER_API_KEY` in text and as `'stackstate.apiKey'` in the command.

#### Ingestion API Key

SUSE Observability supports creating multiple Ingestion Keys. This allows you to assign a unique key to each OpenTelemetry Collector for better security and access control.
For instructions on generating an Ingestion API Key, refer to the [documentation page](../../use/security/k8s-ingestion-api-keys.md).

### Deploy the collector

To deploy the collector first make sure you have the Open Telemetry helm charts repository configured:

```bash
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
```

Now install the collector, using the configuration defined in the previous steps:

```bash
helm upgrade --install opentelemetry-collector open-telemetry/opentelemetry-collector \
  --values otel-collector.yaml \
  --namespace open-telemetry
```

### Configure applications

The collector as it is configured now is ready to receive and send telemetry data. The only thing left to do is to update the SDK configuration for your applications to send their telemetry via the collector to the agent.

Use the [generic configuration for the SDKs](./languages/sdk-exporter-config.md) to export data to the collector. Follow the [language-specific instrumentation instructions](./languages/README.md) to enable the SDK for your applications.

## Related resources

The Open Telemetry documentation provides much more details on the configuration and alternative installation options:

- Open Telemetry Collector configuration: https://opentelemetry.io/docs/collector/configuration/
- Kubernetes installation of the collector: https://opentelemetry.io/docs/kubernetes/helm/collector/
- Using the Kubernetes operator instead of the collector Helm chart: https://opentelemetry.io/docs/kubernetes/operator/
- Open Telemetry sampling: https://opentelemetry.io/blog/2022/tail-sampling/