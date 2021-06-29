---
description: StackState curated integration
---

# RedHat

## Overview

StackState Agent V2 will retrieve data from the RedHat host it is running on and push this to StackState.

## Setup

### Prerequisites
 
* [StackState Agent](/setup/agent/linux.md)

## Data retrieved

StackState Agent will synchronize the following data from the host it is running on with StackState:

- Hosts, processes and containers.
- Telemetry for hosts, processes and containers   
- For OS versions with a Network Tracer: Network connections between processes and containers including network traffic telemetry. See the [supported Linux versions](/setup/agent/linux.md#supported-linux-versions) for details.

## See also

* [About the StackState Agent](/setup/agent/about-stackstate-agent.md)
* [Deploy StackState Agent on Linux](/setup/agent/linux.md)