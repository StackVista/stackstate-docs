---
description: StackState curated integration
---

# CentOS

{% hint style="warning" %}
**This page describes StackState v4.4.x.**

The StackState 4.4 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.4 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/stackpacks/integrations/centos).
{% endhint %}

## Overview

StackState Agent V2 will retrieve data from the CentOS host it is running on and push this to StackState.

## Setup

### Prerequisites

* [StackState Agent V2](../../setup/agent/linux.md) installed on a CentOS host that is able to connect to StackState.
* The [StackState Agent V2 StackPack](agent.md) installed in StackState.

### Install

The CentOS integration is part of the [StackState Agent V2 StackPack](agent.md).

## Data retrieved

StackState Agent V2 will synchronize the following data from the host it is running on with StackState:

* Hosts, processes and containers.
* Telemetry for hosts, processes and containers.

See the [supported Linux versions](../../setup/agent/linux.md#supported-linux-versions) for details.

## See also

* [About the StackState Agent](../../setup/agent/about-stackstate-agent.md)
* [Deploy StackState Agent V2 on Linux](../../setup/agent/linux.md)

