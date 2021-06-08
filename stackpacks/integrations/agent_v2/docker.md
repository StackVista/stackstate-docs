---
description: StackState curated integration
---

# Docker

## Overview

## Install

### Prerequisites
 
* [StackState Agent](/setup/agent/docker.md) running in a Docker container that is able to connect to StackState.
* The [StackState Agent StackPack](/stackpacks/integrations/agent.md) installed in StackState.

### Install

The Docker integration is part of the [StackState Agent StackPack](/stackpacks/integrations/agent.md). 


## Data retrieved

When a [StackState Agent is running in a Docker container](/setup/agent/docker.md), the following data will be synchronized from the host on which it is running:

* Hosts, processes, and containers
* Network connections between processes/containers/services including network traffic telemetry
* Telemetry for hosts, processes, and containers


## See also

* [StackState Agent](/setup/agent/docker.md) installed on a Fedora host that is able to connect to StackState.
* [StackState Agent StackPack](/stackpacks/integrations/agent.md) installed in StackState.