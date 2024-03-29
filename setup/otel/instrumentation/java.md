description: StackState Kubernetes Troubleshooting
---

# Instrumenting Java Applications

## Automatic instrumentation

Automatic instrumentation with Java uses a Java agent JAR that can be attached to any Java 8+ application. It dynamically injects bytecode to capture telemetry from many [popular libraries and frameworks](https://github.com/open-telemetry/opentelemetry-java-instrumentation/blob/main/docs/supported-libraries.md). It can be used to capture telemetry data at the “edges” of an app or service, such as inbound requests, outbound HTTP calls, database calls, and so on.

Automatic instrumentation does not require any modifications of the application. To set it up follow these steps:

1. Download [opentelemetry-javaagent.jar](https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar) from [Releases](https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases) of the opentelemetry-java-instrumentation repository and include the JAR file in the docker image of your application. The JAR file contains the agent and instrumentation libraries.
2. Update the command that starts your application to load the Java agent, either by updating the docker image entry-point or command or by updating the `command` in the Kubernetes manifest for your application. Add `-javaagent:/path/to/opentelemetry-javaagent.jar`:
```bash
java -javaagent:/path/to/opentelemetry-javaagent.jar -jar myapp.jar
```
3. Deploy your application with the extra environment variables [to configure the service name and exporter endpoint](./sdk-exporter-config.md).

For more details please refer to the [Open Telemetry documentation](https://opentelemetry.io/docs/languages/java/automatic/). 

## Manual instrumentation

Manual instrumentation can be used when you need metrics, traces or logs from parts of the code that are not supported by the auto instrumentation. For example unsupported libraries, in-house code or business level metrics. 

To capture that data you need to modify your application. 
1. Include the Open Telemetry SDK as a dependency
2. Add code to your application to capture metrics, spans or logs where needed

There is detailed documentation for this on the [Open Telemetry Java SDK doc pages](https://opentelemetry.io/docs/languages/java/instrumentation/). 

Make sure you use the the OTLP exporter (this is the default) and [auto-configuration](https://opentelemetry.io/docs/languages/java/instrumentation/#autoconfiguration). When deploying the application the service name and exporter are [configured via environment variables](./sdk-exporter-config.md).


