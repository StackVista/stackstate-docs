---
description: StackState core integration
---

# StackState Agent

## Overview

The StackState Agent V2 StackPack works with [StackState Agent V2](/setup/agent) to synchronize topology, metrics, events and traces data from external systems with StackState. A number of integrations are automatically enabled when the StackState Agent V2 StackPack is installed, however, integration with some systems will require an additional StackPack and configuration. 

## Setup

### Prerequisites

* [StackState Agent V2](/setup/agent/about-stackstate-agent.md) installed on a machine that can connect to StackState and any system you will integrate with.

### Install

Install the StackState Agent V2 StackPack from the StackState UI **StackPacks** > **Integrations** screen.

### Configure

The integrations included in the StackState Agent V2 StackPack are listed below. Refer to the integration pages to find configuration details for each integration:

* [Apache TomCat](/stackpacks/integrations/agent_v2/apache-tomcat.md)
* [AWS ECS](/stackpacks/integrations/agent_v2/aws-ecs.md)
* [CentOS](/stackpacks/integrations/agent_v2/centos.md)
* [Debian](/stackpacks/integrations/agent_v2/debian.md)
* [Docker](/stackpacks/integrations/agent_v2/docker.md)  
* [DotNet APM](/stackpacks/integrations/agent_v2/dotnet-apm.md)
* [Fedora](/stackpacks/integrations/agent_v2/fedora.md)
* [Java APM](/stackpacks/integrations/agent_v2/java-apm.md)
* [JMX](/stackpacks/integrations/agent_v2/jmx.md)
* [MySQL](/stackpacks/integrations/agent_v2/mysql.md)
* [PostgreSQL](/stackpacks/integrations/agent_v2/postgresql.md)
* [RedHat](/stackpacks/integrations/agent_v2/redhat.md)
* [Static Health](/stackpacks/integrations/agent_v2/static-health.md)  
* [Ubuntu](/stackpacks/integrations/agent_v2/ubuntu.md)
* [Windows](/stackpacks/integrations/agent_v2/windows.md)  
* [WMI](/stackpacks/integrations/agent_v2/wmi.md)

### Status

To find the status of an installed Agent, use the status commands provided in the [StackState Agent documentation](/setup/agent/).

### Upgrade

When a new version of the ServiceNow StackPack is available in your instance of StackState, you will be prompted to upgrade in the StackState UI on the page **StackPacks** > **Integrations** > **StackState Agent V2**. For an overview of recent StackPack updates, check the [StackPack versions](/setup/upgrade-stackstate/stackpack-versions.md) shipped with each StackState release.

To upgrade StackState Agent V2, see the [StackState Agent documentation](/setup/agent/).

## Integration details

### Data retrieved

When installed and running, StackState Agent V2 will synchronize the following data with StackState from the host it is running on:

Linux:
- Hosts, processes and containers
- Network connections between processes and containers including network traffic telemetry
- Telemetry for hosts, processes and containers 

Docker:
- Hosts, processes, and containers
- Network connections between processes, containers and services including network traffic telemetry
- Telemetry for hosts, processes, and containers
- Trace agent support

When additional checks have been enabled on the Agent, data from other external systems will be integrated. Refer to the individual integration pages for details of the data retrieved from each system.

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

## Uninstall

Uninstall the StackState Agent V2 StackPack from the StackState UI **StackPacks** > **Integrations** screen.

To uninstall StackState Agent V2, see the [StackState Agent documentation](/setup/agent/).

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