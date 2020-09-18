---
title: Install StackState
kind: Documentation
---

# StackState images

## Installing StackState

{% hint style="warning" %}
This page describes StackState version 4.0.  
Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## StackState images

This page describes the images used by the StackState Helm chart and how to configure the registry, repository and tag used to pull them.

### Serving the images from a different image registry

Pulling the images from the different image registries can take some time when pod are started, either when the application starts for the first time or when it is being scaled to a new node. Also, if one of those registries is not accessible, the pods won't start.

To address this issue, you can copy all the images to a single registry, close to your Kubernetes cluster, and configure the Helm chart to pull the images from that registry:

1. Set up a registry close to your Kubernetes cluster.
   * For Amazon Elastic Kubernetes Service \(EKS\), use [Amazon Elastic Container Registry \(ECR\)](https://aws.amazon.com/ecr/).
   * For Azure Kubernetes Service \(AKS\), use [Azure Container Registry \(ACR\)](https://azure.microsoft.com/en-us/services/container-registry/).
2. Use the `copy_images.sh` script in the [installation directory](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/installation) to copy all the images used by the Helm chart to that registry, e.g.:

   ```text
   ./stackstate/installation/copy_images.sh -d 57413481473.dkr.ecr.eu-west-1.amazonaws.com
   ```

3. Add the registry to the global configuration section in your `values.yaml`, e.g.:

   ```text
   global:
    imageRegistry: 57413481473.dkr.ecr.eu-west-1.amazonaws.com
   ```

### Configuration

| Chart | Component | Image | Value for registry | Value for repository | Value for tag |
| :--- | :--- | :--- | :--- | :--- | :--- |
| StackState | Correlate | `quay.io/stackstate/stackstate-correlate:sts-private-v1-16-0-delta` | `stackstate.components.all.image.registry`   \(can be overridden with `global.imageRegistry`\) | `stackstate.components.correlate.image.repository` | `stackstate.components.correlate.image.tag`   \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | Kafka-to-ElasticSearch \(3x\) | `quay.io/stackstate/stackstate-kafka-to-es:sts-private-v1-16-0-delta` | `stackstate.components.all.image.registry`   \(can be overridden with `global.imageRegistry`\) | `stackstate.components.k2es.image.repository` | `stackstate.components.k2es.image.tag`   \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | Receiver | `quay.io/stackstate/stackstate-receiver:sts-private-v1-16-0-delta` | `stackstate.components.all.image.registry`   \(can be overridden with `global.imageRegistry`\) | `stackstate.components.receiver.image.repository` | `stackstate.components.receiver.image.tag`   \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | Router | `docker.io/envoyproxy/envoy-alpine:v1.12.1` | `stackstate.components.router.image.registry`   \(can be overridden with `global.imageRegistry`\) | `stackstate.components.router.image.repository` | `stackstate.components.router.image.tag` |
| StackState | Server | `quay.io/stackstate/stackstate-server:sts-private-v1-16-0-delta` | `stackstate.components.all.image.registry`   \(can be overridden with `global.imageRegistry`\) | `stackstate.components.server.image.repository` | `stackstate.components.server.image.tag`   \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | UI | `quay.io/stackstate/stackstate-ui:sts-private-v1-16-0-delta` | `stackstate.components.all.image.registry`   \(can be overridden with `global.imageRegistry`\) | `stackstate.components.ui.image.repository` | `stackstate.components.ui.image.tag`   \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | UI \(init container\) | `docker.io/nginx/nginx-prometheus-exporter:0.4.2` | `stackstate.components.nginxPrometheusExporter.image.registry`   \(can be overridden with `global.imageRegistry`\) | `stackstate.components.nginxPrometheusExporter.image.repository` | `stackstate.components.nginxPrometheusExporter.image.tag` |
| StackState | multiple | `docker.io/dokkupaas/wait:latest` | `stackstate.components.wait.image.registry`   \(can be overridden with `global.imageRegistry`\) | `stackstate.components.wait.image.repository` | `stackstate.components.wait.image.tag` |
| StackState | kafka-topic-create job | `docker.io/bitnami/kafka` | `stackstate.components.kafkaTopicCreate.image.registry`   \(can be overridden with `global.imageRegistry`\) | `stackstate.components.kafkaTopicCreate.image.repository` | `stackstate.components.kafkaTopicCreate.image.tag` |
| ElasticSearch |  | `docker.elastic.co/elasticsearch/elasticsearch:7.4.1` | `elasticSearch.imageRegistry`   \(can be overridden with `global.imageRegistry`\) | `elasticsearch.imageRepository` | `elasticsearch.imageTag` |
| HBase | StackGraph Console | `quay.io/stackstate/stackgraph-console:1.5.3` | `hbase.all.image.registry`   \(can be overridden with `global.imageRegistry`\) | `hbase.console.image.repository` | `hbase.console.image.tag`   \(defaults to `hbase.stackgraph.image.tag`\) |
| HBase | Master | `quay.io/stackstate/hbase-master:1.5.3` | `hbase.all.image.registry`   \(can be overridden with `global.imageRegistry`\) | `hbase.hbase.master.image.repository` | `hbase.hbase.master.image.tag`   \(defaults to `hbase.stackgraph.image.tag`\) |
| HBase | RegionServer | `quay.io/stackstate/hbase-regionserver:1.5.3` | `hbase.all.image.registry`   \(can be overridden with `global.imageRegistry`\) | `hbase.hbase.regionserver.image.repository` | `hbase.hbase.regionserver.image.tag`   \(defaults to `stackgraph.image.tag`\) |
| HBase | HDFS \(DN, NN, SNN\) | `quay.io/stackstate/hadoop:2.9.2-java11` | `hbase.all.image.registry`   \(can be overridden with `global.imageRegistry`\) | `hbase.hdfs.image.repository` | `hbase.hdfs.image.tag` |
| HBase | Tephra | `quay.io/stackstate/tephra-server:1.5.3` | `hbase.all.image.registry`   \(can be overridden with `global.imageRegistry`\) | `hbase.tephra.image.repository` | `hbase.tephra.image.tag`   \(defaults to `hbase.stackgraph.image.tag`\) |
| HBase | multiple | `docker.io/dokkupaas/wait:latest` | `hbase.wait.image.registry`   \(can be overridden with `global.imageRegistry`\) | `hbase.wait.image.repository` | `hbase.wait.image.tag` |
| Kafka |  | `docker.io/bitnami/kafka:2.3.1-debian-9-r41` | `kafka.image.registry`   \(can be overridden with `global.imageRegistry`\) | `kafka.image.repository` | `kafka.image.tag` |
| Kafka | JMX Exporter | `docker.io/bitnami/jmx-exporter:0.12.0-debian-10-r29` | `kafka.metrics.jmx.image.registry`   \(can be overridden with `global.imageRegistry`\) | `kafka.metrics.jmx.image.repository` | `kafka.metrics.jmx.image.tag` |
| Kafka | Kafka Exporter | `docker.io/bitnami/kafka-exporter:1.2.0-debian-10-r29` | `kafka.metrics.kafka.image.registry`   \(can be overridden with `global.imageRegistry`\) | `kafka.metrics.kafka.image.repository` | `kafka.metrics.kafka.image.tag` |
| Zookeeper |  | `docker.io/bitnami/zookeeper-exporter:0.1.3-debian-10-r26` | `zookeeper.image.registry`   \(can be overridden with `global.imageRegistry`\) | `zookeeper.image.repository` | `zookeeper.image.tag` |

