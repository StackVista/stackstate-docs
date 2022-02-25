---
description: Install StackState on Kubernetes
---

# Install StackState

{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Before you start

{% hint style="info" %}
Extra notes for installing on:

* **Kubernetes clusters with limited permissions**: Read the [required permissions](required_permissions.md).
* **OpenShift**: Refer to the [OpenShift installation instructions](../openshift_install.md).
{% endhint %}

Before you start the installation of StackState:

* Check that your Kubernetes environment meets the [requirements](../../requirements.md)
* Check that you have the [required permissions](required_permissions.md)
* Request access credentials to pull the StackState Docker images from [StackState support](https://support.stackstate.com/).
* Add the StackState helm repository to the local helm client:

```text
helm repo add stackstate https://helm.stackstate.io
helm repo update
```

## Install StackState

1. [Create the namespace where StackState will be installed](install_stackstate.md#create-namespace)
2. [Generate the `values.yaml` file](install_stackstate.md#generate-values-yaml)
3. [Deploy StackState with Helm](install_stackstate.md#deploy-stackstate-with-helm)
4. [Access the StackState UI](install_stackstate.md#access-the-stackstate-ui)

### Create namespace

Start by creating the namespace where you want to install StackState and deploy the secret in that namespace. In our walkthrough we will use the namespace `stackstate`:

```text
kubectl create namespace stackstate
```

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
  ./generate_values.sh -n <configuration items>
  ```

The script requires the following configuration items:

| Configuration | Flag | Description |
| :--- | :--- | :--- |
| Base URL | `-b` | The external URL for StackState that users and agents will use to connect. For example `https://stackstate.internal`.  If you haven't decided on an Ingress configuration yet, use `http://localhost:8080`. This can be updated later in the generated file. |
| Username and password\*\* | `-u` `-p` | The username and password used by StackState to pull images from quay.io/stackstate repositories. |
| License key | `-l` | The StackState license key. |
| Admin API password | `-a` | The password for the admin API. Note that this API contains system maintenance functionality and should only be accessible by the maintainers of the StackState installation. This can be omitted from the command line, the script will prompt for it. |
| Default password | `-d` | The password for the default user \(`admin`\) to access StackState's UI. This can be omitted from the command line, the script will prompt for it. |
| Kubernetes cluster name | `-k` | StackState will use this name to identify the cluster. In non-interactive mode, specifying `-k` will both enable [automatic Kubernetes support](install_stackstate.md#automatic-kubernetes-support) and set the cluster name. In interactive mode, you will first be asked if you want to automatically install the [Kubernetes StackPack](../../../stackpacks/integrations/kubernetes.md). |

The generated file is suitable for a production setup \(i.e. redundant storage services\). It is also possible to create smaller deployments for test setups, see [development setup](development_setup.md).

{% hint style="info" %}
Store the `values.yaml` file somewhere safe. You can reuse this file for upgrades, which will save time and \(more importantly\) will ensure that StackState continues to use the same API key. This is desirable as it means agents and other data providers for StackState will not need to be updated.
{% endhint %}

### Deploy StackState with Helm

Use the generated `values.yaml` file to deploy the latest StackState version to the `stackstate` namespace with the following command:

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
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

After StackState has been deployed you can check if all pods are up and running:

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
* Give your [co-workers access](../../../configure/security/authentication/).

## Automatic Kubernetes support

StackState has built-in support for Kubernetes by means of the [Kubernetes StackPack](../../../stackpacks/integrations/kubernetes.md). To get started quickly, the StackState installation can automate installation of this StackPack and the required agent for the cluster that StackState itself will be installed on. This is not required and can always be done later from the StackPacks page of the StackState UI for StackState's cluster or any other Kuberenetes cluster.

The only required information is a name for the Kubernetes cluster that will distinguish it from the other Kubernetes clusters monitored by StackState. A good choice usually is the same name that is used in the kube context configuration. This will then automatically install the StackPack and install a Daemonset for the agent and a deployment for the so called cluster agent. For the full details, please read the [Kubernetes StackPack](../../../stackpacks/integrations/kubernetes.md) page.

