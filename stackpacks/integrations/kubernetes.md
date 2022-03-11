---
description: StackState Self-hosted v4.6.x
---

# 💠 Kubernetes

## Overview

The Kubernetes integration is used to create a near real-time synchronization of topology and associated internal services from a Kubernetes cluster to StackState. This StackPack allows monitoring of the following:

* Workloads
* Nodes, pods, containers and services
* Configmaps, secrets and volumes

Kubernetes is a [StackState core integration](/stackpacks/integrations/about_integrations.md#stackstate-core-integrations "StackState Self-Hosted only").

![Data flow](../../.gitbook/assets/stackpack-kubernetes.svg)

* Data is retrieved by the deployed [StackState Agents](../../setup/agent/kubernetes.md#stackstate-agent-types) and then pushed to StackState via the Agent StackPack and the Kubernetes StackPack.
* In StackState:
  * [Topology data](kubernetes.md#topology) is translated into components and relations.
  * [Tags](kubernetes.md#tags) defined in Kubernetes are added to components and relations in StackState.
  * [Metrics data](kubernetes.md#metrics) is stored and accessible within StackState. Relevant metrics data is mapped to associated components and relations in StackState.
  * [Kubernetes events](kubernetes.md#events) are available in the StackState UI Events Perspective and listed in the details pane on the right of the StackState UI.
  * [Objects changes events](kubernetes.md#events) are created for every detected change to `spec` or `metadata` in Kubernetes objects

## Setup

### Prerequisites

The following prerequisites are required to install the Kubernetes StackPack and deploy the StackState Agent and Cluster Agent:

* A Kubernetes Cluster must be up and running.
* A recent version of Helm 3.
* A user with permissions to create privileged pods, ClusterRoles and ClusterRoleBindings:
  * ClusterRole and ClusterRoleBinding are needed to grant StackState Agents permissions to access the Kubernetes API.
  * StackState Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Install

Install the Kubernetes StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **Kubernetes Cluster Name** - A name to identify the cluster. This does not need to match the cluster name used in `kubeconfig`, however, that is usually a good candidate for a unique name.

If the Agent StackPack is not already installed, this will be automatically installed together with the Kubernetes StackPack. This is required to work with the StackState Agent, which will need to be deployed on each node in the Kubernetes cluster.

### Deploy the StackState Agent and Cluster Agent

For the Kubernetes integration to retrieve topology, events and metrics data, you will need to have the following installed on your Kubernetes cluster:

* StackState Agent V2 on each node in the cluster
* StackState Cluster Agent on one node
* kube-state-metrics

➡️ [Deploy StackState Agents and kube-state-metrics](../../setup/agent/kubernetes.md).

{% hint style="info" %}
To integrate with other services, a separate instance of the [StackState Agent](../../setup/agent/about-stackstate-agent.md) should be deployed on a standalone VM. It is not currently possible to configure a StackState Agent deployed on a Kubernetes cluster with checks that integrate with other services.
{% endhint %}

### Status

To check the status of the Kubernetes integration, check that the StackState Cluster Agent \(`cluster-agent`\) pod and all of the StackState Agent \(`cluster-agent-agent`\) pods have status ready.

```text
❯ kubectl get deployment,daemonset --namespace stackstate

NAME                                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/stackstate-cluster-agent             1/1     1            1           5h14m
NAME                                                 DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/stackstate-cluster-agent-agent        10        10        10      10           10          <none>          5h14m
```

## Integration details

### Data retrieved

The Kubernetes integration retrieves the following data:

* [Events](kubernetes.md#events)
* [Metrics](kubernetes.md#metrics)
* [Tags](kubernetes.md#tags)
* [Topology](kubernetes.md#topology)

#### Events

The Kubernetes integration retrieves all Kubernetes events from the Kubernetes cluster. In addition to this, `Element Properties Change` events will be generated in StackState for changes in Kubernetes objects.

##### Kubernetes events

The table below shows which event category will be assigned to each event type in StackState:

| StackState event category | Kubernetes events |
| :--- | :--- |
| **Activities** | `BackOff` `ContainerGCFailed` `ExceededGracePeriod` `FileSystemResizeSuccessful` `ImageGCFailed` `Killing` `NodeAllocatableEnforced` `NodeNotReady` `NodeSchedulable` `Preempting` `Pulling` `Pulled` `Rebooted` `Scheduled` `Starting` `Started` `SuccessfulAttachVolume` `SuccessfulDetachVolume` `SuccessfulMountVolume` `SuccessfulUnMountVolume` `VolumeResizeSuccessful` |
| **Alerts** | `NotTriggerScaleUp` |
| **Changes** | `Created` \(created container\) `NodeReady` `SandboxChanged` `SuccesfulCreate` |
| **Others** | All other events |

##### Object change events

The Kubernetes integration will detect changes in Kubernetes objects and will create an event of type `Element Properties Change` with a diff with a YAML representation of the changed object.

![Element Properties Change event](../../.gitbook/assets/k8s-change-event.png)

Changes will be detected in the following object types:
* `ConfigMap`
* `CronJob`
* `DaemonSet`
* `Deployment`
* `Ingress`
* `Job`
* `Namespace`
* `Node`
* `PersistentVolume`
* `Pod`
* `ReplicaSet`
* `Secret` (a hash of the content will be compared)
* `Service`
* `StatefulSet`

{% hint style="info" %}
Note that, in order to reduce noise of changes, the following object properties **will not** be compared:
* `metadata`
  * `managedFields`
  * `resourceVersion`
  * `annotations`
    * `kubectl.kubernetes.io/last-applied-configuration`
* `status` (except for `Node`, `Pod` and `PersistentVolume` objects)
{% endhint %}

You can also see current ([or past](../../use/stackstate-ui/timeline-time-travel.md#topology-time)) YAML definition of the object in the ["Component properties"](../../getting_started#component-relation-details):

![Kubernetes Component properties](../../.gitbook/assets/k8s-component-properties-yaml.png)

#### Metrics

The Kubernetes integration makes all metrics from the Kubernetes cluster available in StackState. Relevant metrics are automatically mapped to the associated components.

All retrieved metrics can be browsed or added to a component as a telemetry stream. Select the data source **StackState Metrics** and type `kubernetes` in the **Select** box to get a full list of all available metrics.

![Add a Kubernetes metrics stream to a component](../../.gitbook/assets/v46_add_k8s_stream.png)

#### Topology

The Kubernetes integration retrieves components and relations for the Kubernetes cluster.

{% hint style="info" %}
Note that topology information is only gathered from Kubernetes clusters that use the Docker container runtime.
{% endhint %}

**Components**

The following Kubernetes topology data is available in StackState as components:

|  |  |
| :--- | :--- |
| Cluster | Ingress |
| Namespace | Job |
| Node | Persistent Volume |
| Pod | ReplicaSet |
| Container | Secret |
| ConfigMap | Service |
| CronJob | StatefulSet |
| DaemonSet | Volume |
| Deployment |  |

**Relations**

The following relations between components are retrieved:

* Container → Volume
* CronJob → Job
* DaemonSet → Pod
* Deployment → ReplicaSet
* Job → Pod
* Ingress → Service
* Namespace → CronJob, DaemonSet, Deployment, Job, ReplicaSet, Service, StatefulSet
* Node → Cluster relation
* Pod → ConfigMap, Container, Deployment, Node, Secret, Volume
* ReplicaSet →  Pod
* Service → ExternalService, Pod
* StatefulSet → Pod
* Direct communication between processes
* Process → Process communication via Kubernetes service
* Process → Process communication via headless Kubernetes service

#### Traces

The Kubernetes integration does not retrieve any traces data.

#### Tags

All tags defined in Kubernetes will be retrieved and added to the associated components and relations in StackState.

### REST API endpoints

The StackState Agent talks to the kubelet and kube-state-metrics API.

The StackState Agent and Cluster Agent connect to the Kubernetes API to retrieve cluster wide information and Kubernetes events. The following API endpoints used:

| Resource type | REST API endpoint |
| :--- | :--- |
| Cluster &gt; ComponentStatus | `GET /api/v1/componentstatuses` |
| Cluster &gt; Event | `GET /apis/events.k8s.io/v1/events` |
| Cluster &gt; Namespace | `GET /api/v1/namespaces` |
| Cluster &gt; Node | `GET /api/v1/nodes` |
| Services &gt; Endpoints | `GET /api/v1/namespaces/{namespace}/endpoints` |
| Services &gt; Ingress | `GET /apis/networking.k8s.io/v1/namespaces/{namespace}/ingresses` |
| Services &gt; Service | `GET /api/v1/namespaces/{namespace}/services` |
| Workloads &gt; CronJob | `GET /apis/batch/v1beta1/namespaces/{namespace}/cronjobs` |
| Workloads &gt; DaemonSet | `GET /apis/apps/v1/namespaces/{namespace}/daemonsets` |
| Workloads &gt; Deployment | `GET /apis/apps/v1/namespaces/{namespace}/deployments` |
| Workloads &gt; Job | `GET /apis/batch/v1/namespaces/{namespace}/jobs` |
| Workloads &gt; Pod | `GET /api/v1/namespaces/{namespace}/pods` |
| Workloads &gt; ReplicaSet | `GET /apis/apps/v1/namespaces/{namespace}/replicasets` |
| Workloads &gt; StatefulSet | `GET /apis/apps/v1/namespaces/{namespace}/statefulsets` |
| Config and Storage &gt; ConfigMap | `GET /api/v1/namespaces/{namespace}/configmaps` |
| Config and Storage &gt; Secret | `GET /api/v1/secrets` |
| Config and Storage &gt; PersistentVolume | `GET /api/v1/persistentvolumes` |
| Config and Storage &gt; PersistentVolumeClaimSpec | `GET /api/v1/namespaces/{namespace}/persistentvolumeclaims` |
| Config and Storage &gt; VolumeAttachment | `GET /apis/storage.k8s.io/v1/volumeattachments` |
|  | `/version` |
|  | `/healthz` |

For further details, refer to the [Kubernetes API documentation \(kubernetes.io\)](https://kubernetes.io/docs/reference/kubernetes-api/).

### Component actions

A number of [actions](../../use/stackstate-ui/perspectives/topology-perspective.md#actions) are added to StackState when the Kubernetes StackPack is installed. They are available from the **Actions** section on the right of the screen when a Kubernetes component is selected or from the component context menu, displayed when you hover over a Kubernetes component in the Topology Perspective

| Action | Available for component types | Description |
| :--- | :--- | :--- |
| **Show configuration and storage** | pods containers | Display the selected pod or container with its configmaps, secrets and volumes |
| **Show dependencies \(deep\)** | deployment replicaset replicationcontroller statefulset daemonset job cronjob pod | Displays all dependencies \(up to 6 levels deep\) of the selected pod or workload. |
| **Show pods** | deployment replicaset replicationcontroller statefulset daemonset job cronjob | Displays the pods for the selected workload. |
| **Show pods & services** | namespace | Opens a view for the pods/services in the selected namespace |
| **Show services** | namespace | Open a view for the service and ingress components in the selected namespace |
| **Show workloads** | namespace | Show workloads in the selected namespace |

Details of installed actions can be found in the StackState UI **Settings** &gt; **Actions** &gt; **Component Actions** screen.

### Kubernetes views in StackState

When the Kubernetes integration is enabled, the following Kubernetes views are available in StackState for each cluster:

* Kubernetes - Applications -
* Kubernetes - Infrastructure -
* Kubernetes - Namespaces -
* Kubernetes - Workload Controllers -

### Open source

The code for the StackState Agent Kubernetes check is open source and available on GitHub at:

* [https://github.com/StackVista/stackstate-agent/tree/master/pkg/collector/corechecks/cluster](https://github.com/StackVista/stackstate-agent/tree/master/pkg/collector/corechecks/cluster)
* [https://github.com/stackvista/stackstate-agent](https://github.com/stackvista/stackstate-agent)
* [https://github.com/StackVista/stackstate-agent-integrations/tree/master/kubernetes](https://github.com/StackVista/stackstate-agent-integrations/tree/master/kubernetes)

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?utf8=%E2%9C%93&query=kubernetes).

## Uninstall

To uninstall the Kubernetes StackPack, go to the StackState UI **StackPacks** &gt; **Integrations** &gt; **Kubernetes** screen and click **UNINSTALL**. All Kubernetes StackPack specific configuration will be removed from StackState.

## Release notes

**Kubernetes StackPack v3.9.9 (2022-03-02)**

- Improvement: Documentation for `agent.containerRuntime.customSocketPath` option.

**Kubernetes StackPack v3.9.8 (2021-11-30)**

* Bug Fix: Support nodes without instanceId

**Kubernetes StackPack v3.9.7 (2021-10-06)**

* Bug Fix: Fix metrics for generic events

**Kubernetes StackPack v3.9.6 (2021-08-20)**

* Improvement: Add description to Views

**Kubernetes StackPack v3.9.5 \(2021-07-14\)**

* Improvement: Documentation update
* Improvement: Update of `stackstate.url` for the installation documentation of the StackState Agent

## See also

* [Deploy StackState Agent V2, the Cluster Agent and kube-state-metrics](../../setup/agent/kubernetes.md)
* [StackState Agent V2 StackPack](agent.md)
* [StackState Agent Kubernetes check \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/tree/master/kubernetes)
* [StackState Cluster Agent Helm Chart \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/cluster-agent)
* [Kubernetes API documentation \(kubernetes.io\)](https://kubernetes.io/docs/reference/kubernetes-api/)

