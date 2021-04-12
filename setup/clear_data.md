---
title: Clear data
kind: Documentation
description: Removing data from StackState.
---

# Clearing data

{% hint style="warning" %}
This page describes StackState version 4.x.  
The StackState 4.0 version range is End of Life (EOL) and no longer supported.

We encourage customers still running the 4.0 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Clearing StackState

The data in StackState is divided into three different sets: ElasticSearch data, Kafka Topic data, and the StackGraph data. With this much data to store, it is important to have the means to manage it. There is a standard 8 days data retention period set in StackState, that you can configure according to your needs. Besides that, you can also use a StackState CLI command or choose to perform a few manual steps locally on each machine.

{% hint style="warning" %}
Clearing the data in StackState will **remove any configured permissions from the system**.
{% endhint %}

## Clearing data using StackState CLI

The StackState CLI needs access to the Admin API \(default port 7071\) to issue the command used below.

Using the StackState CLI route takes care of stopping all necessary services, performs the deletion of all topology and telemetry data, and starts StackState up. However, the Kafka topics folder needs to be deleted manually from the StackState server. The Kafka topics folder is located in `/opt/stackstate/var/lib/` and is named `kafka`.

```text
sts graph delete --all
```

## Data retention period

Data retention configuration provides a balance between the amount of stored data, performance, and data availability. By default, the data retention window is set to 8 days. This works in a way that the latest state of topology graph will always be retained; only history older than 8 days will be removed. Find more [here](retention.md).

## Clearing data manually

Please note that the below instructions are valid for a single node installation type. For a two-node installation, you need to stop the service corresponding to the node - `stop stackgraph` for a StackGraph node, for example.

1. To clean StackState manually, StackState and StackGraph services must be stopped first:

   ```text
    systemctl stop stackstate
   ```

   and

   ```text
    systemctl stop stackgraph
   ```

2. After above services are stopped you can remove the directory that holds the files:

   ```text
    rm -rf /opt/stackstate/var/lib/*
   ```

3. Start StackState and StackGraph services:

   ```text
    systemctl start stackstate
   ```

   and

   ```text
    systemctl start stackgraph
   ```

