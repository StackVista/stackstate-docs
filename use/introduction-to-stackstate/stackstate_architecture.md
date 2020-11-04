---
description: An overview of StackState components and integration with external systems. 
---

# StackState architecture

## Overview



![StackState architecture and data flow](/.gitbook/assets/v41_sts-architecture.svg)

## Data sources

StackState integrates with external systems to retrieve events, metrics, topology and traces. Integrations are set up using [StackState Agent](/stackpacks/integrations/agent.md), [API integration](/stackpacks/integrations/api-integration.md) and/or an associated [integration StackPack](/stackpacks/integrations).

## StackGraph

StackState configuration and topology data are stored in the StackGraph database. 

## StackState User Interface and CLI

The StackState User Interface visualizes all collected data in [perspectives](/use/views/perspectives.md). You can also customize your instance of StackState here by adding automization steps, such as event handlers and output to external systems.

You can optionally install the [StackState CLI](/develop/reference/cli_reference.md) to control your StackState instance directly from the command line.

## Open source

### StackState Agent V2

StackState Agent V2 is open source and available on GitHub:

- Agent - [https://github.com/StackVista/stackstate-agent](https://github.com/StackVista/stackstate-agent)
- Agent integrations - [https://github.com/StackVista/stackstate-agent-integrations](https://github.com/StackVista/stackstate-agent-integrations)

### StackPacks

The StackPacks listed below are open source and available on GitHub:

- Custom Sync StackPack - [https://github.com/StackVista/stackpack-autosync](https://github.com/StackVista/stackpack-autosync)
- SAP StackPack - [https://github.com/StackVista/stackpack-sap](https://github.com/StackVista/stackpack-sap)
- Splunk StackPack - [https://github.com/StackVista/stackpack-splun](https://github.com/StackVista/stackpack-splunk)