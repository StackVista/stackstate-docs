---
description: StackState core integration
---

# StackState Agent

## Overview

The StackState Agent StackPack works with the [StackState Agent](/setup/agent) to synchronize topology, metrics, events and trace data from external systems with StackState.

The StackState Agent is open source and available on github at [https://github.com/StackVista/stackstate-agent](https://github.com/StackVista/stackstate-agent).

## Setup

### Prerequisites

### Install

## Configure

## Troubleshooting

Try running the [status](agent.md#status-and-information) command to see the state of the StackState Agent.

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

