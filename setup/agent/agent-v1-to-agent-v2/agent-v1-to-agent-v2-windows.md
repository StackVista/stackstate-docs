---
description: StackState Self-hosted v5.1.x
---

# Agent V1 \(Legacy\) to Agent V2 Migration

## Overview

A few steps is required to successfully migrate from [Agent v1](/setup/agent/agent-v1.md) to [Agent v2](/setup/agent/about-stackstate-agent.md).

These steps must be done to prevent any v1 to v2 corruption, either with the upgrade process or the corruption of the cache files.

**Downtime**, When swapping between Agent v1 and Agent v2, there will be some downtime to allow a successful migration process.

## Migration Process

### 1. Stop Agent v1

Stop the currently running v1 Agent. If the Agent is still running, it might interfere with the installation process of Agent v2 or, even worse, break the agent cache.

This can be done by following the [Agent v1 - Start and Stop](/setup/agent/agent-v1.md#start--stop--restart-the-agent) section.

### 2. Install Agent v2

Deploy Agent v2 by following the [Agent v2 - Deploy on Windows](/setup/agent/windows.md) page.

### 3. Stop Agent v2

The installation of Agent v2 will automatically start the Agent, To prevent cache files from being corrupted during the
cache migration process, let's stop the Agent.

This can be done by following the [Agent v2 - Stop on Windows](/setup/agent/windows.md#start-stop-or-restart-the-agent) page.

### 4. Copy over your existing conf.d checks

Migrate your existing conf.d check YAML files to the Agent v2 directory.

This can be done by following these steps:

1. Head over to your Agent v1 conf directory found at the following location `???/conf.d/`
2. Copy each of the files in the conf.d directory to their respective v2 subdirectories found at `???/conf.d/<CHECK-SUBDIRECTORY>.d/`
   - **Do not** just copy all the files from the `???/conf.d/` to `??/conf.d/` as Agent v2 works with a directory structure. Let's take `splunk_topology` as an example, you will have to do the following:
   - **EXAMPLE -** Copy the `???/conf.d/splunk_topology.yaml` into the `???/conf.d/splunk_topology.d/` directory leaving you with the following structure `???/conf.d/splunk_topology.d/splunk_topology.yaml`

### 5. Migrate the Agent V1 Cache

Migrating the Agent v1 cache requires a cache conversion process, and this is a manual process that StackState will assist you with.
Contact StackState to assist with this process.

A breakdown of the steps that will happen in the cache migration is as follows:

- Backing up the Agent v1 cache folder from the following location `???/run/`
- Run the Agent v1 cache migration process
   - The output of the cache migration process will either be manually moved into the Agent v2 cache directory or automatically, depending on the conversion process used for Agent v2 (Some steps depending on the installation can only be done manually).

### 5. Start Agent v2

Start Agent v2 and monitor the logs to ensure everything started up correctly.

You can start the Agent by following the [Agent v2 - Start on Windows](/setup/agent/windows.md#start-stop-or-restart-the-agent) page.

The log files for the above process can be found at the following location [Agent v2 - Windows Logs](/setup/agent/windows.md#log-files) page

### 5. (Optional) Enable Health checks for Splunk

Agent v2 supports health checks for Splunk Checks. This can be enabled by following the [Splunk Health Integration Page](/stackpacks/integrations/splunk/splunk_health.md)
