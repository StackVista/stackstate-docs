---
description: SUSE Observability
---

# Getting Started with Open Telemetry

Here is the setup we'll be creating, for an application that needs to be monitored:

* The monitored application / workload running on a Linux host
* The Open Telemetry collector running on the same Linux host
* SUSE Observability or SUSE Cloud Observability

![Application instrumentation on a linux host with Open Telemetry collector running on the host](/.gitbook/assets/otel/open-telemetry-collector-linux.png)

## Install the Open Telemetry collector

{% hint style="info" %}
For a production setup it is strongly recommended to install the collector, since it allows your service to offload data quickly and the collector can take care of additional handling like retries, batching, encryption or even sensitive data filtering.
{% endhint %}

First we'll install the collector. We configure it to:

* Receive data from, potentially many, instrumented applications
* Enrich collected data with host attributes
* Generate metrics for traces
* Forward the data to SUSE Observability, including authentication using the API key

Next to that it will also retry sending data when there are a connection problems.

### Configure and install the collector

### Install and configure the collector

The collector provides packages (apk, deb and rpm) for most Linux versions and architectures and it uses `systemd` for automatic service configuration. To install it find the [latest release on Github](https://github.com/open-telemetry/opentelemetry-collector-releases/releases) and update the URL in the example to use the latest version:

{% tabs %}
{% tab title="DEB AMD64" %}
```bash
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.123.1/otelcol-contrib_0.123.1_linux_amd64.deb
sudo dpkg -i otelcol-contrib_0.123.1_linux_amd64.deb
```
{% endtab %}
{% tab title="DEB ARM64" %}
```bash
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.123.1/otelcol-contrib_0.123.1_linux_arm64.deb
sudo dpkg -i otelcol-contrib_0.123.1_linux_arm64.deb
```
{% endtab %}
{% tab title="RPM AMD64" %}
```bash
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.123.1/otelcol-contrib_0.123.1_linux_amd64.rpm
sudo rpm -iv1 otelcol-contrib_0.123.1_linux_amd64.rpm
```
{% endtab %}
{% tab title="RPM ARM64" %}
```bash
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.123.1/otelcol-contrib_0.123.1_linux_arm64.rpm
sudo rpm -iv1 otelcol-contrib_0.123.1_linux_arm64.rpm
```
{% endtab %}
{% endtabs %}

For other installation options use the [Open Telemetry instructions](https://opentelemetry.io/docs/collector/installation/#linux).

After installation modify the collector configuration by editing `/etc/otelcol-contrib/config.yaml`. Change the file such that it looks like the `config.yaml` example here, replace `<otlp-suse-observability-endpoint>` with your OTLP endpoint (see [OTLP API](../otlp-apis.md) for your endpoint) and insert your receiver api key for `<receiver-api-key>` (see [here](/use/security/k8s-ingestion-api-keys.md#api-keys) where to find it):

{% code title="config.yaml" lineNumbers="true" %}
```yaml
receivers:
  otlp:
    protocols:
      # Only bind to localhost to keep the collector secure, see https://github.com/open-telemetry/opentelemetry-collector/blob/main/docs/security-best-practices.md#safeguards-against-denial-of-service-attacks
      grpc:
        endpoint: 127.0.0.1:4317
      http:
        endpoint: 127.0.0.1:4318
  # Collect own metrics
  prometheus:
    config:
      scrape_configs:
      - job_name: 'otel-collector'
        scrape_interval: 10s
        static_configs:
        - targets: ['0.0.0.0:8888']
extensions:
  health_check: {}
  pprof:
    endpoint: 0.0.0.0:1777
  zpages:
    endpoint: 0.0.0.0:55679
  # Use the API key from the env for authentication
  bearertokenauth:
    scheme: SUSEObservability
    token: "<receiver-api-key>"
exporters:
  nop: {}
  debug: {}
  otlp/suse-observability:
    compression: snappy
    auth:
      authenticator: bearertokenauth
    # Put in your own otlp endpoint
    endpoint: <otlp-suse-observability-endpoint>
processors:
  memory_limiter:
    check_interval: 5s
    limit_percentage: 80
    spike_limit_percentage: 25
  batch: {}
  # Optionally include resource information from the system running the collector
  resourcedetection/system:
    detectors: [env, system] # Replace system with gcp, ec2, azure when running in cloud environments
    system:
      hostname_sources: ["os"]
connectors:
  # Generate metrics for spans
  spanmetrics:
    metrics_expiration: 5m
    namespace: otel_span
service:
  extensions: [ bearertokenauth, health_check, pprof, zpages ]
  pipelines:
    traces:
      receivers: [otlp]
      processors: [memory_limiter, resourcedetection/system, batch]
      exporters: [debug, spanmetrics, otlp/suse-observability]
    metrics:
      receivers: [otlp, spanmetrics, prometheus]
      processors: [memory_limiter, batch, resourcedetection/system]
      exporters: [debug, otlp/suse-observability]
    logs:
      receivers: [otlp]
      processors: []
      exporters: [nop]
```
{% endcode %}

Finally restart the collector:

```bash
sudo systemctl restart otelcol-contrib
```

To see the logs of the collector use:
```bash
sudo journalctl -u otelcol-contrib
```

## Collect telemetry data from your application

The common way to collect telemetry data is to instrument your application using the Open Telemetry SDK's. We've documented some quick start guides for a few languages, but there are many more:
* [Java](../instrumentation/java.md)
* [.NET](../instrumentation/dot-net.md)
* [Node.js](../instrumentation/node.js.md)

No additional configuration is needed for the SDKs, they export to localhost via OTLP or OTLP over HTTP (depending on the supported protocols) by default.

For other languages follow the documentation on [opentelemetry.io](https://opentelemetry.io/docs/languages/). 

## View the results
Go to SUSE Observability and make sure the Open Telemetry Stackpack is installed (via the main menu -> Stackpacks). 

After a short while and if your application is processing some traffic you should be able to find it under its service name in the Open Telemetry -> services and service instances overviews. Traces will appear in the [trace explorer](/use/traces/k8sTs-explore-traces.md) and in the [trace perspective](/use/views/k8s-traces-perspective.md) for the service and service instance components. Span metrics and language specific metrics (if available) will become available in the [metrics perspective](/use/views/k8s-metrics-perspective.md) for the components.

## Next steps
You can add new charts to components, for example the service or service instance, for your application, by following [our guide](/use/metrics/k8s-add-charts.md). It is also possible to create [new monitors](/use/alerting/k8s-monitors.md) using the metrics and setup [notifications](/use/alerting/notifications/configure.md) to get notified when your application is not available or having performance issues.

# More info

* [API keys](/use/security/k8s-ingestion-api-keys.md)
* [Open Telemetry API](../otlp-apis.md)
* [Customizing Open Telemetry Collector configuration](../collector.md)
* [Open Telemetry SDKs](../instrumentation/README.md)