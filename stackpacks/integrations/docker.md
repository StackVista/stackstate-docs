---
description: StackState curated integration
---

# Docker

{% hint style="warning" %}
**This page describes StackState v4.4.x.**

The StackState 4.4 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.4 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/stackpacks/integrations/docker).
{% endhint %}

## Overview

## Setup

StackState Agent V2 will retrieve data from the host it is running on and push this to StackState.

### Prerequisites

* [StackState Agent V2](../../setup/agent/docker.md) running in a Docker container that is able to connect to StackState.
* The [StackState Agent V2 StackPack](agent.md) installed in StackState.

### Install

The Docker integration is part of the [StackState Agent V2 StackPack](agent.md).

## Data retrieved

StackState Agent V2 will synchronize the following data from the host it is running on with StackState:

* Hosts, processes, and containers
* Network connections between processes/containers/services including network traffic telemetry
* Telemetry for hosts, processes, and containers

In Docker swarm mode, StackState Cluster Agent running on the manager node will synchronize the following topology data for a Docker cluster:

* Containers
* Services
* Relations between containers and services

## See also

* [About the StackState Agent](../../setup/agent/about-stackstate-agent.md)
* [Deploy StackState Agent V2 on Docker](../../setup/agent/docker.md)

