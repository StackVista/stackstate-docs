# Non-HA setup

## Overview

The recommended Kubernetes deployment of StackState is a [production ready setup](/setup/installation/kubernetes_install/install_stackstate.md) with many services running redundantly. However, it is also possible to run StackState in a non-redundant setup, where each service has only a single replica. Note that this setup is only suitable for situations that do not require high availability.

## Non-high availability setup

To run StackState in a non-high availability setup (non-HA):

1. Create a Helm values file `nonha_values.yaml` with the following content: 

```yaml
# This files defines additional Helm values to run StackState on a non-HA production setup.
# Use this file in combination with a regular values.yaml file that contains your API key, etc.
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

2. Install StackState with the `nonha_values.yaml` Helm values file: 

```bash
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values nonha_values.yaml \
stackstate \
stackstate/stackstate
```
