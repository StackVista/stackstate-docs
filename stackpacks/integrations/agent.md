---
description: StackState core integration
---

# 💠 StackState Agent V2

## Overview

The StackState Agent V2 StackPack works with [StackState Agent V2](../../setup/agent/about-stackstate-agent.md) to synchronize topology, metrics, events and traces data from external systems with StackState. A number of integrations are automatically enabled when the StackState Agent V2 StackPack is installed, however, integration with some systems will require an additional StackPack and configuration.

## Setup

### Prerequisites

* [StackState Agent V2](../../setup/agent/about-stackstate-agent.md) installed on a machine that can connect to StackState and any system you will integrate with.

### Install

Install the StackState Agent V2 StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen.

### Configure

The integrations included in the StackState Agent V2 StackPack are listed below. Refer to the integration pages to find configuration details for each integration:

* [Apache TomCat](apache-tomcat.md "StackState Self-Hosted only")
* [AWS ECS](aws/aws-ecs.md)
* [AWS Xray](aws/aws-x-ray.md)
* [DotNet APM](dotnet-apm.md "StackState Self-Hosted only")
* [Java APM](java-apm.md)
* [JMX](jmx.md "StackState Self-Hosted only")
* [MySQL](mysql.md "StackState Self-Hosted only")
* [PostgreSQL](postgresql.md "StackState Self-Hosted only")
* [Static Health](static_health.md "StackState Self-Hosted only")  
* [WMI](wmi.md "StackState Self-Hosted only")

### Status

To find the status of an installed Agent, use the status commands provided in the [StackState Agent documentation](../../setup/agent/).

### Upgrade

When a new version of the StackState Agent V2 StackPack is available in your instance of StackState, you will be prompted to upgrade in the StackState UI on the page **StackPacks** &gt; **Integrations** &gt; **StackState Agent V2**. 

{% hint style="success" "self-hosted info" %}

For an overview of recent StackPack updates, check the [StackPack versions](/setup/upgrade-stackstate/stackpack-versions.md) shipped with each StackState release.
{% endhint %}

To upgrade StackState Agent V2, see the [StackState Agent documentation](../../setup/agent/).

## Integration details

### Data retrieved

When installed and running, StackState Agent V2 will synchronize the following data with StackState from the host it is running on:

Linux:

* Hosts, processes and containers
* Network connections between processes and containers including network traffic telemetry
* Telemetry for hosts, processes and containers 

Docker:

* Hosts, processes, and containers
* Network connections between processes, containers and services including network traffic telemetry
* Telemetry for hosts, processes, and containers
* Trace agent support

When additional checks have been enabled on the Agent, data from other external systems will be integrated. Refer to the individual integration pages for details of the data retrieved from each system.

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

## Uninstall

Uninstall the StackState Agent V2 StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen.

To uninstall StackState Agent V2, see the [StackState Agent documentation](../../setup/agent/).

## Release notes

**Agent V2 StackPack v4.4.9 \(2021-11-17\)**

* Improvement: Updated supported platforms documentation.

**Agent V2 StackPack v4.4.8 \(2021-07-23\)**

* Improvement: Documentation updated

**Agent V2 StackPack v4.4.7 \(2021-06-30\)**

* Bugfix: Disable Indirect relations

**Agent V2 StackPack v4.4.6 \(2021-06-18\)**

* Bugfix: Fixed integration page
* Feature: Split Error Count Metric for X-Ray into 4xx and 5xx count

**Agent V2 StackPack v4.4.5 \(2021-06-14\)**

* Bugfix: Fixed runs\_on relation creation

**Agent V2 StackPack v4.4.4 \(2021-06-10\)**

* Feature: Added static health integration

**Agent V2 StackPack v4.4.3 \(2021-06-10\)**

* Feature: HTTP Endpoints \(Kubernetes services for example\) and processes now have metric streams for HTTP request rates and response times \(only StackState 4.4.0+\)
* Feature: HTTP Endpoints \(Kubernetes services for example\) and processes have a new tag `application-protocol` that lists the protocols that are handled by that service/process, currently supported protocols are http and mysql \(only StackState 4.4.0+\)
* Feature: Network connection relations also get the `application-protocol` tag \(only StackState 4.4.0+\)

**Agent V2 StackPack v4.4.2 \(2021-05-18\)**

* Improvement: Expose service -&gt; process relation metrics on the outgoing service component if running in Kubernetes
* Improvement: Add the Agent category for filtering capability

**Agent V2 StackPack v4.4.1 \(2021-04-23\)**

* Bugfix: Fix escaping bugs in templates

**Agent V2 StackPack v4.4.0 \(2021-04-23\)**

* Improvement: Add "runs" relation for container -&gt; process such that a container "runs" the process
* Improvement: Stop state propagation over relations that represent health checks or metrics collection, these used to result in a lot of false positives
* Improvement: Expose process -&gt; process relation metrics on the process component if running in Kubernetes

**Agent V2 StackPack v4.3.1 \(2021-04-12\)**

* Improvement: Common bumped from 2.5.0 to 2.5.1

**Agent V2 StackPack v4.3.0 \(2021-04-02\)**

* Feature: Introduced swarm services as components and relations with containers.
* Feature: Report desired replicas and active replicas for swarm services.
* Feature: Health check added for swarm service on active replicas.
* Improvement: Enable auto grouping on generated views.
* Improvement: Common bumped from 2.3.1 to 2.5.0
* Improvement: StackState min version bumped to 4.3.0

**Agent V2 StackPack v4.2.1 \(2021-03-11\)**

* Bugfix: Fix for trace service types causing spurious updates on StackState.

**Agent V2 StackPack v4.2.0 \(2021-02-26\)**

* Feature: Map the container restart event stream as metric stream.
* Feature: Introduced the container health check for restart event.
* Feature: Introduced Disk Metrics and Check on Host in Agent V2 StackPack.
* Feature: Separate Sync and DataSource added for Disk Type.

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

* [StackState Agent documentation](../../setup/agent/)

