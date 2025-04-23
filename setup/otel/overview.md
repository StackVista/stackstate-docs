---
description: SUSE Observability
---

# Getting Started with Open Telemetry

![Open Telemetry collector and 2 instrumented applications sending metrics and traces to SUSE Observability](/.gitbook/assets/otel/open-telemetry.svg)

SUSE Observability supports [Open Telemetry](https://opentelemetry.io/docs/what-is-opentelemetry/). Open Telemetry is a set of standardized protocols and an open-source framework to collect, transform and ship telemetry data such as traces, metrics and logs. Open telemetry supports a wide variety of programming languages and platforms. 

SUSE Observability has support for both metrics and traces. When used in combination with the Kubernetes stackpack the Kubernetes pods will be enriched with traces when available. By installing the Open Telemetry stackpack new overview pages for services and service instances become available providing access to traces and span metrics. Open Telemetry metrics can be used in monitors and metric bindings. The stackpack comes with metric bindings for span metrics and .NET and JVM memory metrics. There are also out-of-the-box monitors for span error rates and duration.

The recommended setup for usage with SUSE Observability, is to instrument applications with the applicable Open Telemetry [SDKs](./instrumentation/README.md) and to install the [Open Telemetry collector](./collector.md) close to your instrumented applications to pre-process the data (enrich with Kubernetes labels, sampling on traces, etc.) and ship the data to SUSE Observability. The Open Telemetry Collector can also be used to collect metrics from many types of telemetry sources without instrumenting the applications using the SDKs. See the [Open Telemetry collector integrations](https://opentelemetry.io/ecosystem/registry/?language=collector) for more details and if your database or telemetry protocol is supported.

Follow the [getting started](./getting-started/README.md) guide to set up everything such that it works best with SUSE Observability.

## References

* [Open Telemetry collector](https://opentelemetry.io/docs/collector/) on the Open Telemetry documentation
* [Open Telemetry collector integrations](https://opentelemetry.io/ecosystem/registry/?language=collector)
* [SDKs to instrument your application](https://opentelemetry.io/docs/instrumentation/README.md) on the Open Telemetry documentation