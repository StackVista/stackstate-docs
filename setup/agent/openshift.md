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

## StackState Agents

The OpenShift integration collects topology data in an OpenShift cluster, as well as metrics and events. To achieve this, different types of StackState Agent are used:

| Component | Required? | Pod name |
| :--- | :--- | :--- |
| [StackState Cluster Agent](openshift.md#stackstate-cluster-agent) | ✅ | `stackstate-cluster-agent` |
| [StackState Agent](openshift.md#stackstate-agent) | ✅ | `stackstate-cluster-agent-agent` |
| [StackState ClusterCheck Agent](openshift.md#stackstate-clustercheck-agent) | - | `stackstate-cluster-agent-clusterchecks` |

{% hint style="info" %}
To integrate with other services, a separate instance of the [StackState Agent](about-stackstate-agent.md) should be deployed on a standalone VM. It is not currently possible to configure a StackState Agent deployed on an OpenShift cluster with checks that integrate with other services.
{% endhint %}

### StackState Cluster Agent

StackState Cluster Agent is deployed as a Deployment. There is one instance for the entire cluster:

* Topology and events data for all resources in the cluster are retrieved from the OpenShift API
* Control plane metrics are retrieved from the OpenShift API

When cluster checks are enabled, cluster checks configured here are run by one of the deployed [StackState ClusterCheck Agent](openshift.md#stackstate-clustercheck-agent) pods.

### StackState Agent

StackState Agent V2 is deployed as a DaemonSet with one instance **on each node** in the cluster:

* Host information is retrieved from the OpenShift API.
* Container information is collected from the Docker daemon.
* Metrics are retrieved from kubelet running on the node and also from kube-state-metrics if this is deployed on the same node.

By default, metrics are also retrieved from kube-state-metrics if that is deployed on the same node as the StackState Agent pod. This can cause issues on a large OpenShift cluster. To avoid this, it is advisable to enable cluster checks so that metrics are gathered from kube-state-metrics by a dedicated [StackState ClusterCheck Agent](openshift.md#stackstate-clustercheck-agent).

### StackState ClusterCheck Agent

Deployed only when `clusterChecks.enabled` is set to `true` in `values.yaml` when the StackState Cluster Agent is deployed. When deployed, default is one instance per cluster. When enabled, cluster checks configured on the [StackState Cluster Agent](openshift.md#stackstate-cluster-agent) are run by one of the deployed StackState ClusterCheck Agent pods. This is useful to run checks that do not need to run on a specific node and monitor non-containerized workloads such as:

* Out-of-cluster datastores and endpoints \(for example, RDS or CloudSQL\).
* Load-balanced cluster services \(for example, Kubernetes services\).

Read how to [enable cluster checks](openshift.md#cluster-check-configuration).

## Setup

### Supported versions

StackState Agent v2.15.0 is supported to monitor the following versions of Kubernetes:

* OpenShift 4.3 - 4.8
* Docker container runtime (not containerd, cri-o)
* Default networking

### Install

The StackState Agent, Cluster Agent and kube-state-metrics can be installed together using the Cluster Agent Helm Chart:

1. If you do not already have it, you will need to add the StackState helm repository to the local helm client:

   ```text
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
   ```

2. Deploy the StackState Agent, Cluster Agent and kube-state-metrics with the helm command provided in the StackState UI after you have installed the StackPack. For large OpenShift clusters, you can [enable cluster checks](openshift.md#cluster-check-configuration) to run the kubernetes\_state check in a StackState ClusterCheck Agent pod.

{% hint style="info" %}
**stackstate.cluster.authToken**

In addition to the variables included in the provided helm command, it is also recommended to provide a `stackstate.cluster.authToken`. This is an optional variable, however, if not provided a new, random value will be generated each time a helm upgrade is performed. This could leave some pods in the cluster with an incorrect configuration.

For example:

```text
helm upgrade --install \
--namespace stackstate \
--create-namespace \
--set-string 'stackstate.apiKey'='<your-api-key>' \
--set-string 'stackstate.cluster.name'='<your-cluster-name>' \
--set-string 'stackstate.cluster.authToken'='<your-cluster-token>' \
--set-string 'stackstate.url'='<your-stackstate-url>/receiver/stsAgent' \
--set 'agent.scc.enabled'=true \
--set 'kube-state-metrics.securityContext.enabled'=false \
stackstate-cluster-agent stackstate/cluster-agent
```
{% endhint %}

Full details of the available values can be found in the [Cluster Agent Helm Chart documentation \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/cluster-agent).

### Upgrade

To upgrade the Agents running in your OpenShift cluster, run the helm upgrade command provided on the StackState UI **StackPacks** &gt; **Integrations** &gt; **OpenShift** screen. This is the same command used to deploy the StackState Agent and Cluster Agent.

## Configure

### Cluster check configuration

Optionally, the chart can be configured to start additional StackState Agent V2 pods \(1 by default\) as StackState ClusterCheck Agent pods that run cluster checks. Cluster checks are configured on the [StackState Cluster Agent](openshift.md#stackstate-cluster-agent) are run by one of the deployed [StackState ClusterCheck Agent](openshift.md#stackstate-clustercheck-agent) pods.

#### Enable cluster checks

To enable cluster checks and the cluster check Agent pods, create a `values.yaml` file to deploy the `cluster-agent` Helm chart and add the following YAML segment:

```yaml
clusterChecks:
  enabled: true
```

#### Run the Kubernetes\_state check as a cluster check

The kubernetes\_state check is responsible for gathering metrics from kube-state-metrics and sending them to StackState. It is configured on the StackState Cluster Agent and runs in the StackState Agent pod that is on the same node as the kube-state-metrics pod.

In a default deployment, the pod running the StackState Cluster Agent and every deployed StackState Agent need to be able to run the check. In a large OpenShift cluster, this can consume a lot of memory as every pod must be configured with sufficient CPU and memory requests and limits. Since only one of those Agent pods will actually run the check, a lot of CPU and memory resources will be allocated, but will not be used.

To remedy that situation, the kubernetes\_state check can be configured to run as a cluster check. The YAML segment below shows how to do that in the `values.yaml` file used to deploy the `cluster-agent` chart:

```yaml
clusterChecks:
# clusterChecks.enabled -- Enables the cluster checks functionality _and_ the clustercheck pods.
  enabled: true
agent:
  config:
    override:
# agent.config.override -- Disables kubernetes_state check on regular agent pods.
    - name: auto_conf.yaml
      path: /etc/stackstate-agent/conf.d/kubernetes_state.d
      data: |
clusterAgent:
  config:
    override:
# clusterAgent.config.override -- Defines kubernetes_state check for clusterchecks agents. Auto-discovery
#                                 with ad_identifiers does not work here. Use a specific URL instead.
    - name: conf.yaml
      path: /etc/stackstate-agent/conf.d/kubernetes_state.d
      data: |
        cluster_check: true

        init_config:

        instances:
          - kube_state_url: http://YOUR_KUBE_STATE_METRICS_SERVICE_NAME:8080/metrics
```

### Advanced Agent configuration

StackState Agent V2 can be configured to tune the process blacklist, or turn off specific features when not needed. The required environment variables and are described on the page [advanced Agent configuration](advanced-agent-configuration.md).

### Integration configuration

To integrate with other external services, a separate instance of the [StackState Agent](about-stackstate-agent.md) should be deployed on a standalone VM. It is not currently possible to configure a StackState Agent deployed on an OpenShift cluster with checks that integrate with other services.

## Commands

### Status and information

To check the status of the OpenShift integration, check that the StackState Cluster Agent \(`cluster-agent`\) pod and all of the StackState Agent \(`cluster-agent-agent`\) pods have status `READY`.

```text
❯ kubectl get deployment,daemonset --namespace stackstate

NAME                                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/stackstate-cluster-agent             1/1     1            1           5h14m
NAME                                                 DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/stackstate-cluster-agent-agent        10        10        10      10           10          <none>          5h14m
```

## Uninstall

To uninstall the StackState Cluster Agent and the StackState Agent from your OpenShift cluster, run a Helm uninstall:

```text
helm uninstall <release_name> --namespace <namespace>

# If you used the standard install command provided when you installed the StackPack
helm uninstall stackstate-cluster-agent --namespace stackstate
```

## See also

* [About the StackState Agent](about-stackstate-agent.md)
* [Advanced Agent configuration](advanced-agent-configuration.md)  
* [OpenShift StackPack](../../stackpacks/integrations/openshift.md)

