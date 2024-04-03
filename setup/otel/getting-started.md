description: StackState Kubernetes Troubleshooting
---

# Getting Started with Open Telemetry

![Open Telemetry collector and 2 instrumented applications sending metrics and traces to StackState](/.gitbook/assets/otel/open-telemetry.svg)

StackState supports [Open Telemetry](https://opentelemetry.io/docs/what-is-opentelemetry/). Open Telemetry is a set of standardized protocols and an open source framework to collect, transform and ship telemetry data such as traces, metrics and logs. Open telemetry supports a wide variety of programming languages and platforms. 

StackState has support for both metrics and traces and adds the Open Telemetry metrics and traces to the (Kubernetes) topology data that is provided by the StackState agent. Therefore it is still needed to also install the StackState agent. Support for logs and using Open Telemetry without the StackState agent is coming soon.

Open Telemetry consists of several different components. For usage with StackState the [SDKs to instrument your application](https://opentelemetry.io/docs/languages/) and the [Open Telemetry collector](https://opentelemetry.io/docs/collector/) are the most important parts. We'll show how to configure both for usage with StackState.

If you're application is already instrumented with Open Telemetry or with any other library that is supported by Open Telemetry, like Jaeger or Zipkin, the collector can be used to ship that data to StackState and no additional instrumentation is needed.

StackState requires the collector to be configured with specific processors and authentication to make sure all data used by StackState is available.
