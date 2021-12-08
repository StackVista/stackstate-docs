# notes

## Stackstate values.yaml

### stackstate.components.all.image
```yaml
# stackstate.components.all.image.registry -- Base container image registry for all StackState containers, except for the wait container and the container-tools container
registry: quay.io
# stackstate.components.all.image.repositorySuffix - String to append to repositories for StackState components
repositorySuffix: ""
# stackstate.components.all.image.pullSecretName -- Name of ImagePullSecret to use for all pods.
pullPolicy: IfNotPresent
# When changing this value make sure to also update hbase.stackgraph.image.tag to the matching StackGraph version
# stackstate.components.all.image.tag -- The default tag used for all stateless components of StackState; invividual service `tag`s can be overriden (see below).
tag: master
```

### - stackstate.components.api.image
```yaml
# stackstate.components.api.image.repository -- Repository of the api component Docker image.
repository: stackstate/stackstate-server
# stackstate.components.api.image.tag -- Tag used for the `api` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### ✅ stackstate.components.correlate.image

From report:
* quay.io/stackstate/stackstate-correlate

```yaml
# stackstate.components.correlate.image.repository -- Repository of the correlate component Docker image.
repository: stackstate/stackstate-correlate
# stackstate.components.correlate.image.tag -- Tag used for the `correlate` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### - stackstate.components.checks.image
```yaml
# stackstate.components.checks.image.repository -- Repository of the sync component Docker image.
repository: stackstate/stackstate-server
# stackstate.components.checks.image.tag -- Tag used for the `state` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### - stackstate.components.healthsync.image
```yaml
# stackstate.components.healthSync.image.repository -- Repository of the healthSync component Docker image.
repository: stackstate/stackstate-server
# stackstate.components.healthSync.image.tag -- Tag used for the `healthSync` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### - stackstate.components.initialized.image
```yaml
# stackstate.components.initializer.image.repository -- Repository of the initializer component Docker image.
repository: stackstate/stackstate-server
# stackstate.components.initializer.image.tag -- Tag used for the `initializer` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### ✅ stackstate.components.mm2es.image

From report:
* quay.io/stackstate/stackstate-kafka-to-es-stable
```yaml
# stackstate.components.mm2es.image.repository -- Repository of the mm2es component Docker image.
repository: stackstate/stackstate-kafka-to-es
# stackstate.components.mm2es.image.tag -- Tag used for the `mm2es` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### - stackstate.components.e2es.image
```yaml
# stackstate.components.e2es.image.repository -- Repository of the e2es component Docker image.
repository: stackstate/stackstate-kafka-to-es
# stackstate.components.e2es.image.tag -- Tag used for the `e2es` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### - stackstate.components.trace2es.image
```yaml
# stackstate.components.trace2es.image.repository -- Repository of the trace2es component Docker image.
repository: stackstate/stackstate-kafka-to-es
# stackstate.components.trace2es.image.tag -- Tag used for the `trace2es` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### ✅ stackstate.components.receiver.image

From report:
* quay.io/stackstate/stackstate-receiver-stable

```yaml
# stackstate.components.receiver.image.repository -- Repository of the receiver component Docker image.
repository: stackstate/stackstate-receiver
# stackstate.components.receiver.image.tag -- Tag used for the `receiver` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### ✅ stackstate.components.router.image

From report:
* quay.io/stackstate/envoy-alpine

```yaml
# stackstate.components.router.image.registry -- Registry of the router component Docker image.
registry: quay.io
# stackstate.components.router.image.repository -- Repository of the router component Docker image.
repository: stackstate/envoy-alpine
# stackstate.components.router.image.tag -- Tag used for the `router` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: v1.19.1-sts.20211012.0914
```

### ✅ stackstate.components.server.image

From report:
* quay.io/stackstate/stackstate-server-stable

```yaml
# stackstate.components.server.image.repository -- Repository of the server component Docker image.
repository: stackstate/stackstate-server
# stackstate.components.server.image.tag -- Tag used for the `server` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### - stackstate.components.state.image
```yaml
# stackstate.components.state.image.repository -- Repository of the sync component Docker image.
repository: stackstate/stackstate-server
# stackstate.components.state.image.tag -- Tag used for the `state` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### - stackstate.components.sync.image
```yaml
# stackstate.components.sync.image.repository -- Repository of the sync component Docker image.
repository: stackstate/stackstate-server
# stackstate.components.sync.image.tag -- Tag used for the `sync` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### - stackstate.components.slicing.image
```yaml
# stackstate.components.slicing.image.repository -- Repository of the slicing component Docker image.
repository: stackstate/stackstate-server
# stackstate.components.slicing.image.tag -- Tag used for the `slicing` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### ✅ stackstate.components.ui.image

From report:
* quay.io/stackstate/stackstate-ui-stable

```yaml
# stackstate.components.ui.image.repository -- Repository of the ui component Docker image.
repository: stackstate/stackstate-ui
# stackstate.components.ui.image.tag -- Tag used for the `ui` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### - stackstate.components.viewhealth.yaml
```yaml
# stackstate.components.viewHealth.image.repository -- Repository of the viewHealth component Docker image.
repository: stackstate/stackstate-server
# stackstate.components.viewHealth.image.tag -- Tag used for the `viewHealth` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### - stackstate.components.problemProducer.image
```yaml
# stackstate.components.problemProducer.image.repository -- Repository of the problemProducer component Docker image.
repository: stackstate/stackstate-server
# stackstate.components.problemProducer.image.tag -- Tag used for the `problemProducer` component Docker image; this will override `stackstate.components.all.image.tag` on a per-service basis.
tag: ""
```

### stackstate.components.kafkaTopicCreate.image
```yaml
# stackstate.components.kafkaTopicCreate.image.registry -- Base container image registry for kafka-topic-create containers.
registry: quay.io
# stackstate.components.kafkaTopicCreate.image.repository -- Base container image repository for kafka-topic-create containers.
repository: stackstate/kafka
# stackstate.components.kafkaTopicCreate.image.tag -- Container image tag for kafka-topic-create containers.
tag: 2.8.0-focal-20210827-r108
```

### ✅ stackstate.components.nginxPrometheusExporter.image

From report:
* quay.io/stackstate/nginx-prometheus-exporter

```yaml
# stackstate.components.nginxPrometheusExporter.image.registry -- Base container image registry for nginx-prometheus-exporter containers.
registry: quay.io
# stackstate.components.nginxPrometheusExporter.image.repository -- Base container image repository for nginx-prometheus-exporter containers.
repository: stackstate/nginx-prometheus-exporter
# stackstate.components.nginxPrometheusExporter.image.tag -- Container image tag for nginx-prometheus-exporter containers.
tag: 0.7.0-sts.20211018.0810
```

### ✅ stackstate.components.containerTools.image

From report:
* quay.io/stackstate/container-tools

```yaml
# stackstate.components.containerTools.image.registry -- Base container image registry for container-tools containers.
registry: quay.io
# stackstate.components.containerTools.image.repository -- Base container image repository for container-tools containers.
repository: stackstate/container-tools
# stackstate.components.containerTools.image.tag -- Container image tag for container-tools containers.
tag: 1.1.3
```

### ✅ stackstate.components.wait.image

From report:
* quay.io/stackstate/wait
  (!) also used in hbase wait.image

```yaml
# stackstate.components.wait.image.registry -- Base container image registry for wait containers.
registry: quay.io
# stackstate.components.wait.image.repository -- Base container image repository for wait containers.
repository: stackstate/wait
# stackstate.components.wait.image.tag -- Container image tag for wait containers.
tag: 1.0.5
```

### hbase.stackgraph.image
```yaml
# hbase.stackgraph.image.tag -- The StackGraph server version, must be compatible with the StackState version
tag: 4.2.16
```

### ✅ kafka.image

From report:
* quay.io/stackstate/kafka

```yaml
# kafka.image.registry -- Kafka image registry
registry: quay.io
# kafka.image.repository -- Kafka image repository
repository: stackstate/kafka
# kafka.image.tag -- Kafka image
```

### ✅ kafka.metrics.jmx.image

From report:
* quay.io/stackstate/jmx-exporter

```yaml
# kafka.metrics.jmx.image.registry -- Kafka JMX exporter image registry
registry: quay.io
# kafka.metrics.jmx.image.repository -- Kafka JMX exporter image repository
repository: stackstate/jmx-exporter
# kafka.metrics.jmx.image.tag -- Kafka JMX exporter image tag
tag: 0.15.0-focal-20210827-r138
```

### ✅ minio.image

From report:
* quay.io/stackstate/minio

```yaml
# minio.image.repository -- MinIO image repository
repository: quay.io/stackstate/minio
tag: 2021.2.19-focal-20210827-r5
```

### ✅ zookeeper.image

From report:
* quay.io/stackstate/zookeeper

```yaml
# zookeeper.image.registry -- ZooKeeper image registry
registry: quay.io
# zookeeper.image.repository -- ZooKeeper image repository
repository: stackstate/zookeeper
# zookeeper.image.tag -- ZooKeeper image tag
tag: 3.6.1-focal-20210827-r37
```

### ✅ anomaly-detection.image

From report:
* quay.io/stackstate/spotlight

```yaml
# anomaly-detection.image.registry -- Base container image registry for all containers, except for the wait container
registry: quay.io
# anomaly-detection.image.spotlightRepository -- Repository of the spotlight Docker image.
spotlightRepository: stackstate/spotlight
```

## cluster-agent values.yaml

### all.image
```yaml
# all.image.registry -- The image registry to use.
registry: "docker.io"
```

### agent.image
```yaml
# agent.image.repository -- Base container image repository.
repository: stackstate/stackstate-agent-2
# agent.image.tag -- Default container image tag.
tag: 2.14.0
```

### clusterAgent.image
```yaml
# clusterAgent.image.repository -- Base container image repository.
repository: stackstate/stackstate-cluster-agent
# clusterAgent.image.tag -- Default container image tag.
tag: 2.14.0
```

### clusterChecks.image
```yaml
# clusterChecks.image.repository -- Base container image repository.
repository: stackstate/stackstate-agent-2
# clusterChecks.image.tag -- Default container image tag.
tag: 2.14.0
```

## common values.yaml

### image:
```yaml
# image.repository -- (string) Repository of the Docker image.
repository: nginx
# image.tag -- (string) Tag of the Docker image.
tag: latest
```

## Elasticsearch values.yaml

### ✅ root level

From report: 
* quay.io/stackstate/elasticsearch

```yaml
imageRegistry: "quay.io"
imageRepository: "stackstate/elasticsearch"
imageTag: "7.6.2-yu"
```

### ✅ prometheus-elasticsearch-exporter.image

From report:
* quay.io/stackstate/elasticsearch-exporter 

```yaml
# prometheus-elasticsearch-exporter.image.repository -- Elastichsearch Prometheus exporter image repository
repository: quay.io/stackstate/elasticsearch-exporter
# prometheus-elasticsearch-exporter.image.tag -- Elastichsearch Prometheus exporter image tag
tag: v1.2.1
```

## hbase values.yaml

### all.image
```yaml
# all.image.registry -- Base container image registry for all containers, except for the wait container
registry: quay.io
```

### stackgraph.image
```yaml
# stackgraph.image.tag -- The default tag used for all omponents of hbase that are stackgraph version dependent; invividual service `tag`s can be overriden (see below).
tag: 4.4.1
```

### ✅ console.image

From report:
* quay.io/stackstate/stackgraph-console

```yaml
# console.image.repository -- Base container image repository for console pods.
repository: stackstate/stackgraph-console
# console.image.tag -- Container image tag for console pods, defaults to `stackgraph.image.tag`
tag:
```

### wait.image
```yaml
# wait.image.registry -- Base container image registry for wait containers.
registry: quay.io
# wait.image.repository -- Base container image repository for wait containers.
repository: stackstate/wait
# wait.image.repository -- Container image tag for wait containers.
tag: 1.0.5
```

### ✅ hbase.master.image

From report:
* quay.io/stackstate/hbase-master

```yaml
# hbase.master.image.repository -- Base container image repository for HBase masters.
repository: stackstate/hbase-master
# hbase.master.image.tag -- Container image tag for HBase masters, defaults to `stackgraph.image.tag`
tag:
```

### ✅ hbase.regionserver.image

From report:
* quay.io/stackstate/hbase-regionserver

```yaml
# hbase.regionserver.image.repository -- Base container image repository for HBase region servers.
repository: stackstate/hbase-regionserver
# hbase.regionserver.image.tag -- Container image tag for HBase region servers, defaults to `stackgraph.image.tag`
tag:
```

### ✅ hdfs.image

From report:
* quay.io/stackstate/hadoop

```yaml
# hdfs.image.repository -- Base container image repository for HDFS datanode.
repository: stackstate/hadoop
# hdfs.image.tag -- Default container image tag for HDFS datanode.
tag: 2.10.1-java11-4
```

### ✅ tephra.image

From report:
* quay.io/stackstate/tephra-server

```yaml
# tephra.image.repository -- Base container image repository for Tephra pods.
repository: stackstate/tephra-server
# tephra.image.tag -- Container image tag for Tephra pods, defaults to `stackgraph.image.tag`
tag:
```

## kafka values.yaml

### global
```yaml
## Global Docker image parameters
## Please, note that this will override the image parameters, including dependencies, configured to use the global value
## Current available global Docker image parameters: imageRegistry and imagePullSecrets
##
# global:
#   imageRegistry: myRegistryName
```

### image
```yaml
registry: docker.io
repository: bitnami/kafka
tag: 2.6.0-debian-10-r7
```

## minio values.yaml

### image
```yaml
## Set default image, imageTag, and imagePullPolicy. mode is used to indicate the
##
image:
  repository: minio/minio
  tag: RELEASE.2021-02-14T04-01-33Z
```

### mcImage
```yaml
## Set default image, imageTag, and imagePullPolicy for the `mc` (the minio
## client used to create a default bucket).
##
mcImage:
  repository: minio/mc
  tag: RELEASE.2021-02-14T04-28-06Z
```

### helmKubectlJqImage
```yaml
## Set default image, imageTag, and imagePullPolicy for the `jq` (the JSON
## process used to create secret for prometheus ServiceMonitor).
##
helmKubectlJqImage:
  repository: bskim45/helm-kubectl-jq
  tag: 3.1.0
```

## from report

KAFKA
* quay.io/stackstate/kafka ? docker.io/bitnami/kafka ... docker.io/bitnami/kafka in kafka/values.yaml
* quay.io/stackstate/kafka ?
* quay.io/stackstate/jmx-exporter ? docker.io/bitnami/jmx-exporter
  * ? Kafka exporter? docker.io/bitnami/kafka-exporter >> in kafka/values.yaml

STACKSTATE
* quay.io/stackstate/stackstate-correlate-stable
* quay.io/stackstate/stackstate-kafka-to-es-stable
* quay.io/stackstate/stackstate-receiver-stable
* quay.io/stackstate/envoy-alpine
* quay.io/stackstate/stackstate-server-stable
* quay.io/stackstate/stackstate-ui-stable
* quay.io/stackstate/nginx-prometheus-exporter
* quay.io/stackstate/wait
* quay.io/stackstate/container-tools
  * ? kafka-topic-create job? docker.io/bitnami/kafka ... quay.io/stackstate/kafka in stackstate/values.yaml

HBASE
* quay.io/stackstate/stackgraph-console
* quay.io/stackstate/hbase-master
* quay.io/stackstate/hbase-regionserver
* quay.io/stackstate/hadoop
* quay.io/stackstate/tephra-server
  * ? multiple? docker.io/dokkupaas/wait ... quay.io/stackstate/wait in hbase/values.yaml

ZOOKEEPER
* quay.io/stackstate/zookeeper ? docker.io/bitnami/zookeeper-exporter