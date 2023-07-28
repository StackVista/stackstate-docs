---
description: StackState for Kubernetes troubleshooting Self-hosted
---

# OpenShift install

## Before you start

{% hint style="info" %}
Extra notes for installing on:

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

{% hint style="info" %}
For environments without internet access, also known as air-gapped environments, first follow [these extra instructions](./no_internet/stackstate_installation.md).

Also make sure to follow the air-gapped instalaltion instructions whenever those are present for a step.
{% endhint %}

1. [Create the project where StackState will be installed](openshift_install.md#create-project)
1. [Generate the `values.yaml` file](openshift_install.md#generate-values.yaml)
1. [Create the `openshift-values.yaml` file](openshift_install.md#create-openshift-values.yaml)
1. [Deploy StackState with Helm](openshift_install.md#deploy-stackstate-with-helm)
1. [Access the StackState UI](openshift_install.md#access-the-stackstate-ui)
1. [Manually create `SecurityContextConfiguration` objects](openshift_install.md#manually-create-securitycontextconfiguration-objects)

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

| Configuration | Flag | Description                                                                                                                                                                                                                                                                              |
| :--- | :--- |:------|
| Base URL | `-b` | The `<STACKSTATE_BASE_URL>`. The external URL for StackState that users and agents will use to connect. For example `https://stackstate.internal`. If you haven't decided on an Ingress configuration yet, use `http://localhost:8080`. This can be updated later in the generated file. |
| Username and password\*\* | `-u` `-p` | The username and password used by StackState to pull images from quay.io/stackstate repositories. For air-gapped environments these need to be the username and password for the local docker registry.|
| License key | `-l` | The StackState license key.                                                                                                                                                                                                                                                              |
| Admin API password | `-a` | The password for the admin API. Note that this API contains system maintenance functionality and should only be accessible by the maintainers of the StackState installation. You can omit this from the command line, the script will prompt for it.                                    |
| Default password | `-d` | The password for the default user \(`admin`\) to access StackState's UI. You can omit this from the command line, the script will prompt for it.                                                                                                                                         |
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
kafkaup-operator:
  securityContext:
    enabled: false
minio:
  securityContext:
    enabled: false
zookeeper:
  securityContext:
    enabled: false
scc:
  enabled: true
```

### Deploy StackState with Helm

The recommended deployment of StackState is a production ready, high availability setup with many services running redundantly. If required, it's also possible to run StackState in a non-redundant setup, where each service has only a single replica. This setup is only recommended for a test environment.

For air-gapped environments follow the instructions for the air-gapped installations.

{% tabs %}
{% tab title="High availability setup" %}

To deploy StackState in a high availability setup on OpenShift:

1. Before you deploy:
   * [Create the project where StackState will be installed](openshift_install.md#create-project)
   * [Generate `values.yaml`](#generate-values.yaml)
   * [Create `openshift-values.yaml`](#create-openshift-values.yaml)
2. Deploy the latest StackState version to the `stackstate` namespace with the following command:

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values openshift-values.yaml \
stackstate \
stackstate/stackstate-k8s
```
{% endtab %}
{% tab title="Non-high availability setup" %}

To deploy StackState in a non-high availability setup on OpenShift:

1. Before you deploy:
   * [Create the project where StackState will be installed](openshift_install.md#create-project)
   * [Generate `values.yaml`](#generate-values.yaml)
   * [Create `openshift-values.yaml`](#create-openshift-values.yaml)
   * [Create `nonha_values.yaml`](/setup/install-stackstate/kubernetes_openshift/non_high_availability_setup.md)
2. Deploy the latest StackState version to the `stackstate` namespace with the following command:

```bash
helm upgrade \
  --install \
  --namespace stackstate \
  --values local-docker-registry.yaml \
  --values values.yaml \
  --values nonha_values.yaml \
  --values openshift-values.yaml \
stackstate \
stackstate/stackstate-k8s
```
{% endtab %}
{% tab title="Air-gapped, high availability setup" %}

To deploy StackState in a high availability setup on OpenShift:

1. Before you deploy:
   * [Create the project where StackState will be installed](openshift_install.md#create-project)
   * [Generate `values.yaml`](#generate-values.yaml)
   * [Create `openshift-values.yaml`](#create-openshift-values.yaml)
2. Deploy the latest StackState version to the `stackstate` namespace with the following command:

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values local-docker-registry.yaml \
  --values values.yaml \
  --values openshift-values.yaml \
stackstate \
stackstate/stackstate-k8s
```
{% endtab %}
{% tab title="Air-gapped, non-high availability setup" %}

To deploy StackState in a non-high availability setup on OpenShift:

1. Before you deploy:
   * [Create the project where StackState will be installed](openshift_install.md#create-project)
   * [Generate `values.yaml`](#generate-values.yaml)
   * [Create `openshift-values.yaml`](#create-openshift-values.yaml)
   * [Create `nonha_values.yaml`](/setup/install-stackstate/kubernetes_openshift/non_high_availability_setup.md)
5. Deploy the latest StackState version to the `stackstate` namespace with the following command:

```bash
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values nonha_values.yaml \
  --values openshift-values.yaml \
stackstate \
stackstate/stackstate-k8s
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

* [Expose StackState outside of the cluster](ingress.md)
* [Start monitoring your Kubernetes clusters](../../../k8s-quick-start-guide.md)
* Give your [co-workers access](/setup/security/authentication/README.md).

## Manually create `SecurityContextConfiguration` objects

If you can't use an administrator account to install StackState on OpenShift, ask your administrator to apply the below `SecurityContextConfiguration` objects.

```yaml
apiVersion: security.openshift.io/v1
kind: SecurityContextConstraints
metadata:
  name: {{ template "common.fullname.short" . }}-{{ .Release.Namespace }}
  labels:
    {{- include "common.labels.standard" . | nindent 4 }}
  annotations:
    helm.sh/hook: pre-install
    stackstate.io/note: "Ignored by helm uninstall, has to be deleted manually"
fsGroup:
  type: RunAsAny
groups:
- system:serviceaccounts:{{ .Release.Namespace }}
runAsUser:
  type: RunAsAny
seLinuxContext:
  type: MustRunAs
supplementalGroups:
  type: RunAsAny
volumes:
- configMap
- downwardAPI
- emptyDir
- ephemeral
- persistentVolumeClaim
- projected
- secret
allowHostDirVolumePlugin: false
allowHostIPC: false
allowHostNetwork: false
allowHostPID: false
allowHostPorts: false
allowPrivilegeEscalation: true
allowPrivilegedContainer: false
readOnlyRootFilesystem: false
```

## See also

* [Create a `nonha_values.yaml` file](/setup/install-stackstate/kubernetes_openshift/non_high_availability_setup.md)
* For other configuration and management options, refer to the Kubernetes documentation - [manage a StackState Kubernetes installation](kubernetes_install/)

