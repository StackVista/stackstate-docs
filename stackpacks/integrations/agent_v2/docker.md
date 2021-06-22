---
description: StackState curated integration
---

# Docker

## Overview

## Setup

StackState Agent V2 will retrieve data from the host it is running on and push this to StackState.

### Prerequisites
 
* [StackState Agent](/setup/agent/docker.md) running in a Docker container that is able to connect to StackState.

### Install

The Docker integration is part of the [StackState Agent StackPack](/stackpacks/integrations/agent.md).

## Data retrieved

StackState Agent will synchronize the following data from the host it is running on with StackState:

* Hosts, processes, and containers
* Network connections between processes/containers/services including network traffic telemetry
* Telemetry for hosts, processes, and containers


## See also

* [About the StackState Agent](/setup/agent/about-stackstate-agent.md)
* [Deploy StackState Agent on Docker](/setup/agent/docker.md)