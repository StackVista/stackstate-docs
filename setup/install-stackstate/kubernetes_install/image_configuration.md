# StackState images

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

## Image configuration

### API

* **Chart:** StackState
* **Image:** `quay.io/stackstate/stackstate-server`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag:
    api:
      image:
        repository: stackstate/stackstate-server
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### containerTools

* **Chart:** StackState
* **Image:** `quay.io/stackstate/container-tools`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry:
        tag: 
    containerTools:
      image:
        # will override `stackstate.components.all.image.registry`
        registry: quay.io
        repository: stackstate/container-tools
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### Correlate

* **Chart:** StackState
* **Image:** `quay.io/stackstate/stackstate-correlate`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag: 
    correlate:
      image:
        repository: stackstate/stackstate-correlate
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### Checks

* **Chart:** StackState
* **Image:** `quay.io/stackstate/stackstate-server`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag: 
    checks:
      image:
        repository: stackstate/stackstate-server
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### healthSync

* **Chart:** StackState
* **Image:** `quay.io/stackstate/stackstate-server`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag: 
    healthSync:
      image:
        repository: stackstate/stackstate-server
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### initializer

* **Chart:** StackState
* **Image:** `quay.io/stackstate/stackstate-server`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag: 
    initializer:
      image:
        repository: stackstate/stackstate-server
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### Kafka

* **Chart:** StackState
* **Image:** `quay.io/stackstate/kafka`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: 
        tag: 
    kafka:
      image:
        # will override `stackstate.components.all.image.registry`
        registry: quay.io
        repository: stackstate/kafka
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### Kafka JMX exporter

* **Chart:** StackState
* **Image:** `quay.io/stackstate/jmx-exporter`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: 
        tag: 
    metrics:
      kafka:
        image:
          # will override `stackstate.components.all.image.registry`
          registry: quay.io
          repository: stackstate/jmx-exporter
          # will override `stackstate.components.all.image.tag`
          tag: 
```

### Kafka-to-Elasticsearch

* **Chart:** StackState
* **Image:** `quay.io/stackstate/stackstate-kafka-to-es`

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag: 
    mm2es:
      image:
        repository: stackstate/stackstate-kafka-to-es
        # will override `stackstate.components.all.image.tag`
        tag:
    e2es:
      image:
        repository: stackstate/stackstate-kafka-to-es
        # will override `stackstate.components.all.image.tag`
        tag:
    trace2es:
      image:
        repository: stackstate/stackstate-kafka-to-es
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### Kafka-topic-create

* **Chart:** StackState
* **Image:** `quay.io/stackstate/kafka`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: 
        tag: 
    kafkaTopicCreate:
      image:
        # will override `stackstate.components.all.image.registry`
        registry: quay.io
        repository: stackstate/kafka
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### minio

* **Chart:** StackState
* **Image:** `quay.io/stackstate/minio`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag: 
    minio:
      image:
        repository: stackstate/minio
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### nginxPrometheusExporter

* **Chart:** StackState
* **Image:** `quay.io/stackstate/nginx-prometheus-exporter`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: 
        tag: 
    nginxPrometheusExporter:
      image:
        # will override `stackstate.components.all.image.registry`
        registry: quay.io
        repository: stackstate/nginx-prometheus-exporter
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### problemProducer

* **Chart:** StackState
* **Image:** `quay.io/stackstate/stackstate-server`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag: 
    problemProducer:
      image:
        repository: stackstate/stackstate-server
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### Receiver

* **Chart:** StackState
* **Image:** `quay.io/stackstate/stackstate-receiver`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag: 
    receiver:
      image:
        repository: stackstate/stackstate-receiver
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### Router

* **Chart:** StackState
* **Image:** `quay.io/stackstate/envoy-alpine`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: 
        tag: 
    router:
      image:
        # will override `stackstate.components.all.image.registry`
        registry: quay.io
        repository: stackstate/envoy-alpine
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### Server

* **Chart:** StackState
* **Image:** `quay.io/stackstate/stackstate-server`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag: 
    server:
      image:
        repository: stackstate/stackstate-server
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### Slicing

* **Chart:** StackState
* **Image:** `quay.io/stackstate/stackstate-server`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag: 
    slicing:
      image:
        repository: stackstate/stackstate-server
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### Spotlight

* **Chart:** StackState
* **Image:** `quay.io/stackstate/spotlight`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: 
        tag: 
    anomaly-detection:
      image:
        # will override `stackstate.components.all.image.registry`
        registry: quay.io      
        spotlightRepository: stackstate/minio
```

### State

* **Chart:** StackState
* **Image:** `quay.io/stackstate/stackstate-server`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag: 
    state:
      image:
        repository: stackstate/stackstate-server
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### Sync

* **Chart:** StackState
* **Image:** `quay.io/stackstate/stackstate-server`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag: 
    sync:
      image:
        repository: stackstate/stackstate-server
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### UI

* **Chart:** StackState
* **Image:** `quay.io/stackstate/stackstate-ui`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag: 
    ui:
      image:
        repository: stackstate/stackstate-ui
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### viewHealth

* **Chart:** StackState
* **Image:** `quay.io/stackstate/stackstate-server`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: quay.io
        tag: 
    viewHealth:
      image:
        repository: stackstate/stackstate-server
        # will override `stackstate.components.all.image.tag`
        tag: 
```

### wait

* **Chart:** StackState and HBase
* **Image:** `quay.io/stackstate/wait`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry:
        tag: 
    wait:
      image:
        # will override `stackstate.components.all.image.registry`
        registry: quay.io
        repository: stackstate/wait
        # will override `stackstate.components.all.image.tag`
        tag: 
hbase:
  components:
    all:
      image:
        registry:
    wait:
      image:
        # will override `hbase.components.all.image.registry`
        registry: quay.io
        repository: stackstate/wait
        tag: 
```

### Zookeeper

* **Chart:** StackState
* **Image:** `quay.io/stackstate/zookeeper`
* **Configuration:**

```yaml
global:
  # will override any other registry configuration
  imageRegistry: 
stackstate:
  components:
    all:
      image:
        registry: 
        tag: 
    zookeeper:
      # if set to false, will use external zookeeper servers
      enabled: true
      image:
        # will override `stackstate.components.all.image.registry`
        registry: quay.io
        repository: stackstate/zookeeper
        # will override `stackstate.components.all.image.tag`
        tag: 
```

## Elasticsearch
```yaml
imageRegistry: "quay.io"
imageRepository: "stackstate/elasticsearch"
imageTag: "7.6.2-yu"
```
and
```yaml
prometheus-elasticsearch-exporter:
  # prometheus-elasticsearch-exporter.enabled -- Enable to expose prometheus metrics
  enabled: false
  image:
    # prometheus-elasticsearch-exporter.image.repository -- Elastichsearch Prometheus exporter image repository
    repository: quay.io/stackstate/elasticsearch-exporter
    # prometheus-elasticsearch-exporter.image.tag -- Elastichsearch Prometheus exporter image tag
    tag: v1.2.1

```

## HBase

```yaml
all:
  image:
    # all.image.registry -- Base container image registry for all containers, except for the wait container
    registry: quay.io

```

and
```yaml
stackgraph:
  image:
    # stackgraph.image.tag -- The default tag used for all omponents of hbase that are stackgraph version dependent; invividual service `tag`s can be overriden (see below).
    tag: 4.2.10

```
and
```yaml
console:
  image:
    # console.image.repository -- Base container image repository for console pods.
    repository: stackstate/stackgraph-console
    # console.image.tag -- Container image tag for console pods, defaults to `stackgraph.image.tag`
    tag:
```
and wait
and
```yaml
hbase:
  master:
    image:
      # hbase.master.image.repository -- Base container image repository for HBase masters.
      repository: stackstate/hbase-master
      # hbase.master.image.tag -- Container image tag for HBase masters, defaults to `stackgraph.image.tag`
      tag:

```
and
```yaml
hbase:
  regionserver:
    image:
      # hbase.regionserver.image.repository -- Base container image repository for HBase region servers.
      repository: stackstate/hbase-regionserver
      # hbase.regionserver.image.tag -- Container image tag for HBase region servers, defaults to `stackgraph.image.tag`
      tag:
```
and
```yaml
hdfs:
  image:
    # hdfs.image.repository -- Base container image repository for HDFS datanode.
    repository: stackstate/hadoop
    # hdfs.image.tag -- Default container image tag for HDFS datanode.
    tag: 2.9.2-java11-3

```
and
```yaml
tephra:
  image:
    # tephra.image.repository -- Base container image repository for Tephra pods.
    _repository: stackstate_/tephra-server
    # tephra.image.tag -- Container image tag for Tephra pods, defaults to `stackgraph.image.tag`
    tag:

```