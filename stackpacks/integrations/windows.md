---
description: StackState curated integration
---

# Windows

{% hint style="warning" %}
**This page describes StackState version 4.4.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/stackpacks/integrations/windows).
{% endhint %}

## Overview

StackState Agent V2 will retrieve data from the Windows host it is running on and push this to StackState.

## Setup

### Prerequisites

* [StackState Agent V2](../../setup/agent/windows.md) installed on a Windows host that is able to connect to StackState.
* The [StackState Agent V2 StackPack](agent.md) installed in StackState.

### Install

The Windows integration is part of the [StackState Agent V2 StackPack](agent.md).

## Data retrieved

StackState Agent V2 will synchronize the following data from the host it is running on with StackState:

* Hosts, processes and containers.
* Telemetry for hosts, processes and containers   
* Network connections between processes and containers, including network traffic telemetry. See the [supported Linux versions](../../setup/agent/windows.md#supported-windows-versions) for details.

## See also

* [About the StackState Agent](../../setup/agent/about-stackstate-agent.md)
* [Deploy StackState Agent V2 on Windows](../../setup/agent/windows.md)

