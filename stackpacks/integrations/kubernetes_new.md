---
description: StackPack description
stackpack-name: Kubernetes
---

# Kubernetes

## Overview

The Kubernetes StackPack is used to create a near real-time synchronization of topology and associated internal services from a Kubernetes cluster to StackState. This StackPack allows monitoring of the following:

* Workloads
* Nodes, pods, containers and services

![Data flow](/.gitbook/assets/stackpack_kubernetes_draft1.svg)



## Setup

### Prerequisites

The following prerequisites are required for manual installation:

* A Kubernetes Cluster must be up and running
* `Kubectl(1.14+)` binary
* Cluster KubeConfig must be properly set in the path

### Install

Install the Kubernetes StackPack from the StackState UI **StackPacks** > **Integrations** screen. You will need to provide the following parameters:

- **Kubernetes Cluster Name** - A name to identify the cluster. This does not need to match the cluster name used in `kubeconfig`, however, that is usually a good candidate for a unique name.


### Deploy the StackState Agent and Cluster Agent

To retrieve topology, events and metrics data from you Kubernetes cluster, you will need to install the StackState Agent, the StackState Cluster Agent and kube-state-metrics. This can be done using the [Cluster Agent Helm Chart](https://github.com/StackVista/helm-charts/tree/master/stable/cluster-agent).

TODO: Required steps

### Status



## Integration details

### Data retrieved

#### Events



#### Metrics



#### Topology


#### Traces

#### Tags

All tags defined in Kubernetes will be retrieved and added to the associated components and relations in StackState. 


### REST API endpoints

The StackState Kubernetes Cluster Agent connects to the Kubernetes API to retrieve cluster wide information and Kubernetes events. The API endpoints used are described in the table below.

| Resource | Description |
|:---|:---|
| componentstatuses | [/cluster-resources/component-status-v1/](https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/component-status-v1/) |
| events | [/cluster-resources/event-v1/](https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/event-v1/) |
| namespaces | [/cluster-resources/namespace-v1/](https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/namespace-v1/) |  
| nodes | [/cluster-resources/node-v1/](https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/node-v1/) |
| endpoints | [/services-resources/endpoints-v1/](https://kubernetes.io/docs/reference/kubernetes-api/services-resources/endpoints-v1/) |
| ingresses | [/services-resources/ingress-v1/](https://kubernetes.io/docs/reference/kubernetes-api/services-resources/ingress-v1/) |
| services | [/services-resources/service-v1/](https://kubernetes.io/docs/reference/kubernetes-api/services-resources/service-v1/) |
| cronjobs | [/workloads-resources/cron-job-v1beta1/](https://kubernetes.io/docs/reference/kubernetes-api/workloads-resources/cron-job-v1beta1/) |
| daemonsets | [/workloads-resources/daemon-set-v1/](https://kubernetes.io/docs/reference/kubernetes-api/workloads-resources/daemon-set-v1/) |
| deployments | [/workloads-resources/deployment-v1/](https://kubernetes.io/docs/reference/kubernetes-api/workloads-resources/deployment-v1/) |
| jobs | [/workloads-resources/job-v1/](https://kubernetes.io/docs/reference/kubernetes-api/workloads-resources/job-v1/) |
| pods | [/workloads-resources/pod-v1/](https://kubernetes.io/docs/reference/kubernetes-api/workloads-resources/pod-v1/) |
| replicasets | [/workloads-resources/replica-set-v1/](https://kubernetes.io/docs/reference/kubernetes-api/workloads-resources/replica-set-v1/) |
| statefulsets | [/workloads-resources/stateful-set-v1/](https://kubernetes.io/docs/reference/kubernetes-api/workloads-resources/stateful-set-v1/) |
| secrets | [/config-and-storage-resources/secret-v1/](https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/secret-v1/) |
| configmaps | [/config-and-storage-resources/config-map-v1/](https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/config-map-v1/) |
| persistentvolumes | [/config-and-storage-resources/persistent-volume-v1/](https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/persistent-volume-v1/) |
| persistentvolumeclaims | [/config-and-storage-resources/persistent-volume-claim-v1/](https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/persistent-volume-claim-v1/) |
| volumeattachments | [/config-and-storage-resources/volume-attachment-v1/](https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/volume-attachment-v1/) |
| "/version" | |
| "/healthz" | |



For further details see the [Kubernetes API documentation \(kubernetes.io\)](https://kubernetes.io/docs/reference/kubernetes-api/).


### Open source


## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](???).

## Uninstall


## Release notes

**Kubernetes StackPack v3.8.0 (2021-03-08)**

- Feature: Namespaces are now a component in StackState with a namespaces view for each cluster
- Feature: New component actions for quick navigation on workloads, pods and namespaces
- Feature: Added a "Pod Scheduled" metric stream to pods
- Feature: Secrets are now a component in StackState
- Improvement: The "Desired vs Ready" checks on workloads now use the "Ready replicas" stream instead of the replicas stream.
- Improvement: Use standard (blue) Kubernetes icons
- Bug fix: Fixed Kubernetes synchronization when a component had no labels but only tags

**Kubernetes StackPack v3.7.2 (2020-08-18)**

- Feature: Introduced the Release notes pop up for customer

**Kubernetes StackPack v3.7.1 (2020-08-10)**

- Feature: Introduced Kubernetes specific component identifiers

**Kubernetes StackPack v3.7.0 (2020-08-04)**

- Improvement: Deprecated stackpack specific layers and introduced a new common layer structure.

**Kubernetes StackPack v3.6.0 (2020-06-19)**

- Improvement: Set the stream priorities on all streams.

**Kubernetes StackPack v3.5.0 (2020-05-27)**

- Feature: Removing the Container restart check

**Kubernetes StackPack v3.4.0 (2020-05-25)**

- Feature: Added Kubernetes topology expiration.

**Kubernetes StackPack v3.3.0 (2020-04-10)**

- Improvement: Updated StackPacks integration page, categories, and icons for the SaaS trial


**Kubernetes StackPack v3.2.0 (2020-04-03)**

- Improvement: Added Kubernetes topology expiration.

**Kubernetes StackPack v3.1.0 (2020-03-23)**

- Improvement: Kubernetes tracing documentation updated.
- Improvement: Kube state metrics installation documentation added.

**Kubernetes StackPack v3.0.0 (2020-03-12)**

- Improvement: Use Full Cause Tree visibility on all views to show root cause analysis. (Breaking Change)

**Kubernetes StackPack v2.2.1 (2020-03-09)**

- Bug fix: Fixed the monitoring of Kubernetes Cron Jobs to view all successful and failed jobs.

**Kubernetes StackPack v2.2.0 (2020-03-09)**

- Feature: Added cluster name (and optional namespace) to all metric / event telemetry query conditions to support multiple Kubernetes clusters.

**Kubernetes StackPack v2.1.1 (2019-12-19)**

- Improvement: Packaging of Kubernetes manifests in the build pipeline.
- Bug fix: Fixed Kubernetes synchronization to support multiple kubernetes clusters as domains in StackState.

## See also

- [Kubernetes API documentation \(kubernetes.io\)](https://kubernetes.io/docs/reference/kubernetes-api/)
