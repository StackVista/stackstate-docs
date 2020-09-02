# requirements

StackState can be installed on a Kubernetes cluster via Helm charts provided by StackState. These charts have been tested and are compatible with Kubernetes 1.15.x \(tested on Amazon EKS and Azure AKS\) and Helm 3.

For a list of all docker images used see the [image overview](image_configuration.md).

### Node sizing

For the standard deployment with the helm chart StackState will deploy storage services in a redundant setup with 3 instances of each service. The nodes for different environments:

* Virtual machines: 6 nodes with `16GB memory`, `4 vCPUs`
* Amazon EKS: 6 instances of type `m5.xlarge` or `m4.xlarge`
* Azure AKS: 6 instances of type `D4s v3` or `D4as V4` \(Intel or AMD cpu's\)

### Storage

StackState uses persistent volume claims for the services that need to store data. The default storage class for the cluster will be used for all services unless this is overriden via values specified on the command line or a `values.yaml` file. All services come with a pre-configured volume size that should get you started, but can be customized via variables as well.

The [storage](storage.md) docs page goes into more details on the defaults used.

### Ingress

By default the helm chart will deploy a router pod and service. This services port 8080 is the only entrypoint that needs to be exposed via ingress. Without configuring ingress you can access StackState by forwarding this port like this:

```text
kubectl port-forward service/<helm-release-name>-distributed-router 8080:8080
```

When configuring ingress make sure to allow for large request body sizes \(50MB\) that may be sent occasionally by data sources like the stackstate agent or the aws integration.

For more details on configuring ingress have a look at the [ingress](ingress.md) docs.
