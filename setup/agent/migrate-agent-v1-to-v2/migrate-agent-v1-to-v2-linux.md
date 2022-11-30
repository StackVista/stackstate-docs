---
description: StackState Self-hosted v5.1.x
---

# Agent V1 \(legacy\) to Agent V2 Migration

## Overview

This page will walk you through the steps required to successfully migrate from Agent V1 (legacy) to Agent V2.  This migration process will also migrate the  existing Agent V1 (legacy) state. This will allow Agent checks, such as Splunk topology, metrics or event checks, to continue on Agent V2 from their previous state.

{% hint style="warning" %}
**The migration process steps detailed below must be carried out in the correct order**.

Problems can occur if any of the steps is completed out of order. This could result in overwritten Agent state files, invalid Agent state files or a broken Agent V2 instance.
{% endhint %}

{% hint style="warning" %}
**It's highly recommended to run this migration in a test environment.** 

It may affect some steps below, but will reduce the initial impact if something doesn't run to plan.
{% endhint %}

## Impact analysis

### Downtime

Running Agent V1 (legacy) and Agent V2 at the same time on a single machine will result in missing data. For this reason, StackState Agent will need to be down for the entire of the migration process. The exact length of time required to complete the migration process will vary depending on your specific environment and the number of Agent checks that need to be migrated.

### Performance

Switching from Agent V1 (legacy) to Agent V2 can either increase or decrease the number of resources used. Unlike Agent V1 (legacy), Agent V2 can synchronously execute checks. This provides a better StackState experience, but may result in increased resource requirements.

## Migration process

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

To do this, run one of the following commands:

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

### 4. Copy Agent V1 (legacy) conf.d checks

Migrate your existing conf.d check YAML files to the Agent V2 directory:

1. Head over to your Agent V1 (legacy) `conf.d` directory found at the following location `/etc/sts-agent/conf.d/`.
2. Copy each of the files in the `conf.d` directory to their respective v2 **subdirectories** inside the Agent V2 conf.d directory found at `/etc/stackstate-agent/conf.d/<CHECK-SUBDIRECTORY>.d/`.
    - **DO NOT** just copy all the files from the `/etc/sts-agent/conf.d/` to  
      `/etc/stackstate-agent/conf.d/` as Agent V2 works with a subdirectory structure.
    - For example, If you are using **Splunk** copy the following files:
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

### 4. Migrate Agent V1 (legacy) cache

Migrating the Agent V1 (legacy) cache requires a cache conversion process. This is a manual process that StackState will assist you with. Contact StackState support to assist with this process.

A breakdown of the steps that will happen in the cache migration is as follows:

- Back up the Agent V1 (legacy) cache folder from the following location `/opt/stackstate-agent/run/`.
- Run the Agent V1 (legacy) cache migration process.
- The output of the cache migration process will be moved into the Agent V2 cache directory. Depending on the installation, some steps may need to be completed manually.

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


{% hint style="info" %}
**Splunk Health check**

In addition to the Splunk Topology, Splunk Metrics and Splunk Events checks, StackState Agent V2 can also be configured to run a [Splunk Health](/stackpacks/integrations/splunk/splunk_health.md) check to collect health data from Splunk.
{% endhint %}
