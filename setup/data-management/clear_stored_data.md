---
description: StackState Self-hosted v5.1.x
---

# Clear stored data

The data in StackState is divided into three different sets:

* Elasticsearch data
* Kafka Topic data
* StackGraph data

With this much data to store, it's important to have the means to manage it. There is a standard 8 days data retention period set in StackState. This can be configured according to your needs using the StackState CLI or manually on each machine. Find out more about [StackState data retention](data_retention.md).

## Clear data manually

{% hint style="warning" %}
Clearing the data in StackState will **remove any configured permissions from the system**.
{% endhint %}

{% tabs %}
{% tab title="Kubernetes" %}
To clear stored data in StackState running on Kubernetes, it's recommended to run a [clean install](../install-stackstate/kubernetes_openshift/kubernetes_install.md).
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

