---
description: SUSE Observability
---

# Open Telemetry Collector as a proxy

The normal configuration of the Opentelemetry Collector for tail-sampling traces can be found [here](collector.md)

The below configuration describes a deployment that only does batching, and no further processing of traces, metrics, 
or logs.  It is meant as a security proxy that exists outside the SUSE Observability cluster, but within trusted network
infrastructure.  Security credentials for the proxy and SUSE Observability can be set up separately, adding a layer of
authentication that does not reside with the caller, but with the host.

![AWS Lambda Instrumentation With Opentelemetry via proxy collector](/.gitbook/assets/otel/aws_nodejs_otel_proxy_collector_configuration.svg)

{% code title="otel-collector.yaml" lineNumbers="true" %}
```yaml
mode: deployment
presets:
   kubernetesAttributes:
      enabled: true
      # You can also configure the preset to add all the associated pod's labels and annotations to you telemetry.
      # The label/annotation name will become the resource attribute's key.
      extractAllPodLabels: true
extraEnvsFrom:
   - secretRef:
        name: open-telemetry-collector
image:
   # Temporary override for image tag, the helm chart has not been released yet
   tag: 0.97.0

config:
   receivers:
      otlp:
         protocols:
            grpc:
               endpoint: 0.0.0.0:4317
            http:
               endpoint: 0.0.0.0:4318

   exporters:
      # Exporter for traces to traffic mirror (used by the common config)
      otlp:
         endpoint: <url for opentelemetry ingestion by suse observability>
         auth:
            authenticator: bearertokenauth

   extensions:
      bearertokenauth:
         scheme: SUSEObservability
         token: "${env:API_KEY}"

   service:
      extensions: [health_check, bearertokenauth]
      pipelines:
         traces:
            receivers: [otlp]
            processors: [batch]
            exporters: [otlp]
         metrics:
            receivers: [otlp]
            processors: [batch]
            exporters: [otlp]
         logs:
            receivers: [otlp]
            processors: [batch]
            exporters: [otlp]

ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: ingress-nginx-external
    nginx.ingress.kubernetes.io/ingress.class: ingress-nginx-external
    nginx.ingress.kubernetes.io/backend-protocol: GRPC
    # "12.34.56.78/32" IP address of NatGateway in the VPC where the otel data is originating from
    #  nginx.ingress.kubernetes.io/whitelist-source-range: "12.34.56.78/32"
  hosts:
    - host: "otlp-collector-proxy.${CLUSTER_NAME}"
      paths:
        - path: /
          pathType: ImplementationSpecific
          port: 4317
  tls:
    - secretName: ${CLUSTER_NODOT}-ecc-tls
      hosts:
        - "otlp-collector-proxy.${CLUSTER_NAME}"
```
{% endcode %}


### Ingress Source Range Whitelisting

To emphasize the role of the proxy collector as a security measure, it is recommended to use a source-range whitelist
to filter out data from untrusted and/or unknown sources.  In contrast, the SUSE Observability ingestion collector may 
have to accept data from multiple sources, maintaining a whitelist on that level does not scale well.