---
description: StackState SaaS
---

# Set up traces

## Overview

This page describes the steps to set up traces that can be viewed in the StackState [Traces Perspective](../../use/stackstate-ui/perspectives/traces-perspective.md).

For traces to be available in StackState, the [StackState Agent V2 StackPack](../../stackpacks/integrations/agent.md) must be installed with one or more tracing integrations configured.

## Set up

### 1\) Install StackState Agent V2

The StackState Agent V2 StackPack enables integration with external systems to receive trace data. You can check if it's installed on the StackPacks page in StackState. If it isn't installed, follow the [StackState Agent setup instructions](../../setup/agent/about-stackstate-agent.md).

### 2\) Configure tracing integrations

When the StackState Agent V2 StackPack is installed, you can configure integrations to receive trace data from external systems. One or more of the StackState Agent V2 integrations below can be configured to populate the Traces Perspective.

* The [AWS X-ray integration](../../stackpacks/integrations/aws/aws-x-ray.md) collects tracing information from the in-built AWS distributed tracing system.
* The [OpenTelemetry integration](../../stackpacks/integrations/opentelemetry/opentelemetry-nodejs.md) adds topology and telemetry information from AWS Lambdas to traces.

