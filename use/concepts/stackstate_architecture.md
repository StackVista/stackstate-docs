---
description: Rancher Observability Self-hosted v5.1.x 
---

# Rancher Observability architecture

## Overview

Rancher Observability is built for scale and runs on Kubernetes in your cloud or data center.

In most cases, a single Host Agent is installed on the Rancher Observability server to provide Agent-less integration with APIs from multiple sources. Data is gathered and received by one or more Agents and delivered at the Receiver API. From there, all data is put on Kafka. The data is processed by microservices and ends up as Topology in our versioned graph database, called StackGraph. Traces, and some telemetry data, are temporarily stored in Elasticsearch.

A Script and Query Language provides access to all dimensions of the 4T Data Model. They're also used by our own AI Microservices to interface with the 4T Data Model.

REST APIs are available for external services and are also used by our Command Line Interface. Every user interface is kept up to date by WebSocket APIs.

Notifications, tickets, webhooks, and API calls are just a few examples of output data sources to let you respond to situations you observe in Rancher Observability.

![Rancher Observability architecture and data flow](/.gitbook/assets/sts-architecture.svg)

## Data sources

Rancher Observability integrates with external systems to retrieve data. Integrations use [Rancher Observability Agent](/setup/agent/about-stackstate-agent.md) or an associated [integration StackPack](/stackpacks/integrations/README.md).

## StackGraph

Rancher Observability configuration and topology data are stored in the StackGraph database.

## Rancher Observability User Interface and CLI

The Rancher Observability User Interface visualizes all collected data in [perspectives](perspectives.md). You can also customize your instance of Rancher Observability here by adding automation steps, such as event handlers and output to external systems.

You can optionally install the [Rancher Observability CLI](/setup/cli) to control your Rancher Observability instance directly from the command line.

## Open source

### Rancher Observability Agent V2

Rancher Observability Agent V2 is open source and available on GitHub:

* Agent - [https://github.com/StackVista/stackstate-agent](https://github.com/StackVista/stackstate-agent)
* Agent integrations - [https://github.com/StackVista/stackstate-agent-integrations](https://github.com/StackVista/stackstate-agent-integrations)

### StackPacks

The StackPacks listed below are open source and available on GitHub:

* Custom Sync StackPack - [https://github.com/StackVista/stackpack-autosync](https://github.com/StackVista/stackpack-autosync)
* SAP StackPack - [https://github.com/StackVista/stackpack-sap](https://github.com/StackVista/stackpack-sap)
* SolarWinds StackPack - [https://github.com/StackVista/stackpack-solarwinds](https://github.com/StackVista/stackpack-solarwinds)
* Splunk StackPack - [https://github.com/StackVista/stackpack-splunk](https://github.com/StackVista/stackpack-splunk)

