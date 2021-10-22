# Development setup

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

The standard Kubernetes deployment of StackState is a production ready setup with many processes running multiple replicas. For development and testing purposes, it can be desirable to run StackState with lower resource requirements. Several example `values.yaml` files are provided in the [Helm chart repository](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/installation/examples):

* `test_values.yaml` sets the replica count for all services to 1, this effectively reduces the number of required nodes from 7 to 3.
* `micro_test_values.yaml` goes even further and also reduces the memory footprint of most services, thereby making it possible to run StackState within about 16GB of memory.

Note that the generated `values.yaml` should also still be included on the Helm command line, e.g.:

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values test_values.yaml \
stackstate \
stackstate/stackstate
```

{% hint style="danger" %}
Both the test and micro\_test deployments are not suitable for bigger workloads. They are not supported for production usage.
{% endhint %}
