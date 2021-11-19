---
description: StackState curated integration
---

# RedHat

{% hint style="warning" %}
**This page describes StackState version 4.4.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

StackState Agent V2 will retrieve data from the RedHat host it is running on and push this to StackState.

## Setup

### Prerequisites

To set up the StackState RedHat integration, you need to have:

* [StackState Agent V2](../../setup/agent/linux.md) installed on a RedHat host that is able to connect to StackState.
* The [StackState Agent V2 StackPack](agent.md) installed in StackState.\#\#\# Install

The RedHat integration is part of the [StackState Agent V2 StackPack](agent.md).

## Data retrieved

StackState Agent V2 will synchronize the following data from the host it is running on with StackState:

* Hosts, processes and containers.
* Telemetry for hosts, processes and containers.

See the [supported Linux versions](../../setup/agent/linux.md#supported-linux-versions) for details.

## See also

* [About the StackState Agent](../../setup/agent/about-stackstate-agent.md)
* [Deploy StackState Agent V2 on Linux](../../setup/agent/linux.md)

