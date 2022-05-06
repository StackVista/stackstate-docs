---
description: StackState Self-hosted v4.6.x
---

# Clear stored data

{% hint style="warning" %}
**This page describes StackState version 4.6.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/setup/data-management/clear_stored_data).
{% endhint %}

The data in StackState is divided into three different sets:

* Elasticsearch data
* Kafka Topic data
* StackGraph data

With this much data to store, it is important to have the means to manage it. There is a standard 8 days data retention period set in StackState. This can be configured according to your needs using the StackState CLI or manually on each machine. Find out more about [StackState data retention](data_retention.md).

## Clear data using the StackState CLI

{% hint style="warning" %}
Clearing the data in StackState will **remove any configured permissions from the system**.
{% endhint %}

The StackState CLI needs access to the Admin API \(default port 7071\) to issue the command used below.

Running the StackState CLI delete command will:

* Stop all necessary services.
* Delete all topology and telemetry data. Note that, the Kafka topics folder needs to be deleted manually from the StackState server. The Kafka topics folder is located in `/opt/stackstate/var/lib/` and is named `kafka`.
* Start StackState.

```text
# Delete all topology and telemetry data
sts graph delete --all

# The Kafka topics folder needs to be deleted manually from the StackState server:
# /opt/stackstate/var/lib/kafka
```

## Clear data manually

{% hint style="warning" %}
Clearing the data in StackState will **remove any configured permissions from the system**.
{% endhint %}

{% tabs %}
{% tab title="Kubernetes" %}
To clear stored data in StackState running on Kubernetes, it is recommended to run a [clean install](../install-stackstate/kubernetes_install/install_stackstate.md).
{% endtab %}

{% tab title="Linux" %}
Note that the below instructions are valid for a single node installation type. For a two-node installation, you need to stop the service corresponding to the node. For example, `systemctl stop stackgraph` for a StackGraph node.

1. Stop the StackState and StackGraph services:

   ```text
   systemctl stop stackstate
   systemctl stop stackgraph
   ```

2. Remove the directory that holds the files:

   ```text
   rm -rf /opt/stackstate/var/lib/*
   ```

3. Start the StackState and StackGraph services:

   ```text
   systemctl start stackstate
   systemctl start stackgraph
   ```
{% endtab %}
{% endtabs %}

