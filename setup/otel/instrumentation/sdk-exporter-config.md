description: StackState Kubernetes Troubleshooting
---

# Exporter config

All SDKs, regardless of the language, use the same basic configuration for defining the Open Telemetry [service name](https://opentelemetry.io/docs/concepts/glossary/#service) and the exporter endpoint (i.e. where the telemetry is sent).

These can be configured by setting environment variables for your instrumented application. 

In Kubernetes set these 2 environment variables in the manifest for your workload (replace `<the-service-name>` with a name for your application service):

```yaml
...
spec:
  containers:
  - env:
    - name: OTEL_EXPORTER_OTLP_ENDPOINT 
      value: http://opentelemetry-collector.open-telemetry.svc.cluster.local:4317
    - name: OTEL_SERVICE_NAME
      value: <the-service-name>
...
```

The endpoint specified in the example assumes the collector was installed using the defaults from [the installation guide](../collector.md). It uses port `4317` which uses the `gRPC` version of the OTLP protocol. Some instrumentations only support HTTP, in that case use port `4318`.

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
