---
description: StackState SaaS
---

# StackState quick start guide

## Overview

When your StackState SaaS instance has been set up and configured, you will receive an email from StackState with the required login details. This quick start guide will help you get started and get your own data into your StackState SaaS instance.

* [Integrate with Kubernetes](#kubernetes-quick-start-guide)
* [Integrate with OpenShift](#openshift-quick-start-guide)

## Kubernetes quick start guide

Set up a Kubernetes integration to collect topology, events, logs, change and metrics data from a Kubernetes cluster and make this available in StackState.

### Supported container runtimes

From StackState Agent V2.16, the following container runtimes are supported:

* containerd
* CRI-O
* Docker

Note that versions of StackState Agent prior to v2.16 support the Docker container runtime only.

### Prerequisites for Kubernetes

To set up a StackState Kubernetes integration you need to have:

* An up and running Kubernetes Cluster.
* A recent version of Helm 3.
* A user with permissions to create privileged pods, ClusterRoles and ClusterRoleBindings:
  * ClusterRole and ClusterRoleBinding are needed to grant StackState Agents permissions to access the Kubernetes API.
  * StackState Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up a Kubernetes integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-kubernetes).
{% endhint %}

To get data from a Kubernetes cluster into StackState, follow the steps described below:

1. Add the StackState helm repository to the local helm client:
    ```buildoutcfg
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
    ```
   
2. In the StackState UI, open the main menu by clicking in the top left of the screen and go to **StackPacks** > **Integrations** > **Kubernetes**.
3. Install a new instance of the Kubernetes StackPack:
   * Specify a **Kubernetes Cluster Name** - this name will be used to identify the cluster in StackState.
   * Click **INSTALL**.
4. Deploy the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Kubernetes cluster using the helm command provided in the StackState UI after you have installed the StackPack.
   * Once the Agents have been deployed, they will begin collecting data and push this to StackState

➡️ [Learn more about the StackState Kubernetes integration](/stackpacks/integrations/kubernetes.md)

## OpenShift quick start guide

Set up an OpenShift integration to collect topology, events, logs, change and metrics data from an OpenShift cluster and make this available in StackState.

### Prerequisites for OpenShift

To set up a StackState OpenShift integration you need to have:

* An up and running OpenShift Cluster.
* A recent version of Helm 3.
* A user with permissions to create privileged pods, ClusterRoles, ClusterRoleBindings and SCCs:
  * ClusterRole and ClusterRoleBinding are needed to grant StackState Agents permissions to access the OpenShift API.
  * StackState Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up an OpenShift integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for OpenShift](#prerequisites-for-openshift).
{% endhint %}

To get data from an OpenShift cluster into StackState, follow the steps described below:

1. Add the StackState helm repository to the local helm client:
    ```buildoutcfg
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
    ```
   
2. In the StackState UI, open the main menu by clicking in the top left of the screen and go to **StackPacks** > **Integrations** > **OpenShift**.
3. Install a new instance of the Kubernetes StackPack:
   * Specify a **OpenShift Cluster Name** - this name will be used to identify the cluster in StackState.
   * Click **INSTALL**.
4. Deploy the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics on your OpenShift cluster using the helm command provided in the StackState UI after you have installed the StackPack.
   * Once the Agents have been deployed, they will begin collecting data and push this to StackState

➡️ [Learn more about the StackState OpenShift integration](/stackpacks/integrations/openshift.md)

## What next?

- [StackState walk-through](/getting_started.md)