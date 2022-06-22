---
description: StackState Self-hosted v5.0.x
---

# OpenTelemetry

## Prerequisites

To set up a OpenTelemetry manual instrumentations, you need to have:
* [StackState Agent](/setup/agent/about-stackstate-agent.md) v2.17 (or later)
* StackState Agent should have [traces enabled](/setup/agent/advanced-agent-configuration.md#enable-traces). If traces are not enabled on the Agent, OpenTelemetry will not generate any data.
* The Agent StackPack should be installed in StackState. 