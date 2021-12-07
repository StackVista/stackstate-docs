# StackState images

This page describes the images used by the StackState Helm chart and how to configure the registry, repository and tag used to pull them.

## Serving the images from a different image registry

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
     * `-c` specify a different chart (`-c`) to use.
     * `-r` specify a different repository to use.

3. Add the registry to the global configuration section in your `values.yaml`, for example:

   ```yaml
   global:
    imageRegistry: 57413481473.dkr.ecr.eu-west-1.amazonaws.com
   ```

   * A separate entry must be made for the image used by the `prometheus-elasticsearch-exporter` subchart as this cannot be configured with the `global.imageRegistry` setting. For example:

     ```yaml
      elasticsearch:
        prometheus-elasticsearch-exporter:
          image:
            repository: 57413481473.dkr.ecr.eu-west-1.amazonaws.com/justwatch/elasticsearch_exporter
     ```

## Configuration

{% hint style="info" %}
If the registry for an image can be configured with a specific value \(for example `stackstate.components.all.image.registry`\), it can also be overridden with the global value `global.imageRegistry`. Some images \(from other sources\) do not support this and need to be configured separately.
{% endhint %}

### StackState chart

#### Correlate

#### Kafka-to-ElasticSearch (x3)

#### Receiver

#### Router

#### Server

#### API

#### Checks

#### Initializer

#### Slicing

#### State

#### Sync

#### ViewHealth

#### UI

#### UI (init container)

#### multiple

#### kafka-topic-create job

### Elasticsearch chart

### Elasticsearch explorer chart

### HBase chart

* **StackGraph Console:**
  * Image (without tag) - 
  * Value for registry - 
  * Value for repository - 
  * Value for tag -
* **Master:**
  * Image (without tag) -  `quay.io/stackstate/hbase-master`
  * Value for registry -  `hbase.all.image.registry` (default `quay.io`)
  * Value for repository - `hbase.hbase.master.image.repository` (default `stackstate/hbase-master`)
  * Value for tag - `hbase.hbase.master.image.tag` (default `stackgraph.image.tag`)
* **RegionServer:**
  * Image (without tag) - 
  * Value for registry - 
  * Value for repository - 
  * Value for tag -
* **HDFS (DN, NN, SNN):**
  * Image (without tag) - 
  * Value for registry - 
  * Value for repository - 
  * Value for tag -
* **Tephra:**
  * Image (without tag) - 
  * Value for registry - 
  * Value for repository - 
  * Value for tag -
* **Multiple:**
  * Image (without tag) - 
  * Value for registry - 
  * Value for repository - 
  * Value for tag -

### Kafka chart

### Zookeeper chart

| Chart | Component | Image \(without tag\) | Value for registry \(can be overridden with `global.imageRegistry`\) | Value for repository | Value for tag |
| :--- | :--- | :--- | :--- | :--- | :--- |
| StackState | Correlate | `quay.io/stackstate/stackstate-correlate` | `stackstate.components.all.image.registry` | `stackstate.components.correlate.image.repository` | `stackstate.components.correlate.image.tag` \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | Kafka-to-ElasticSearch \(3x\) | `quay.io/stackstate/stackstate-kafka-to-es` | `stackstate.components.all.image.registry` | `stackstate.components.k2es.image.repository` | `stackstate.components.k2es.image.tag` \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | Receiver | `quay.io/stackstate/stackstate-receiver` | `stackstate.components.all.image.registry` | `stackstate.components.receiver.image.repository` | `stackstate.components.receiver.image.tag` \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | Router | `docker.io/envoyproxy/envoy-alpine` | `stackstate.components.router.image.registry` | `stackstate.components.router.image.repository` | `stackstate.components.router.image.tag` |
| StackState | Server | `quay.io/stackstate/stackstate-server` | `stackstate.components.all.image.registry` | `stackstate.components.server.image.repository` | `stackstate.components.server.image.tag` \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | API | `quay.io/stackstate/stackstate-server` | `stackstate.components.all.image.registry` | `stackstate.components.api.image.repository` | `stackstate.components.api.image.tag` \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | Checks | `quay.io/stackstate/stackstate-server` | `stackstate.components.all.image.registry` | `stackstate.components.checks.image.repository` | `stackstate.components.checks.image.tag` \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | Initializer | `quay.io/stackstate/stackstate-server` | `stackstate.components.all.image.registry` | `stackstate.components.initializer.image.repository` | `stackstate.components.initializer.image.tag` \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | Slicing | `quay.io/stackstate/stackstate-server` | `stackstate.components.all.image.registry` | `stackstate.components.slicing.image.repository` | `stackstate.components.slicing.image.tag` \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | State | `quay.io/stackstate/stackstate-server` | `stackstate.components.all.image.registry` | `stackstate.components.state.image.repository` | `stackstate.components.state.image.tag` \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | Sync | `quay.io/stackstate/stackstate-server` | `stackstate.components.all.image.registry` | `stackstate.components.sync.image.repository` | `stackstate.components.sync.image.tag` \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | ViewHealth | `quay.io/stackstate/stackstate-server` | `stackstate.components.all.image.registry` | `stackstate.components.viewHealth.image.repository` | `stackstate.components.viewHealth.image.tag` \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | UI | `quay.io/stackstate/stackstate-ui` | `stackstate.components.all.image.registry` | `stackstate.components.ui.image.repository` | `stackstate.components.ui.image.tag` \(defaults to `stackstate.components.all.image.tag`\) |
| StackState | UI | `docker.io/nginx/nginx-prometheus-exporter` | `stackstate.components.nginxPrometheusExporter.image.registry` | `stackstate.components.nginxPrometheusExporter.image.repository` | `stackstate.components.nginxPrometheusExporter.image.tag` |
| StackState | multiple | `quay.io/stackstate/wait` | `stackstate.components.wait.image.registry` | `stackstate.components.wait.image.repository` | `stackstate.components.wait.image.tag` |
| StackState | multiple | `quay.io/stackstate/container-tools` | `stackstate.components.containerTools.image.registry` | `stackstate.components.containerTools.image.repository` | `stackstate.components.containerTools.image.tag` |
| StackState | kafka-topic-create job | `docker.io/bitnami/kafka` | `stackstate.components.kafkaTopicCreate.image.registry` | `stackstate.components.kafkaTopicCreate.image.repository` | `stackstate.components.kafkaTopicCreate.image.tag` |
| Elasticsearch |  | `docker.elastic.co/elasticsearch/elasticsearch` | `elasticSearch.imageRegistry` | `elasticsearch.imageRepository` | `elasticsearch.imageTag` |
| Elasticsearch Exporer |  | `justwatch/elasticsearch_exporter` | N/A | `elasticsearch.prometheus-elasticsearch-exporter.image.repository` | `elasticsearch.prometheus-elasticsearch-exporter.image.tag` |
| HBase | StackGraph Console | `quay.io/stackstate/stackgraph-console` | `hbase.all.image.registry` | `hbase.console.image.repository` | `hbase.console.image.tag` \(defaults to `hbase.stackgraph.image.tag`\) |
| HBase | Master | `quay.io/stackstate/hbase-master` | `hbase.all.image.registry` | `hbase.hbase.master.image.repository` | `hbase.hbase.master.image.tag` \(defaults to `hbase.stackgraph.image.tag`\) |
| HBase | RegionServer | `quay.io/stackstate/hbase-regionserver` | `hbase.all.image.registry` | `hbase.hbase.regionserver.image.repository` | `hbase.hbase.regionserver.image.tag` \(defaults to `stackgraph.image.tag`\) |
| HBase | HDFS \(DN, NN, SNN\) | `quay.io/stackstate/hadoop` | `hbase.all.image.registry` | `hbase.hdfs.image.repository` | `hbase.hdfs.image.tag` |
| HBase | Tephra | `quay.io/stackstate/tephra-server` | `hbase.all.image.registry` | `hbase.tephra.image.repository` | `hbase.tephra.image.tag` \(defaults to `hbase.stackgraph.image.tag`\) |
| HBase | multiple | `docker.io/dokkupaas/wait` | `hbase.wait.image.registry` | `hbase.wait.image.repository` | `hbase.wait.image.tag` |
| Kafka |  | `docker.io/bitnami/kafka` | `kafka.image.registry` | `kafka.image.repository` | `kafka.image.tag` |
| Kafka | JMX Exporter | `docker.io/bitnami/jmx-exporter` | `kafka.metrics.jmx.image.registry` | `kafka.metrics.jmx.image.repository` | `kafka.metrics.jmx.image.tag` |
| Kafka | Kafka Exporter | `docker.io/bitnami/kafka-exporte` | `kafka.metrics.kafka.image.registry` | `kafka.metrics.kafka.image.repository` | `kafka.metrics.kafka.image.tag` |
| Zookeeper |  | `docker.io/bitnami/zookeeper-exporter` | `zookeeper.image.registry` | `zookeeper.image.repository` | `zookeeper.image.tag` |

