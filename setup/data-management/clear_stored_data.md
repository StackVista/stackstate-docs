---
description: StackState Self-hosted v5.1.x
---

# Clear stored data

The data in StackState is divided into three different sets:

* Elasticsearch data
* Kafka Topic data
* StackGraph data

With this much data to store, it is important to have the means to manage it. There is a standard 8 days data retention period set in StackState. This can be configured according to your needs using the StackState CLI or manually on each machine. Find out more about [StackState data retention](data_retention.md).

## Clear data using the `stac` CLI

{% hint style="warning" %}
Clearing the data in StackState will **remove any configured permissions from the system**.
{% endhint %}

The `stac` CLI needs access to the Admin API \(default port 7071\) to issue the command used below.

Running the `stac` CLI delete command will:

* Stop all necessary services.
* Delete all topology and telemetry data. Note that, the Kafka topics folder needs to be deleted manually from the StackState server. The Kafka topics folder is located in `/opt/stackstate/var/lib/` and is named `kafka`.
* Start StackState.

{% tabs %}
{% tab title="CLI: stac (deprecated)" %}

```text
# Delete all topology and telemetry data
stac graph delete --all

# The Kafka topics folder needs to be deleted manually from the StackState server:
# /opt/stackstate/var/lib/kafka
```

⚠️ **From StackState v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="CLI: sts" %}

Command not available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% endtabs %}

## Clear data manually

{% hint style="warning" %}
Clearing the data in StackState will **remove any configured permissions from the system**.
{% endhint %}

{% tabs %}
{% tab title="Kubernetes" %}
To clear stored data in StackState running on Kubernetes, it is recommended to run a [clean install](../install-stackstate/kubernetes_openshift/kubernetes_install.md).
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

