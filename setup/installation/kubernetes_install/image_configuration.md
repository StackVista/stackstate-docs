# StackState images

This page describes the images used by the StackState Helm chart and how to configure the registry, repository and tag used to pull them.

## Serving the images from a different image registry

Pulling the images from the different image registries can take some time when pod are started, either when the application starts for the first time or when it is being scaled to a new node. Also, if one of those registries is not accessible, the pods won't start.

To address this issue, you can copy all the images to a single registry, close to your Kubernetes cluster, and configure the Helm chart to pull the images from that registry:

1. Set up a registry close to your Kubernetes cluster.
   * For Amazon Elastic Kubernetes Service \(EKS\), use [Amazon Elastic Container Registry \(ECR\)](https://aws.amazon.com/ecr/).
   * For Azure Kubernetes Service \(AKS\), use [Azure Container Registry \(ACR\)](https://azure.microsoft.com/en-us/services/container-registry/).
2. Use the `copy_images.sh` script in the [installation directory](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/installation) to copy all the images used by the Helm chart to that registry, for example:

   ```text
   ./stackstate/installation/copy_images.sh -d 57413481473.dkr.ecr.eu-west-1.amazonaws.com
   ```

3. Add the registry to the global configuration section in your `values.yaml`, e.g.:

   ```text
   global:
    imageRegistry: 57413481473.dkr.ecr.eu-west-1.amazonaws.com
   ```

