---
description: StackState for Kubernetes troubleshooting Self-hosted
---

# Install StackState

## Before you start

{% hint style="info" %}
Extra notes for installing on:

* **Kubernetes clusters with limited permissions**: Read the [required permissions](required_permissions.md).
* **OpenShift**: Refer to the [OpenShift installation instructions](openshift_install.md).
{% endhint %}

Before you start the installation of StackState:

* Check the [requirements](/setup/install-stackstate/requirements.md) to make sure that your Kubernetes environment fits the setup that you will use (recommended, minimal or non- high availability).
* Check that you have the [required permissions](required_permissions.md).
* Request access credentials to pull the StackState Docker images from [StackState support](https://support.stackstate.com/).
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

1. [Create the namespace where StackState will be installed](kubernetes_install.md#create-namespace)
2. [Generate the `values.yaml` file](kubernetes_install.md#generate-values.yaml)
3. [Deploy StackState with Helm](kubernetes_install.md#deploy-stackstate-with-helm)
4. [Access the StackState UI](kubernetes_install.md#access-the-stackstate-ui)

### Create namespace

Start by creating the namespace where you want to install StackState and deploy the secret in that namespace. In our walkthrough we will use the namespace `stackstate`:

```text
kubectl create namespace stackstate
```

### Generate `values.yaml`

The `values.yaml` file is required to deploy StackState with Helm. It contains your StackState license key, StackState Receiver API key and other important information.

{% hint style="info" %}
**Before you continue:** Make sure you have the latest version of the Helm chart with `helm repo update`.
{% endhint %}

The `generate_values.sh` script in the [installation directory](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate-k8s/installation) of the Helm chart will guide you through generating a `values.yaml` file that can be used to deploy StackState. You can run the `generate_values.sh` script in two ways:

* **Interactive mode:** When the script is run without any arguments, it will guide you through the required configuration items.

  ```text
  ./generate_values.sh
  ```

* **Non-interactive mode:** Run the script with the flag `-n` to pass configuration on the command line, this is useful for scripting.

  ```text
  ./generate_values.sh -n <configuration items>
  ```

The script requires the following configuration items:

| Configuration | Flag | Description                                                                                                                                                                                                                                                                                                                                                                                 |
| :--- | :--- |:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Base URL | `-b` | The `<STACKSTATE_BASE_URL>`. The external URL for StackState that users and agents will use to connect. For example `https://stackstate.internal`. If you haven't decided on an Ingress configuration yet, use `http://localhost:8080`. This can be updated later in the generated file.                                                                                                    |
| Username and password\*\* | `-u` `-p` | The username and password used by StackState to pull images from quay.io/stackstate repositories. For air-gapped environments these need to be the username and password for the local docker registry. |
| License key | `-l` | The StackState license key.                                                                                                                                                                                                                                                                                                                                                                 |
| Admin API password | `-a` | The password for the admin API. Note that this API contains system maintenance functionality and should only be accessible by the maintainers of the StackState installation. You can omit this from the command line, the script will prompt for it.                                                                                                                                       |
| Default password | `-d` | The password for the default user \(`admin`\) to access StackState's UI. You can omit this from the command line, the script will prompt for it.                                                                                                                                                                                                                                            |
| Kubernetes cluster name | `-k` | StackState will use this name to identify the cluster. In non-interactive mode, specifying `-k` will both enable [automatic Kubernetes support](kubernetes_install.md#automatic-kubernetes-support) and set the cluster name. In interactive mode, you will first be asked if you want to automatically install the [Kubernetes StackPack](../../../stackpacks/integrations/kubernetes.md). |

{% hint style="info" %}
Store the generated `values.yaml` file somewhere safe. You can reuse this file for upgrades, which will save time and \(more importantly\) will ensure that StackState continues to use the same API key. This is desirable as it means Agents and other data providers for StackState won't need to be updated.
{% endhint %}

### Deploy StackState with Helm

The recommended deployment of StackState is a production ready, high availability setup with many services running redundantly. If required, it's also possible to run StackState in a non-redundant setup, where each service has only a single replica. This setup is only recommended for a test environment.

For air-gapped environments follow the instructions for the air-gapped installations.

{% tabs %}
{% tab title="High availability setup" %}

To deploy StackState in a high availability setup on Kubernetes:

1. Before you deploy:
   * [Create the namespace where StackState will be installed](kubernetes_install.md#create-namespace)
   * [Generate `values.yaml`](#generate-values.yaml)
2. Deploy the latest StackState version to the `stackstate` namespace with the following command:

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
stackstate \
stackstate/stackstate-k8s
```
{% endtab %}
{% tab title="Non-high availability setup" %}

To deploy StackState in a non-high availability setup on Kubernetes:

1. Before you deploy:
   * [Create the namespace where StackState will be installed](kubernetes_install.md#create-namespace)
   * [Generate `values.yaml`](#generate-values.yaml)
   * [Create `nonha_values.yaml`](non_high_availability_setup.md)
3. Deploy the latest StackState version to the `stackstate` namespace with the following command:

```bash
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values nonha_values.yaml \
stackstate \
stackstate/stackstate-k8s
```
{% endtab %}
{% tab title="Air-gapped, high availability setup" %}

To deploy StackState in a air-gapped, high availability setup on Kubernetes:

1. Before you deploy:
   * [Follow these extra instructions for air-gapped installations](./no_internet/stackstate_installation.md).
   * [Create the namespace where StackState will be installed](kubernetes_install.md#create-namespace)
   * [Generate `values.yaml`](#generate-values.yaml)
2. Deploy the latest StackState version to the `stackstate` namespace with the following command:

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values local-docker-registry.yaml \
  --values values.yaml \
stackstate \
stackstate/stackstate-k8s
```
{% endtab %}
{% tab title="Air-gapped, non-high availability setup" %}

To deploy StackState in a air-gapped, non-high availability setup on Kubernetes:

1. Before you deploy:
   * [Follow these extra instructions for air-gapped installations](./no_internet/stackstate_installation.md).
   * [Create the namespace where StackState will be installed](kubernetes_install.md#create-namespace)
   * [Generate `values.yaml`](#generate-values.yaml)
   * [Create `nonha_values.yaml`](non_high_availability_setup.md)
3. Deploy the latest StackState version to the `stackstate` namespace with the following command:

```bash
helm upgrade \
  --install \
  --namespace stackstate \
  --values local-docker-registry.yaml \
  --values values.yaml \
  --values nonha_values.yaml \
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

* [Expose StackState outside of the cluster](ingress.md)
* [Start monitoring your Kubernetes clusters](../../../k8s-quick-start-guide.md)
* Give your [co-workers access](/setup/security/authentication/README.md).
