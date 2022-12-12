---
description: StackState Self-hosted v5.1.x 
---

# Non-high availability setup

## Overview

The recommended Kubernetes/OpenShift deployment of StackState is a production ready setup with many services running redundantly. If required, it's also possible to run StackState in a non-redundant setup, where each service has only a single replica.

{% hint style="info" %}
The non-high availability setup is only suitable for situations that do not require high availability.
{% endhint %}

## Create `nonha_values.yaml`

To deploy StackState in a non-high availability setup, you will need a `nonha_values.yaml` file. Follow the instructions below to create this file and use it for deployment of StackState.

1. Create a Helm values file `nonha_values.yaml` with the following content and store it next to the generated `values.yaml` file:

   ```yaml
    # This files defines additional Helm values to run StackState on a 
    # non-high availability production setup. Use this file in combination
    # with a regular values.yaml file that contains your API key, etc.
    elasticsearch:
      minimumMasterNodes: 1
      replicas: 1

    hbase:
      hbase:
        master:
          replicaCount: 1
        regionserver:
          replicaCount: 1
      hdfs:
        datanode:
          replicaCount: 1
        secondarynamenode:
          enabled: false
      tephra:
        replicaCount: 1

    kafka:
      replicaCount: 1
      defaultReplicationFactor: 1
      offsetsTopicReplicationFactor: 1
      transactionStateLogReplicationFactor: 1
    stackstate:
      components:
        ui:
          replicaCount: 1

    zookeeper:
      replicaCount: 1
   ```

2. Continue with the instructions to deploy StackState with Helm:
   * [Deploy on Kubernetes](/setup/install-stackstate/kubernetes_openshift/kubernetes_install.md#deploy-stackstate-with-helm).
   * [Deploy on OpenShift](/setup/install-stackstate/kubernetes_openshift/openshift_install.md#deploy-stackstate-with-helm).

