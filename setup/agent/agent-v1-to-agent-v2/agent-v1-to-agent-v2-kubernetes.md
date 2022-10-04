---
description: StackState Self-hosted v5.1.x
---

# Agent V1 \(Legacy\) to Agent V2 Migration

## Overview

A few steps is required to successfully migrate from Agent v1 to Agent v2 including the Agent v1 cache.

These steps **must be done in order** to prevent any Agent v1 to Agent v2 corruption, either caused by the upgrade process or the corruption of Agent v2 cache files.

**Downtime**, When swapping between Agent v1 and Agent v2, there will be some downtime to allow a successful migration process.

## Migration Process

### 1. Stop Agent v1

Stop the currently running v1 Agent. If the Agent is still running, it might interfere with the installation process of Agent v2 or, even worse, break the agent cache.

This can be done by following the [Agent v1 - Start and Stop](/setup/agent/agent-v1.md#start--stop--restart-the-agent) section.

### 2. Install Agent v2

Deploy Agent v2 by following the [Agent v2 - Deploy on Kubernetes](/setup/agent/kubernetes.md) page.

### 3. Stop Agent v2

The installation of Agent v2 will automatically start the Agent, To prevent cache files from being corrupted during the
cache migration process, let's stop the Agent.

This can be done by following the ??? page.

### 4. Create the existing conf.d checks in Kubernetes

You will have to update your Kubernetes Helm charts to contain the same information your checks contains.

Head over to your checks folder, it can be found under `/etc/sts-agent/conf.d/` and use the information in those files to create the updated helm charts.

The helm chart information differs per Check and can be found under the [StackState Agent Integrations](/stackpacks/integrations) page. 
Follow the integration page for instruction on how to enable the check in Kubernetes


### 5. Migrate the Agent V1 Cache

Migrating the Agent v1 cache requires a cache conversion process, and this is a manual process that StackState will assist you with.
Contact StackState to assist with this process.

A breakdown of the steps that will happen in the cache migration is as follows:

- Backing up the Agent v1 cache folder from the following location `/opt/stackstate-agent/run/`
- Run the Agent v1 cache migration process
   - The output of the cache migration process can not be automatic when and should be ???

### 5. Start Agent v2

Start Agent v2 and monitor the logs to ensure everything started up correctly.

You can start the Agent by following the [Agent v2 - Start on Kubernetes](???) page.

The log files for the above process can be found at the following location [Agent v2 - Kubernetes Logs](/setup/agent/kubernetes.md#log-files) page

### 5. (Optional) Enable Health checks for Splunk

Agent v2 supports health checks for Splunk Checks. This can be enabled by following the [Splunk Health Integration Page](/stackpacks/integrations/splunk/splunk_health.md)
