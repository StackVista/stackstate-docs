---
description: StackState for Kubernetes troubleshooting
---

# StackState quick start guides

## Overview

When your StackState SaaS instance has been set up and configured, you will receive an email from StackState
with the required login details. This quick start guide will help you get started and get your own data into
your StackState SaaS instance.

To integrate your cluster(s) with StackState you can follow one of these guides for your appropriate environment.
* [Amazon EKS](#amazon-eks)
* [Azure AKS](#azure-aks)
* [Google GKE](#google-gke)
* [Kubernetes](#kubernetes)
* [KOPS](#kops)
* [OpenShift](#openshift)
* [Self-hosted](#self-hosted)

---

# Kubernetes

Set up a Kubernetes integration to collect topology, events, logs, change and metrics data from a Kubernetes cluster and make this available in StackState.

### Supported versions

| Supported Kubernetes Version |
|------------------------------|
| Kubernetes 1.28              |
| Kubernetes 1.27              |
| Kubernetes 1.26              |
| Kubernetes 1.25              |
| Kubernetes 1.24              |
| Kubernetes 1.23              |
| Kubernetes 1.22              |
| Kubernetes 1.21              |

### Supported runtime

| Supported runtime |
|--------------------|
| Docker             |
| ContainerD         |
| CRI-O              |

### Prerequisites for Kubernetes

To set up a StackState Kubernetes integration you need to have:

* An up-and-running Kubernetes Cluster.
* A recent version of Helm 3.
* A user with the permission to `create privileged pods`, `ClusterRoles` and `ClusterRoleBindings`:
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

2. In the StackState UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Integrations` > `Kubernetes`.
3. Install a new instance of the Kubernetes StackPack:
   * Specify a **Kubernetes Cluster Name**
     * This name will be used to identify the cluster in StackState
   * Click **install**.
4. Deploy the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Cluster using the helm command provided in the StackState UI after you have installed the StackPack.
   * Once the Agents have been deployed, they will begin collecting data and push this to StackState

{% hint style="warning" %}
When running on a self-hosted air-gapped environment prepare the agent installation first with the [air-gapped instructions](setup/install-stackstate/kubernetes_openshift/no_internet/agent_install.md).
{% endhint %}
---

# OpenShift

Set up an OpenShift integration to collect topology, events, logs, change and metrics data from a OpenShift cluster and make this available in StackState.

### Supported versions
[comment]: <> (https://access.redhat.com/support/policy/updates/openshift)

| OpenShift Version | Supported Kubernetes Version | OpenShift End of Support |
|-------------------|------------------------------|--------------------------|
| OpenShift 4.12    | Kubernetes 1.25              | July 17, 2024            |
| OpenShift 4.11    | Kubernetes 1.24              | February 10, 2024        |
| OpenShift 4.10    | Kubernetes 1.23              | September 10, 2023       |
| OpenShift 4.9     | Kubernetes 1.22              | April 18, 2023           |

### Supported runtime

| Supported runtime |
|--------------------|
| Docker             |
| ContainerD         |
| CRI-O              |


### Prerequisites for OpenShift

To set up a StackState OpenShift integration you need to have:

* An up-and-running OpenShift Cluster.
* A recent version of Helm 3.
* A user with the permission to `create privileged pods`, `ClusterRoles` and `ClusterRoleBindings`:
  * ClusterRole and ClusterRoleBinding are needed to grant StackState Agents permissions to access the Kubernetes API.
  * StackState Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up an OpenShift integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-openshift).
{% endhint %}

To get data from a Kubernetes cluster into StackState, follow the steps described below:

1. Add the StackState helm repository to the local helm client:
    ```buildoutcfg
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
    ```

2. In the StackState UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Integrations` > `Kubernetes`.
3. Install a new instance of the Kubernetes StackPack:
   * Specify a **Kubernetes Cluster Name**
     * This name will be used to identify the cluster in StackState
   * Click **install**.
4. Deploy the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Cluster using the helm command provided in the StackState UI after you have installed the StackPack.
   * Once the Agents have been deployed, they will begin collecting data and push this to StackState

---

# Amazon EKS

Set up an Amazon EKS integration to collect topology, events, logs, change and metrics data from an Amazon EKS cluster and make this available in StackState.

### Supported versions
[comment]: <> (https://endoflife.date/amazon-eks)

| Kubernetes version | Amazon EKS release | Amazon EKS End of Support |
|--------------------|--------------------|---------------------------|
| 1.28               | September 26, 2023 | November 01, 2024         |
| 1.27               | May 24, 2023       | July 2024                 |
| 1.26               | April 11, 2023     | June 2024                 |
| 1.25               | February 21, 2023  | May 2024                  |
| 1.24               | November 15, 2022  | January 2024              |
| 1.23               | August 11, 2022    | October 11, 2023          |
| 1.22               | April 4, 2022      | June 4, 2023              |
| 1.21               | July 19, 2021      | February 15, 2023         |
| 1.20               | May 18, 2021       | November 1, 2022          |
| 1.19               | February 16, 2021  | August 1, 2022            |
| 1.18               | October 13, 2020   | August 15, 2022           |

### Supported runtime

| Supported runtime |
|--------------------|
| Docker             |
| ContainerD         |
| CRI-O              |

### Prerequisites for Amazon EKS

To set up a StackState Amazon EKS integration you need to have:

* An up-and-running Amazon EKS Cluster.
* A recent version of Helm 3.
* A user with the permission to `create privileged pods`, `ClusterRoles` and `ClusterRoleBindings`:
    * ClusterRole and ClusterRoleBinding are needed to grant StackState Agents permissions to access the Kubernetes API.
    * StackState Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up a Amazon EKS integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-amazon-eks).
{% endhint %}

To get data from a Kubernetes cluster into StackState, follow the steps described below:

1. Add the StackState helm repository to the local helm client:
    ```buildoutcfg
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
    ```

2. In the StackState UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Integrations` > `Kubernetes`.
3. Install a new instance of the Kubernetes StackPack:
    * Specify a **Kubernetes Cluster Name**
        * This name will be used to identify the cluster in StackState
    * Click **install**.
4. Deploy the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Cluster using the helm command provided in the StackState UI after you have installed the StackPack.
    * Once the Agents have been deployed, they will begin collecting data and push this to StackState

---

# Google GKE

Set up a Google GKE integration to collect topology, events, logs, change and metrics data from an Google GKE cluster and make this available in StackState.

### Supported versions
[comment]: <> (https://endoflife.date/google-kubernetes-engine)

| Kubernetes Version | Google GKE release | Google GKE End of Support |
|--------------------|--------------------|---------------------------|
| 1.27               | June 15, 2023      | August 31, 2024           |
| 1.26               | March 31, 2023     | May 31, 2024              |
| 1.25               | December 14, 2022  | February 29, 2024         |
| 1.24               | August 12, 2022    | October 31, 2023          |
| 1.23               | May 27, 2022       | July 31, 2023             |
| 1.22               | April 5, 2022      | April 30, 2023            |
| 1.21               | November 1, 2022   | January 31, 2023          |

### Supported runtime

| Supported runtime |
|--------------------|
| Docker             |
| ContainerD         |
| CRI-O              |

### Prerequisites for Google GKE

To set up a StackState Google GKE integration you need to have:

* An up-and-running Google GKE Cluster.
* A recent version of Helm 3.
* A user with the permission to `create privileged pods`, `ClusterRoles` and `ClusterRoleBindings`:
    * ClusterRole and ClusterRoleBinding are needed to grant StackState Agents permissions to access the Kubernetes API.
    * StackState Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up a Google GKE integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-amazon-eks).
{% endhint %}

To get data from a Kubernetes cluster into StackState, follow the steps described below:

1. Add the StackState helm repository to the local helm client:
    ```buildoutcfg
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
    ```

2. In the StackState UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Integrations` > `Kubernetes`.
3. Install a new instance of the Kubernetes StackPack:
    * Specify a **Kubernetes Cluster Name**
        * This name will be used to identify the cluster in StackState
    * Click **install**.
4. Deploy the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Cluster using the helm command provided in the StackState UI after you have installed the StackPack.
    * Once the Agents have been deployed, they will begin collecting data and push this to StackState

---

# Azure AKS

Set up a Azure AKS integration to collect topology, events, logs, change and metrics data from an Azure AKS cluster and make this available in StackState.

### Supported versions
[comment]: <> (https://endoflife.date/azure-kubernetes-service)

| Kubernetes Version | Azure AKS release | Azure AKS End of Support |
|--------------------|-------------------|--------------------------|
| 1.28               | November, 2023    | November, 2024           |
| 1.27               | August 16, 2023   | July 31, 2024            |
| 1.26               | April 18, 2023    | March 31, 2024           |
| 1.25               | December 14, 2022 | December 31, 2023        |
| 1.24               | August 17, 2022   | July 31, 2023            |
| 1.23               | April 26, 2022    | April 02, 2023           |
| 1.22               | January 10, 2021  | December 04, 2022        |
| 1.21               | July 26, 2021     | July 31, 2022            |

### Supported runtime

| Supported runtime |
|--------------------|
| Docker             |
| ContainerD         |
| CRI-O              |

### Prerequisites for Azure AKS

To set up a StackState Azure AKS integration you need to have:

* An up-and-running Azure AKS Cluster.
* A recent version of Helm 3.
* A user with the permission to `create privileged pods`, `ClusterRoles` and `ClusterRoleBindings`:
    * ClusterRole and ClusterRoleBinding are needed to grant StackState Agents permissions to access the Kubernetes API.
    * StackState Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up a Azure AKS integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-amazon-eks).
{% endhint %}

To get data from a Kubernetes cluster into StackState, follow the steps described below:

1. Add the StackState helm repository to the local helm client:
    ```buildoutcfg
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
    ```

2. In the StackState UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Integrations` > `Kubernetes`.
3. Install a new instance of the Kubernetes StackPack:
    * Specify a **Kubernetes Cluster Name**
        * This name will be used to identify the cluster in StackState
    * Click **install**.
4. Deploy the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Cluster using the helm command provided in the StackState UI after you have installed the StackPack.
    * Once the Agents have been deployed, they will begin collecting data and push this to StackState

---

# KOPS

Set up a KOPS integration to collect topology, events, logs, change and metrics data from an KOPS cluster and make this available in StackState.

### Supported versions

| Supported Kubernetes Version |
|------------------------------|
| Kubernetes 1.28              |
| Kubernetes 1.27              |
| Kubernetes 1.26              |
| Kubernetes 1.25              |
| Kubernetes 1.24              |
| Kubernetes 1.23              |
| Kubernetes 1.22              |
| Kubernetes 1.21              |
| Kubernetes 1.20              |
| Kubernetes 1.19              |
| Kubernetes 1.18              |
| Kubernetes 1.17              |
| Kubernetes 1.16              |

### Supported runtime

| Supported runtime |
|--------------------|
| Docker             |
| ContainerD         |
| CRI-O              |

### Prerequisites for KOPS

To set up a StackState KOPS integration you need to have:

* An up-and-running KOPS Cluster.
* A recent version of Helm 3.
* A user with the permission to `create privileged pods`, `ClusterRoles` and `ClusterRoleBindings`:
    * ClusterRole and ClusterRoleBinding are needed to grant StackState Agents permissions to access the Kubernetes API.
    * StackState Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up a KOPS integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-amazon-eks).
{% endhint %}

To get data from a Kubernetes cluster into StackState, follow the steps described below:

1. Add the StackState helm repository to the local helm client:
    ```buildoutcfg
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
    ```

2. In the StackState UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Integrations` > `Kubernetes`.
3. Install a new instance of the Kubernetes StackPack:
    * Specify a **Kubernetes Cluster Name**
        * This name will be used to identify the cluster in StackState
    * Click **install**.
4. Deploy the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Cluster using the helm command provided in the StackState UI after you have installed the StackPack.
    * Once the Agents have been deployed, they will begin collecting data and push this to StackState

---

# Self-hosted

Set up a Self-hosted integration to collect topology, events, logs, change and metrics data from an Self-hosted cluster and make this available in StackState.

### Supported versions

| Supported Kubernetes Version |
|------------------------------|
| Kubernetes 1.28              |
| Kubernetes 1.27              |
| Kubernetes 1.26              |
| Kubernetes 1.25              |
| Kubernetes 1.24              |
| Kubernetes 1.23              |
| Kubernetes 1.22              |
| Kubernetes 1.21              |
| Kubernetes 1.20              |
| Kubernetes 1.19              |
| Kubernetes 1.18              |
| Kubernetes 1.17              |
| Kubernetes 1.16              |

### Supported runtime

| Supported runtime |
|--------------------|
| Docker             |
| ContainerD         |
| CRI-O              |

### Prerequisites for Self-hosted

To set up a StackState Self-hosted integration you need to have:

* An up-and-running Self-hosted Cluster.
* A recent version of Helm 3.
* A user with the permission to `create privileged pods`, `ClusterRoles` and `ClusterRoleBindings`:
    * ClusterRole and ClusterRoleBinding are needed to:
      * Grant StackState Agents permissions to access the Kubernetes API
      * Generate a secret for the mutating validation webhook which is part of [request tracing](/setup/agent/k8sTs-agent-request-tracing.md)
    * StackState Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up a self-hosted integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-amazon-eks).
{% endhint %}

To get data from a Kubernetes cluster into StackState, follow the steps described below:

1. Add the StackState helm repository to the local helm client:
    ```buildoutcfg
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
    ```

2. In the StackState UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Integrations` > `Kubernetes`.
3. Install a new instance of the Kubernetes StackPack:
    * Specify a **Kubernetes Cluster Name**
        * This name will be used to identify the cluster in StackState
    * Click **install**.
4. Deploy the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Cluster using the helm command provided in the StackState UI after you have installed the StackPack.
    * Once the Agents have been deployed, they will begin collecting data and push this to StackState

---


## What's next?

- [StackState walk-through](k8s-getting-started.md)
