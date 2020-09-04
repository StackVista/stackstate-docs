# Configure storage

## Storage defaults

StackState doesn't specify a specific storage class on its PVC's \(persistent volume claims\) by default, for cloud providers like EKS and AKS this means the default storage class will be used.

The defaults for those storage classes are typically to delete the PV \(persistent volume\) when the PVC is deleted. Note that even when running `helm delete` to remove a stackstate release the PVC's will remain present within the namespace and will be reused if a `helm install` is run in the same namespace with the same release name.

To remove the PVC's either remove them manually with `kubectl delete pvc` or delete the entire namespace.

## Customizing

The `storageClass` and `size` for the different volumes can be customized. The [`micro_test_values.yaml`](https://github.com/StackVista/helm-charts/blob/master/stable/stackstate/installation/examples/micro_test_values.yaml.yaml) is an example of how to customize the `size` of the volumes. The `storageClass` can be added in a similar fashion.

Note that only for Elasticsearch this is deviating, it uses instead the full volumeClaimTemplate \(i.e. `volumeClaimTemplate.storageClassName` should be used\).

