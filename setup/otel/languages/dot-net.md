---
description: StackState Kubernetes Troubleshooting
---

# .NET Applications

## Automatic instrumentation

Automatic instrumentation for .NET can automatically capture traces and metrics for a variety of [libraries and frameworks](https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/blob/main/docs/internal/instrumentation-libraries.md).

Automatic instrumentation does not require any modifications of the application. To set it up follow these steps:

1. Download the [glibc](https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/releases/latest/download/opentelemetry-dotnet-instrumentation-linux-glibc.zip) or [musl](https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/releases/latest/download/opentelemetry-dotnet-instrumentation-linux-musl.zip) version of the instrumentation libraries (musl for Alpine, glibc for most other docker images) from the [Releases](https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases) of the opentelemetry-dotnet-instrumentation repository. Unzip the files and include them in your application docker image in a directory, here we use `/autoinstrumentation`.
2. Set the following env vars, here we do it via the `env` of the container in the Kubernetes pod spec:
```yaml
env: 
- name: CORECLR_ENABLE_PROFILING
  value: "1"
- name: CORECLR_PROFILER
  value: "{918728DD-259F-4A6A-AC2B-B85E1B658318}"
- name: CORECLR_PROFILER_PATH
  # for glibc:
  value: "/autoinstrumentation/linux-x64/OpenTelemetry.AutoInstrumentation.Native.so"
  # For musl use instead:
  # value: "/autoinstrumentation/linux-musl-x64/OpenTelemetry.AutoInstrumentation.Native.so"
- name: DOTNET_ADDITIONAL_DEPS
  value: "/autoinstrumentation/AdditionalDeps"
- name: DOTNET_SHARED_STORE
  value: "/autoinstrumentation/store"
- name: DOTNET_STARTUP_HOOKS
  value: "/autoinstrumentation/net/OpenTelemetry.AutoInstrumentation.StartupHook.dll"
- name: OTEL_DOTNET_AUTO_HOME
  value: "/autoinstrumentation"
```
3. Also add the extra environment variables [to configure the service name and exporter endpoint](./sdk-exporter-config.md) on the pod.
4. Deploy your application with the changes
5. [Verify](./verify.md) StackState is receiving traces and/or metrics

For more details please refer to the [Open Telemetry documentation](https://opentelemetry.io/docs/languages/java/automatic/). 

## Manual instrumentation

Manual instrumentation can be used when you need metrics, traces or logs from parts of the code that are not supported by the auto instrumentation. For example unsupported libraries, in-house code or business-level metrics. 

To capture that data you need to modify your application. 
1. Include the Open Telemetry SDK as a dependency
2. Add code to your application to capture metrics, spans or logs where needed

There is detailed documentation for this on the [Open Telemetry .NET SDK doc pages](https://opentelemetry.io/docs/languages/net/instrumentation/). 

Make sure you use the OTLP exporter (this is the default) and [auto-configuration](https://opentelemetry.io/docs/languages/java/instrumentation/#autoconfiguration). When deploying the application the service name and exporter are [configured via environment variables](./sdk-exporter-config.md).

## Metrics in StackState

For some .NET  metrics, for example, garbage collector metrics, StackState has defined charts on the related components. For Kubernetes,the charts are available on the pods. It is possible to [add charts for more metrics](/use/metrics/k8s-add-charts.md), this works for metrics from automatic instrumentation but also for application-specific metrics from manual instrumentation.