---
description: SUSE Observability
---

# SUSE Observabilty Open Telemetry Protocol support

SUSE Observability supports 2 versions of the OTLP protocol, the `grpc` version (also referred to as OTLP) and `http/protobuf` (also referred to as OTLP over HTTP). In the collector configuration you can choose which exporter to use, but make sure to configure the correcct URL for SUSE Observability. The `grpc` version of the protocol is preferred, it allows for larger payloads and higher throughput. But in case of poor support for `grpc` in your infra-structure you can switch to the HTTP version. See also [troubleshooting](./troubleshooting.md#some-proxies-and-firewalls-dont-work-well-with-grpc)

## SUSE Cloud Observability

The endpoints for SUSE Cloud Observability are:

* OTLP: `https://otlp-<your-suse-observabillity>.app.stackstate`.com:443
* OTLP over HTTP: `https://otlp-http-<your-suse-observabillity>`.app.stackstate.com

## Self-hosted SUSE Observability

For a self-hosted installation you need to enable one of the endpoints, or both, by configuring the ingress for SUSE Observability as [described here](../install-stackstate/kubernetes_openshift/ingress.md#configure-ingress-rule-for-open-telemetry).

When SUSE Observability is running in the same cluster as the collector you can also use it without ingress by using the service endpoints:
* OTLP: `http://suse-observability-otel-collector.<namespace>.svc.cluster.local:4317`
* OTLP over HTTP: `http://suse-observability-otel-collector.<namespace>.svc.cluster.local:4318`

Make sure to set `insecure: true` in the collector configuration (see next section) to allow the usage of plain http endpoints instead of https.

## Collector configuration

The examples in the collector configuration use the OTLP protocol like this:

```
extensions:
  bearertokenauth:
    scheme: SUSEObservability
    token: "${env:API_KEY}"
exporters:
  otlp/suse-observability:
    auth:
      authenticator: bearertokenauth
    endpoint: <otlp-suse-observability-endpoint>
    # Optional TLS configurations:
    #tls:
    # To disable TLS entirely:
    #  insecure: true
    # To disable certificate verification (but still use TLS):
    #  insecure_skip_verify: true
```

To use the OTLP over HTTP protocol instead use the `otlphttp` exporter instead. Don't forget to update the exporter references, `otlp/suse-observability`, in your pipelines to `otlphttp/suse-observability`!

```
extensions:
  bearertokenauth:
    scheme: SUSEObservability
    token: "${env:API_KEY}"
exporters:
  otlphttp/stackstate:
    auth:
      authenticator: bearertokenauth
    endpoint: <otlp-http-suse-observability-endpoint>
    # Optional TLS configurations:
    #tls:
    # To disable TLS entirely:
    #  insecure: true
    # To disalbe certificate verification (but still use TLS):
    #  insecure_skip_verify: true
```

There is more configuration available to control the exact requirements and behavior of the exporter. For example it is also possible to use a custom CA root certificate or to enable client certificates. See the [OTLP exporter documentation](https://github.com/open-telemetry/opentelemetry-collector/blob/main/exporter/otlpexporter/README.md) for the details.
