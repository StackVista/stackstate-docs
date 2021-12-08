# StackState images

## Overview 

This page describes the images used by the StackState Helm chart and how to configure the registry, repository and tag used to pull them.

## Serve images from a different image registry

Pulling the images from the different image registries can take some time when pods are started, either when the application starts for the first time or when it is being scaled to a new node. If one of those registries is not accessible for some reason, the pods won't start.

To address this issue, you can copy all the images to a single registry close to your Kubernetes cluster, and configure the Helm chart to pull the images from that registry:

1. Set up a registry close to your Kubernetes cluster.
   * For Amazon Elastic Kubernetes Service \(EKS\), use [Amazon Elastic Container Registry \(ECR\)](https://aws.amazon.com/ecr/).
   * For Azure Kubernetes Service \(AKS\), use [Azure Container Registry \(ACR\)](https://azure.microsoft.com/en-us/services/container-registry/).
2. Use the `copy_images.sh` script in the [installation directory \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/installation) to copy all the images used by the Helm chart to the new registry, for example:

   ```bash
   ./installation/copy_images.sh -d 57413481473.dkr.ecr.eu-west-1.amazonaws.com
   ```

   * The script will detect when an ECR registry is used and automatically create the required repositories. Most other registries will automatically create repositories when the first image is pushed to it.
   * The script has a dry-run option that can be activated with the `-t` flag. This will show the images that will be copied without actually copying them, for example:

     ```bash
      $ ./installation/copy_images.sh -d 57413481473.dkr.ecr.eu-west-1.amazonaws.com -t
      Copying justwatch/elasticsearch_exporter:1.1.0 to 57413481473.dkr.ecr.eu-west-1.amazonaws.com/justwatch/elasticsearch_exporter:1.1.0 (dry-run)
      Copying quay.io/stackstate/stackgraph-console:3.6.14 to 57413481473.dkr.ecr.eu-west-1.amazonaws.com/stackstate/stackgraph-console:3.6.14 (dry-run)
      Copying quay.io/stackstate/stackstate-server-stable:4.2.2 to 57413481473.dkr.ecr.eu-west-1.amazonaws.com/stackstate/stackstate-server-stable:4.2.2 (dry-run)
      Copying quay.io/stackstate/wait:1.0.0 to 57413481473.dkr.ecr.eu-west-1.amazonaws.com/stackstate/wait:1.0.0 (dry-run)
      Copying quay.io/stackstate/stackstate-server-stable:4.2.2 to 57413481473.dkr.ecr.eu-west-1.amazonaws.com/stackstate/stackstate-server-stable:4.2.2 (dry-run)
     ```

   * Additional optional flags can be used when running the script:
     * `-c` specify a different chart to use.
     * `-r` specify a different repository to use.

3. Add the registry to the global configuration section in your `values.yaml`. For example:

   ```yaml
   global:
    imageRegistry: 57413481473.dkr.ecr.eu-west-1.amazonaws.com
   ```

4. Add a separate entry for the image used by the `prometheus-elasticsearch-exporter` subchart. This is required as it cannot be configured with the setting `global.imageRegistry`. For example:

     ```yaml
      elasticsearch:
        prometheus-elasticsearch-exporter:
          image:
            repository: 57413481473.dkr.ecr.eu-west-1.amazonaws.com/justwatch/elasticsearch_exporter
     ```

## Configuration

### API

Configured in StackState values.yaml:

* **Image** - `quay.io/stackstate/stackstate-server`
* **Registry**: ???
* **Repository**: `stackstate.components.api.image.repository`
* **Tag**: `stackstate.components.api.image.tag` - overrides `stackstate.components.all.image.tag` on a per-service basis.

### Correlate

Configured in StackState values.yaml.

* `stackstate.components.correlate.image.repository` - Repository of the correlate component Docker image.
* `stackstate.components.correlate.image.tag` - Tag used for the `correlate` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
* **image** - `quay.io/stackstate/stackstate-correlate`

Registry taken from ???

### Kafka-to-ElasticSearch 

Configured in StackState values.yaml.

* `stackstate.components.mm2es.image.repository` - Repository of the mm2es component Docker image.
* `stackstate.components.mm2es.image.tag` - Tag used for the `mm2es` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
* **image** - `quay.io/stackstate/stackstate-kafka-to-es-stable`

Registry taken from ???