---
description: SUSE Observability
---

# Getting Started with Open Telemetry on Kubernetes

Here is the setup we'll be creating, for an application that needs to be monitored:

* The monitored application / workload running in cluster A
* The Open Telemetry collector running near the observed application(s), so in cluster A, and sending the data to SUSE Observability
* SUSE Observability running in cluster B, or SUSE Cloud Observability

![Container instrumentation with Open Telemetry via collector running as Kubernetes deployment](/.gitbook/assets/otel/open-telemetry-collector-kubernetes.png)


## The Open Telemetry collector

{% hint style="info" %}
For a production setup it is strongly recommended to install the collector, since it allows your service to offload data quickly and the collector can take care of additional handling like retries, batching, encryption or even sensitive data filtering.
{% endhint %}

First we'll install the OTel (Open Telemetry) collector in cluster A. We configure it to:

* Receive data from, potentially many, instrumented applications
* Enrich collected data with Kubernetes attributes
* Generate metrics for traces
* Forward the data to SUSE Observability, including authentication using the API key

Next to that it will also retry sending data when there are connection problems.

### Create the namespace and a secret for the API key

We'll install in the `open-telemetry` namespace and use the receiver API key generated during installation (see [here](/use/security/k8s-ingestion-api-keys.md#api-keys) where to find it):

```bash
kubectl create namespace open-telemetry
kubectl create secret generic open-telemetry-collector \
    --namespace open-telemetry \
    --from-literal=API_KEY='<suse-observability-api-key>' 
```

### Configure and install the collector

We install the collector with a Helm chart provided by the Open Telemetry project. Make sure you have the Open Telemetry helm charts repository configured:

```bash
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
```

Create a `otel-collector.yaml` values file for the Helm chart. Here is a good starting point for usage with SUSE Observability, replace `<otlp-suse-observability-endpoint>` with your OTLP endpoint (see [OTLP API](../otlp-apis.md) for your endpoint) and insert the name for your Kubernetes cluster instead of `<your-cluster-name>`:

{% code title="otel-collector.yaml" lineNumbers="true" %}
```yaml
# Set the API key from the secret as an env var:
extraEnvsFrom:
  - secretRef:
      name: open-telemetry-collector
mode: deployment
image:
  # Use the collector container image that has all components important for k8s. In case of missing components the ghcr.io/open-telemetry/opentelemetry-collector-releases/opentelemetry-collector-contrib image can be used which
  # has all components in the contrib repository: https://github.com/open-telemetry/opentelemetry-collector-contrib
  repository: "ghcr.io/open-telemetry/opentelemetry-collector-releases/opentelemetry-collector-k8s"
ports:
  metrics:
    enabled: true
presets:
  kubernetesAttributes:
    enabled: true
    extractAllPodLabels: true
# This is the config file for the collector:
config:
  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: 0.0.0.0:4317
        http:
          endpoint: 0.0.0.0:4318
  extensions:
    # Use the API key from the env for authentication
    bearertokenauth:
      scheme: SUSEObservability
      token: "${env:API_KEY}"
  exporters:
    nop: {}
    otlp/suse-observability:
      auth:
        authenticator: bearertokenauth
      # Put in your own otlp endpoint
      endpoint: <otlp-suse-observability-endpoint>
      compression: snappy
  processors:
    memory_limiter:
      check_interval: 5s
      limit_percentage: 80
      spike_limit_percentage: 25
    batch: {}
    resource:
      attributes:
      - key: k8s.cluster.name
        action: upsert
        # Insert your own cluster name
        value: <your-cluster-name>
      - key: service.instance.id
        from_attribute: k8s.pod.uid
        action: insert
        # Use the k8s namespace also as the open telemetry namespace
      - key: service.namespace
        from_attribute: k8s.namespace.name
        action: insert
  connectors:
    # Generate metrics for spans
    spanmetrics:
      metrics_expiration: 5m
      namespace: otel_span
  service:
    extensions: [ health_check,  bearertokenauth ]
    pipelines:
      traces:
        receivers: [otlp]
        processors: [memory_limiter, resource, batch]
        exporters: [debug, spanmetrics, otlp/suse-observability]
      metrics:
        receivers: [otlp, spanmetrics, prometheus]
        processors: [memory_limiter, resource, batch]
        exporters: [debug, otlp/suse-observability]
      logs:
        receivers: [otlp]
        processors: []
        exporters: [nop]
```
{% endcode %}

{% hint style="warning" %}
**Use the same cluster name as used for installing the SUSE Observability agent** if you also use the SUSE Observability agent with the Kubernetes stackpack. Using a different cluster name will result in an empty traces perspective for Kubernetes components and will overall make correlating information much harder for SUSE Observability and your users.
{% endhint %}

Now install the collector, using the configuration file:

```bash
helm upgrade --install opentelemetry-collector open-telemetry/opentelemetry-collector \
  --values otel-collector.yaml \
  --namespace open-telemetry
```

The collector offers a lot more configuration receivers, processors and exporters, for more details see our [collector page](../collector.md). For production usage often large amounts of spans are generated and you will want to start setting up [sampling](../sampling.md).

## Collect telemetry data from your application

The common way to collect telemetry data is to instrument your application using the Open Telemetry SDK's. We've documented some quick start guides for a few languages, but there are many more:
* [Java](../instrumentation/java.md)
* [.NET](../instrumentation/dot-net.md)
* [Node.js](../instrumentation/node.js.md)

For other languages follow the documentation on [opentelemetry.io](https://opentelemetry.io/docs/languages/) and make sure to configure the SDK exporter to ship data to the collector you just installed by following [these instructions](../instrumentation/sdk-exporter-config.md).

## View the results
Go to SUSE Observability and make sure the Open Telemetry Stackpack is installed (via the main menu -> Stackpacks). 

After a short while and if your pods are getting some traffic you should be able to find them under their service name in the Open Telemetry -> services and service instances overviews. Traces will appear in the [trace explorer](/use/traces/k8sTs-explore-traces.md) and in the [trace perspective](/use/views/k8s-traces-perspective.md) for the service and service instance components. Span metrics and language specific metrics (if available) will become available in the [metrics perspective](/use/views/k8s-metrics-perspective.md) for the components.

If you also have the Kubernetes stackpack installed the instrumented pods will also have the traces available in the [trace perspective](/use/views/k8s-traces-perspective.md).

## Next steps
You can add new charts to components, for example the service or service instance, for your application, by following [our guide](/use/metrics/k8s-add-charts.md). It is also possible to create [new monitors](/use/alerting/k8s-monitors.md) using the metrics and setup [notifications](/use/alerting/notifications/configure.md) to get notified when your application is not available or having performance issues.

# More info

* [API keys](/use/security/k8s-ingestion-api-keys.md)
* [Open Telemetry API](../otlp-apis.md)
* [Customizing Open Telemetry Collector configuration](../collector.md)
* [Open Telemetry SDKs](../instrumentation/README.md)