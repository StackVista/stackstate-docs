---
description: Rancher Observability Self-hosted v5.1.x
---

# Prerequisites

To set up a OpenTelemetry manual instrumentations, you need to have:

* [Rancher Observability Agent](/setup/agent/about-stackstate-agent.md) v2.17 (or later)
* [Traces enabled](/setup/agent/advanced-agent-configuration.md#enable-traces) on Rancher Observability Agent. If traces aren't enabled on the Agent, OpenTelemetry won't generate any data.
* The [Agent StackPack](/stackpacks/integrations/agent.md) should be installed in Rancher Observability. 
