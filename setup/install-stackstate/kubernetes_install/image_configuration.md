---
description: StackState Self-hosted v4.5.x
---

# StackState images

{% hint style="warning" %}
This page describes StackState v4.5.x.
The StackState 4.5 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.5 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/setup/install-stackstate/kubernetes_install/image_configuration).
{% endhint %}

## Overview

This page describes the images used by the StackState Helm chart and how to configure the registry, repository and tag used to pull them.

## Serve images from a different image registry

Pulling the images from the different image registries can take some time when pods are started, either when the application starts for the first time or when it is being scaled to a new node. If one of those registries is not accessible for some reason, the pods won't start.

To address this issue, you can copy all the images to a single registry close to your Kubernetes cluster, and configure the Helm chart to pull the images from that registry:

1. Set up a registry close to your Kubernetes cluster.
   * For Amazon Elastic Kubernetes Service (EKS), use [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/).
   * For Azure Kubernetes Service (AKS), use [Azure Container Registry (ACR)](https://azure.microsoft.com/en-us/services/container-registry/).
2.  Use the `copy_images.sh` script in the [installation directory (github.com)](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/installation) to copy all the images used by the Helm chart to the new registry, for example:

    ```bash
    ./installation/copy_images.sh -d 57413481473.dkr.ecr.eu-west-1.amazonaws.com
    
    ```

    * The script will detect when an ECR registry is used and automatically create the required repositories. Most other registries will automatically create repositories when the first image is pushed to it.
    *   The script has a dry-run option that can be activated with the `-t` flag. This will show the images that will be copied without actually copying them, for example:

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
3.  Add the registry to the global configuration section in your `values.yaml`. For example:

    ```yaml
    global:
      imageRegistry: 57413481473.dkr.ecr.eu-west-1.amazonaws.com
    ```
4.  Add a separate entry for the image used by the `prometheus-elasticsearch-exporter` subchart. This is required as it cannot be configured with the setting `global.imageRegistry`. For example:

    ```yaml
     elasticsearch:
       prometheus-elasticsearch-exporter:
         image:
           repository: 57413481473.dkr.ecr.eu-west-1.amazonaws.com/justwatch/elasticsearch_exporter
    ```

## Images

The images listed below are used in StackState v4.5.6:

* quay.io/stackstate/container-tools:1.1.3
* quay.io/stackstate/elasticsearch-exporter:v1.2.1
* quay.io/stackstate/elasticsearch:7.6.2-sts.20220316.0825
* quay.io/stackstate/envoy-alpine:v1.19.1-sts.20211207.0748
* quay.io/stackstate/hadoop:2.10.1-java11-4
* quay.io/stackstate/hbase-master:4.2.19
* quay.io/stackstate/hbase-regionserver:4.2.19
* quay.io/stackstate/jmx-exporter:0.15.0-focal-20220316-r138.20220405.1513
* quay.io/stackstate/kafka:2.3.1-focal-20220316-r41.1
* quay.io/stackstate/kafka:2.8.0-focal-20220316-r108.20220405.1511
* quay.io/stackstate/minio:2021.2.19-focal-20220316-r5.20220405.1533
* quay.io/stackstate/nginx-prometheus-exporter:0.9.0
* quay.io/stackstate/spotlight:4.5.6
* quay.io/stackstate/stackgraph-console:4.2.19
* quay.io/stackstate/stackstate-correlate-stable:4.5.6
* quay.io/stackstate/stackstate-kafka-to-es-stable:4.5.6
* quay.io/stackstate/stackstate-receiver-stable:4.5.6
* quay.io/stackstate/stackstate-server-stable:4.5.6
* quay.io/stackstate/stackstate-ui-stable:4.5.6
* quay.io/stackstate/tephra-server:4.2.19
* quay.io/stackstate/wait:1.0.6
* quay.io/stackstate/zookeeper:3.6.3-focal-20220316-r302.20220411.1232
