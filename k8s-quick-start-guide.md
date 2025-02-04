---
description: SUSE Observability
---

# SUSE Observability quick start guides

## Overview

When your SUSE Observability SaaS instance has been set up and configured, you will receive an email from SUSE Observability
with the required login details. This quick start guide will help you get started and get your own data into
your SUSE Observability SaaS instance.

To integrate your cluster(s) with SUSE Observability you can follow one of these guides for your appropriate environment.
* [Amazon EKS](#amazon-eks)
* [Azure AKS](#azure-aks)
* [Google GKE](#google-gke)
* [Kubernetes](#kubernetes)
* [KOPS](#kops)
* [OpenShift](#openshift)
* [Self-hosted](#self-hosted)

---

# Kubernetes

Set up a Kubernetes integration to collect topology, events, logs, change and metrics data from a Kubernetes cluster and make this available in SUSE Observability.

### Supported versions

| Supported Kubernetes Version |
|------------------------------|
| Kubernetes 1.32              |
| Kubernetes 1.31              |
| Kubernetes 1.30              |
| Kubernetes 1.29              |
| Kubernetes 1.28              |
| Kubernetes 1.27              |
| Kubernetes 1.26              |
| Kubernetes 1.25              |
| Kubernetes 1.24              |
| Kubernetes 1.23              |
| Kubernetes 1.22              |
| Kubernetes 1.21              |

### Supported runtime

| Supported runtime   |
|---------------------|
| ContainerD          |
| CRI-O               |

### Prerequisites for Kubernetes

To set up a SUSE Observability Kubernetes integration you need to have:

* An up-and-running Kubernetes Cluster.
* Helm version 3.13.1 or higher.
* A user with the permission to `create privileged pods`, `ClusterRoles` and `ClusterRoleBindings`:
  * ClusterRole and ClusterRoleBinding are needed to grant SUSE Observability Agents permissions to access the Kubernetes API.
  * SUSE Observability Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up a Kubernetes integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-kubernetes).
{% endhint %}

To get data from a Kubernetes cluster into SUSE Observability, follow the steps described below:

1. Add the SUSE Observability helm repository to the local helm client:
    ```buildoutcfg
    helm repo add suse-observability https://charts.rancher.com/server-charts/prime/suse-observability
    helm repo update
    ```

2. In the SUSE Observability UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Integrations` > `Kubernetes`.
3. Install a new instance of the Kubernetes StackPack:
   * Specify a **Kubernetes Cluster Name**
     * This name will be used to identify the cluster in SUSE Observability
   * Click **install**.
4. Deploy the SUSE Observability Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Cluster using the helm command provided in the SUSE Observability UI after you have installed the StackPack.
   * Once the Agents have been deployed, they will begin collecting data and push this to SUSE Observability

{% hint style="warning" %}
When running on a self-hosted air-gapped environment prepare the agent installation first with the [air-gapped instructions](./k8s-suse-rancher-prime-agent-air-gapped.md).
{% endhint %}
---

# OpenShift

Set up an OpenShift integration to collect topology, events, logs, change and metrics data from a OpenShift cluster and make this available in SUSE Observability.

### Supported versions
[comment]: <> (https://access.redhat.com/support/policy/updates/openshift)

| OpenShift Version | Supported Kubernetes Version | OpenShift End of Support |
|-------------------|------------------------------|--------------------------|
| OpenShift 4.17    | Kubernetes 1.30              | April 1, 2026            |
| OpenShift 4.16    | Kubernetes 1.29              | December 27, 2025        |
| OpenShift 4.15    | Kubernetes 1.28              | August 27, 2025          |
| OpenShift 4.14    | Kubernetes 1.27              | May 1, 2025              |
| OpenShift 4.13    | Kubernetes 1.26              | November 17, 2024        |
| OpenShift 4.12    | Kubernetes 1.25              | July 17, 2024            |
| OpenShift 4.11    | Kubernetes 1.24              | February 10, 2024        |
| OpenShift 4.10    | Kubernetes 1.23              | September 10, 2023       |
| OpenShift 4.9     | Kubernetes 1.22              | April 18, 2023           |

### Supported runtime

| Supported runtime   |
|---------------------|
| ContainerD          |
| CRI-O               |


### Prerequisites for OpenShift

To set up a SUSE Observability OpenShift integration you need to have:

* An up-and-running OpenShift Cluster.
* Helm version 3.13.1 or higher.
* A user with the permission to `create privileged pods`, `ClusterRoles` and `ClusterRoleBindings`:
  * ClusterRole and ClusterRoleBinding are needed to grant SUSE Observability Agents permissions to access the Kubernetes API.
  * SUSE Observability Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up an OpenShift integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-openshift).
{% endhint %}

To get data from a Kubernetes cluster into SUSE Observability, follow the steps described below:

1. Add the SUSE Observability helm repository to the local helm client:
    ```buildoutcfg
    helm repo add suse-observability https://charts.rancher.com/server-charts/prime/suse-observability
    helm repo update
    ```

2. In the SUSE Observability UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Integrations` > `Kubernetes`.
3. Install a new instance of the Kubernetes StackPack:
   * Specify a **Kubernetes Cluster Name**
     * This name will be used to identify the cluster in SUSE Observability
   * Click **install**.
4. Deploy the SUSE Observability Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Cluster using the helm command provided in the SUSE Observability UI after you have installed the StackPack.
   * Once the Agents have been deployed, they will begin collecting data and push this to SUSE Observability

---

# Amazon EKS

Set up an Amazon EKS integration to collect topology, events, logs, change and metrics data from an Amazon EKS cluster and make this available in SUSE Observability.

### Supported versions
[comment]: <> (https://endoflife.date/amazon-eks)
[comment]: <> (https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html#kubernetes-release-calendar)

| Kubernetes version | Amazon EKS release | Amazon EKS End of Support | Amazon EKS End of Extended Support |
|--------------------|--------------------|---------------------------|------------------------------------|
| 1.32               | January 23, 2025   | March 23, 2026            | March 23, 2027                     |
| 1.31               | September 26, 2024 | November 26, 2025         | November 26, 2026                  |
| 1.30               | May 23, 2024       | July 23, 2025             | July 23, 2026                      |
| 1.29               | January 23, 2024   | March 23, 2025            | March 23, 2026                     |
| 1.28               | September 26, 2023 | November 01, 2024         | November 26, 2025                  |
| 1.27               | May 24, 2023       | July 2024                 | July 24, 2025                      |
| 1.26               | April 11, 2023     | June 2024                 | June 11, 2025                      |
| 1.25               | February 21, 2023  | May 2024                  | May 1, 2025                        |
| 1.24               | November 15, 2022  | January 2024              | January 31, 2025                   |
| 1.23               | August 11, 2022    | October 11, 2023          | October 11, 2024                   |
| 1.22               | April 4, 2022      | June 4, 2023              | September 1, 2024                  |
| 1.21               | July 19, 2021      | February 15, 2023         | July 15, 2024                      |
| 1.20               | May 18, 2021       | November 1, 2022          | N/A                                |
| 1.19               | February 16, 2021  | August 1, 2022            | N/A                                |
| 1.18               | October 13, 2020   | August 15, 2022           | N/A                                |

### Supported runtime

| Supported runtime  |
|--------------------|
| ContainerD         |
| CRI-O              |

### Prerequisites for Amazon EKS

To set up a SUSE Observability Amazon EKS integration you need to have:

* An up-and-running Amazon EKS Cluster.
* Helm version 3.13.1 or higher.
* A user with the permission to `create privileged pods`, `ClusterRoles` and `ClusterRoleBindings`:
    * ClusterRole and ClusterRoleBinding are needed to grant SUSE Observability Agents permissions to access the Kubernetes API.
    * SUSE Observability Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up an Amazon EKS integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-amazon-eks).
{% endhint %}

To get data from a Kubernetes cluster into SUSE Observability, follow the steps described below:

1. Add the SUSE Observability helm repository to the local helm client:
    ```buildoutcfg
    helm repo add suse-observability https://charts.rancher.com/server-charts/prime/suse-observability
    helm repo update
    ```

2. In the SUSE Observability UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Integrations` > `Kubernetes`.
3. Install a new instance of the Kubernetes StackPack:
    * Specify a **Kubernetes Cluster Name**
        * This name will be used to identify the cluster in SUSE Observability
    * Click **install**.
4. Deploy the SUSE Observability Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Cluster using the helm command provided in the SUSE Observability UI after you have installed the StackPack.
    * Once the Agents have been deployed, they will begin collecting data and push this to SUSE Observability

---

# Google GKE

Set up a Google GKE integration to collect topology, events, logs, change and metrics data from an Google GKE cluster and make this available in SUSE Observability.

### Supported versions
[comment]: <> (https://endoflife.date/google-kubernetes-engine)
[comment]: <> (https://cloud.google.com/kubernetes-engine/docs/release-schedule)

| Kubernetes Version | Google GKE release | Google GKE End of Support | Google GKE End of Extended Support |
|--------------------|--------------------|---------------------------|------------------------------------|
| 1.32               | February, 2025     | Q2, 2026                  | Q1, 2027                           |
| 1.31               | October 22, 2024   | December 22, 2025         | October 22, 2026                   |
| 1.30               | July 30, 2024      | September 30, 2025        | July 30, 2026                      |
| 1.29               | January 25, 2024   | March 21, 2025            | January 25, 2026                   |
| 1.28               | December 4, 2023   | February 4, 2025          | December 4, 2025                   |
| 1.27               | June 14, 2023      | August 31, 2024           | June 14, 2025                      |
| 1.26               | April 14, 2023     | June 30, 2024             | N/A                                |


### Supported runtime

| Supported runtime  |
|--------------------|
| ContainerD         |
| CRI-O              |

### Prerequisites for Google GKE

To set up a SUSE Observability Google GKE integration you need to have:

* An up-and-running Google GKE Cluster.
* Helm version 3.13.1 or higher.
* A user with the permission to `create privileged pods`, `ClusterRoles` and `ClusterRoleBindings`:
    * ClusterRole and ClusterRoleBinding are needed to grant SUSE Observability Agents permissions to access the Kubernetes API.
    * SUSE Observability Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up a Google GKE integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-amazon-eks).
{% endhint %}

To get data from a Kubernetes cluster into SUSE Observability, follow the steps described below:

1. Add the SUSE Observability helm repository to the local helm client:
    ```buildoutcfg
    helm repo add suse-observability https://charts.rancher.com/server-charts/prime/suse-observability
    helm repo update
    ```

2. In the SUSE Observability UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Integrations` > `Kubernetes`.
3. Install a new instance of the Kubernetes StackPack:
    * Specify a **Kubernetes Cluster Name**
        * This name will be used to identify the cluster in SUSE Observability
    * Click **install**.
4. Deploy the SUSE Observability Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Cluster using the helm command provided in the SUSE Observability UI after you have installed the StackPack.
    * Once the Agents have been deployed, they will begin collecting data and push this to SUSE Observability

---

# Azure AKS

Set up an Azure AKS integration to collect topology, events, logs, change and metrics data from an Azure AKS cluster and make this available in SUSE Observability.

### Supported versions
[comment]: <> (https://endoflife.date/azure-kubernetes-service)
[comment]: <> (https://learn.microsoft.com/en-us/azure/aks/supported-kubernetes-versions?tabs=azure-cli#aks-kubernetes-release-calendar)

| Kubernetes Version | AKS GA        | Azure AKS End of Life | Platform support |
|--------------------|---------------|-----------------------|------------------|
| 1.32               | June 2024     | March 2026            | Until 1.36 GA    |
| 1.31               | November 2024 | November 2025         | Until 1.35 GA    |
| 1.30               | June 2024     | July 2025             | Until 1.34 GA    |
| 1.29               | March 2024    | Januanry 2025         | Until 1.33 GA    |
| 1.28               | November 2023 | November 2024         | Until 1.32 GA    |
| 1.27               | July 2023     | July  2024            | July 2025        |

### Supported runtime

| Supported runtime  |
|--------------------|
| ContainerD         |
| CRI-O              |

### Prerequisites for Azure AKS

To set up a SUSE Observability Azure AKS integration you need to have:

* An up-and-running Azure AKS Cluster.
* Helm version 3.13.1 or higher.
* A user with the permission to `create privileged pods`, `ClusterRoles` and `ClusterRoleBindings`:
    * ClusterRole and ClusterRoleBinding are needed to grant SUSE Observability Agents permissions to access the Kubernetes API.
    * SUSE Observability Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up a Azure AKS integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-amazon-eks).
{% endhint %}

To get data from a Kubernetes cluster into SUSE Observability, follow the steps described below:

1. Add the SUSE Observability helm repository to the local helm client:
    ```buildoutcfg
    helm repo add suse-observability https://charts.rancher.com/server-charts/prime/suse-observability
    helm repo update
    ```

2. In the SUSE Observability UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Integrations` > `Kubernetes`.
3. Install a new instance of the Kubernetes StackPack:
    * Specify a **Kubernetes Cluster Name**
        * This name will be used to identify the cluster in SUSE Observability
    * Click **install**.
4. Deploy the SUSE Observability Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Cluster using the helm command provided in the SUSE Observability UI after you have installed the StackPack.
    * Once the Agents have been deployed, they will begin collecting data and push this to SUSE Observability

---

# KOPS

Set up a KOPS integration to collect topology, events, logs, change and metrics data from an KOPS cluster and make this available in SUSE Observability.

### Supported versions

| Supported Kubernetes Version |
|------------------------------|
| Kubernetes 1.32              |
| Kubernetes 1.31              |
| Kubernetes 1.30              |
| Kubernetes 1.29              |
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

| Supported runtime   |
|---------------------|
| ContainerD          |
| CRI-O               |

### Prerequisites for KOPS

To set up a SUSE Observability KOPS integration you need to have:

* An up-and-running KOPS Cluster.
* Helm version 3.13.1 or higher.
* A user with the permission to `create privileged pods`, `ClusterRoles` and `ClusterRoleBindings`:
    * ClusterRole and ClusterRoleBinding are needed to grant SUSE Observability Agents permissions to access the Kubernetes API.
    * SUSE Observability Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up a KOPS integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-amazon-eks).
{% endhint %}

To get data from a Kubernetes cluster into SUSE Observability, follow the steps described below:

1. Add the SUSE Observability helm repository to the local helm client:
    ```buildoutcfg
    helm repo add suse-observability https://charts.rancher.com/server-charts/prime/suse-observability
    helm repo update
    ```

2. In the SUSE Observability UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Integrations` > `Kubernetes`.
3. Install a new instance of the Kubernetes StackPack:
    * Specify a **Kubernetes Cluster Name**
        * This name will be used to identify the cluster in SUSE Observability
    * Click **install**.
4. Deploy the SUSE Observability Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Cluster using the helm command provided in the SUSE Observability UI after you have installed the StackPack.
    * Once the Agents have been deployed, they will begin collecting data and push this to SUSE Observability

---

# Self-hosted

Set up a Self-hosted integration to collect topology, events, logs, change and metrics data from an Self-hosted cluster and make this available in SUSE Observability.

### Supported versions

| Supported Kubernetes Version |
|------------------------------|
| Kubernetes 1.32              |
| Kubernetes 1.31              |
| Kubernetes 1.30              |
| Kubernetes 1.29              |
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

| Supported runtime   |
|---------------------|
| ContainerD          |
| CRI-O               |

### Prerequisites for Self-hosted

To set up a SUSE Observability Self-hosted integration you need to have:

* An up-and-running Self-hosted Cluster.
* Helm version 3.13.1 or higher.
* A user with the permission to `create privileged pods`, `ClusterRoles` and `ClusterRoleBindings`:
    * ClusterRole and ClusterRoleBinding are needed to:
      * Grant SUSE Observability Agents permissions to access the Kubernetes API
      * Generate a secret for the mutating validation webhook which is part of [request tracing](/setup/agent/k8sTs-agent-request-tracing.md)
    * SUSE Observability Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up a self-hosted integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-amazon-eks).
{% endhint %}

To get data from a Kubernetes cluster into SUSE Observability, follow the steps described below:

1. Add the SUSE Observability helm repository to the local helm client:
    ```buildoutcfg
    helm repo add suse-observability https://charts.rancher.com/server-charts/prime/suse-observability
    helm repo update
    ```

2. In the SUSE Observability UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Integrations` > `Kubernetes`.
3. Install a new instance of the Kubernetes StackPack:
    * Specify a **Kubernetes Cluster Name**
        * This name will be used to identify the cluster in SUSE Observability
    * Click **install**.
4. Deploy the SUSE Observability Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Cluster using the helm command provided in the SUSE Observability UI after you have installed the StackPack.
    * Once the Agents have been deployed, they will begin collecting data and push this to SUSE Observability

---


## What's next?

- [SUSE Observability walk-through](k8s-getting-started.md)
