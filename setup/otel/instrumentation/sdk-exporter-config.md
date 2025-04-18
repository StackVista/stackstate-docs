---
description: SUSE Observability
---

# Configuring SDK exporters

To send data to SUSE Observability the SDKs that are used to instrument your application use a built-in exporter. A production ready setup uses [a collector](#with-a-collector-production-setup) close to your instrumeneted applications to send the data to SUSE Observability, but it is also possible to have the instrumented application [directly send](#without-a-collector) the telemetry data to SUSE Observability.

## With a collector (production setup)

### SDK Exporter config for Kubernetes

All SDKs, regardless of the language, use the same basic configuration for defining the Open Telemetry [service name](https://opentelemetry.io/docs/concepts/glossary/#service) and the exporter endpoint (i.e. where the telemetry is sent).

These can be configured by setting environment variables for your instrumented application. 

In Kubernetes set these environment variables in the manifest for your workload (replace `<the-service-name>` with a name for your application service):

```yaml
...
spec:
  containers:
  - env:
    - name: OTEL_EXPORTER_OTLP_ENDPOINT 
      value: http://opentelemetry-collector.open-telemetry.svc.cluster.local:4317
    - name: OTEL_SERVICE_NAME
      value: <the-service-name>
    - name: OTEL_EXPORTER_OTLP_PROTOCOL
      value: grpc
...
```

The endpoint specified in the example assumes the collector was installed using the defaults from [the installation guide](../collector.md). It uses port `4317` which uses the `gRPC` version of the OTLP protocol. Some instrumentations only support HTTP, in that case, use port `4318`.

The service name can also be derived from Kubernetes labels that may already be present. For example like this:
```yaml
spec:
  containers:
  - env:
    - name: OTEL_SERVICE_NAME
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: metadata.labels['app.kubernetes.io/component']
```

### SDK Exporter config for other installations

To configure the SDK set these environment variables for your application:

```bash
export OTEL_EXPORTER_OTLP_ENDPOINT="http://<the-host-for-the-collector>:4317"
export OTEL_EXPORTER_OTLP_PROTOCOL="grpc"
export OTEL_SERVICE_NAME="<the-service-name>"
export OTEL_RESOURCE_ATTRIBUTES='service.namespace=<the-namespace>'
```

The example uses port `4317` which uses the `gRPC` version of the OTLP protocol. Some instrumentations only support HTTP, which uses port `4318` with the protocol set to `http`. Use the SDK documentation for your language to check which protocol the SDK supports. The `OTEL_EXPORTER_OLTP_ENDPOINT` and `OTEL_EXPORTER_OTLP_PROTOCOL` can be omitted, they have default values which send data to the preferred endpoint on the localhost.

The `OTEL_RESOURCE_ATTRIBUTES` is optional and, next to defining a service namespace, can be used to set more resource attributes in a comma-separated list.

### gRPC vs HTTP

OTLP, the Open Telemetry Protocol, supports gRPC and protobuf over HTTP. In the previous section, the exporter protocol is set to `gRPC`, this usually gives the best performance. Next to the SDK not supporting gRPC there can be other reasons to prefer HTTP:

* Some firewalls are not setup to handle gRPC
* (reverse) proxies and load balancers may not support gRPC without additional configuration
* gRPC's long-lived connections may cause problems when load-balancing.

To switch to HTTP instead of gRPC change the protocol to `http` *and* use port `4318`. 

To summarize, you can try to use HTTP in case gRPC is not working for you:

* `grpc` protocol uses port `4317` on the collector
* `http` protocol uses port `4318` on the collector

## Without a collector

In small test setups it can be convenient to directly send data from your instrumented application to SUSE Observability. The only difference from the collector setup documented above is to use a different value for `OTEL_EXPORTER_OTLP_ENDPOINT`:

* For gRPC use the OTLP endpoint for SUSE Observability, see the [OTLP APIs page](../otlp-apis.md).
* For HTTP use the OTLP over HTTP endpoint for SUSE Observability, see the [OTLP APIs page](../otlp-apis.md).

{% hint style="info" %}
Replace both the collector URL **and** the port with the SUSE Observability endpoints. Depending on your SUSE Observability installation the ports will be different.
{% endhint %}
