---
description: StackState curated integration
---

# Ubuntu

## Overview

## Install

### Prerequisites
 
* [StackState Agent](/setup/agent/linux.md) installed on an Ubinti host that is able to connect to StackState.
* The [StackState Agent StackPack](/stackpacks/integrations/agent.md) installed in StackState.

## Data retrieved

When installed and running, StackState Agent will synchronize the following data with StackState from the host it is running on:

- Hosts, processes and containers.
- Telemetry for hosts, processes and containers   
- For OS versions with a Network Tracer: Network connections between processes and containers including network traffic telemetry. See the [supported Linux versions](/setup/agent/linux.md#supported-linux-versions) for details.