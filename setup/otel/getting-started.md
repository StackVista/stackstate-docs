---
description: Rancher Observability v6.0
---

# Getting Started with Open Telemetry

![Open Telemetry collector and 2 instrumented applications sending metrics and traces to Rancher Observability](/.gitbook/assets/otel/open-telemetry.svg)

Rancher Observability supports [Open Telemetry](https://opentelemetry.io/docs/what-is-opentelemetry/). Open Telemetry is a set of standardized protocols and an open-source framework to collect, transform and ship telemetry data such as traces, metrics and logs. Open telemetry supports a wide variety of programming languages and platforms. 

Rancher Observability has support for both metrics and traces and adds the Open Telemetry metrics and traces to the (Kubernetes) topology data that is provided by the Rancher Observability agent. Therefore it is still needed to also install the Rancher Observability agent. Support for logs and using Open Telemetry without the Rancher Observability agent is coming soon.

Open Telemetry consists of several different components. For usage with Rancher Observability, the [SDKs](./languages/README.md) to instrument your application and the [Open Telemetry collector](./collector.md) are the most important parts. We'll show how to configure both for usage with Rancher Observability.

If your application is already instrumented with Open Telemetry or with any other library that is supported by Open Telemetry, like Jaeger or Zipkin, the collector can be used to ship that data to Rancher Observability and no additional instrumentation is needed.

Rancher Observability requires the collector to be configured with specific processors and authentication to make sure all data used by Rancher Observability is available.

## References

* [Open Telemetry collector](https://opentelemetry.io/docs/collector/) on the Open Telemetry documentation
* [SDKs to instrument your application](https://opentelemetry.io/docs/languages/) on the Open Telemetry documentation