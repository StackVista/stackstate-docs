# Non-redundant setup

The recommended Kubernetes deployment of StackState is a production ready setup with many services running redundantly. However, it is also possible to run StackState in a non-redundant setup, where each service has only a single replica. This setup is not highly available.

To run this setup

1. Save the additional Helm values below in a file called `nonha_values.yaml` 

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

2. Install StackState with this additional Helm values file: 

```bash
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values nonha_values.yaml \
stackstate \
stackstate/stackstate
```
