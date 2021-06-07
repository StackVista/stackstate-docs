---
description: StackState core integration
---

# StackState Agent

## Overview

The StackState Agent StackPack works with the [StackState Agent](/setup/agent) to synchronize topology, metrics, events and trace data from external systems with StackState. A number of integrations are automatically enabled when the StackState Agent StackPack is installed, however, integration with some systems will require an additional StackPack and configuration. 

The StackState Agent is open source and available on GitHub at [https://github.com/StackVista/stackstate-agent](https://github.com/StackVista/stackstate-agent).

## Setup

### Prerequisites

### Install

Install the StackState Agent V2 StackPack from the StackState UI **StackPacks** > **Integrations** screen.

### Configure

### Status

To find the status of an installed Agent, use the status commands provided in the [StackState Agent documentation](/setup/agent/).

### Upgrade

When a new version of the ServiceNow StackPack is available in your instance of StackState, you will be prompted to upgrade in the StackState UI on the page **StackPacks** > **Integrations** > **StackState Agent V2**. For a quick overview of recent StackPack updates, check the [StackPack versions](/setup/upgrade-stackstate/stackpack-versions.md) shipped with each StackState release.

To upgrade the StackState Agent, see the [StackState Agent documentation](/setup/agent/).

## Integration details

### Data retrieved

When installed and running, StackState Agent will synchronize the following data with StackState from the host it is running on:

Fedora:
- Hosts, processes and containers
- Network connections between processes and containers including network traffic telemetry
- Telemetry for hosts, processes and containers 

Docker:
- Hosts, processes, and containers
- Network connections between processes, containers and services including network traffic telemetry
- Telemetry for hosts, processes, and containers
- Trace agent support

### Rest API endpoints

### Agent views in StackState

### Open source

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

## Uninstall

## Release notes

**Agent V2 StackPack v4.3.1 \(2021-04-02\)**

* Features: Introduced swarm services as components and relations with containers.
* Features: Report desired replicas and active replicas for swarm services.
* Features: Health check added for swarm service on active replicas.
* Improvement: Enable auto grouping on generated views.
* Improvement: Common bumped from 2.3.1 to 2.5.0
* Improvement: StackState min version bumped to 4.3.0

**Agent V2 StackPack v4.2.1 \(2021-03-11\)**

* Bugfix: Fix for trace service types causing spurious updates on StackState.

**Agent V2 StackPack v4.2.0 \(2021-02-26\)**

* Features: Map the container restart event stream as metric stream.
* Features: Introduced the container health check for restart event.
* Features: Introduced Disk Metrics and Check on Host in Agent V2 StackPack.
* Features: Separate Sync and DataSource added for Disk Type.

**Agent V2 StackPack v4.1.0 \(2021-02-08\)**

* Improvement: Updated the "Agent Container Mapping Function" and "Agent Container Template" to map the container name instead of the container id to the identifier
* Bugfix: Fix the error stream for the traces not coming from traefik.

**Agent V2 StackPack v4.0.0 \(2021-01-29\)**

* Bugfix: Major bump the version for installation fix

**Agent V2 StackPack v3.12.0 \(2020-12-15\)**

* Feature: Split error types in traces into:
  * 5xx errors - Use this in check function to determine critical status in the component.
  * 4xx errors.

**Agent V2 StackPack v3.11.0 \(2020-09-03\)**

* Feature: Added the Agent Integration synchronization, mapping functions and templates to synchronize topology and telemetry coming from custom Agent Integrations.
* Feature: Added the "Create your own" integration StackPack page that explains how to build a custom integration in the StackState Agent.
* Feature: Introduced monitoring of all StackState Agent Integrations in the Agent - Integrations - All View.

**Agent V2 StackPack v3.10.1 \(2020-08-18\)**

* Feature: Introduced the Release notes pop up for customer.
* Feature: Introduced the Docker-Swarm mode setup docs in Docker integration.

## See also

* [StackState Agent documentation](/setup/agent/)