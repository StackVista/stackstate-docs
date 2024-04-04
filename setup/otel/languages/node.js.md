---
description: StackState Kubernetes Troubleshooting
---

# Instrumenting  Node.js Applications

## Automatic instrumentation

Automatic instrumentation for Node.js is done by including the automatic instrumentation Javascript libraries with your application. A wide range of [libraries and frameworks is supported](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/metapackages/auto-instrumentations-node#supported-instrumentations).

Automatic instrumentation does not require any modifications of the application. To set it up follow these steps:

1. Add the Open Telemetry instrumentation SDK to your application:
```bash
npm install --save @opentelemetry/api
npm install --save @opentelemetry/auto-instrumentations-node
```
2. Update the command that starts your application to load the Java agent, either by updating the docker image entry-point or command or by updating the `command` in the Kubernetes manifest for your application. Add `--require @opentelemetry/auto-instrumentations-node/register`:
```bash
node --require @opentelemetry/auto-instrumentations-node/register app.js
```
3. Deploy your application with the extra environment variables [to configure the service name and exporter endpoint](./sdk-exporter-config.md).
4. [Verify](./verify.md) StackState is receiving traces and/or metrics

For more details please refer to the [Open Telemetry documentation](https://opentelemetry.io/docs/languages/js/automatic/). 

{% hint style="warning" %}
The auto instrumentation configured via environment variables only supports traces until this [Open Telemetry issue](https://github.com/open-telemetry/opentelemetry-js/issues/4551) is resolved. To enable metrics from the automatic instrumentation code changes are needed. Please follow the instructions in the [Open Telemetry documentation](https://opentelemetry.io/docs/languages/js/exporters/#usage-with-nodejs) to make these changes. 
{% endhint %}

## Manual instrumentation

Manual instrumentation can be used when you need metrics, traces or logs from parts of the code that are not supported by the auto instrumentation. For example unsupported libraries, in-house code or business level metrics. 

To capture that data you need to modify your application. 
1. Include the Open Telemetry SDK as a dependency
2. Add code to your application to capture metrics, spans or logs where needed

There is detailed documentation for this on the [Open Telemetry Javascript SDK doc pages](https://opentelemetry.io/docs/languages/js/instrumentation/). 

Make sure you use the the OTLP exporter and to configure the exporter endpoint correctly from the code. See also the [Open Telemetry documentation](https://opentelemetry.io/docs/languages/js/exporters/#usage-with-nodejs). Assuming you set up the exporter as [documented](../collector.md) the endpoint that needs to be configured is `http://opentelemetry-collector.open-telemetry.svc.cluster.local:4317`, using gRPC. See also [gRPC vs HTTP](./sdk-exporter-config.md#grpc-vs-http) in case gRPC is problematic.