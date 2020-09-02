# Install StackState

## Before you start

* Request access credentials to pull the StackState Docker images from [StackState support](https://support.stackstate.com/).

* Add the StackState helm repository to the local helm client:

```text
helm repo add stackstate https://helm.stackstate.io
helm repo update
```

## Deploy StackState

Start by creating the namespace where you want to install StackState \(for the example we'll assume that is `stackstate`\) and deploy the secret in that namespace:

```text
kubectl create namespace stackstate
```

If you didn't before run `helm repo update` to make sure the latest helm chart version is used. Installation can now be started. For the production setup the default should be good \(i.e. redundant storage services\). It is possible to create smaller deployments for test setups, see the [test environment deployments](./).

First generate a `values.yaml` containing your license key, api key etc. Store it somewhere safe so that it can be reused for upgrades. This saves some work on upgrades but more importantly StackState will keep using the same api key which is desirable because then agents and other data providers for StackState don't need to be updated.

Generate it with the `generate_values.sh` script in the [installation directory](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/installation) of the helm chart. When run without any arguments it will guide you through the process of installing StackState with a few simple questions. Specifying the `-n` switches it to non-interactive mode requiring all required arguments are passed on the command line \(useful for scripting\).

To get started run it like this:

```text
./generate_values.sh
```

The script requires the following input:

* base url \(`-b`\): The external URL for StackState that users and agents will use to connect with it: `https://<stackstate-hostname>`. For example `https://stackstate.internal`. If you don't know this yet, because you haven't decided on an ingress configuration yet, you can start with `http://localhost:8080` and later update it in the generated `values.yaml`
* image pull username and password \(`-u` , `-p`\): The username and password provided by StackState to pull images from quay.io/stackstate repositories
* license key \(`-l`\): The StackState license key
* admin api password \(`-d`\): The password for the admin api, this api contains system maintenance functionality and should only be accessible by the maintainers of the StackState installation \(you can also omit it from the command line, the script will ask for it in that case\)
* default password \(`-d`\): The password for the default user \(`admin`\) to access StackState's UI \(you can also omit it from the command line, the script will ask for it in that case\)
* should the StackState k8s agent be installed automatically \(interactively a yes/no question, also enabled when specifying `-k`\): StackState has built-in support \(via the [Kubernetes StackPack](/stackpacks/integrations/kubernetes.md)) for Kubernetes that can be automatically enabled, see this [section](./#automatic-kubernetes-support).
* the Kubernetes cluster name \(`-k`\): When enabling automatic Kubernetes support StackState will use this name to identify the cluster, for more details see [this section](./#automatic-kubernetes-support). In non-interactive mode specifying `-k` will specify the cluster name and at the same time enable the Kubernetes support.

Use the generated `values.yaml` file to deploy the latest StackState version to the `stackstate` namespace run the following command:

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
stackstate \
stackstate/stackstate
```

When all pods are up you can enable a port-forward with `kubectl port-forward service/stackstate-router 8080:8080` and open StackState in your browser under `https://localhost:8080`. Log in with the username `admin` and the default password provided in the previous steps. Next steps are to configure [ingress](ingress.md), install a [StackPack](/stackpacks/) or two and to give your [co-workers access](./#configuring-authentication-and-authorization).

### Automatic Kubernetes support

StackState has built-in support for Kubernetes via the [Kubernetes StackPack](/stackpacks/integrations/kubernetes.md). To get started quickly the StackState installation can automate the installation of this StackPack and the required agent instalation, but only for the cluster StackState itself will be installed on. This is not required and can always be done later via the StackPacks page of StackState for StackState's cluster or any other Kuberenetes cluster.

The only required information is a name for the Kubernetes cluster that will distinguish it for the other Kubernetes clusters monitored by StackState. A good choice usually is the same name that is used in the kube context configuration. This will then automatically install the StackPack and install a Daemonset for the agent and a deployment for the so called cluster agent. For the full details please read the [Kubernetes StackPack](/stackpacks/integrations/kubernetes.md).
