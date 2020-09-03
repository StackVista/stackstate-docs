# Install StackState

## Before you start

Before you start the installation of StackState:

* Check that your Kubernetes environment meets the [requirements](requirements.md)
* Request access credentials to pull the StackState Docker images from [StackState support](https://support.stackstate.com/).

* Add the StackState helm repository to the local helm client:

```text
helm repo add stackstate https://helm.stackstate.io
helm repo update
```

## Install StackState

1. [Create the namespace where StackState will be installed](#create-the-namespace)
2. [Generate the `values.yaml` file](#generate-values-yaml)
3. [Deploy StackState with Helm](#deploy-stackstate-with-helm)
4. [Enable port forwarding](#enable-port-forwarding)

### Create the namespace

Start by creating the namespace where you want to install StackState and deploy the secret in that namespace. In our walkthrough we will use the namespace `stackstate`:

```text
kubectl create namespace stackstate
```

### Generate the file `values.yaml`

The `values.yaml` is required to deploy StackState with Helm. It contains  your StackState license key, API key etc. and can be generated using the `generate_values.sh` script in the [installation directory](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/installation).

{% hint style="info" %}
**Before you continue:** If you didn't already, make sure you have the latest version of the Helm chart with `helm repo update`.
{% endhint %}

When the `generate_values.sh` script is run without any arguments, it will guide you through the required configuration. You can also optionally pass all required arguments on the command line, this is useful for scripting.

```
./generate_values.sh

```
{% hint style="info" %}
Store the generated 'values.yaml' file somewhere safe. You can reuse this file for upgrades, which will save time and (more importantly) ensures that StackState continues to use the same API key. This is desirable as it means Agents and other data providers for StackState will not need to be updated.
{% endhint %}

The `values.yaml` file generated is suitable for a production setup \(i.e. redundant storage services\). It is also possible to create smaller deployments for test setups, see [development setup](development_setup.md).



The script requires the following input:

* base url \(`-b`\): The external URL for StackState that users and agents will use to connect with it: `https://<stackstate-hostname>`. For example `https://stackstate.internal`. If you don't know this yet, because you haven't decided on an ingress configuration yet, you can start with `http://localhost:8080` and later update it in the generated `values.yaml`
* image pull username and password \(`-u` , `-p`\): The username and password provided by StackState to pull images from quay.io/stackstate repositories
* license key \(`-l`\): The StackState license key
* admin api password \(`-d`\): The password for the admin api, this api contains system maintenance functionality and should only be accessible by the maintainers of the StackState installation \(you can also omit it from the command line, the script will ask for it in that case\)
* default password \(`-d`\): The password for the default user \(`admin`\) to access StackState's UI \(you can also omit it from the command line, the script will ask for it in that case\)
* should the StackState k8s agent be installed automatically \(interactively a yes/no question, also enabled when specifying `-k`\): StackState has built-in support \(via the [Kubernetes StackPack](/stackpacks/integrations/kubernetes.md)) for Kubernetes that can be automatically enabled, see this [section](./#automatic-kubernetes-support).
* the Kubernetes cluster name \(`-k`\): When enabling automatic Kubernetes support StackState will use this name to identify the cluster, for more details see [this section](./#automatic-kubernetes-support). In non-interactive mode specifying `-k` will specify the cluster name and at the same time enable the Kubernetes support.

### Deploy StackState with Helm


Use the generated `values.yaml` file to deploy the latest StackState version to the `stackstate` namespace run the following command:

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
stackstate \
stackstate/stackstate
```

### Enable port forwarding

When all pods are up you can enable a port-forward with `kubectl port-forward service/stackstate-router 8080:8080` and open StackState in your browser under `https://localhost:8080`. Log in with the username `admin` and the default password provided in the previous steps. Next steps are to configure [ingress](ingress.md), install a [StackPack](/stackpacks/) or two and to give your [co-workers access](./#configuring-authentication-and-authorization).

### Automatic Kubernetes support

StackState has built-in support for Kubernetes via the [Kubernetes StackPack](/stackpacks/integrations/kubernetes.md). To get started quickly the StackState installation can automate the installation of this StackPack and the required agent instalation, but only for the cluster StackState itself will be installed on. This is not required and can always be done later via the StackPacks page of StackState for StackState's cluster or any other Kuberenetes cluster.

The only required information is a name for the Kubernetes cluster that will distinguish it for the other Kubernetes clusters monitored by StackState. A good choice usually is the same name that is used in the kube context configuration. This will then automatically install the StackPack and install a Daemonset for the agent and a deployment for the so called cluster agent. For the full details please read the [Kubernetes StackPack](/stackpacks/integrations/kubernetes.md).
