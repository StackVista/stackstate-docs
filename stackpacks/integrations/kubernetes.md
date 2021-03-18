---
stackpack-name: Kubernetes
---

# Kubernetes

## Overview

The Kubernetes integration is used to create a near real-time synchronization of topology and associated internal services from a Kubernetes cluster to StackState. This StackPack allows monitoring of the following:

* Workloads
* Nodes, pods, containers and services
* Configmaps, secrets and volumes

![Data flow](/.gitbook/assets/stackpack_kubernetes.svg)

The Kubernetes integration collects topology data in a Kubernetes cluster as well as metrics and events.

- StackState Agent V2 is deployed as a DaemonSet with one instance **on each node** in the Kubernetes cluster:
    * Host information is retrieved from the Kubernetes API
    * Container information is collected from the Docker daemon
    * Metrics are retrieved from kubelet running on the node and also from kube-state-metrics if this is deployed on the same node
- StackState Cluster Agent is deployed with a Deployment. There is one instance for the entire Kubernetes cluster:
    * Topology and events data for all resources in the cluster are retrieved from the Kubernetes API
    * Control plane metrics are retrieved from the Kubernetes API
- Retrieved data is pushed to StackState via the Agent StackPack (StackState Agent V2) and the Kubernetes StackPack (StackState Cluster Agent).
- In StackState:
    - [Topology data](#topology) is translated into components and relations.
    - [Tags](#tags) defined in Kubernetes are added to components and relations in StackState.
    - Relevant [metrics data](#metrics) is mapped to associated components and relations in StackState. All retrieved metrics data is stored and accessible within StackState.
    - [Events](#events) are available in the StackState Events Perspective and listed in the details pane of the StackState UI.

## Setup

### Prerequisites

The following prerequisites are required to install the Kubernetes StackPack and deploy the StackState Agent and Cluster Agent:

* A Kubernetes Cluster must be up and running.
* A recent version of Helm 3.
* A user with permissions to create privileged pods, ClusterRoles and ClusterRoleBindings:
    - ClusterRole and ClusterRoleBinding are needed to grant StackState Agents permissions to access the Kubernetes API.
    - StackState Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Install

Install the Kubernetes StackPack from the StackState UI **StackPacks** > **Integrations** screen. You will need to provide the following parameters:

- **Kubernetes Cluster Name** - A name to identify the cluster. This does not need to match the cluster name used in `kubeconfig`, however, that is usually a good candidate for a unique name.

If the Agent StackPack is not already installed, this will be automatically installed together with the Kubernetes StackPack. This is required to work with the StackState Agent, which will need to be deployed on each node in the Kubernetes cluster.

### Deploy the StackState Agent and Cluster Agent

For the Kubernetes integration to retrieve topology, events and metrics data, you will need to have the following installed on your Kubernetes cluster:

- A StackState Agent on each node in the cluster
- StackState Cluster Agent on one node
- kube-state-metrics

These can be installed together using the Cluster Agent Helm Chart:

1. If you do not already have it, you will need to add the StackState helm repository to the local helm client:
    ```
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
    ```
2. Deploy the StackState Agent, Cluster Agent and kube-state-metrics with the helm install command provided in the StackState UI after you have installed the StackPack.

{% hint style="info" %}
**stackstate.cluster.authToken**

In addition to the variables included in the provided helm command, it is also recommended to provide a `stackstate.cluster.authToken`. This is an optional variable, however, if not provided a new, random value will be generated each time a helm upgrade is performed. This could leave some pods in the cluster with an incorrect configuration.

For example:

```
helm install \
--namespace monitoring \
--set-string 'stackstate.apiKey'='<your-api-key>' \
--set-string 'stackstate.cluster.name'='<your-cluster-name>' \
--set-string 'stackstate.cluster.authToken'='<your-cluster-token>' \
--set-string 'stackstate.url'='<your-stackstate-url>' \
stackstate/cluster-agent
```

{% endhint %}

Full details of the available values can be found in the [Cluster Agent Helm Chart documentation \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/cluster-agent).

### Status

To check the status of the Kubernetes integration, check that the StackState Cluster Agent (`cluster-agent`) pod and all of the StackState Agent (`cluster-agent-agent`) pods have status ready.

```
❯ kubectl get deployment,daemonset --namespace monitoring

NAME                                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/stackstate-cluster-agent             1/1     1            1           5h14m
NAME                                                 DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/stackstate-cluster-agent-agent        10        10        10      10           10          <none>          5h14m
```

## Integration details

### Data retrieved

The Kubernetes integration retrieves the following data:

- [Events](#events)
- [Metrics](#metrics)
- [Tags](#tags)
- [Topology](#topology)

#### Events

The Kubernetes integration retrieves all events from the Kubernetes cluster. The table below shows which event category will be assigned to each event type in StackState:

| StackState event category | Kubernetes events | 
|:---|:---|
| **Activities** | `BackOff`<br />`ContainerGCFailed`<br />`ExceededGracePeriod`<br />`FileSystemResizeSuccessful`<br />`ImageGCFailed`<br />`Killing`<br />`NodeAllocatableEnforced`<br />`NodeNotReady`<br />`NodeSchedulable`<br />`Preempting`<br />`Pulling`<br />`Pulled`<br />`Rebooted`<br />`Scheduled`<br />`Starting`<br />`Started`<br />`SuccessfulAttachVolume`<br />`SuccessfulDetachVolume`<br />`SuccessfulMountVolume`<br />`SuccessfulUnMountVolume`<br />`VolumeResizeSuccessful` |
| **Alerts** | `NotTriggerScaleUp` |
| **Changes** | `Created` (created container)<br />`NodeReady`<br />`SandboxChanged`<br />`SuccesfulCreate` |
| **Others** | All other events |

#### Metrics

The Kubernetes integration makes all metrics from the Kubernetes cluster available in StackState. Relevant metrics are automatically mapped to the associated components. 

All retrieved metrics can be browsed or added to a component as a telemetry stream. Select the data source **StackState Metrics** and type `kubernetes` in the **Select** box to get a full list of all available metrics. 

![Add a Kubernetes metrics stream to a component](/.gitbook/assets/v43_add_k8s_stream.png)

#### Topology

The Kubernetes integration retrieves components and relations for the Kubernetes cluster. 

**Components**

The following Kubernetes topology data is available in StackState as components:

| | |
|:---|:---|
| Cluster | Deployment |
| Namespace | Ingress |
| Node | Job |
| Pod | Persistent Volume |
| Container | ReplicaSet |
| ConfigMap | Secret |
| CronJob | Service |
| DaemonSet | StatefulSet |

**Relations**

The following relations between components are retrieved:

- Container → Volume
- CronJob → Job
- Deployment → ReplicaSet
- Ingress → Service
- Namespace → CronJob, DaemonSet, Deployment, Job, Pod, ReplicaSet, Service, StatefulSet
- Node → Cluster relation
- Pod → ConfigMap, Container, DaemonSet, Deployment, Job, Node, ReplicaSet, Secret, StatefulSet, Volume
- Service → ExternalService, Pod
- Direct communication between processes
- Process → Process communication via Kubernetes service
- Process → Process communication via headless Kubernetes service

#### Traces

The Kubernetes integration does not retrieve any traces data.

#### Tags

All tags defined in Kubernetes will be retrieved and added to the associated components and relations in StackState. 

### REST API endpoints

The StackState Agent and Cluster Agent connect to the Kubernetes API to retrieve cluster wide information and Kubernetes events. The following API endpoints used:

| Resource type | REST API endpoint |
|:---|:---|
| Cluster > ComponentStatus | `GET /api/v1/componentstatuses` |
| Cluster > Event | `GET /apis/events.k8s.io/v1/events` | 
| Cluster > Namespace | `GET /api/v1/namespaces` |
| Cluster > Node | `GET /api/v1/nodes` |
| Services > Endpoints | `GET /api/v1/namespaces/{namespace}/endpoints` | 
| Services > Ingress | `GET /apis/networking.k8s.io/v1/namespaces/{namespace}/ingresses` |
| Services > Service | `GET /api/v1/namespaces/{namespace}/services` |
| Workloads > CronJob | `GET /apis/batch/v1beta1/namespaces/{namespace}/cronjobs` |
| Workloads > DaemonSet | `GET /apis/apps/v1/namespaces/{namespace}/daemonsets` |
| Workloads > Deployment | `GET /apis/apps/v1/namespaces/{namespace}/deployments` |
| Workloads > Job | `GET /apis/batch/v1/namespaces/{namespace}/jobs` |
| Workloads > Pod | `GET /api/v1/namespaces/{namespace}/pods` |
| Workloads > ReplicaSet | `GET /apis/apps/v1/namespaces/{namespace}/replicasets` |
| Workloads > StatefulSet | `GET /apis/apps/v1/namespaces/{namespace}/statefulsets` |
| Config and Storage > ConfigMap | `GET /api/v1/namespaces/{namespace}/configmaps` |
| Config and Storage > Secret | `GET /api/v1/secrets` |
| Config and Storage > PersistentVolume | `GET /api/v1/persistentvolumes` |
| Config and Storage > PersistentVolumeClaimSpec | `GET /api/v1/namespaces/{namespace}/persistentvolumeclaims` |
| Config and Storage > VolumeAttachment | `GET /apis/storage.k8s.io/v1/volumeattachments` |
| | `/version` |
| | `/healthz` |

For further details, refer to the [Kubernetes API documentation \(kubernetes.io\)](https://kubernetes.io/docs/reference/kubernetes-api/).

### Component actions

The following [actions](use/views/topology-perspective.md#actions) are added to StackState when the Kubernetes StackPack is installed. They are available from the **Actions** section on the right of the screen when a Kubernetes component is selected or from the component context menu, displayed when you hover over a Kubernetes component.

| Action | Available for<br />component types | Description|
|:---|:---|:---|
| **Show configuration and storage** | pods<br />containers | Display the selected pod or container with its configmaps, secrets and volumes |
| **Show dependencies (deep)** | deployment<br />replicaset<br />replicationcontroller<br />statefulset<br />daemonset<br />job<br />cronjob<br />pod | Displays all dependencies (up to 6 levels deep) of the selected pod or workload. |
| **Show pods** | deployment<br />replicaset<br />replicationcontroller<br />statefulset<br />daemonset<br />job<br />cronjob | Displays the pods for the selected workload. |
| **Show pods & services** | namespace | Opens a view for the pods/services in the selected namespace |
| **Show services** | namespace | Open a view for the service and ingress components in the selected namespace |
| **Show workloads** | namespace | Show workloads in the selected namespace |

Details of installed actions can be found in the StackState UI **Settings** > **Actions** > **Component Actions** screen.

### Kubernetes views in StackState

When the Kubernetes integration is enabled, the following Kubernetes views are available in StackState for each cluster:

* Kubernetes - Applications - <instance_name>
* Kubernetes - Infrastructure - <instance_name>
* Kubernetes - Namespaces - <instance_name>
* Kubernetes - Workload Controllers - <instance_name>


### Open source

The code for the StackState Agent Kubernetes check is open source and available on GitHub at:

- [https://github.com/StackVista/stackstate-agent/tree/master/pkg/collector/corechecks/cluster](https://github.com/StackVista/stackstate-agent/tree/master/pkg/collector/corechecks/cluster)
- [https://github.com/stackvista/stackstate-agent](https://github.com/stackvista/stackstate-agent)
- [https://github.com/StackVista/stackstate-agent-integrations/tree/master/kubernetes](https://github.com/StackVista/stackstate-agent-integrations/tree/master/kubernetes)

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?utf8=%E2%9C%93&query=kubernetes).

## Uninstall

To uninstall the Kubernetes StackPack, go to the StackState UI **StackPacks** > **Integrations** > **Kubernetes** screen and click **UNINSTALL**. All Kubernetes StackPack specific configuration will be removed from StackState.

To uninstall the StackState Cluster Agent and the StackState Agent from your Kubernetes cluster, run a Helm uninstall:

```
helm uninstall <release_name> <namespace>
```

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

- [Agent StackPack](/stackpacks/integrations/agent.md)
- [StackState Agent Kubernetes check \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/tree/master/kubernetes)
- [StackState Cluster Agent Helm Chart \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/cluster-agent)
- [Kubernetes API documentation \(kubernetes.io\)](https://kubernetes.io/docs/reference/kubernetes-api/)
