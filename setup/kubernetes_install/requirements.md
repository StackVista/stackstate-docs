# requirements

StackState can be installed on a Kubernetes cluster using the Helm charts provided by StackState. These charts have been tested and are compatible with Kubernetes 1.15.x \(tested on Amazon EKS and Azure AKS\) and Helm 3.

For a list of all docker images used see the [image overview](image_configuration.md).

### Node sizing

For a standard deployment, the StackState Helm chart will deploy storage services in a redundant setup with 3 instances of each service. The nodes required for different environments:

* **Virtual machines:** 6 nodes with `16GB memory`, `4 vCPUs`
* **Amazon EKS:** 6 instances of type `m5.xlarge` or `m4.xlarge`
* **Azure AKS:** 6 instances of type `D4s v3` or `D4as V4` \(Intel or AMD CPUs\)

### Storage

StackState uses persistent volume claims for the services that need to store data. The default storage class for the cluster will be used for all services unless this is overridden by values specified on the command line or in a `values.yaml` file. All services come with a pre-configured volume size that should be good to get you started, but can be customized later using variables as required.

For more details on the defaults used, see the page [Configure storage](storage.md).

### Ingress

By default, the StackState Helm chart will deploy a router pod and service. This service's port `8080` is the only entry point that needs to be exposed via Ingress. You can access StackState without configuring Ingress by forwarding this port:

```text
kubectl port-forward service/<helm-release-name>-distributed-router 8080:8080
```

When configuring Ingress, make sure to allow for large request body sizes \(50MB\) that may be sent occasionally by data sources like the StackState Agent or the AWS integration.

For more details on configuring Ingress, have a look at the page [Configure Ingress docs](ingress.md).
