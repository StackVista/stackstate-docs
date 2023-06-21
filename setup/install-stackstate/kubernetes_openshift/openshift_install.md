---
description: StackState Self-hosted v5.1.x 
---

# OpenShift install

## Before you start

{% hint style="info" %}
Extra notes for installation:

* **OpenShift clusters with limited permissions**: Read the [required permissions](required_permissions.md).
* **Kubernetes**: Refer to the [Kubernetes installation instructions](kubernetes_install.md).
{% endhint %}

Before you start the installation of StackState:

* Check that your OpenShift environment meets the [requirements](../requirements.md)
* Request access credentials to pull the StackState Docker images from [StackState support](https://support.stackstate.com/).
* Ensure you have the OpenShift command line tools installed \(`oc`\)
* Add the StackState helm repository to the local helm client:

```text
helm repo add stackstate https://helm.stackstate.io
helm repo update
```

## Install StackState

1. [Create the project where StackState will be installed](openshift_install.md#create-project)
2. [Generate the `values.yaml` file](openshift_install.md#generate-values.yaml)
3. [Create the `openshift-values.yaml` file](openshift_install.md#create-openshift-values.yaml)
4. [Automatically install the Cluster Agent for OpenShift](openshift_install.md#automatically-install-the-cluster-agent-for-openshift)
5. [Deploy StackState with Helm](openshift_install.md#deploy-stackstate-with-helm)
6. [Access the StackState UI](openshift_install.md#access-the-stackstate-ui)
7. [Manually create `SecurityContextConfiguration` objects](openshift_install.md#manually-create-securitycontextconfiguration-objects)

### Create project

Start by creating the project where you want to install StackState. In our walkthrough we will use the namespace `stackstate`:

```text
oc new-project stackstate
```

{% hint style="info" %}
The project name is used in `helm` and `kubectl` commands as the namespace name in the `--namespace` flag
{% endhint %}

### Generate `values.yaml`

The `values.yaml` file is required to deploy StackState with Helm. It contains your StackState license key, StackState Receiver API key and other important information.

{% hint style="info" %}
**Before you continue:** Make sure you have the latest version of the Helm chart with `helm repo update`.
{% endhint %}

The `generate_values.sh` script in the [installation directory](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/installation) of the Helm chart will guide you through generating a `values.yaml` file that can be used to deploy StackState. You can run the `generate_values.sh` script in two ways:

* **Interactive mode:** When the script is run without any arguments, it will guide you through the required configuration items.

  ```text
  ./generate_values.sh
  ```

* **Non-interactive mode:** Run the script with the flag `-n` to pass configuration on the command line, this is useful for scripting.

  ```text
  ./generate_values.sh -n <configuration options>
  ```

The script requires the following configuration options:

| Configuration           | Flag | Description                                                                                                                                                                                                                                                                              |
|:------------------------| :--- |:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Base URL                | `-b` | The `<STACKSTATE_BASE_URL>`. The external URL for StackState that users and agents will use to connect. For example `https://stackstate.internal`. If you haven't decided on an Ingress configuration yet, use `http://localhost:8080`. This can be updated later in the generated file. |
| Username and password   | `-u` `-p` | The username and password used by StackState to pull images from quay.io/stackstate repositories.                                                                                                                                                                                        |
| License key             | `-l` | The StackState license key.                                                                                                                                                                                                                                                              |
| Admin API password      | `-a` | The password for the admin API. Note that this API contains system maintenance functionality and should only be accessible by the maintainers of the StackState installation. You can omit this from the command line, the script will prompt for it.                                    |
| Default password        | `-d` | The password for the default user \(`admin`\) to access StackState's UI. You can omit this from the command line, the script will prompt for it.                                                                                                                                         |
| Kubernetes cluster name | `-k` | Option only available for plain Kubernetes installation                                                                                                                                                                                                                                  |

{% hint style="info" %}
Store the `values.yaml` file somewhere safe. You can reuse this file for upgrades, which will save time and \(more importantly\) will ensure that StackState continues to use the same API key. This is desirable as it means agents and other data providers for StackState won't need to be updated.
{% endhint %}

### Create `openshift-values.yaml`

Because OpenShift has stricter security model than plain Kubernetes, all of the standard security contexts in the deployment need to be disabled. 

Create a Helm values file `openshift-values.yaml` with the following content and store it next to the generated `values.yaml` file. This contains the values that are needed for an OpenShift deployment.
```yaml
backup:
  stackGraph:
    securityContext:
      enabled: false
cluster-agent:
  agent:
    scc:
      enabled: true
  kube-state-metrics:
    podAnnotations:
      ad.stackstate.com/kube-state-metrics.check_names: '["kubernetes_state"]'
      ad.stackstate.com/kube-state-metrics.init_configs: '[{}]'
      ad.stackstate.com/kube-state-metrics.instances: '[{"kube_state_url":"http://%%host%%:%%port%%/metrics","labels_mapper":{"namespace":"kube_namespace" "label_deploymentconfig":"oshift_deployment_config","label_deployment":"oshift_deployment"},"label_joins":{"kube_pod_labels":{"label_to_match":"pod","labels_to_get":["label_deployment","label_deploymentconfig"]}}}]'
    securityContext:
      enabled: false
stackstate:
  components:
    all:
      securityContext:
        enabled: false
    kafkaTopicCreate:
      securityContext:
        enabled: false
    ui:
      securityContext:
        enabled: false
anomaly-detection:
  securityContext:
    enabled: false
elasticsearch:
  prometheus-elasticsearch-exporter:
    securityContext:
      enabled: false
  securityContext:
    enabled: false
  sysctlInitContainer:
    enabled: false
hbase:
  hdfs:
    securityContext:
      enabled: false
    volumePermissions:
      enabled: false
  hbase:
    securityContext:
      enabled: false
  console:
    securityContext:
      enabled: false
  tephra:
    securityContext:
      enabled: false
kafka:
  podSecurityContext:
    enabled: false
  volumePermissions:
    enabled: false
kafkaup-operator:
  securityContext:
    enabled: false
minio:
  securityContext:
    enabled: false
zookeeper:
  securityContext:
    enabled: false
```

### Automatically install the Cluster Agent for OpenShift

StackState has built-in support for OpenShift by means of the [OpenShift StackPack](../../../stackpacks/integrations/openshift.md). To get started quickly, the StackState installation can automate installation of this StackPack and the required Agent for the cluster that StackState itself will be installed on. This isn't required and can always be done later from the StackPacks page of the StackState UI for StackState's cluster or any other OpenShift cluster.

The only required information is a name for the OpenShift cluster that will distinguish it from the other OpenShift clusters monitored by StackState. A good choice usually is the same name that is used in the kube context configuration. This will then automatically install the StackPack and install a Daemonset for the Agent and a deployment for the so-called cluster Agent. For the full details, read the [OpenShift StackPack](../../../stackpacks/integrations/openshift.md) page.

To automate this installation, the below values file can be added to the `helm install` command. The Agent chart needs to add specific OpenShift `SecurityContextConfiguration` objects to the OpenShift installation.

If you're installing as an administrator on the OpenShift cluster, it's possible to automatically create this. You can configure this using the following configuration option in the values file:

| Pod\(s\) | Config key | Description |
| :--- | :--- | :--- |
| The Agent that runs the Kubernetes checks | `cluster-agent.agent.scc.enabled` | This process needs to run a privileged container with direct access to the host\(network\) and volumes. |

If you're not installing as an administrator, follow the instructions below to [first install the `SecurityContextConfiguration` objects in OpenShift](openshift_install.md#manually-create-securitycontextconfiguration-objects). Then ensure that you set the above configuration flag to `false`.

The values file that automates the installation of the OpenShift StackPack and monitoring Agent is:

```yaml
stacktate:
  stackpacks:
    installed:
      - name: openshift
        configuration:
          openshift_cluster_name: <CLUSTER_NAME>
cluster-agent:
  agent:
    scc:
      enabled: true
  enabled: true
  stackstate:
    cluster:
      name: <CLUSTER_NAME>
      authToken: <RANDOM_TOKEN>
  kube-state-metrics:
    securityContext:
      enabled: false
```

Two placeholders in this file need to be given a value before this can be applied to the Helm installation:

* `<CLUSTER_NAME>`: A name that StackState will use to identify the cluster
* `<RANDOM_TOKEN>`: A 32 character random token. This can be generated by executing `head -c32 < /dev/urandom | md5sum  | cut -c-32`

Save this as `agent-values.yaml` and add it to the `helm install` command to enable this feature.

### Deploy StackState with Helm

The recommended deployment of StackState is a production ready, high availability setup with many services running redundantly. If required, it's also possible to run StackState in a non-redundant setup, where each service has only a single replica.

{% hint style="info" %}
The non-high availability setup is only suitable for situations that don't require high availability.
{% endhint %}

{% tabs %}
{% tab title="High availability setup" %}

To deploy StackState in a high availability setup on OpenShift:

1. Before you deploy:
   * [Create the project where StackState will be installed](openshift_install.md#create-project)
   * [Generate `values.yaml`](#generate-values.yaml)
   * [Create `openshift-values.yaml`](#create-openshift-values.yaml)
   * If you want to automatically install the Cluster Agent for OpenShift, [create `agent-values.yaml`](#automatically-install-the-cluster-agent-for-openshift)
4. Deploy the latest StackState version to the `stackstate` namespace with the following command:

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values openshift-values.yaml \
stackstate \
stackstate/stackstate
```
{% endtab %}
{% tab title="Non-high availability setup" %}

To deploy StackState in a non-high availability setup on OpenShift:

1. Before you deploy:
   * [Create the project where StackState will be installed](openshift_install.md#create-project)
   * [Generate `values.yaml`](#generate-values.yaml)
   * [Create `openshift-values.yaml`](#create-openshift-values.yaml)
   * [Create `nonha_values.yaml`](/setup/install-stackstate/kubernetes_openshift/non_high_availability_setup.md)
   * If you want to automatically install the Cluster Agent for OpenShift, [create `agent-values.yaml`](#automatically-install-the-cluster-agent-for-openshift)
5. Deploy the latest StackState version to the `stackstate` namespace with the following command:

```bash
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values nonha_values.yaml \
  --values openshift-values.yaml \
stackstate \
stackstate/stackstate
```
{% endtab %}
{% endtabs %}

After the install, the StackState release should be listed in the StackState namespace and all pods should be running:

```text
# Check the release is listed
helm list --namespace stackstate

# Check pods are running
# It may take some time for all pods to be installed or available
kubectl get pods --namespace stackstate
```

### Access the StackState UI

After StackState has been deployed, you can check if all pods are up and running:

```text
kubectl get pods --namespace stackstate
```

When all pods are up, you can enable a port-forward:

```text
kubectl port-forward service/stackstate-router 8080:8080 --namespace stackstate
```

StackState will now be available in your browser at `https://localhost:8080`. Log in with the username `admin` and the default password provided in the `values.yaml` file.

Next steps are

* Configure [ingress](ingress.md)
* Install a [StackPack](../../../stackpacks/about-stackpacks.md) or two
* Give your [co-workers access](../../configure/security/authentication/).

## Manually create `SecurityContextConfiguration` objects

If you can't use an administrator account to install StackState on OpenShift, ask your administrator to apply the below `SecurityContextConfiguration` objects.

### Cluster Agent

If you want to monitor the OpenShift cluster using the [OpenShift StackPack](../../../stackpacks/integrations/openshift.md) and Cluster Agent, the below `SecurityContextConfiguration` needs to be applied:

```yaml
apiVersion: security.openshift.io/v1
kind: SecurityContextConstraints
metadata:
  name: stackstate-agent-scc
allowHostDirVolumePlugin: true
allowHostIPC: true
allowHostNetwork: true
allowHostPID: true
allowHostPorts: true
allowPrivilegeEscalation: true
allowPrivilegedContainer: true
allowedCapabilities: []
allowedUnsafeSysctls:
- '*'
defaultAddCapabilities: null
fsGroup:
  type: MustRunAs
groups: []
priority: null
readOnlyRootFilesystem: false
requiredDropCapabilities: null
runAsUser:
  type: MustRunAsRange
seLinuxContext:
  type: RunAsAny
  seLinuxOptions:
    user: "system_u"
    role: "system_r"
    type: "spc_t"
    level: "s0"
seccompProfiles: []
supplementalGroups:
  type: RunAsAny
users:
volumes:
  - configMap
  - downwardAPI
  - emptyDir
  - hostPath
  - secret
```

Save this file as `agent-scc.yaml` and apply it as an administrator of the OpenShift cluster using the following command:

```text
oc apply -f agent-scc.yaml
```

After this file is applied, execute the following command as administrator to grant the service account access to this `SecurityContextConfiguration` object:

```text
> oc adm policy add-scc-to-user stackstate-agent-scc system:serviceaccount:stackstate:stackstate-agent-node-agent
```

## See also

* [Create a `nonha_values.yaml` file](/setup/install-stackstate/kubernetes_openshift/non_high_availability_setup.md)
* For other configuration and management options, refer to the Kubernetes documentation - [manage a StackState Kubernetes installation](kubernetes_install/)

