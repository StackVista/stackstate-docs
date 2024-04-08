---
description: StackState Kubernetes Troubleshooting
---

# Exporter config

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

## gRPC vs HTTP

OTLP, the Open Telemetry Protocol, supports gRPC and protobuf over HTTP. Some SDKs also support JSON over HTTP. In the previous section, the exporter protocol is set to `gRPC`, this usually gives the best performance and is the default for many SDKs. However, in some cases it may be problematic:

* Some firewalls are not setup to handle gRPC
* (reverse) proxies and load balancers may not support gRPC without additional configuration
* gRPC's long-lived connections may cause problems when load-balancing.

To switch to HTTP instead of gRPC change the protocol to `http` *and* use port `4318`. 

To summarize, use HTTP in case gRPC is given problems:

* `grpc` protocol uses port `4317`
* `http` protocol uses port `4318`
