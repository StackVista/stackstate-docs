# Set up traces

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

This how-to describes the steps to set up traces that can be viewed in the StackState [Traces Perspective](../../use/views/traces-perspective.md).

For traces to be available in StackState, the [StackState Agent V2 StackPack](../../stackpacks/integrations/agent.md) must be installed with one or more tracing integrations configured.

## 1\) Install StackState Agent V2

The StackState Agent V2 StackPack enables integration with external systems to receive trace data. You can check if it is installed on the StackPacks page in StackState. If it is not installed, follow the installation instructions on [StackState Agent V2 StackPack](../../stackpacks/integrations/agent.md).

## 2\) Configure tracing integrations

When the StackState Agent V2 StackPack is installed, you can configure integrations to receive trace data from external systems. One or more of the StackState Agent V2 integrations below can be configured to populate the Traces Perspective.

### AWS X-ray

The AWS integration collects tracing information from the in-built AWS distributed tracing system.  
[Configure AWS X-ray](../../stackpacks/integrations/aws-x-ray.md)

### DotNet APM

The DotNet APM integration enables instrumentation for DotNet applications and sends traces back to StackState.  
[Configure DotNet APM](../../stackpacks/integrations/dotnet-apm.md)

### Java APM

The Java APM integration enables tracing support for Java JVM based systems.  
[Configure Java APM](../../stackpacks/integrations/java-apm.md).

### Traefik `BETA`

The Traefik integration adds topology and telemetry information from Traefik to traces.  
[Configure Traefik](../../stackpacks/integrations/traefik.md)

{% hint style="info" %}
Full configuration details for each available StackState Agent V2 integration are also provided in the StackPacks section of the StackState GUI.
{% endhint %}

