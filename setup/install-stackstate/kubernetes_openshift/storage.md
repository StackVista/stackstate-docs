---
description: SUSE Observability Self-hosted
---

# Configure storage

## Storage defaults

SUSE Observability doesn't specify a specific storage class on its PVC's \(persistent volume claims\) by default, for cloud providers like EKS and AKS this means the default storage class will be used.

The defaults for those storage classes are typically to delete the PV \(persistent volume\) when the PVC is deleted. However, even when running `helm delete` to remove a stackstate release the PVC's will remain present within the namespace and will be reused if a `helm install` is run in the same namespace with the same release name.

To remove the PVC's either remove them manually with `kubectl delete pvc` or delete the entire namespace.

## Customize storage

You can customize the `storageClass` and `size` settings for different volumes in the Helm chart. These example values files show how to change the storage class or the volume size. These can be merged to change both at the same time.
For the `size` we provide the sameple for both `HA` and `NonHa` depending on the sizing profile chosen during the installation process.

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

{% tab title="Changing volume size for HA" %}
```yaml
clickhouse:
  persistence:
    # Size of persistent volume for each clickhouse pod
    size: 50Gi
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
    size: 100Gi


zookeeper:
  persistence:
    # size of persistent volume for each Zookeeper pod
    size: 8Gi

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
{% tab title="Changing volume size Non-Ha" %}
```yaml
clickhouse:
  persistence:
    # Size of persistent volume for each clickhouse pod
    size: 50Gi

elasticsearch:
  volumeClaimTemplate:
    resources:
      requests:
        # size of volume for each Elasticsearch pod
        storage: 250Gi

hbase:
  stackgraph:
    persistence:
      # Size of persistent volume for the single stackgraph hbase pod
      size: 100Gi

kafka:
  persistence:
    # size of persistent volume for each Kafka pod
    size: 100Gi


zookeeper:
  persistence:
    # size of persistent volume for each Zookeeper pod
    size: 8Gi

victoria-metrics-0:
  server:
    persistentVolume:
      size: 50Gi

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

{% hint style="info" %}
The NonHa example belongs to the biggest NonHa instance meant to observe 100 nodes and retain data for 2 weeks.
{% endhint %}