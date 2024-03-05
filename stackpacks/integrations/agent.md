---
description: StackState SaaS
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

* [AWS ECS](aws/aws-ecs.md)
* [AWS Xray](aws/aws-x-ray.md)

### Status

To find the status of an installed Agent, use the status commands provided in the [StackState Agent documentation](/setup/agent/).

### Upgrade

When a new version of the StackState Agent V2 StackPack is available in your instance of StackState, you will be prompted to upgrade in the StackState UI on the page **StackPacks** &gt; **Integrations** &gt; **StackState Agent V2**. 

{% hint style="success" "self-hosted info" %}

**StackState Self-Hosted**

Extra information for the [StackState Self-Hosted product](https://docs.stackstate.com/):

    
For an overview of recent StackPack updates, check the StackPack versions shipped with each StackState release.
{% endhint %}

To upgrade StackState Agent V2, see the [StackState Agent documentation](/setup/agent/).

## Integration details

### Data retrieved

When installed and running, StackState Agent V2 will synchronize the following data with StackState from the host it's running on:

Linux:

* Hosts, processes and containers
* Network connections between processes and containers including network traffic telemetry
* Telemetry for hosts, processes and containers 

Docker:

* Hosts, processes, and containers
* Network connections between processes, containers and services including network traffic telemetry
* Telemetry for hosts, processes, and containers
* Trace Agent support

When additional checks have been enabled on the Agent, data from other external systems will be integrated. Refer to the individual integration pages for details of the data retrieved from each system.

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

## Uninstall

Uninstall the StackState Agent V2 StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen.

To uninstall StackState Agent V2, see the [StackState Agent documentation](/setup/agent/).

## Release notes

**Agent V2 StackPack v4.5.1 (2022-04-08)**

- Improvement: Added a Deprovisioning screen when uninstalling the StackState Agent V2 StackPack.


**Agent V2 StackPack v4.5.0 (2022-03-02)**

- Feature: Automatically add OpenTelemetry HTTP health checks
  - Error count (sum) check
  - Request count (sum) check
  - Response Time (milliseconds) check
- Feature: Add Container integration DataSource and Sync

**Agent V2 StackPack v4.4.14 (2022-02-18)**

- Feature: Health check added for HTTP error (5xx) rate over total rate ratio

**Agent V2 StackPack v4.4.13 (2022-02-03)**

- Improvement: Documentation updated - added documentation for OpenMetrics integration.

- Feature: Automatically add [anomaly health checks](https://l.stackstate.com/ui-agent-anomaly-health-checks) for [golden signals](https://l.stackstate.com/ui-agent-golden-signals)
  - HTTP Success response time (s) (95th percentile) AAD Check
  - HTTP 5xx error response time (s) (95th percentile) AAD Check
  - HTTP total response time (s) (95th percentile) AAD Check
  - HTTP Success rate (req/s) AAD Check
  - HTTP 5xx error rate (req/s) AAD Check

**Agent V2 StackPack v4.4.12 (2021-12-15)**

* Improvement: Supported additional identifiers for Disk component




