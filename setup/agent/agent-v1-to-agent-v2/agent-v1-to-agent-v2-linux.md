---
description: StackState Self-hosted v5.1.x
---

# Agent V1 \(Legacy\) to Agent V2 Migration

## Overview

A few steps is required to successfully migrate from Agent v1 to Agent v2 including the Agent v1 cache.

These steps **must be done in order** to prevent any Agent v1 to Agent v2 corruption, either caused by the upgrade process or the corruption of Agent v2 cache files.


## Impact Analysis

### Downtime
- When swapping between Agent v1 and Agent v2, there will be some downtime for the StackState Agent to allow a successful migration process.
- The length the Agent will be down for all depends on how fast the process below happens.

### Performance
- The exact performance impact of switching from Agent v1 to Agent v2 can increase or decrease the amount of resources used on the environments.
- Agent v2 is more synchronise than Agent v1 allow a better StackState experience but may trigger more services as it is non-blocking.

## Migration Process

### 1. Stop Agent v1

Stop the currently running v1 Agent. If the Agent is still running, it might interfere with the installation process of Agent v2 or, even worse, break the agent cache.

This can be done by following [Agent v1 - Start and Stop](/setup/agent/agent-v1.md#start--stop--restart-the-agent).

### 2. Install Agent v2

Deploy Agent v2 on Linux by following [Agent v2 - Deploy on Linux](/setup/agent/linux.md).

### 3. Stop Agent v2

The installation of Agent v2 will automatically start the StackState Agent, To prevent cache files from being corrupted during the
cache migration process, let's stop the Agent.

This can be done by following [Agent v2 - Stop on Linux](/setup/agent/linux.md#start-stop-or-restart-the-agent).

### 4. Copy over your existing conf.d checks

Migrate your existing conf.d check YAML files to the Agent v2 directory.

This can be done by following these steps:

1. Head over to your Agent v1 `conf.d` directory found at the following location `/etc/sts-agent/conf.d/`.
2. Copy each of the files in the `conf.d` directory to their respective v2 subdirectories inside the Agent v2 conf.d directory found at `/etc/stackstate-agent/conf.d/<CHECK-SUBDIRECTORY>.d/`.
   - **DO NOT** just copy all the files from the `/etc/sts-agent/conf.d/` to `/etc/stackstate-agent/conf.d/` as Agent v2 works with a directory subdirectory structure. Let's take `splunk_topology` as an example, you will have to do the following:
     - Copy `/etc/sts-agent/conf.d/splunk_topology.yaml` into `/etc/stackstate-agent/conf.d/splunk_topology.d/`.

### 5. Migrate the Agent v1 Cache

Migrating the Agent v1 cache requires a cache conversion process, and this is a manual process that StackState will assist you with.
Contact StackState to assist with this process.

A breakdown of the steps that will happen in the cache migration is as follows:

- Backing up the Agent v1 cache folder from the following location `/opt/stackstate-agent/run/`.
- Run the Agent v1 cache migration process.
   - The output of the cache migration process will either be manually moved into the Agent v2 cache directory or automatically, depending on the conversion process used for Agent v2 (Some steps depending on the installation can only be done manually).

### 5. Start Agent v2

Start Agent v2 and monitor the logs to ensure everything started up correctly.

You can start the Agent by following [Agent v2 - Start on Linux](/setup/agent/linux.md#start-stop-or-restart-the-agent).

The log files for the above process can be found at the following location [Agent v2 - Linux Logs](/setup/agent/linux.md#log-files).

### 5. (Optional) Enable Health checks for Splunk

The newly installed StackState Agent v2 also supports health checks for Splunk. 

This can be enabled by following [Splunk Health Integration Page](/stackpacks/integrations/splunk/splunk_health.md).
