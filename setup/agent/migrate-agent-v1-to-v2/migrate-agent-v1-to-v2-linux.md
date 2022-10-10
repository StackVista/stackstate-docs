---
description: StackState Self-hosted v5.1.x
---

# Agent V1 \(Legacy\) to Agent V2 Migration

## Overview

This page will walk you through the steps required to successfully migrate from Agent V1 (legacy) to Agent V2.  This migration process will also migrate the  existing Agent V1 (legacy) state. This will allow Agent checks, such as Splunk topology, metrics or event checks, to continue on Agent V2 from their previous state.

{% hint style="warning" %}
**These steps must be carried out in the correct order**.

Problems can occur if any of the steps is completed out of order. This could result in overwritten Agent state files, invalid Agent state files or a broken Agent V2 instance.
{% endhint %}

{% hint style="warning" %}
**It is highly recommended to run this migration in a test environment. It may affect some steps below but reduce the initial impact if something does not work**
{% endhint %}

{% hint style="warning" %}
## Impact Analysis

### Downtime
- Some downtime is required for the StackState Agent to allow a successful migration processfrom Agent V1 (legacy) to Agent V2.
- The length of time that the Agent will be down depends on how quickly the process described on this page is completed.

### Performance
- The exact performance impact of switching from Agent V1 (legacy) to Agent V2 can increase or decrease the number of resources used in the environments.
- Agent V2 is more synchronized than Agent V1 (legacy), allowing a better StackState experience but may trigger more services as it is non-blocking.
{% endhint %}


## Migration Process

### 1. Stop Agent V1 (legacy)

Agent V1 (legacy) will have to be stopped before proceeding with the **Agent V2 install** and **Agent V1 (legacy) state** migration.

{% hint style="warning" %}
**If Agent V1 (legacy) is still running, it might interfere with the installation process of Agent V2 or, even worse, break the Agent V2 state.**
{% endhint %}

You can stop Agent V1 (legacy) with the following command:

```shell
sudo /etc/init.d/stackstate-agent stop
```

After the Agent has been stopped, verify its status with:

```shell
sudo /etc/init.d/stackstate-agent status
```

### 2. Install Agent V2

StackState Agent V2 can now safely be installed.

Follow all the steps on [Agent V2 - Deploy on Linux](/setup/agent/linux.md) to successfully deploy Agent V2.

### 3. Stop Agent V2

{% hint style="info" %}
The installation of Agent V2 will automatically start the StackState Agent.
{% endhint %}

To prevent Agent state files from being overwritten during the state migration process, let's stop the Agent

This can be done by running one of the following commands:

```shell
# with systemctl
sudo systemctl stop stackstate-agent

# with service
sudo service stackstate-agent stop
```

After the Agent has been stopped, verify its status with one of these commands:

```shell
# with systemctl
sudo systemctl status stackstate-agent

# with service
sudo service stackstate-agent status
```

### 4. Copy over your existing conf.d checks

Migrate your existing conf.d check YAML files to the Agent V2 directory.

This can be done by following these steps:

1. Head over to your Agent V1 (legacy) `conf.d` directory found at the following location `/etc/sts-agent/conf.d/`.
2. Copy each of the files in the `conf.d` directory to their respective v2 **subdirectories** inside the Agent V2 conf.d directory found at `/etc/stackstate-agent/conf.d/<CHECK-SUBDIRECTORY>.d/`.
    - **DO NOT** just copy all the files from the `/etc/sts-agent/conf.d/` to  
      `/etc/stackstate-agent/conf.d/` as Agent V2 works with a subdirectory structure.
    - For Example, If you are using **Splunk** copy the following files:
      - `/etc/sts-agent/conf.d/splunk_topology.yaml` into  
        `/etc/stackstate-agent/conf.d/splunk_topology.d/splunk_topology.yaml`
      - `/etc/sts-agent/conf.d/splunk_event.yaml` into  
        `/etc/stackstate-agent/conf.d/splunk_event.d/splunk_event.yaml`
      - `/etc/sts-agent/conf.d/splunk_metric.yaml` into  
        `/etc/stackstate-agent/conf.d/splunk_metric.d/splunk_metric.yaml`

{% hint style="info" %}
**This step is only required if you have Splunk Topology Check enabled**

- Edit the check configuration file `/etc/stackstate-agent/conf.d/splunk_topology.d/splunk_topology.yaml` and replace all occurrences of the following items
  - `default_polling_interval_seconds` replace with `collection_interval`
  - `polling_interval_seconds` replace with `collection_interval`
{% endhint %}

### 5. Migrate the Agent V1 Cache

Migrating the Agent V1 (legacy) cache requires a cache conversion process, and this is a manual process that StackState will assist you with.
Contact StackState to assist with this process.

A breakdown of the steps that will happen in the cache migration is as follows:

- Backing up the Agent V1 (legacy) cache folder from the following location `/opt/stackstate-agent/run/`.
- Run the Agent V1 cache migration process.
    - The output of the cache migration process will either be manually moved into the Agent V2 cache directory or automatically, depending on the conversion process used for Agent V2 (Some steps, depending on the installation, can only be done manually).

### 5. Start Agent V2

Start Agent V2 and monitor the logs to ensure everything started up correctly.

You can start Agent V2 with the following command:

```shell
# with systemctl
sudo systemctl start stackstate-agent

# with service
sudo service stackstate-agent start
```

After the Agent has been started, verify its status with:


```shell
# with systemctl
sudo systemctl status stackstate-agent

# with service
sudo service stackstate-agent status
```

The log files for the above process can be found at the following locations:

- `/var/log/stackstate-agent/agent.log`
- `/var/log/stackstate-agent/process-agent.log`

### 6. Add Splunk Health State

Agent V2 Supports a new Splunk check called Splunk Health state.

You can follow the docs [Splunk Health](/stackpacks/integrations/splunk/splunk_health.md) to enable this check.
