---
description: StackState SaaS
---

# Overview

{% hint style="info" %}
**StackState Agent V2**
{% endhint %}

To retrieve topology, events and metrics data from a Kubernetes or OpenShift cluster, you will need to have the following installed in the cluster:

* StackState Agent V2 on each node in the cluster
* StackState Cluster Agent on one node
* StackState Checks Agent on one node
* kube-state-metrics

To integrate with other services, a separate instance of StackState Agent V2 should be deployed on a standalone VM.

# StackState Agent types

The Kubernetes and OpenShift integrations collect topology data from Kubernetes and OpenShift clusters respectively, as well as metrics and events. To achieve this, different types of StackState Agent are used:

| Component | Pod name |
| :--- | :--- |
| [Node Agent](#agent) | `stackstate-agent-node-agent` |
| [Checks Agent](#checks-agent)| `stackstate-agent-checks-agent` |
| [Cluster Agent](#cluster-agent) | `stackstate-agent-cluster-agent` |

{% hint style="info" %}
To integrate with other services, a separate instance of the StackState Agent should be deployed on a standalone VM. It isn't currently possible to configure a StackState Agent deployed on a Kubernetes or OpenShift cluster with checks that integrate with other services.
{% endhint %}

![StackState Agents on Kubernetes](/.gitbook/assets/agent-kubernetes-openshift.svg)

## Agent

StackState Agent V2 is deployed as a DaemonSet with one instance **on each node** in the cluster:

* Host information is retrieved from the Kubernetes or OpenShift API.
* Container information is collected from the Docker daemon.
* Metrics are retrieved from kubelet running on the node and also from kube-state-metrics if this is deployed on the same node.

## Checks Agent

The StackState Checks Agent is an additional StackState Agent V2 pod that will run the cluster checks that are configured on the [StackState Cluster Agent](#cluster-agent).

The following checks can be configured to run as a cluster check:

* The `kubernetes_state` check - this check gathers metrics from kube-state-metrics and sends them to StackState.
  * [Kubernetes integration `kubernetes_state` check](/stackpacks/integrations/kubernetes.md)
  * [OpenShift integration `kubernetes_state` check](/stackpacks/integrations/openshift.md)
* The [AWS check](/stackpacks/integrations/aws/aws.md#configure-the-aws-check)
* The Checks Agent is also useful to run checks that don't need to run on a specific node and monitor non-containerized workloads such as:
  * Out-of-cluster datastores and endpoints \(for example, RDS or CloudSQL\).
  * Load-balanced cluster services \(for example, Kubernetes services\).

## Cluster Agent

StackState Cluster Agent is deployed as a Deployment. There is one instance for the entire cluster:

* Topology and events data for all resources in the cluster are retrieved from the Kubernetes API
* Control plane metrics are retrieved from the Kubernetes or OpenShift API

Cluster checks configured here are run by the deployed [StackState Checks Agent](kubernetes-openshift.md#checks-agent) pod.

# Setup

## Supported Kubernetes versions

StackState Agent v2.19.x is supported to monitor the following versions of Kubernetes or OpenShift:

* Kubernetes:
  * Kubernetes 1.16 - 1.24
  * EKS (with Kubernetes 1.16 - 1.24)
* OpenShift:
  * OpenShift 4.3 - 4.11
* Default networking
* Container runtime:
  * Docker
  * containerd
  * CRI-O

## Install

The StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics can be installed together using the StackState Agent Helm Chart:

* [Online install](#online-install) - charts are retrieved from the default StackState chart repository (https://helm.stackstate.io), images are retrieved from the default StackState image registry (quay.io).
* [Air gapped install](#air-gapped-install) - images are retrieved from a local system or registry.
* [Install from a custom image registry](#install-from-a-custom-image-registry) - images are retrieved from a configured image registry.

### Online install

The StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics can be installed together using the StackState Agent Helm Chart:

1. If you don't already have it, you will need to add the StackState helm repository to the local helm client:

   ```sh
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
   ```

2. Deploy the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics to namespace `stackstate` using the helm command below.
   * `<STACKSTATE_RECEIVER_API_KEY>` is set during StackState installation.
   * `<STACKSTATE_RECEIVER_API_ADDRESS>` is specific to your installation of StackState.

   * For details see [StackState Receiver API](/setup/agent/about-stackstate-agent.md#connect-to-stackstate).

   - Note that [additional optional configuration](#helm-chart-values) can be added to the standard helm command.

{% tabs %}
{% tab title="Kubernetes" %}
```sh
helm upgrade --install \
   --namespace stackstate \
   --create-namespace \
   --set-string 'stackstate.apiKey'='<STACKSTATE_RECEIVER_API_KEY>' \
   --set-string 'stackstate.cluster.name'='<KUBERNETES_CLUSTER_NAME>' \
   --set-string 'stackstate.url'='<STACKSTATE_RECEIVER_API_ADDRESS>' \
   stackstate-agent stackstate/stackstate-agent
```
{% endtab %}
{% tab title="OpenShift" %}
```sh
helm upgrade --install \
  --namespace stackstate \
  --create-namespace \
  --set-string 'stackstate.apiKey'='<STACKSTATE_RECEIVER_API_KEY>' \
  --set-string 'stackstate.cluster.name'='<OPENSHIFT_CLUSTER_NAME>' \
  --set-string 'stackstate.url'='<STACKSTATE_RECEIVER_API_ADDRESS>' \
  --set 'agent.scc.enabled'=true \
  --set 'kube-state-metrics.podSecurityContext.enabled'=false \
  --set 'kube-state-metrics.containerSecurityContext.enabled'=false \
  stackstate-agent stackstate/stackstate-agent
```
{% endtab %}
{% endtabs %}

### Air gapped install

If StackState Agent will run in an environment that doesn't have a direct connection to the Internet, the images required to install the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics can be downloaded and stored in a local system or image registry.

1. Internet connection required:
   1. Download or clone the StackState Helm charts repo from GitHub: [https://github.com/StackVista/helm-charts](https://github.com/StackVista/helm-charts)
   2. In the Helm charts repo, go to the directory `stable/stackstate-agent/installation` and use the script `backup.sh` to back up the required images from StackState. The script will pull all images required for the `stackstate-agent` Helm chart to run, back them up to individual tar archives and add all tars to a single `tar.gz` archive. The images will be in a `tar.gz` archive in the same folder as the working directory from where the script was executed. It's advised to run the script from the `stable/stackstate-agent/installation` directory as this will simplify the process of importing images on the destination system.
      * By default, the backup script will retrieve charts from the StackState chart repository (https://helm.stackstate.io), images are retrieved from the default StackState image registry (quay.io). The script can be executed from the `installation` directory as simply `./backup.sh`.
        ```text
          Back up helm chart images to a tar.gz archive for easy transport via an external storage device.

          Arguments:
              -c : Helm chart (default: stackstate/stackstate-agent)
              -h : Show this help text
              -r : Helm repository (default: https://helm.stackstate.io)
              -t : Dry-run
          ```
      * Add the `-t` (dry-run) parameter to the script to give a predictive output of what work will be performed, for example:
         ```text
         ./backup.sh -t
         Backing up quay.io/stackstate/stackstate-agent-2:2.19.1 to stackstate/stackstate-agent-2__2.19.1.tar (dry-run)
         Backing up quay.io/stackstate/stackstate-process-agent:4.0.10 to stackstate/stackstate-process-agent__4.0.7.tar (dry-run)
         Backing up quay.io/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032 to stackstate/kube-state-metrics__2.3.0-focal-20220316-r61.20220418.2032.tar (dry-run)
         Backing up quay.io/stackstate/stackstate-agent-cluster-agent:2.19.1 to stackstate/stackstate-agent-cluster-agent__2.19.1.tar (dry-run)
         Backing up quay.io/stackstate/stackstate-agent-2:2.19.1 to stackstate/stackstate-agent-2__2.19.1.tar (dry-run)
         Images have been backed up to stackstate.tar.gz
         ```

2. No internet connection required:
   1. Transport images to the destination system.
      * Copy the StackState Helm charts repo, including the `tar.gz` generated by the backup script, to a storage device for transportation. If the backup script was run from the `stable/stackstate-agent/installation` directory as advised, the `tar.gz` will be located at `stable/stackstate-agent/installation/stackstate.tar.gz`.
      * Copy the Helm charts repo and `tar.gz` from the storage device to a working folder of choice on the destination system.

   2. Import images to the system, and optionally push to a registry.
      * On the destination system, go to the directory in the StackState Helm charts repo that contains both the scripts and the generated `tar.gz` archive. By default, this will be `stable/stackstate-agent/installation`.
      * Execute the `import.sh` script. Note that the import script must be located in the same directory as the `tar.gz` archive to be imported, the following must be specified:
        * `-b` - path to the `tar.gz` to be imported
        * `-d` - the destination Docker image registry
      * Additional options when running the script:
        * `-p` - push images to the destination registry. When not specified, images will be imported and tagged, but remain on the local machine.
        * `-t` - Dry-run. Use to show the work that will be performed without any action being taken.

**Example script usage**

In the example below, the StackState Agent images will be extracted from the archive `stackstate.tar.gz`, imported by Docker, and re-tagged to the registry given by the `-d` flag, in this example, `localhost`. The `-t` argument (dry-run) is provided to show the work that will be performed:

```text
./import.sh -b stackstate.tar.gz -d localhost -t

Unzipping archive stackstate.tar.gz
x stackstate/
x stackstate/stackstate-process-agent__4.0.7.tar
x stackstate/stackstate-agent-2__2.19.1.tar
x stackstate/kube-state-metrics__2.3.0-focal-20220316-r61.20220418.2032.tar
x stackstate/stackstate-agent-cluster-agent__2.19.1.tar
Restoring stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032 from kube-state-metrics__2.3.0-focal-20220316-r61.20220418.2032.tar (dry-run)
Imported quay.io/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032
Tagged quay.io/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032 as localhost/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032
Untagged: quay.io/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032
Restoring stackstate/stackstate-agent-2:2.19.1 from stackstate-agent-2__2.19.1.tar (dry-run)
Imported quay.io/stackstate/stackstate-agent-2:2.19.1
Tagged quay.io/stackstate/stackstate-agent-2:2.19.1 as localhost/stackstate/stackstate-agent-2:2.19.1
Untagged: quay.io/stackstate/stackstate-agent-2:2.19.1
Restoring stackstate/stackstate-agent-cluster-agent:2.19.1 from stackstate-cluster-agent__2.19.1.tar (dry-run)
Imported quay.io/stackstate/stackstate-agent-cluster-agent:2.19.1
Tagged quay.io/stackstate/stackstate-agent-cluster-agent:2.19.1 as localhost/stackstate/stackstate-cluster-agent:2.19.1
Untagged: quay.io/stackstate/stackstate-agent-cluster-agent:2.19.1
Restoring stackstate/stackstate-process-agent:4.0.10 from stackstate-process-agent__4.0.7.tar (dry-run)
Imported quay.io/stackstate/stackstate-process-agent:4.0.10
Tagged quay.io/stackstate/stackstate-process-agent:4.0.10 as localhost/stackstate/stackstate-process-agent:4.0.10
Untagged: quay.io/stackstate/stackstate-process-agent:4.0.10
Images have been imported up to localhost
```

### Install from a custom image registry

If required, the images required to install the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics can be served from a custom image registry. To do this, follow the instructions to [install from a custom image registry](/setup/install-stackstate/kubernetes_openshift/install-from-custom-image-registry.md).

## Helm chart values

Additional variables can be added to the standard helm command used to deploy the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics. For example:
* It's recommended to [use a `stackstate.cluster.authToken`](#stackstateclusterauthtoken).
* If you use a custom socket path, [set the `agent.containerRuntime.customSocketPath`](#agentcontainerruntimecustomsocketpath).

{% hint style="info" %}
Details of all available helm chart values can be found in the [Agent Helm Chart documentation \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate-agent).
{% endhint %}

### stackstate.cluster.authToken

It's recommended to use a `stackstate.cluster.authToken` in addition to the standard helm chart variables when the StackState Agent is deployed. This is an optional variable, however, if not provided a new, random value will be generated each time a helm upgrade is performed. This could leave some pods in the cluster with an incorrect configuration.

For example:

{% tabs %}
{% tab title="Kubernetes" %}
```bash
helm upgrade --install \
  --namespace stackstate \
  --create-namespace \
  --set-string 'stackstate.apiKey'='<STACKSTATE_RECEIVER_API_KEY>' \
  --set-string 'stackstate.cluster.name'='<KUBERNETES_CLUSTER_NAME>' \
  --set-string 'stackstate.cluster.authToken'='<CLUSTER_AUTH_TOKEN>' \
  --set-string 'stackstate.url'='<STACKSTATE_RECEIVER_API_ADDRESS>' \
  stackstate-agent stackstate/stackstate-agent
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
  --set 'kube-state-metrics.podSecurityContext.enabled'=false \
  --set 'kube-state-metrics.containerSecurityContext.enabled'=false \\
  stackstate-agent stackstate/stackstate-agent
```
{% endtab %}
{% endtabs %}

### agent.containerRuntime.customSocketPath

It isn't necessary to configure this property if your cluster uses one of the default socket paths (`/var/run/docker.sock`, `/var/run/containerd/containerd.sock` or `/var/run/crio/crio.sock`)

If your cluster uses a custom socket path, you can specify it using the key `agent.containerRuntime.customSocketPath`. For example:

```bash
helm upgrade --install \
--namespace stackstate \
--create-namespace \
--set-string 'stackstate.apiKey'='<STACKSTATE_RECEIVER_API_KEY>' \
--set-string 'stackstate.cluster.name'='<KUBERNETES_CLUSTER_NAME>' \
--set-string 'stackstate.url'='<STACKSTATE_RECEIVER_API_ADDRESS>' \
--set-string 'agent.containerRuntime.customSocketPath'='<CUSTOM_SOCKET_PATH>' \
stackstate-agent stackstate/stackstate-agent
```

## Upgrade

### Upgrade Agents

To upgrade the Agents running in your Kubernetes or OpenShift cluster, follow the steps described below.

{% tabs %}
{% tab title="stackstate/stackstate-agent chart" %}
**Redeploy/upgrade Agents with the new stackstate/stackstate-agent chart**

The new `stackstate/stackstate-agent` chart can be used to deploy any version of the Agent. Note that the naming of some values has changed compared to the old `stackstate/cluster-agent` chart.

* If this is the first time you will use the new `stackstate/stackstate-agent` chart to deploy the Agent, follow the instructions to [upgrade the Helm chart](#upgrade-helm-chart).
* If you previously deployed the Agent using the new `stackstate/stackstate-agent`, you can upgrade/redeploy the Agent using the same command used to initially deploy the Agent.
{% tabs %}
{% tab title="Kubernetes" %}
```bash
helm upgrade --install \
  --namespace stackstate \
  --create-namespace \
  --set-string 'stackstate.apiKey'='<STACKSTATE_RECEIVER_API_KEY>' \
  --set-string 'stackstate.cluster.name'='<KUBERNETES_CLUSTER_NAME>' \
  --set-string 'stackstate.cluster.authToken'='<CLUSTER_AUTH_TOKEN>' \
  --set-string 'stackstate.url'='<STACKSTATE_RECEIVER_API_ADDRESS>' \
  --values values.yaml \
  stackstate-agent stackstate/stackstate-agent
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
  --set 'kube-state-metrics.podSecurityContext.enabled'=false \
  --set 'kube-state-metrics.containerSecurityContext.enabled'=false \
  --values values.yaml \
  stackstate-agent stackstate/stackstate-agent
```
{% endtab %}
{% endtabs %}
{% endtab %}
{% tab title="stackstate/cluster-agent chart (deprecated)" %}

**Redeploy/upgrade Agents with the old stackstate/cluster-agent chart**

{% hint style="warning" %}
The `stackstate/cluster-agent` chart is being deprecated and will no longer be supported.

It's recommended that you [upgrade to the new `stackstate/stackstate-agent` chart](#upgrade-helm-chart).
{% endhint %}

If you need to redeploy the Agent using the old `stackstate/cluster-agent` chart, refer to the [StackState v5.0 documentation \(docs.stackstate.com/v/5.0/\)](https://docs.stackstate.com/v/5.0/setup/agent/kubernetes#install).

{% endtab %}
{% endtabs %}


### Upgrade Helm chart

The `stackstate/cluster-agent` chart is being deprecated and will no longer be supported. It has been replaced by the new `stackstate/stackstate-agent` chart.

The naming of some values has changed in the new chart. If you previously deployed the Agent using the `stackstate/cluster-agent`, follow the steps below to update the values.yaml file and redeploy the Agent with the new `stackstate/stackstate-agent` chart:

2. Backup the values.yaml file that was used to deploy with the old `stackstate/cluster-agent` chart.
3. Copy of the values.yaml file and update the following values in the new file. This will allow you to re-use the previous values while ensuring compatibility with the new chart:
    * `clusterChecks` has been renamed to `checksAgent` - the `checksAgent` now runs by default. The `checksAgent` section is now only required if you want to disable the Checks Agent.
    * `agent` has been renamed to `nodeAgent`.
    * The kubernetes\_state check now runs in the Checks Agent by default, this no longer needs to be configured on default installations.
    * For an example of the changes required to the values.yaml file, see the [comparison - OLD values.yaml and NEW values.yaml](#comparison-old-values.yaml-and-new-values.yaml)

4. Uninstall the StackState Cluster Agent and the StackState Agent from your Kubernetes or OpenShift cluster, using a Helm uninstall:
    ```bash
    helm uninstall <release_name> --namespace <namespace>

    # If you used the standard install command provided when you installed the StackPack
    helm uninstall stackstate-agent --namespace stackstate
    ```
5. Redeploy the `cluster_agent` using the updated values.yaml file created in step 2 and the new `stackstate/stackstate-agent` chart:

{% tabs %}
{% tab title="Kubernetes" %}
```bash
helm upgrade --install \
  --namespace stackstate \
  --create-namespace \
  --set-string 'stackstate.apiKey'='<STACKSTATE_RECEIVER_API_KEY>' \
  --set-string 'stackstate.cluster.name'='<KUBERNETES_CLUSTER_NAME>' \
  --set-string 'stackstate.cluster.authToken'='<CLUSTER_AUTH_TOKEN>' \
  --set-string 'stackstate.url'='<STACKSTATE_RECEIVER_API_ADDRESS>' \
  --values values.yaml \
  stackstate-agent stackstate/stackstate-agent
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
  --set 'kube-state-metrics.podSecurityContext.enabled'=false \
  --set 'kube-state-metrics.containerSecurityContext.enabled'=false \
  --values values.yaml \
  stackstate-agent stackstate/stackstate-agent
```
{% endtab %}
{% endtabs %}

### Comparison - OLD values.yaml and NEW values.yaml

The old `stackstate/cluster-agent` chart used to be the Agent has been replaced by the new `stackstate/stackstate-agent` chart. The naming of some values has changed in the new chart. If you were previously deploying the Agent with the old `stackstate/cluster-agent` and a values.yaml file, you should update your values.yaml to match the new naming.

| stackstate/cluster-agent | stackstate/stackstate-agent | Changes in NEW chart                                                                   |
| :--- | :--- |:---------------------------------------------------------------------------------------|
| OLD chart (being deprecated) | NEW chart | It's advised to use the NEW `stackstate/stackstate-agent` chart.                     |
| `clusterChecks` | `checksAgent` | Section renamed and enabled by default. |
| `agent` | `nodeAgent` | Section renamed.                           |

In addition to these changes, the kubernetes_state check runs by default in the Checks Agent when using the new chart (`stackstate/stackstate-agent`). This no longer needs to be configured on default installations.

Below is an example comparing the values.yaml required by the new chart (`stackstate/stackstate-agent`) and the old chart (`stackstate/cluster-agent`) to deploy the Agent with the following configuration:

* Checks Agent enabled
* kubernetes\_state check running in the Checks Agent
* AWS check running in the Checks Agent

{% tabs %}
{% tab title="Example: values.yaml file for NEW stackstate/stackstate-agent chart" %}
```yaml
# checksAgent enabled by default
# (Called clusterChecks in the old stackstate/cluster-agent chart)
# kubernetes_state check disabled by default on regular Agent pods.
clusterAgent:
 config:
   override:
   # kubernetes_state check enabled by default for the Checks Agent.
   # Define the AWS check for the Checks Agent.
   - name: conf.yaml
     path: /etc/stackstate-agent/conf.d/aws_topology.d
     data: |
       cluster_check: true
       init_config:
         aws_access_key_id: ''
         aws_secret_access_key: ''
         external_id: uniquesecret!1
         # full_run_interval: 3600
       instances:
       - role_arn: arn:aws:iam::123456789012:role/StackStateAwsIntegrationRole
           regions:
           - global
           - eu-west-1
           collection_interval: 60
```
{% endtab %}
{% tab title="Example: values.yaml file for OLD stackstate/cluster-agent chart" %}
```yaml
# Enable clusterChecks functionality and the clustercheck pods.
# (Called checksAgent in the new stackstate/stackstate-agent chart)
clusterChecks:
 enabled: true
# Disable the kubernetes_state check on regular Agent pods.
agent:
 config:
   override:
   - name: auto_conf.yaml
     path: /etc/stackstate-agent/conf.d/kubernetes_state.d
     data: |
clusterAgent:
 config:
   override:
   # Define the kubernetes_state check for clusterChecks Agents.
   - name: conf.yaml
     path: /etc/stackstate-agent/conf.d/kubernetes_state.d
     data: |
       cluster_check: true
       init_config:
       instances:
         - kube_state_url: http://YOUR_KUBE_STATE_METRICS_SERVICE_NAME:8080/metrics
   # Define the AWS check for clusterChecks Agents.
   - name: conf.yaml
     path: /etc/stackstate-agent/conf.d/aws_topology.d
     data: |
       cluster_check: true
       init_config:
         aws_access_key_id: ''
         aws_secret_access_key: ''
         external_id: uniquesecret!1
         # full_run_interval: 3600
       instances:
       - role_arn: arn:aws:iam::123456789012:role/StackStateAwsIntegrationRole
           regions:
           - global
           - eu-west-1
           collection_interval: 60
```
{% endtab %}
{% endtabs %}

# Configure

## Advanced Agent configuration

StackState Agent V2 can be configured to reduce data production, tune the process blacklist, or turn off specific features when not needed. The required settings are described in detail on the page [advanced Agent configuration](advanced-agent-configuration.md).

## External integration configuration

To integrate with other external services, a separate instance of the [StackState Agent](about-stackstate-agent.md) should be deployed on a standalone VM. Other than [kubernetes_state check](/stackpacks/integrations/kubernetes.md) and [AWS check](/stackpacks/integrations/aws/aws.md#configure-the-aws-check), it isn't currently possible to configure a StackState Agent deployed on a Kubernetes or OpenShift cluster with checks that integrate with other services.

# Commands

## Agent and Cluster Agent pod status

To check the status of the Kubernetes or OpenShift integration, check that the StackState Cluster Agent \(`cluster-agent`\) pod, StackState Checks Agent pod \(`checks-agent`\) and all of the StackState Agent \(`node-agent`\) pods have status `READY`.

```text
❯ kubectl get deployment,daemonset --namespace stackstate

NAME                                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/stackstate-agent-cluster-agent       1/1     1            1           5h14m
deployment.apps/stackstate-agent-checks-agent        1/1     1            1           5h14m
NAME                                                 DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/stackstate-agent-node-agent           10        10        10      10           10          <none>          5h14m
```

## Agent check status

To find the status of an Agent check:

1. Find the Agent pod that is running on the node where you would like to find a check status:
   ```yaml
   kubectl get pod --output wide
   ```

2. Run the command:
   ```yaml
   kubectl exec <agent-pod-name> -n <agent-namespace> -- Agent status
   ```

3. Look for the check name under the `Checks` section.

# Troubleshooting

## Log files

Logs for the Agent can be found in the `agent` pod, where the StackState Agent is running.

## Debug mode

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
   stackstate-agent stackstate/stackstate-agent
```

## Support knowledge base

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

# Uninstall

To uninstall the StackState Cluster Agent and the StackState Agent from your Kubernetes or OpenShift cluster, run a Helm uninstall:

```text
helm uninstall <release_name> --namespace <namespace>

# If you used the standard install command provided when you installed the StackPack
helm uninstall stackstate-agent --namespace stackstate
```

# See also

* [StackState Agent Helm Chart documentation \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate-agent)
* [About the StackState Agent](about-stackstate-agent.md)
* [Advanced Agent configuration](advanced-agent-configuration.md)
* [Kubernetes StackPack](../../stackpacks/integrations/kubernetes.md)
* [OpenShift StackPack](../../stackpacks/integrations/openshift.md)

