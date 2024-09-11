---
description: SUSE Observability Self-hosted
---

# Non-high availability setup

## Overview

The recommended Kubernetes/OpenShift deployment of SUSE Observability is a production ready setup with many services running redundantly. If required, it's also possible to run SUSE Observability in a non-redundant setup, where each service has only a single replica.

{% hint style="info" %}
The non-high availability setup is only suitable for situations that don't require high availability.
{% endhint %}

## Create `nonha_values.yaml`

To deploy SUSE Observability in a non-high availability setup, you will need a `nonha_values.yaml` file. Follow the instructions below to create this file and use it for deployment of SUSE Observability.

1. Create a Helm values file `nonha_values.yaml` with the following content and store it next to the generated `values.yaml` file:

  ```yaml
  # This files defines additional Helm values to run SUSE Observability on a
  # non-high availability production setup. Use this file in combination
  # with a regular values.yaml file that contains your API key, etc.
  elasticsearch:
    minimumMasterNodes: 1
    replicas: 1

  hbase:
    deployment:
      mode: "Mono"
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
    experimental:
      server:
        split: false

  victoria-metrics-1:
    enabled: false

  zookeeper:
    replicaCount: 1

  clickhouse:
    replicaCount: 1
  ```

2. Continue with the instructions to deploy SUSE Observability with Helm:
   * [Deploy on Kubernetes](/setup/install-stackstate/kubernetes_openshift/kubernetes_install.md#deploy-suse-observability-with-helm).
   * [Deploy on OpenShift](/setup/install-stackstate/kubernetes_openshift/openshift_install.md#deploy-suse-observability-with-helm).

