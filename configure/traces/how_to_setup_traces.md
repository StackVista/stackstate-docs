---
description: StackState Self-hosted v4.5.x
---

# Set up traces

{% hint style="info" %}
[Go to the StackState SaaS docs site](https://docs.stackstate.com/v/stackstate-saas/).
{% endhint %}

This how-to describes the steps to set up traces that can be viewed in the StackState [Traces Perspective](../../use/stackstate-ui/perspectives/traces-perspective.md).

For traces to be available in StackState, the [StackState Agent V2 StackPack](../../stackpacks/integrations/agent.md) must be installed with one or more tracing integrations configured.

## 1\) Install StackState Agent V2

The StackState Agent V2 StackPack enables integration with external systems to receive trace data. You can check if it is installed on the StackPacks page in StackState. If it is not installed, follow the [StackState Agent setup instructions](../../setup/agent/about-stackstate-agent.md).

## 2\) Configure tracing integrations

When the StackState Agent V2 StackPack is installed, you can configure integrations to receive trace data from external systems. One or more of the StackState Agent V2 integrations below can be configured to populate the Traces Perspective.

### AWS X-ray

The AWS integration collects tracing information from the in-built AWS distributed tracing system.  
[Configure AWS X-ray](../../stackpacks/integrations/aws/aws-x-ray.md)

{% hint style="success" "self-hosted info" %}

* The [DotNet APM integration](../../stackpacks/integrations/dotnet-apm.md) enables instrumentation for DotNet applications and sends traces back to StackState.

* The [Java APM integration](../../stackpacks/integrations/java-apm.md) enables tracing support for Java JVM based systems.

* The [Traefik integration](../../stackpacks/integrations/traefik.md) adds topology and telemetry information from Traefik to traces.
* {% endhint %}
