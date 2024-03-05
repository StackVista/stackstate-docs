---
description: StackState SaaS
---

# Install from custom image registry

## Overview

This page describes how to use a custom image registry to install StackState, the StackState Agent, Cluster Agent and kube-state-metrics. The required images are first copied and then the helm chart can then be configured to pull images using the custom registry and tag.

## Serve images from a different image registry

Pulling the images from the different image registries can take some time when pods are started, either when the application starts for the first time or when it's being scaled to a new node. If one of those registries isn't accessible for some reason, the pods won't start.

To address this issue, you can copy all the images to a single registry close to your cluster, and configure the Helm chart to pull the images from that registry:

{% hint style="info" %}
The install script `copy_images.sh` must be run on an Intel x86_64 machine. It isn't compatible with Macs that have an M1 or M2 processor.
{% endhint %}

1. Set up a registry close to your cluster.
   * For Amazon Elastic Kubernetes Service (EKS), use [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/).
   * For Azure Kubernetes Service (AKS), use [Azure Container Registry (ACR) \(azure.microsoft.com\)](https://azure.microsoft.com/en-us/products/container-registry/).
2. Log in to both Docker image registries:
   * **StackState image registry** - `docker login quay.io` - use the username and password provided by StackState.
   * **Custom image registry** - `docker login --username <USERNAME>  <CUSTOM_REGISTRY_ADDRESS>`
3. Download the relevant script and use this to copy all images used by the Helm chart to the custom registry. Note that you will first need to make the downloaded script executable:
   * **StackState Agent:** [stackstate-agent/installation/copy_images.sh \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate-agent/installation/copy_images.sh)
   * For example: 

      ```bash
      # make downloaded script executable
      chmod a+x copy_images.sh
      
      # download images to the custom image registry
      ./installation/copy_images.sh -d <CUSTOM_REGISTRY_ADDRESS>
  
      ```

    * The script will detect when an ECR registry is used and automatically create the required repositories. Most other registries will automatically create repositories when the first image is pushed to it. 
    * The script has a dry-run option that can be activated with the `-t` flag. This will show the images that will be copied without actually copying them, for example:

        ```bash
         $ ./installation/copy_images.sh -d 57413481473.dkr.ecr.eu-west-1.amazonaws.com -t
         Copying stackstate/elasticsearch_exporter:1.1.0 to 57413481473.dkr.ecr.eu-west-1.amazonaws.com/stackstate/elasticsearch_exporter:1.1.0 (dry-run)
         Copying quay.io/stackstate/stackgraph-console:3.6.14 to 57413481473.dkr.ecr.eu-west-1.amazonaws.com/stackstate/stackgraph-console:3.6.14 (dry-run)
         Copying quay.io/stackstate/stackstate-server-stable:4.2.2 to 57413481473.dkr.ecr.eu-west-1.amazonaws.com/stackstate/stackstate-server-stable:4.2.2 (dry-run)
         Copying quay.io/stackstate/wait:1.0.0 to 57413481473.dkr.ecr.eu-west-1.amazonaws.com/stackstate/wait:1.0.0 (dry-run)
         Copying quay.io/stackstate/stackstate-server-stable:4.2.2 to 57413481473.dkr.ecr.eu-west-1.amazonaws.com/stackstate/stackstate-server-stable:4.2.2 (dry-run)

        ```
    * Additional optional flags can be used when running the script:
      * `-c` specify a different chart to use.
      * `-r` specify a different repository to use.
4. Edit the `values.yaml` file and add the following:
   * **global.imageRegistry** - the registry to use.
   * **global.imagePullSecrets** and **pull-secret** object - optional. The authentication details required for the `global.imageRegistry`.
   * **minio.image.registry** - The image registry used by the minio sub-chart. Required as it can't be configured with the setting `global.imageRegistry`.
   * **elasticsearch.prometheus-elasticsearch-exporter.image.repository** - the image used by the prometheus-elasticsearch-exporter sub-chart. Required as it can't be configured with the setting `global.imageRegistry`.
    ```yaml
    global:
      imageRegistry: 57413481473.dkr.ecr.eu-west-1.amazonaws.com
    ## to specify authentication details for the global.imageRegistry
    ## add the sections below.
    #   imagePullSecrets:
    #   - stackstate-pull-secret
    # pull-secret:
    #   enabled: true
    #   fullNameOverride: stackstate-pull-secret
    #   credentials:
    #   - registry: 57413481473.dkr.ecr.eu-west-1.amazonaws.com
    #     username: johndoe
    #     password: my_secret-p@ssw0rd
   
    minio:
      image:
        registry: 57413481583.dkr.ecr.eu-west-1.amazonaws.com

     elasticsearch:
       prometheus-elasticsearch-exporter:
         image:
           repository: 57413481473.dkr.ecr.eu-west-1.amazonaws.com/stackstate/elasticsearch_exporter
    ```

## Images

### StackState

{% hint style="success" "self-hosted info" %}

**StackState Self-Hosted**

Extra information for the [StackState Self-Hosted product](https://docs.stackstate.com/):

    
The images listed below are used in StackState v5.1.2:

- quay.io/stackstate/container-tools:1.1.4
- quay.io/stackstate/elasticsearch-exporter:v1.2.1-2738680411
- quay.io/stackstate/elasticsearch:7.17.2-2738749846
- quay.io/stackstate/envoy:v1.19.1-2738711656
- quay.io/stackstate/hadoop:2.10.1-java11-6-2738734712
- quay.io/stackstate/hbase-master:4.9.2
- quay.io/stackstate/hbase-regionserver:4.9.2
- quay.io/stackstate/jmx-exporter:0.17.0-2738680727
- quay.io/stackstate/kafka:2.8.1-2738720666
- quay.io/stackstate/kafkaup-operator:0.0.2
- quay.io/stackstate/minio:RELEASE.2021-02-14T04-01-33Z-3118065624
- quay.io/stackstate/nginx-prometheus-exporter:0.9.0-2738682730
- quay.io/stackstate/spotlight:5.1.2
- quay.io/stackstate/stackgraph-console:4.9.2
- quay.io/stackstate/stackstate-correlate-stable:5.1.2
- quay.io/stackstate/stackstate-kafka-to-es-stable:5.1.2
- quay.io/stackstate/stackstate-receiver-stable:5.1.2
- quay.io/stackstate/stackstate-server-stable:5.1.2
- quay.io/stackstate/stackstate-ui-stable:5.1.2
- quay.io/stackstate/tephra-server:4.9.2
- quay.io/stackstate/wait:1.0.7-2755960650
- quay.io/stackstate/zookeeper:3.6.3-2738717608

{% endhint %}

### StackState Agent, Cluster Agent and kube-state-metrics

The images listed below are used in StackState Agent v2.19.1:

* quay.io/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032
* quay.io/stackstate/stackstate-agent-2:2.19.1
* quay.io/stackstate/stackstate-cluster-agent:2.19.1
* quay.io/stackstate/stackstate-process-agent:4.0.10