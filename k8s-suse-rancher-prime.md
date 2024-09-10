---
description: SUSE Observability
---

# SUSE Rancher Prime - Observability Tech Preview

## Introduction

This page describes how to install SUSE Rancher Prime - Observability during the Tech Preview phase on-premise.

SUSE Rancher Prime - Observability, formerly known as SUSE Observability can be used for Observability of your Kubernetes clusters and their workloads.
During the Tech Preview phase we only offer 2 on-prem installations which can support up-to 50 (non-HA) or up-to 250 (HA) worker Nodes.

The Tech Preview phase is expected  is expected to last at least 30 days. After the Tech Preview phase a GA version will be made available for SUSE Rancher Prime customers. There is no guarantee that the Tech Preview will be compatible from a feature or upgrade perspective with the GA version.

The installation of SUSE Observability, the SUSE SUSE Observability UI extension and the SUSE Observability Agents takes about 30 minutes in total.

## Getting help
To get support, ask any question or provide feedback you can reach us during the tech preview phase on the following email rancherobservability@suse.com

## Prerequisites

### License key
A license key for SUSE Observability server can be obtained via the SUSE Customer Center and will be shown as "SUSE Rancher Prime - Observability Tech Preview" Registration Code. The license for the tech preview is valid until Oct, 31 2024. Before the end a license will be made available which is valid until the end of your SUSE Rancher Prime subscription.

### Requirements
To install SUSE Observability, ensure that the nodes have enough CPU and memory capacity. Below are the specific requirements.

There are different installation options available for SUSE Observability. It is possible to install SUSE Observability either in a High-Availability (HA) or single instance (non-HA) setup. The non-HA setup is recommended for testing purposes or small environments. For production environments, it is recommended to install SUSE Observability in a HA setup.

The HA production setup can support up to 250 Nodes (a Node is counted as<= 4 vCPU and <= 16GB Memory) under observation
The Non-HA setup can support up to 50 Nodes under observation.

![Requirements](/.gitbook/assets/k8s/prime/requirements.png)

In the near feature we will have more options with lower resource constraints and for smaller + larger setups.

### The different components

#### SUSE Observability Server

This is the on-prem hosted server part of the installation. It contains a set of services to store observability data:

- Topology (StackGraph)
- Metrics (VictoriaMetrics)
- Traces (ClickHouse)
- Logs (ElasticSearch)

Next to this, it contains a set of services for all the observability tasks. e.g. Notifications, State management, Monitoring, etc.

#### SUSE Observability Agent

The lightweight SUSE Observability agent is installed on your downstream worker nodes. It collects and reports metrics, events, traces and logs, and it provides real-time observability and insights, enabling proactive monitoring and troubleshooting of your IT environment.

The SUSE Rancher Prime version of the Agent also uses eBPF as a lightweight way to monitor all your workloads and their communication. It also decodes the RED (Rate, Errors and Duration) signals for most of the common L7 protocols like TCP, HTTP, TLS, Redis, etc.

#### Rancher Prime - Observability UI extension

This is an UI extension to Rancher Manager that integrates the health signals observed by SUSE Observability. It gives direct access to the health of any resource and a link to SUSE Observability's UI for further investigation.

### Where to install SUSE Observability server

SUSE Observability server should be installed in its own downstream cluster intended for Observability. See the below picture for reference.

For StackState to be able to work properly it needs:
* [Kubernetes Persistent Storage](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/manage-clusters/create-kubernetes-persistent-storage) to be available in the observability cluster to store metrics, events, etc.
* the observability cluster to support a way to expose StackState on an HTTPS URL to Rancher, StackState users and the StackState agent. This can be done via an Ingress configuration using an ingress controller, alternatively a (cloud) loadbalancer for the StackState services could do this too, for more information see the [Rancher docs](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/kubernetes-resources-setup/load-balancer-and-ingress-controller).

![Architecture](/.gitbook/assets/k8s/prime/architecture.png)

### Pre-Installation
Before installing the SUSE Observability server a default storage class must be set up in the cluster where the SUSE Observability server will be installed:

- **For k3s**: The local-path storage class of type rancher.io/local-path is created by default.
- **For EKS, AKS, GKE** a storage class is set by default
- **For RKE2 Node Drivers**: No storage class is created by default. You will need to create one before installing SUSE Observability.
- **RKE1** is not supported to run SUSE Observability server.

## Installing SUSE Observability

{% hint style="info" %}
**Good to know**

If you created the cluster using Rancher Manager and would like to run the provisioning commands below from a local terminal instead of in the web terminal, just copy or download the kubeconfig from the cluster dashboard, see image below, and paste it (or place the downloaded file) into a file that you can easily find e.g. ~/.kube/config-rancher and set the environment variable KUBECONFIG=$HOME/.kube/config-rancher
{% endhint %}

![Rancher](/.gitbook/assets/k8s/prime/rancher_cluster_dashboard.png)


After meeting the prerequisites you can proceed with the installation. The installation is NOT YET AVAILABLE from the app store. Instead, you can install SUSE Observability via the downstream or upstream kubectl shell of the cluster.

You can now follow the instruction below for a HA or NON-HA setup.

{% hint style="info" %}
Be aware upgrading or downgrading from HA to NON-HA and visa-versa is not yet supported.
{% endhint %}


### Installing a default HA setup for up to 250 Nodes

1. Get the helm chart
{% code title="helm_repo.sh" lineNumbers="true" %}
```text
helm repo add rancher-prime-observability https://helm-rancher-prime.stackstate.io
helm repo update
```
{% endcode %}


2. Command to generate helm chart values file:

{% code title="helm_template.sh" lineNumbers="true" %}
```text
helm template \
    --set license='<licenseKey>' \
    --set baseUrl='<baseURL>' \
    --set pullSecret.username='trial' \
    --set pullSecret.password='trial' \
    prime-observability-values \
    rancher-prime-observability/stackstate-values > values.yaml
```
{% endcode %}

3. Deploy the SUSE Observability helm chart with the generated values:

{% code title="helm_deploy.sh" lineNumbers="true" %}
```text
helm upgrade --install \
    --namespace prime-observability \
    --create-namespace \
    --values values.yaml \
    prime-observe \
    rancher-prime-observability/stackstate-k8s
```
{% endcode %}

### Installing a NON-HA setup for up to 50 Nodes

1. Get the helm chart
   {% code title="helm_repo.sh" lineNumbers="true" %}
```text
helm repo add rancher-prime-observability https://helm-rancher-prime.stackstate.io
helm repo update
```
{% endcode %}

2. Command to generate helm chart values file:

{% code title="helm_template.sh" lineNumbers="true" %}
```text
helm template \
    --set license='<licenseKey>' \
    --set baseUrl='<baseURL>' \
    --set pullSecret.username='trial' \
    --set pullSecret.password='trial' \
    prime-observability-values \
    rancher-prime-observability/stackstate-values > values.yaml
```
{% endcode %}

The `baseUrl` must be the URL via which StackState will be accessible to Rancher, users, and the StackState agent. The URL must including the scheme, for example `https://stackstate.internal.mycompany.com`. See also [accessing StackState](#accessing-stackstate).

3. Create a second values file for the non-ha setup, named nonha_values.yaml with the following content:


{% code title="nonha_values.yaml" lineNumbers="true" %}
```text
# This files defines additional Helm values to run SUSE Observability on a
# non-high availability production setup. Use this file in combination
# with a regular values.yaml file that contains your API key, etc.
elasticsearch:
  minimumMasterNodes: 1
  replicas: 1

hbase:
  hbase:
    master:
      replicaCount: 1
    regionserver:
      replicaCount: 1
  hdfs:
    datanode:
      replicaCount: 1
    secondarynamenode:
      enabled: false
  tephra:
    replicaCount: 1

kafka:
  replicaCount: 1
  defaultReplicationFactor: 1
  offsetsTopicReplicationFactor: 1
  transactionStateLogReplicationFactor: 1

stackstate:
  components:
    ui:
      replicaCount: 1

victoria-metrics-1:
  enabled: false

zookeeper:
  replicaCount: 1

clickhouse:
  replicaCount: 1
```
{% endcode %}

4. Deploy the SUSE Observability helm chart with the generated values, as well as the non-ha configuration values:

{% code title="helm_deploy.sh" lineNumbers="true" %}
```text
helm upgrade --install \
    --namespace prime-observability \
    --create-namespace \
    --values values.yaml \
    --values nonha_values.yaml \
    prime-observe \
    rancher-prime-observability/stackstate-k8s
```
{% endcode %}

## Accessing StackState

The StackState Helm chart has support for creating an Ingress resource to make StackState accessible outside of the cluster. Follow [these instructions](setup/install-stackstate/kubernetes_openshift/ingress.md) to set that up when you have an ingress controller in the cluster. Make sure that the resulting URL uses TLS with a valid, not self-signed, certificate.

If you prefer to use a load balancer instead of ingress, expose the `prime-observe-stackstate-k8s-router` service. The URL for the loadbalancer needs to use a valid, not self-signed, TLS certificate.

## Installing UI extensions

{% hint style="warning" %}
Currently the UI extension for SUSE SUSE Observability is only supported on the 2.8.x versions for SUSE Rancher Prime, and not on the 2.9.x versions. The 2.9.x version will be released soon.
{% endhint %}

To install UI extensions, enable the UI extensions from the rancher UI

![Install](/.gitbook/assets/k8s/prime/ui_extensions.png)

After enabling UI extensions, follow these steps:

1. Navigate to **Local Cluster > Apps > Repositories** and create a new repository.
Use the default Helm option and add the **Index URL**: http://stackvista.github.io/rancher-extension-stackstate
1. Once it is created, a deployment by the name **ui-plugin-operator** in the namespace **cattle-ui-plugin-system** gets created in the local cluster
1. Navigate to extensions on the rancher UI and under Available section of extensions, we will have the Observability extension available.
1. Install the Observability extension.
1. Once installed, on the left panel of the rancher UI, the _SUSE Observability_ section appears.
1. Navigate to the _SUSE Observability_ section and select "configurations". In this section, you can add the SUSE Observability server details and connect it.
1. Follow the instructions as mentioned in *Obtain a service token* tab and fill in the details.

### Obtain a service token:
1. Log into the SUSE Observability instance.
1. From the top left corner, select CLI.
1. Note the API token and install SUSE Observability cli on your local machine.
1. Create a service token by running

{% code %}
```
sts service-token create --name rancher-prime-observability --roles stackstate-k8s-troubleshooter
```
{% endcode %}


## Installing the SUSE Observability Agent
There are two ways to install the SUSE Observability Agent: via the Rancher UI or directly via helm, as mentioned in the instructions of the StackPack page.

{$ hint style="warning" %}
Ensure that the cluster name provided in the StackState UI matches the cluster name in the Rancher UI.
{$ endhint %}

### Install the StackState Agent from the Rancher UI:

1. In the SUSE Observability UI open the main menu and select StackPacks.
2. Select the Kubernetes StackPack.
3. Click on new instance and provide the cluster name of the downstream cluster which you are adding. Make sure you match the name of the Rancher cluster with the name provided here. Click install. When installation completes the api-key and SUSE Observability URL are shown as part of the installation instructions.
4. In a separate tab navigate to the downstream cluster on the Rancher UI on which you want to install the Agent and then go to apps.
5. From the partner charts, select the SUSE Observability agent.
6. Provide the requested installation values:
   1. Make sure the cluster name matches the Rancher cluster name.
   2. The api-key and SUSE Observability URL from step 3 must be used.
7. The SUSE Observability agent will now be installed on the downstream cluster.
8. After you install the SUSE Observability Agent, the cluster can be seen within the SUSE Observability UI as well as the _SUSE Rancher - Observability UI extension_.

### Install the SUSE Observability Agent via helm:

1. In the SUSE Observability UI open the main menu and select StackPacks.
1. Select the Kubernetes StackPack.
1. Click on new instance and provide the cluster name of the downstream cluster which you are adding. Make sure you match the name of the Rancher cluster with the name provided here. Click install.
1. You will now see the helm command which you need to execute.
1. After you install the SUSE Observability Agent, the cluster can be seen within the SUSE Observability UI as well as the _SUSE Rancher - Observability UI extension_.

## Single Sign On
To enable Single sign-on with your own authentication provider please [see here](setup/security/authentication/authentication_options.md).

## Frequently asked questions & Observations:
1. Is it mandatory to install a SUSE Observability agent before proceeding with adding the UI extension?
   * No this is not mandatory, the UI extension can be installed independent.
1. Is it mandatory to install SUSE Observability Server before we proceed with UI extensions?
   * Yes this is not mandatory since you need to provide a SUSE Observability endpoint in the configuration
1. Can we install SUSE Observability on a local cluster or on a downstream cluster?
   * Both options are possible.
1. To monitor the downstream clusters, should we install the SUSE Observability agent from the app store or add a new instance from the SUSE Observability UI?
   * Both options are possible depending on users preference.

## Open Issues
1. When you uninstall and reinstall the UI extensions for Observability, we noticed that service token is not deleted and is reused upon reinstallation. Whenever we uninstall the extensions, service token should be removed.
   * This information should be deleted when the UI extensions are uninstalled.
1. After the extensions are installed, the SUSE Observability UI opens in the same tab as the Rancher UI.
   * You can use shift-click to open in a new tab, this will become the default behaviour
1. The SUSE Rancher Prime - Observability Extension is only supported on 2.8.x versions and not yet on the 2.9.x version.
   * Support for 2.9.x will be available soon.
1. On RKE(1) The Node Agent does not start process-agent with Ubuntu 20.04.6 LTS worker nodes it fails with a message `failed to create network tracer`
1. Be aware upgrading or downgrading from HA to NON-HA and visa-versa is not yet supported.

