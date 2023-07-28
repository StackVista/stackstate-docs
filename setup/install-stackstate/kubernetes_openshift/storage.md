---
description: StackState for Kubernetes troubleshooting Self-hosted
---

# Configure storage

## Storage defaults

StackState doesn't specify a specific storage class on its PVC's \(persistent volume claims\) by default, for cloud providers like EKS and AKS this means the default storage class will be used.

The defaults for those storage classes are typically to delete the PV \(persistent volume\) when the PVC is deleted. However, even when running `helm delete` to remove a stackstate release the PVC's will remain present within the namespace and will be reused if a `helm install` is run in the same namespace with the same release name.

To remove the PVC's either remove them manually with `kubectl delete pvc` or delete the entire namespace.

## Customize storage

You can customize the `storageClass` and `size` settings for different volumes in the Helm chart. These example values files show how to change the storage class or the volume size. These can be merged to change both at the same time.

{% tabs %}
{% tab title="Changing storage class" %}
```yaml
global:
  # The storage class for most of the persistent volumes
  storageClass: "standard"

elasticsearch:
  volumeClaimTemplate:
    storageClassName: "standard"

victoria-metrics-0:
  server:
    persistentVolume:
      storageClass: "standard"
victoria-metrics-1:
  server:
    persistentVolume:
      storageClass: "standard"
```
{% endtab %}

{% tab title="Changing volume size" %}
```yaml
elasticsearch:
  volumeClaimTemplate:
    resources:
      requests:
        # size of volume for each Elasticsearch pod
        storage: 250Gi

hbase:
  hdfs:
    datanode:
      persistence:
        # size of volume for HDFS data nodes
        size: 250Gi

    namenode:
      persistence:
        # size of volume for HDFS name nodes
        size: 20Gi


kafka:
  persistence:
    # size of persistent volume for each Kafka pod
    size: 50Gi


zookeeper:
  persistence:
    # size of persistent volume for each Zookeeper pod
    size: 50Gi

victoria-metrics-0:
  server:
    persistentVolume:
      size: 250Gi
victoria-metrics-1:
  server:
    persistentVolume:
      size: 250Gi

stackstate:
  components:
    checks:
      tmpToPVC:
        volumeSize: 2Gi
    healthSync:
      tmpToPVC:
        volumeSize: 2Gi
    state:
      tmpToPVC:
        volumeSize: 2Gi
    sync:
      tmpToPVC:
        volumeSize: 2Gi
    vmagent:
      persistence:
        size: 10Gi
```
{% endtab %}

{% endtabs %}

