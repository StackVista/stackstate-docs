---
description: Install StackState on OpenShift
---

# OpenShift install

{% hint style="warning" %}
**This page describes StackState version 4.4.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Before you start

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
2. [Generate the `values.yaml` file](openshift_install.md#generate-values-yaml)
3. [Additional OpenShift values file](openshift_install.md#additional-openshift-values-file)
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

The `values.yaml` is required to deploy StackState with Helm. It contains your StackState license key, API key and other important information. The `generate_values.sh` script in the [installation directory](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/installation) of the Helm chart will guide you through generating the file.

{% hint style="info" %}
**Before you continue:** If you didn't already, make sure you have the latest version of the Helm chart with `helm repo update`.
{% endhint %}

You can run the `generate_values.sh` script in two ways:

* **Interactive mode:** When the script is run without any arguments, it will guide you through the required configuration items.

  ```text
  ./generate_values.sh
  ```

* **Non-interactive mode:** Run the script with the flag `-n` to pass configuration on the command line, this is useful for scripting.

  ```text
  ./generate_values.sh -n <configuration options>
  ```

The script requires the following configuration options:

| Configuration | Flag | Description |
| :--- | :--- | :--- |
| Base URL | `-b` | The external URL for StackState that users and agents will use to connect. For example `https://stackstate.internal`.  If you haven't decided on an Ingress configuration yet, use `http://localhost:8080`. This can be updated later in the generated file. |
| Username and password\*\* | `-u` `-p` | The username and password used by StackState to pull images from quay.io/stackstate repositories. |
| License key | `-l` | The StackState license key. |
| Admin API password | `-a` | The password for the admin API. Note that this API contains system maintenance functionality and should only be accessible by the maintainers of the StackState installation. This can be omitted from the command line, the script will prompt for it. |
| Default password | `-d` | The password for the default user \(`admin`\) to access StackState's UI. This can be omitted from the command line, the script will prompt for it. |
| Kubernetes cluster name | `-k` | Option only available for plain Kubernetes installation |

For OpenShift install, follow the instructions to [Automatically install the Cluster Agent](openshift_install.md#automatically-install-the-cluster-agent-for-openshift).

The generated file is suitable for a production setup with redundant storage services. It is also possible to [create a smaller setup without high availability](kubernetes_install/non_high_availability_setup.md).

{% hint style="info" %}
Store the `values.yaml` file somewhere safe. You can reuse this file for upgrades, which will save time and \(more importantly\) will ensure that StackState continues to use the same API key. This is desirable as it means agents and other data providers for StackState will not need to be updated.
{% endhint %}

### Additional OpenShift values file

Because OpenShift has stricter security model than plain Kubernetes, all of the standard security contexts in the deployment need to be disabled.

The values that are needed for an OpenShift deployment are:

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
minio:
  securityContext:
    enabled: false
zookeeper:
  securityContext:
    enabled: false
```

Store this file next to the generated `values.yaml` file and name it `openshift-values.yaml`.

### Automatically install the Cluster Agent for OpenShift

StackState has built-in support for OpenShift by means of the [OpenShift StackPack](../../stackpacks/integrations/openshift.md). To get started quickly, the StackState installation can automate installation of this StackPack and the required Agent for the cluster that StackState itself will be installed on. This is not required and can always be done later from the StackPacks page of the StackState UI for StackState's cluster or any other OpenShift cluster.

The only required information is a name for the OpenShift cluster that will distinguish it from the other OpenShift clusters monitored by StackState. A good choice usually is the same name that is used in the kube context configuration. This will then automatically install the StackPack and install a Daemonset for the agent and a deployment for the so called cluster agent. For the full details, please read the [OpenShift StackPack](../../stackpacks/integrations/openshift.md) page.

To automate this installation, the below values file can be added to the `helm install` command. The agent chart needs to add specific OpenShift `SecurityContextConfiguration` objects to the OpenShift installation.

If you're installing as an administrator on the OpenShift cluster, it is possible to automatically create this. You can configure this using the following configuration option in the values file:

| Pod\(s\) | Config key | Description |
| :--- | :--- | :--- |
| The Agent that runs the Kubernetes checks | `cluster-agent.agent.scc.enabled` | This process needs to run a privileged container with direct access to the host\(network\) and volumes. |

If you're not installing as an administrator, please follow the instructions below to [first install the `SecurityContextConfiguration` objects in OpenShift](openshift_install.md#manually-create-securitycontextconfiguration-objects). Then ensure that you set the above configuration flag to `false`.

The values file that automates the installation of the OpenShift StackPack and monitoring agent is:

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

Use the generated `values.yaml` and copied `openshift-values.yaml` file to deploy the latest StackState version to the `stackstate` namespace with the command below. If you want to automatically install the Cluster Agent for OpenShift, you will also require the `agent-values.yaml` created in the previous step:

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values openshift-values.yaml \
stackstate \
stackstate/stackstate
```

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

* Configure [ingress](kubernetes_install/ingress.md)
* Install a [StackPack](../../stackpacks/about-stackpacks.md) or two
* Give your [co-workers access](../../configure/security/authentication/).

## Manually create `SecurityContextConfiguration` objects

If you cannot use an administrator account to install StackState on OpenShift, ask your administrator to apply the below `SecurityContextConfiguration` objects.

### Cluster Agent

If you want to monitor the OpenShift cluster using the [OpenShift StackPack](../../stackpacks/integrations/openshift.md) and Cluster Agent, the below `SecurityContextConfiguration` needs to be applied:

```yaml
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
apiVersion: security.openshift.io/v1
defaultAddCapabilities: null
fsGroup:
  type: MustRunAs
groups: []
kind: SecurityContextConstraints
metadata:
  name: stackstate-agent-scc
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
> oc adm policy add-scc-to-user stackstate-agent-scc system:serviceaccount:stackstate:stackstate-cluster-agent-agent
```

## See also

For other configuration and management options, please refer to the Kubernetes documentation:

* [Manage a StackState Kubernetes installation](kubernetes_install/)

