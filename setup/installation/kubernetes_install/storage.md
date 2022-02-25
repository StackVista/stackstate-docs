# Configure storage

{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Storage defaults

StackState doesn't specify a specific storage class on its PVC's \(persistent volume claims\) by default, for cloud providers like EKS and AKS this means the default storage class will be used.

The defaults for those storage classes are typically to delete the PV \(persistent volume\) when the PVC is deleted. Note that even when running `helm delete` to remove a stackstate release the PVC's will remain present within the namespace and will be reused if a `helm install` is run in the same namespace with the same release name.

To remove the PVC's either remove them manually with `kubectl delete pvc` or delete the entire namespace.

## Customize storage

You can customize the `storageClass` and `size` settings for different volumes in the Helm chart. The example values.yaml files provided in the [GitHub Helm chart repo](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/installation/examples) show how you can customize the `size` of volumes. The `storageClass` can be added in a similar fashion.

In the example below, all services that store data are switched to rely on the storageClass named `standard` and not use the default storageClass configured for the Kubernetes cluster:

{% tabs %}
{% tab title="values.yaml" %}
```text
elasticsearch:
  volumeClaimTemplate:
    storageClassName: "standard"

hbase:
  hdfs:
    datanode:
      persistence:
        storageClass: "standard"
    namenode:
      persistence:
        storageClass: "standard"

kafka:
  persistence:
    storageClass: "standard"

zookeeper:
  persistence:
    storageClass: "standard"
```
{% endtab %}
{% endtabs %}

