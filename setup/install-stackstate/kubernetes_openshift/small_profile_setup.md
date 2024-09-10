---
description: SUSE Observability Self-hosted
---

# Small profile setup

## Overview

The recommended Kubernetes/OpenShift deployment of SUSE Observability is a production ready setup suited for observing large clusters. If the setup is not expected to be big, it can be tuned down to consume less resources. This is called the small profile setup.

{% hint style="info" %}
The small profile setup is only suitable for situations that observe up to roughly 100 nodes.
{% endhint %}

## Create `small_values.yaml`

To deploy SUSE Observability in a small profile setup, you will need a `small_values.yaml` file. Follow the instructions below to create this file and use it for deployment of SUSE Observability.

1. Create a Helm values file `small_values.yaml` with the following content and store it next to the generated `values.yaml` file:

  ```yaml
  # This files defines additional Helm values to run SUSE Observability on a
  # small profile production setup. Use this file in combination
  # with a regular values.yaml file that contains your API key, etc.
  elasticsearch:
    esJavaOpts: "-Xmx3g -Xms3g -Des.allow_insecure_settings=true -Dlog4j2.formatMsgNoLookups=true"
    esConfig:
      elasticsearch.yml: |
        cluster.routing.allocation.disk.watermark.low: "80%"
        cluster.routing.allocation.disk.watermark.high: "85%"
    resources:
      requests:
        cpu: "250m"
        memory: "4Gi"
  hbase:
    hbase:
      master:
        resources:
          requests:
            memory: "512Mi"
            cpu: "50m"
      regionserver:
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
    hdfs:
      datanode:
        resources:
          requests:
            memory: "2Gi"
            cpu: "100m"
      namenode:
        resources:
          requests:
            memory: "512Mi"
            cpu: "50m"
  kafka:
    resources:
      requests:
        cpu: "500m"
        memory: "1536Mi"
    persistence:
      size: 400Gi
  stackstate:
    components:
      api:
        resources:
          requests:
            memory: "2Gi"
            cpu: "400m"
      state:
        resources:
          requests:
            memory: "1536Mi"
            cpu: "1200m"
          limits:
            cpu: "1200m"
      kafka2prom:
        resources:
          requests:
            cpu: "300m"
            memory: 2200Mi
          limits:
            memory: 2200Mi
      viewHealth:
        resources:
          requests:
            memory: "2Gi"
            cpu: "1000m"
      checks:
        resources:
          requests:
            memory: "3Gi"
            cpu: "500m"
      correlate:
        resources:
          requests:
            memory: "2600Mi"
            cpu: "1000m"
          limits:
            memory: "2600Mi"
        replicaCount: 2
        extraEnv:
          open:
            CONFIG_FORCE_stackstate_correlate_correlateConnections_extra_maxBufferSize: 1000M
      healthSync:
        resources:
          requests:
            memory: "2000Mi"
            cpu: "250m"
          limits:
            memory: "2000Mi"
      initializer:
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
      e2es:
        resources:
          requests:
            memory: "768Mi"
            cpu: "250m"
      receiver:
        resources:
          requests:
            memory: "3Gi"
            cpu: "1000m"
      sync:
        resources:
          requests:
            memory: "3Gi"
            cpu: "500m"
      slicing:
        resources:
          requests:
            memory: "1536Mi"
            cpu: "250m"
      problemProducer:
        resources:
          requests:
            memory: "1536Mi"
            cpu: "250m"
  minio:
    resources:
      requests:
        cpu: 250m
        memory: 256Mi
      limits:
        memory: 256Mi
  kafkaup-operator:
    resources:
      requests:
        cpu: 10m
  victoria-metrics-0:
    server:
      persistentVolume:
        size: 60Gi
  victoria-metrics-1:
    server:
      persistentVolume:
        size: 60Gi
  ```

2. Continue with the instructions to deploy SUSE Observability with Helm:
   * [Deploy on Kubernetes](/setup/install-stackstate/kubernetes_openshift/kubernetes_install.md#deploy-suse-observability-with-helm).
   * [Deploy on OpenShift](/setup/install-stackstate/kubernetes_openshift/openshift_install.md#deploy-suse-observability-with-helm).

