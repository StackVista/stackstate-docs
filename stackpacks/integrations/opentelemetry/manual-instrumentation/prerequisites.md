---
description: StackState Self-hosted v5.0.x
---

# Prerequisites

{% hint style="warning" %}
**This page describes StackState version 5.0.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/stackpacks/integrations/opentelemetry/manual-instrumentation/prerequisites).
{% endhint %}

To set up a OpenTelemetry manual instrumentations, you need to have:

* [StackState Agent](/setup/agent/about-stackstate-agent.md) v2.17 (or later)
* [Traces enabled](/setup/agent/advanced-agent-configuration.md#enable-traces) on StackState Agent. If traces are not enabled on the Agent, OpenTelemetry will not generate any data.
* The [Agent StackPack](/stackpacks/integrations/agent.md) should be installed in StackState. 
