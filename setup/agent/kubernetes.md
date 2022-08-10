---
description: StackState Self-hosted v5.0.x 
---

# Kubernetes

## Overview

{% hint style="info" %}
**StackState Agent V2**
{% endhint %}

To retrieve topology, events and metrics data from a Kubernetes or OpenShift cluster, you will need to have the following installed in the cluster:

* StackState Agent V2 on each node in the cluster
* StackState Cluster Agent on one node
* kube-state-metrics

To integrate with other services, a separate instance of the StackState Agent should be deployed on a standalone VM.

## StackState Agent types

The Kubernetes and OpenShift integrations collect topology data from Kubernetes and OpenShift clusters respectively, as well as metrics and events. To achieve this, different types of StackState Agent are used:

| Component | Pod name |
| :--- | :--- |
| [Agent](#agent) | `stackstate-cluster-agent-agent` |
| [Cluster Agent](#cluster-agent) | `stackstate-cluster-agent` |
| [ClusterCheck Agent \(optional\)](#clustercheck-agent-optional)| `stackstate-cluster-agent-clusterchecks` |

{% hint style="info" %}
To integrate with other services, a separate instance of the StackState Agent should be deployed on a standalone VM. It is not currently possible to configure a StackState Agent deployed on a Kubernetes or OpenShift cluster with checks that integrate with other services.
{% endhint %}

![StackState Agents on Kubernetes](/.gitbook/assets/agent-kubernetes.svg)

### Agent

StackState Agent V2 is deployed as a DaemonSet with one instance **on each node** in the cluster:

* Host information is retrieved from the Kubernetes or OpenShift API.
* Container information is collected from the Docker daemon.
* Metrics are retrieved from kubelet running on the node and also from kube-state-metrics if this is deployed on the same node.

By default, metrics are also retrieved from kube-state-metrics if that is deployed on the same node as the StackState Agent pod. This can cause issues on a large Kubernetes or OpenShift clusters. To avoid this, it is advisable to [enable cluster checks](#enable-cluster-checks) so that metrics are gathered from kube-state-metrics by a dedicated StackState ClusterCheck Agent.

### Cluster Agent

StackState Cluster Agent is deployed as a Deployment. There is one instance for the entire cluster:

* Topology and events data for all resources in the cluster are retrieved from the Kubernetes API
* Control plane metrics are retrieved from the Kubernetes or OpenShift API

When cluster checks are enabled, cluster checks configured here are run by the deployed [StackState ClusterCheck Agent](kubernetes.md#clustercheck-agent-optional) pod.

### ClusterCheck Agent (optional)

The StackState ClusterCheck Agent is an additional StackState Agent V2 pod that is deployed only when [cluster checks are enabled](#enable-cluster-checks) in the Helm chart. When deployed, the StackState ClusterCheck Agent pod will run the cluster checks that are configured on the [StackState Cluster Agent](#cluster-agent). 

The following checks can be configured to run as a cluster check:

* The `kubernetes_state` check - this check gathers metrics from kube-state-metrics and sends them to StackState, it is useful to run this as a cluster check on large Kubernetes clusters. 
  * [Kubernetes integration `kubernetes_state` check](/stackpacks/integrations/kubernetes.md#configure-cluster-check-kubernetes_state-check)
  * [OpenShift integration `kubernetes_state` check](/stackpacks/integrations/openshift.md#configure-cluster-check-kubernetes_state-check)
* The [AWS check](/stackpacks/integrations/aws/aws.md#configure-the-aws-check)
* The ClusterCheck Agent is also useful to run checks that do not need to run on a specific node and monitor non-containerized workloads such as:
  * Out-of-cluster datastores and endpoints \(for example, RDS or CloudSQL\).
  * Load-balanced cluster services \(for example, Kubernetes services\).

## Setup

### Supported Kubernetes versions

StackState Agent v2.17.x is supported to monitor the following versions of Kubernetes or OpenShift:

* Kubernetes:
  * Kubernetes 1.16 - 1.21
  * EKS (with Kubernetes 1.16 - 1.21)
* OpenShift: 
  * OpenShift 4.3 - 4.8
* Default networking
* Container runtime: 
  * Docker
  * containerd
  * CRI-O

### Install

The StackState Agent, Cluster Agent and kube-state-metrics can be installed together using the Cluster Agent Helm Chart:

* [Online install](#online-install) - charts are retrieved from the default StackState chart repository (https://helm.stackstate.io), images are retrieved from the default StackState image registry (quay.io).
* [Air gapped install](#air-gapped-install) - images are retrieved from a local system or registry.
* [Install from a custom image registry](#install-from-a-custom-image-registry) - images are retrieved from a configured image registry.

#### Online install 

The StackState Agent, Cluster Agent and kube-state-metrics can be installed together using the Cluster Agent Helm Chart:

1. If you do not already have it, you will need to add the StackState helm repository to the local helm client:

   ```commandline
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
   ```

2. Deploy the StackState Agent, Cluster Agent and kube-state-metrics to namespace `stackstate` using the helm command below. 
   * `<STACKSTATE_RECEIVER_API_KEY>` is set during StackState installation.
   * `<STACKSTATE_RECEIVER_API_ADDRESS>` is specific to your installation of StackState. 

   * For details see [StackState Receiver API](/setup/agent/about-stackstate-agent.md#connect-to-stackstate).

   - Note that [additional optional configuration](#helm-chart-values) can be added to the standard helm command.

{% tabs %}
{% tab title="Kubernetes" %}
```commandline 
helm upgrade --install \ 
   --namespace stackstate \
   --create-namespace \
   --set-string 'stackstate.apiKey'='<STACKSTATE_RECEIVER_API_KEY>' \
   --set-string 'stackstate.cluster.name'='<KUBERNETES_CLUSTER_NAME>' \
   --set-string 'stackstate.url'='<STACKSTATE_RECEIVER_API_ADDRESS>' \
   stackstate-cluster-agent stackstate/cluster-agent
```
{% endtab %}
{% tab title="OpenShift" %}
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
{% endtab %}
{% endtabs %}

#### Air gapped install

If StackState Agent will run in an environment that does not have a direct connection to the Internet, the images required to install the StackState Agent, Cluster Agent and kube-state-metrics can be downloaded and stored in a local system or image registry. 


1. Internet connection required:
   1. Download tor clone the StackState Helm charts repo from GitHub: [https://github.com/StackVista/helm-charts](https://github.com/StackVista/helm-charts)
   2. In the Helm charts repo, go to the directory `stable/cluster-agent/installation` and use the script `/backup.sh` to backup the required images from StackState. The script will pull all images required for the `cluster-agent` Helm chart to run, back them up to individual tar archives and add all tars to a single `tar.gz` archive. The images will be in a `tar.gz` archive in the same folder as the working directory from where the script was executed. It is advised to run the script from the `stable/cluster-agent/installation` directory as this will simplify the process of importing images on the destination system.
      * By default, the backup script will retrieve charts from the StackState chart repository (https://helm.stackstate.io), images are retrieved from the default StackState image registry (quay.io). The script can be executed from the `installation` directory as simply `./backup.sh`.
        ```text
          Back up helm chart images to a tar.gz archive for easy transport via an external storage device.
    
          Arguments:
              -c : Helm chart (default: stackstate/cluster-agent)
              -h : Show this help text
              -r : Helm repository (default: https://helm.stackstate.io)
              -t : Dry-run
          ```
      * Add the `-t` (dry-run) parameter to the script to give a predictive output of what work will be performed, for example:
         ```text
         ./backup.sh -t
         Backing up quay.io/stackstate/stackstate-agent-2:2.17.1 to stackstate/stackstate-agent-2__2.17.1.tar (dry-run)
         Backing up quay.io/stackstate/stackstate-process-agent:4.0.7 to stackstate/stackstate-process-agent__4.0.7.tar (dry-run)
         Backing up quay.io/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032 to stackstate/kube-state-metrics__2.3.0-focal-20220316-r61.20220418.2032.tar (dry-run)
         Backing up quay.io/stackstate/stackstate-cluster-agent:2.17.1 to stackstate/stackstate-cluster-agent__2.17.1.tar (dry-run)
         Backing up quay.io/stackstate/stackstate-agent-2:2.17.1 to stackstate/stackstate-agent-2__2.17.1.tar (dry-run)
         Images have been backed up to stackstate.tar.gz
         ```

2. No internet connection required:
   1. Transport images to the destination system.
      * Copy the StackState Helm charts repo, including the `tar.gz` generated by the backup script, to a storage device for transportation. If the backup script was run from the `stable/cluster-agent/installation` directory as advised, the `tar.gz` will be located at `stable/cluster-agent/installation/stackstate.tar.gz`.
      * Copy the Helm charts repo and `tar.gz` from the storage device to a working folder of choice on the destination system.

   2. Import images to the system, and optionally push to a registry. 
      * On the destination system, go to the directory in the StackState Helm charts repo that contains both the scripts and the generated `tar.gz` archive. By default, this will be `stable/cluster-agent/installation`.
      * Execute the `import.sh` script. Note that the import script must be located in the same directory as the `tar.gz` archive to be imported, the following must be specified:
        * `-b` - path to the `tar.gz` to be imported
        * `-d` - the destination Docker image registry
      * Additional options when running the script:
        * `-p` - push images to the destination registry. When not specified, images will be imported and tagged, but but remain on the local machine.
        * `-t` - Dry-run. Use to show the work that will be performed without any action being taken.

**Example script usage**

In the example below, the StackState Agent images will be extracted from the archive `stackstate.tar.gz`, imported by Docker, and re-tagged to the registry given by the `-d` flag, in this example, `localhost`.  The `-t` argument (dry-run) is provided to show the work that will be performed:

```text
./import.sh -b stackstate.tar.gz -d localhost -t

Unzipping archive stackstate.tar.gz
x stackstate/
x stackstate/stackstate-process-agent__4.0.7.tar
x stackstate/stackstate-agent-2__2.17.1.tar
x stackstate/kube-state-metrics__2.3.0-focal-20220316-r61.20220418.2032.tar
x stackstate/stackstate-cluster-agent__2.17.1.tar
Restoring stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032 from kube-state-metrics__2.3.0-focal-20220316-r61.20220418.2032.tar (dry-run)
Imported quay.io/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032
Tagged quay.io/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032 as localhost/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032
Untagged: quay.io/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032
Restoring stackstate/stackstate-agent-2:2.17.1 from stackstate-agent-2__2.17.1.tar (dry-run)
Imported quay.io/stackstate/stackstate-agent-2:2.17.1
Tagged quay.io/stackstate/stackstate-agent-2:2.17.1 as localhost/stackstate/stackstate-agent-2:2.17.1
Untagged: quay.io/stackstate/stackstate-agent-2:2.17.1
Restoring stackstate/stackstate-cluster-agent:2.17.1 from stackstate-cluster-agent__2.17.1.tar (dry-run)
Imported quay.io/stackstate/stackstate-cluster-agent:2.17.1
Tagged quay.io/stackstate/stackstate-cluster-agent:2.17.1 as localhost/stackstate/stackstate-cluster-agent:2.17.1
Untagged: quay.io/stackstate/stackstate-cluster-agent:2.17.1
Restoring stackstate/stackstate-process-agent:4.0.7 from stackstate-process-agent__4.0.7.tar (dry-run)
Imported quay.io/stackstate/stackstate-process-agent:4.0.7
Tagged quay.io/stackstate/stackstate-process-agent:4.0.7 as localhost/stackstate/stackstate-process-agent:4.0.7
Untagged: quay.io/stackstate/stackstate-process-agent:4.0.7
Images have been imported up to localhost
```

#### Install from a custom image registry

If required, the images required to install the StackState Agent, Cluster Agent and kube-state-metrics can be served from a custom image registry. To do this, follow the instructions to [install from a custom image registry](/setup/install-stackstate/kubernetes_install/install-from-custom-image-registry.md).

### Helm chart values

Additional variables can be added to the standard helm command used to deploy the StackState Agent, Cluster Agent and kube-state-metrics. For example:
* It is recommended to [provide a `stackstate.cluster.authToken`](#stackstateclusterauthtoken). 
* For large Kubernetes or OpenShift clusters, [enable cluster checks](kubernetes.md#enable-cluster-checks) to run the kubernetes\_state check in a StackState ClusterCheck Agent pod.
* If you use a custom socket path, [set the `agent.containerRuntime.customSocketPath`](#agentcontainerruntimecustomsocketpath).

{% hint style="info" %}
Details of all available helm chart values can be found in the [Cluster Agent Helm Chart documentation \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/cluster-agent).
{% endhint %}

#### stackstate.cluster.authToken

It is recommended to provide a `stackstate.cluster.authToken` in addition to the standard helm chart variables when the StackState Agent is deployed. This is an optional variable, however, if not provided a new, random value will be generated each time a helm upgrade is performed. This could leave some pods in the cluster with an incorrect configuration.

For example:

{% tabs %}
{% tab title="Kubernetes" %}
```text
helm upgrade --install \
  --namespace stackstate \
  --create-namespace \
  --set-string 'stackstate.apiKey'='<STACKSTATE_RECEIVER_API_KEY>' \
  --set-string 'stackstate.cluster.name'='<KUBERNETES_CLUSTER_NAME>' \
  --set-string 'stackstate.cluster.authToken'='<CLUSTER_AUTH_TOKEN>' \
  --set-string 'stackstate.url'='<STACKSTATE_RECEIVER_API_ADDRESS>' \
  stackstate-cluster-agent stackstate/cluster-agent
```
{% endtab %}
{% tab title="OpenShift" %}
```bash
helm upgrade --install \ 
  --namespace stackstate \
  --create-namespace \
  --set-string 'stackstate.apiKey'='<STACKSTATE_RECEIVER_API_KEY>' \
  --set-string 'stackstate.cluster.name'='<OPENSHIFT_CLUSTER_NAME>' \
  --set-string 'stackstate.url'='<STACKSTATE_RECEIVER_API_ADDRESS>' \
  --set-string 'global.extraEnv.open.STS_LOG_PAYLOADS'='true' \
  --set 'agent.logLevel'='debug' \
  --set 'agent.scc.enabled'=true \
  --set 'kube-state-metrics.securityContext.enabled'=false \
  stackstate-cluster-agent stackstate/cluster-agent
```
{% endtab %}
{% endtabs %}

#### agent.containerRuntime.customSocketPath

It is not necessary to configure this property if your cluster uses one of the default socket paths (`/var/run/docker.sock`, `/var/run/containerd/containerd.sock` or `/var/run/crio/crio.sock`)

If your cluster uses a custom socket path, you can provide it using the key `agent.containerRuntime.customSocketPath`. For example:

```
helm upgrade --install \
--namespace stackstate \
--create-namespace \
--set-string 'stackstate.apiKey'='<STACKSTATE_RECEIVER_API_KEY>' \
--set-string 'stackstate.cluster.name'='<KUBERNETES_CLUSTER_NAME>' \
--set-string 'stackstate.url'='<STACKSTATE_RECEIVER_API_ADDRESS>' \
--set-string 'agent.containerRuntime.customSocketPath'='<CUSTOM_SOCKET_PATH>' \
stackstate-cluster-agent stackstate/cluster-agent
```

### Upgrade

To upgrade the Agents running in your Kubernetes or OpenShift cluster, run the helm upgrade command provided on the associated StackState UI integrations screen:
* **StackPacks** &gt; **Integrations** &gt; **Kubernetes**
* **StackPacks** &gt; **Integrations** &gt; **OpenShift**

{% hint style="info" %}
This is the same command used to deploy the StackState Agent and Cluster Agent. 
{% endhint %}

## Configure

### Advanced Agent configuration

StackState Agent V2 can be configured to reduce data production, tune the process blacklist, or turn off specific features when not needed. The required settings are described in detail on the page [advanced Agent configuration](advanced-agent-configuration.md).

### Enable cluster checks

Optionally, the chart can be configured to start an additional StackState Agent V2 pod as a [StackState ClusterCheck Agent](kubernetes.md#clustercheck-agent-optional) pod. Cluster checks that are configured on the [StackState Cluster Agent](kubernetes.md#cluster-agent) will then be run by the deployed StackState ClusterCheck Agent pod.

To enable cluster checks and deploy the ClusterCheck Agent pod, create a `values.yaml` file to deploy the `cluster-agent` Helm chart and add the following YAML segment:

```yaml
clusterChecks:
  enabled: true
```

The following integrations have checks that can be configured to run as cluster checks:

- **Kubernetes integration** - [Kubernetes_state check as a cluster check](/stackpacks/integrations/openshift.md#configure-cluster-check-kubernetes_state-check).
- **OpenShift integration** - [OpenShift Kubernetes_state check as a cluster check](/stackpacks/integrations/openshift.md#configure-cluster-check-kubernetes_state-check).
- **AWS integration** - [AWS check as a cluster check](/stackpacks/integrations/aws/aws.md#configure-the-aws-check).

### External integration configuration

To integrate with other external services, a separate instance of the [StackState Agent](about-stackstate-agent.md) should be deployed on a standalone VM. Other than [cluster checks](#enable-cluster-checks), it is not currently possible to configure a StackState Agent deployed on a Kubernetes or OpenShift cluster with checks that integrate with other services.

## Commands

### Agent and Cluster Agent pod status

To check the status of the Kubernetes or OpenShift integration, check that the StackState Cluster Agent \(`cluster-agent`\) pod and all of the StackState Agent \(`cluster-agent-agent`\) pods have status `READY`.

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

## Troubleshooting

### Log files

Logs for the Agent can be found in the `agent` pod, where the StackState Agent is running. 

### Debug mode

By default, the log level of the Agent is set to `INFO`. To assist in troubleshooting, the Agent log level can be set to `DEBUG`. This will enable verbose logging and all errors encountered will be reported in the Agent log files.

* To set the log level to `DEBUG` for an Agent running on Kubernetes or OpenShift, set `'agent.logLevel'='debug'` in the helm command when deploying the Agent. 
* To also include the topology/telemetry payloads sent to StackState in the Agent log, set `--set-string 'global.extraEnv.open.STS_LOG_PAYLOADS'='true'`.

For example:

```bash
helm upgrade --install \ 
   --namespace stackstate \
   --create-namespace \
   --set-string 'stackstate.apiKey'='<STACKSTATE_RECEIVER_API_KEY>' \
   --set-string 'stackstate.cluster.name'='<KUBERNETES_CLUSTER_NAME>' \
   --set-string 'stackstate.url'='<STACKSTATE_RECEIVER_API_ADDRESS>' \
   --set-string 'global.extraEnv.open.STS_LOG_PAYLOADS'='true' \
   --set 'agent.logLevel'='debug' \
   stackstate-cluster-agent stackstate/cluster-agent
```

### Support knowledge base

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

## Uninstall

To uninstall the StackState Cluster Agent and the StackState Agent from your Kubernetes or OpenShift cluster, run a Helm uninstall:

```text
helm uninstall <release_name> --namespace <namespace>

# If you used the standard install command provided when you installed the StackPack
helm uninstall stackstate-cluster-agent --namespace stackstate
```

## See also

* [Cluster Agent Helm Chart documentation \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/cluster-agent)
* [About the StackState Agent](about-stackstate-agent.md)
* [Advanced Agent configuration](advanced-agent-configuration.md)  
* [Kubernetes StackPack](../../stackpacks/integrations/kubernetes.md)
* [OpenShift StackPack](../../stackpacks/integrations/openshift.md)

