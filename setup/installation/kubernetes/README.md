# Installing StackState on Kubernetes \(beta\)

## Requirements


{% hint style="warning" %}
**This page describes StackState version 4.0.**

The StackState 4.0 version range is End of Life (EOL) and **no longer supported**. We encourage customers still running the 4.0 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

StackState can be installed on a Kubernetes cluster via Helm charts provided by StackState. These charts have been tested and are compatible with Kubernetes 1.15.x \(tested on Amazon EKS and Azure AKS\) and Helm 3.

For a list of all docker images used see the [image overview](image_configuration.md).

### Node sizing

For the standard deployment with the helm chart StackState will deploy storage services in a redundant setup with 3 instances of each service. The nodes for different environments:

* Virtual machines: 6 nodes with `16GB memory`, `4 vCPUs`
* Amazon EKS: 6 instances of type `m5.xlarge` or `m4.xlarge`
* Azure AKS: 6 instances of type `D4s v3` or `D4as V4` \(Intel or AMD cpu's\)

### Storage

StackState uses persistent volume claims for the services that need to store data. The default storage class for the cluster will be used for all services unless this is overriden via values specified on the command line or a `values.yaml` file. All services come with a pre-configured volume size that should get you started, but can be customized via variables as well.

The [storage](storage.md) docs page goes into more details on the defaults used.

### Ingress

By default the helm chart will deploy a router pod and service. This services port 8080 is the only entrypoint that needs to be exposed via ingress. Without configuring ingress you can access StackState by forwarding this port like this:

```text
kubectl port-forward service/<helm-release-name>-distributed-router 8080:8080
```

When configuring ingress make sure to allow for large request body sizes \(50MB\) that may be sent occasionally by data sources like the stackstate agent or the aws integration.

For more details on configuring ingress have a look at the [ingress](ingress.md) docs.

## Installation

### Before starting

To be able to pull the StackState Docker images, please request access credentials from [StackState support](https://support.stackstate.com/).

To install StackState Helm needs to know about the helm repository of StackState. Do this with these 2 commands:

```text
helm repo add stackstate https://helm.stackstate.io
helm repo update
```

### Deploying StackState

Start by creating the namespace where you want to install stackstate \(for the example we'll assume that is `stackstate`\) and deploy the secret in that namespace:

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
* should the StackState k8s agent be installed automatically \(interactively a yes/no question, also enabled when specifying `-k`\): StackState has built-in support \(via the [Kubernetes StackPack](https://github.com/StackVista/stackstate-docs/tree/9a194542db2dae0c55dfce4f6c8cd1d4dd432b91/integrations/kubernetes.md)\) for Kubernetes that can be automatically enabled, see this [section](./#automatic-kubernetes-support).
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

When all pods are up you can enable a port-forward with `kubectl port-forward service/stackstate-router 8080:8080` and open StackState in your browser under `https://localhost:8080`. Log in with the username `admin` and the default password provided in the previous steps. Next steps are to configure [ingress](ingress.md), install a [StackPack](../../../integrations/) or two and to give your [co-workers access](./#configuring-authentication-and-authorization).

### Automatic Kubernetes support

StackState has built-in support for Kubernetes via the [Kubernetes StackPack](../../../integrations/available_stackpacks/kubernetes.md). To get started quickly the StackState installation can automate the installation of this StackPack and the required agent instalation, but only for the cluster StackState itself will be installed on. This is not required and can always be done later via the StackPacks page of StackState for StackState's cluster or any other Kuberenetes cluster.

The only required information is a name for the Kubernetes cluster that will distinguish it for the other Kubernetes clusters monitored by StackState. A good choice usually is the same name that is used in the kube context configuration. This will then automatically install the StackPack and install a Daemonset for the agent and a deployment for the so called cluster agent. For the full details please read the [Kubernetes StackPack](../../../integrations/available_stackpacks/kubernetes.md).

### Further customizations

On the readme of the [chart](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate) the possible customizations are documented. For example it is possible to customize the `tolerations` and `nodeSelectors` for each of the components.

### Changing configuration

For Stackstate server the Helm chart has a value to drop in custom configuration, this is especially convenient for customizing authentication. An example to set a different "forgot password link" \(for the StackState login page\):

```text
stackstate:
  components:
    server:
      config: |
        stackstate.api.authentication.forgotPasswordLink = "https://www.stackstate.com/forgotPassword.html"
```

The configuration from this value will be available to StackState as its configuration file in [HOCON](https://github.com/lightbend/config/blob/master/HOCON.md) format. This is the advised way to override the default configuration that StackState ships with.

For all of the StackState services \(`receiver`, `k2es-*`, `correlation`, `server`\) it is possible to change settings via environment variables. For `server` these will override even the customizations done via the `config` value. The environment variables can be provided via the helm chart, both for secret settings \(passwords for example\) and normal values. Here an example that changes both the default password and again the "forgot password link". To convert it to an environment variable `.` are replaced by `_` and a prefix `CONFIG_FORCE_` is added. Now it can be set via `values.yaml`:

```text
stackstate:
  components:
    server:
      extraEnv:
        # Use 'secret' instead of open for things that should be stored as a secret
        open:
          CONFIG_FORCE_stackstate_api_authentication_forgotPasswordLink: "https://www.stackstate.com/forgotPassword.html"
```

For details on the naming of all the different services in the StackState Helm chart see its [readme](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/README.md). For another examle have a look at the next section about authentication settings.

### Configuring authentication and authorization

The supported authentication mechanisms for StackState are discussed [here](../authentication.md) in more detail. To keep using configuration file based authentication but change the users here is an example to have 2 users, `admin-demo` and `guest-demo`, with the 2 default roles available, the md5 hash still needs to be generated and put in the example.

```text
stackstate:
  components:
    server:
      config: |
        stackstate.api.authentication.authServer.stackstateAuthServer {
          logins = [
            { username = "admin-demo", password: "<md5-hash>", roles = ["stackstate-admin"] }
            { username = "guest-demo", password: "<md5-hash>", roles = ["stackstate-guest"] }
          ]
        }
```

Here the custom config file is used for configuration, to do this with environment variables would be very cumbersome. This same approach can be used to, for example, to switch to LDAP based authentication as discussed in the authentication docs.

## Upgrading

For upgrading the same command can be used as for the [first time installation](./). Do check the release notes and any optional upgrade notes before running the upgrade.

## Backups

Several mechanisms can be used for backups. When running in EKS or AKS the easiest setup is to periodically make snapshots of all the volumes attached to the StackState processes \(i.e. in the same namespace\). A tool that can automate this for you is [Velero](https://velero.io/).

Next to this StackState has the ability to export its configuration. This configuration can then be imported again at a later time, in a clean StackState instance or it can be used as a starting point to setup a new StackState environment. The most convenient way to create an export and later ipmort it again is to use the [stackstate cli](../../cli.md) import and export commands.

Exporting is as simple as running `sts-cli graph export stackstate_settings.stj`. Importing of an export can be done with the cli as well but is only adviced on an empty StackState \(a new deployment\). If it is not empty it will very likely fail. To import run this command `cat stackstate_settings.stj | sts-cli graph import`.

## Development / test environment deployments

The standard deployment is a production ready setup with many processes running multiple replicas. For development and testing it can be desirable to run StackState with lower resource requirements. For that purpose several example `values.yaml` files are provided in the [helm chart repository](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/installation/examples):

* `test_values.yaml` that sets the replica count for all services to 1, this effectively reduces the number of required nodes from 6 to 3.
* `micro_test_values.yaml` goes even further and also reduces the memory footprint of most services, thereby making it possible to run StackState within about 16GB of memory.

Note that the generated `values.yaml` should also still be included on the helm command line, e.g.:

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values test_values.yaml \
stackstate \
stackstate/stackstate
```

_WARNING:_ Both the test and micro test deployment are not suitable for bigger workloads and are not supported for production usage.

