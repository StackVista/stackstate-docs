---
description: StackState Self-hosted v5.0.x 
---

# OpenShift

## Overview

{% hint style="info" %}
**StackState Agent V2**
{% endhint %}

To retrieve topology, events and metrics data from a OpenShift cluster, you will need to have the following installed in the cluster:

* StackState Agent V2 on each node in the cluster
* StackState Cluster Agent on one node
* kube-state-metrics

To integrate with other services, a separate instance of the [StackState Agent](about-stackstate-agent.md) should be deployed on a standalone VM.

## StackState Agent types

The OpenShift integration collects topology data in an OpenShift cluster, as well as metrics and events. To achieve this, different types of StackState Agent are used:

| Component | Pod name |
| :--- | :--- |
| [StackState Cluster Agent](openshift.md#stackstate-cluster-agent) | `stackstate-cluster-agent` |
| [StackState Agent](openshift.md#stackstate-agent) | `stackstate-cluster-agent-agent` |
| [StackState ClusterCheck Agent \(optional\)](openshift.md#stackstate-clustercheck-agent-optional)| `stackstate-cluster-agent-clusterchecks` |

{% hint style="info" %}
To integrate with other services, a separate instance of the [StackState Agent](about-stackstate-agent.md) should be deployed on a standalone VM. It is not currently possible to configure a StackState Agent deployed on an OpenShift cluster with checks that integrate with other services.
{% endhint %}

![StackState Agents on OpenShift](/.gitbook/assets/agent-openshift.svg)

### StackState Cluster Agent

StackState Cluster Agent is deployed as a Deployment. There is one instance for the entire cluster:

* Topology and events data for all resources in the cluster are retrieved from the OpenShift API
* Control plane metrics are retrieved from the OpenShift API

When cluster checks are enabled, cluster checks configured here are run by the deployed [StackState ClusterCheck Agent](openshift.md#stackstate-clustercheck-agent-optional) pod.

### StackState Agent

StackState Agent V2 is deployed as a DaemonSet with one instance **on each node** in the cluster:

* Host information is retrieved from the OpenShift API.
* Container information is collected from the Docker daemon.
* Metrics are retrieved from kubelet running on the node and also from kube-state-metrics if this is deployed on the same node.

By default, metrics are also retrieved from kube-state-metrics if that is deployed on the same node as the StackState Agent pod. This can cause issues on a large Kubernetes cluster. To avoid this, it is advisable to [enable cluster checks](#enable-cluster-checks) so that metrics are gathered from kube-state-metrics by a dedicated StackState ClusterCheck Agent.

### StackState ClusterCheck Agent (optional)

The StackState ClusterCheck Agent is an additional StackState Agent V2 pod that is deployed only when [cluster checks are enabled](#enable-cluster-checks) in the Helm chart. When deployed, cluster checks configured on the [StackState Cluster Agent](#stackstate-cluster-agent) will be run by the StackState ClusterCheck Agent pod. 

On large OpenShift clusters, you can [run the `kubernetes_state` check on the ClusterCheck Agent](/stackpacks/integrations/openshift.md#configure-cluster-check-kubernetes_state-check). This check gathers metrics from kube-state-metrics and sends them to StackState. The ClusterCheck Agent is also useful to run checks that do not need to run on a specific node and monitor non-containerized workloads such as:

* Out-of-cluster datastores and endpoints \(for example, RDS or CloudSQL\).
* Load-balanced cluster services \(for example, Kubernetes services\).

The [AWS check](/stackpacks/integrations/aws/aws.md#configure-the-aws-check) can be configured to run as a cluster check.

## Setup

### Supported versions

StackState Agent v2.17.x is supported to monitor the following versions of OpenShift:

* OpenShift 4.3 - 4.8
* Default networking
* Container runtime: 
  * Docker
  * containerd
  * CRI-O

### Install

The StackState Agent, Cluster Agent and kube-state-metrics can be installed together using the Cluster Agent Helm Chart:

1. If you do not already have it, you will need to add the StackState helm repository to the local helm client:

   ```text
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
   ```

2. Deploy the StackState Agent, Cluster Agent and kube-state-metrics with helm command provided below.
   * `<STACKSTATE_RECEIVER_API_KEY>` is set during StackState installation.
   * `<STACKSTATE_RECEIVER_API_ADDRESS>` is specific to your installation of StackState. 

   * For details see [StackState Receiver API](/setup/agent/about-stackstate-agent.md#stackstate-receiver-api).
   
   - Note that [additional optional configuration](#helm-chart-values) can be added to the standard helm command.

```commandline
helm upgrade --install \
--namespace stackstate \
--create-namespace \
--set-string 'stackstate.apiKey'='<STACKSTATE_RECEIVER_API_KEY>' \
--set-string 'stackstate.cluster.name'='<OPENSHIFT_CLUSTER_NAME>' \
--set-string 'stackstate.url'='<STACKSTATE_RECEIVER_API_ADDRESS>' \
--set 'agent.scc.enabled'=true \
--set 'kube-state-metrics.securityContext.enabled'=false \
stackstate-cluster-agent stackstate/cluster-agent
```

### Helm chart values

Additional variables can be added to the standard helm command, for example:
* It is recommended to [provide a `stackstate.cluster.authToken`](#stackstateclusterauthtoken). 
* For large OpenShift clusters, [enable cluster checks](openshift.md#enable-cluster-checks) to run the kubernetes\_state check in a StackState ClusterCheck Agent pod.
* If you use a custom socket path, [set the `agent.containerRuntime.customSocketPath`](#agentcontainerruntimecustomsocketpath). 
* Details of all available helm chart values can be found in the [Cluster Agent Helm Chart documentation \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/cluster-agent).


#### stackstate.cluster.authToken

It is recommended to provide a `stackstate.cluster.authToken` in addition to the standard helm chart variables when the StackState Agent is deployed. This is an optional variable, however, if not provided a new, random value will be generated each time a helm upgrade is performed. This could leave some pods in the cluster with an incorrect configuration.

For example:

```text
helm upgrade --install \
--namespace stackstate \
--create-namespace \
--set-string 'stackstate.apiKey'='<STACKSTATE_RECEIVER_API_KEY>' \
--set-string 'stackstate.cluster.name'='<OPENSHIFT_CLUSTER_NAME>' \
--set-string 'stackstate.cluster.authToken'='<CLUSTER_AUTH_TOKEN>' \
--set-string 'stackstate.url'='<STACKSTATE_RECEIVER_API_ADDRESS>' \
--set 'agent.scc.enabled'=true \
--set 'kube-state-metrics.securityContext.enabled'=false \
stackstate-cluster-agent stackstate/cluster-agent
```

#### agent.containerRuntime.customSocketPath

It is not necessary to configure this property if your cluster uses one of the default socket paths (`/var/run/docker.sock`, `/var/run/containerd/containerd.sock` or `/var/run/crio/crio.sock`)

If your cluster uses a custom socket path, you can provide it using the key `agent.containerRuntime.customSocketPath`. For example:

```
helm upgrade --install \
--namespace stackstate \
--create-namespace \
--set-string 'stackstate.apiKey'='<STACKSTATE_RECEIVER_API_KEY>' \
--set-string 'stackstate.cluster.name'='<OPENSHIFT_CLUSTER_NAME>' \
--set-string 'stackstate.url'='<STACKSTATE_RECEIVER_API_ADDRESS>' \
--set-string 'agent.containerRuntime.customSocketPath'='<CUSTOM_SOCKET_PATH>' \
--set 'agent.scc.enabled'=true \
--set 'kube-state-metrics.securityContext.enabled'=false \
stackstate-cluster-agent stackstate/cluster-agent
```

### Upgrade

To upgrade the Agents running in your OpenShift cluster, run the helm upgrade command provided on the StackState UI **StackPacks** &gt; **Integrations** &gt; **OpenShift** screen. This is the same command used to deploy the StackState Agent and Cluster Agent.

## Configure

### Enable cluster checks

Optionally, the chart can be configured to start an additional StackState Agent V2 pod as a [StackState ClusterCheck Agent](openshift.md#stackstate-clustercheck-agent-optional) pod. Cluster checks that are configured on the [StackState Cluster Agent](openshift.md#stackstate-cluster-agent) will then be run by the deployed StackState ClusterCheck Agent pod.

To enable cluster checks and deploy the ClusterCheck Agent pod, create a `values.yaml` file to deploy the `cluster-agent` Helm chart and add the following YAML segment:

```yaml
clusterChecks:
  enabled: true
```

The following integrations have checks that can be configured to run as cluster checks:

- **Kubernetes integration** - [Kubernetes_state check as a cluster check](/stackpacks/integrations/openshift.md#configure-cluster-check-kubernetes_state-check).
- **OpenShift integration** - [OpenShift Kubernetes_state check as a cluster check](/stackpacks/integrations/openshift.md#configure-cluster-check-kubernetes_state-check).
- **AWS integration** - [AWS check as a cluster check](/stackpacks/integrations/aws/aws.md#configure-the-aws-check).

### Advanced Agent configuration

StackState Agent V2 can be configured to reduce data production, tune the process blacklist, or turn off specific features when not needed. The required settings are described in detail on the page [advanced Agent configuration](advanced-agent-configuration.md).

### Integration configuration

To integrate with other external services, a separate instance of the [StackState Agent](about-stackstate-agent.md) should be deployed on a standalone VM. It is not currently possible to configure a StackState Agent deployed on an OpenShift cluster with checks that integrate with other services.

## Commands

### Agent and Cluster Agent pod status

To check the status of the OpenShift integration, check that the StackState Cluster Agent \(`cluster-agent`\) pod and all of the StackState Agent \(`cluster-agent-agent`\) pods have status `READY`.

```text
❯ kubectl get deployment,daemonset --namespace stackstate

NAME                                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/stackstate-cluster-agent             1/1     1            1           5h14m
NAME                                                 DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/stackstate-cluster-agent-agent        10        10        10      10           10          <none>          5h14m
```

### Agent check status

To find the status of an Agent check: 

1. Find the Agent pod that is running on the node where you would like to find a check status:
   ```yaml
   kubectl get pod --output wide
   ```
   
2. Run the command:
   ```yaml
   kubectl exec <agent-pod-name> -n <agent-namespace> -- agent status
   ```
   
3. Look for the check name under the `Checks` section.

## Uninstall

To uninstall the StackState Cluster Agent and the StackState Agent from your OpenShift cluster, run a Helm uninstall:

```text
helm uninstall <release_name> --namespace <namespace>

# If you used the standard install command provided when you installed the StackPack
helm uninstall stackstate-cluster-agent --namespace stackstate
```

## See also

* [Cluster Agent Helm Chart documentation \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/cluster-agent)
* [About the StackState Agent](about-stackstate-agent.md)
* [Advanced Agent configuration](advanced-agent-configuration.md)  
* [OpenShift StackPack](../../stackpacks/integrations/openshift.md)

