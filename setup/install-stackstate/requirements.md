---
description: StackState for Kubernetes troubleshooting Self-hosted
---

# Requirements

## Overview

Requirements for [StackState client \(browser\)](#client-browser) can be found at the bottom of the page.

## Kubernetes and OpenShift

### Supported versions

StackState can be installed on a Kubernetes or OpenShift cluster using the Helm charts provided by StackState. These Helm charts require Helm v3.x to install and are supported on:
* **Kubernetes:** 1.16 to 1.27
* **Amazon Elastic Kubernetes Service (EKS):** 1.26 to 1.27
* **Azure Kubernetes Service (AKS):** 1.27 to 1.27
* **Google Kubernetes Engine (GKE):** 1.26 to 1.27
* **OpenShift:** 4.9 to 4.14

### Resource requirements

There are different installation options available for StackState. It is possible to install StackState either in a High-Availability (HA) or single instance (non-HA) setup. The non-HA setup is recommended for testing purposes only. For production environments, it is recommended to install StackState in a HA setup. For a standard, production, deployment, the StackState Helm chart will deploy many services in a redundant setup with 3 instances of each service.

In the table below you can find the resource requirements for the different installation options. For the HA setup you can find different installation profiles depending on the size of the environment being observed.

| | non-HA | HA - small profile | HA - default profile |
| --- | --- | --- | --- |
| **CPU Requests** | 11 | 14,5 | 16,5 |
| **CPU Limits** | 31,5 | 50 | 50 |
| **Memory Requests** | 55Gi | 67Gi | 87Gi |
| **Memory Limits** | 55Gi | 89Gi | 92Gi |

These are just the upper and lower bounds of the resources that can be consumed by StackState in the different installation options. The actual resource usage will depend on the features used, configured resource limits and dynamic usage patterns, such as Deployment or DaemonSet scaling. For our Self-hosted customers, we recommend to start with the default requirements and monitor the resource usage of the StackState components.

{% hint style="info" %}
The minimum requirements do not include spare CPU/Memory capacity to ensure smooth application rolling updates.
{% endhint %}

For installation of StackState please follow the installation instructions provided below:
- [Kubernetes](/setup/install-stackstate/kubernetes_openshift/kubernetes_install.md)
- [OpenShift](/setup/install-stackstate/kubernetes_openshift/openshift_install.md)
- [Non-high availability setup](/setup/install-stackstate/kubernetes_openshift/non_high_availability_setup.md)
- [Small profile setup](/setup/install-stackstate/kubernetes_openshift/small_profile_setup.md)

### Storage

StackState uses persistent volume claims for the services that need to store data. The default storage class for the cluster will be used for all services unless this is overridden by values specified on the command line or in a `values.yaml` file. All services come with a pre-configured volume size that should be good to get you started, but can be customized later using variables as required.

For our different installation profiles, the following are the defaulted storage requirements:

| | non-HA | HA - small profile | HA - default profile |
| --- | --- | --- | --- |
| **Storage requirement** | 950GB | 2TB | 2TB |

For more details on the defaults used, see the page [Configure storage](/setup/install-stackstate/kubernetes_openshift/storage.md).

### Ingress

By default, the StackState Helm chart will deploy a router pod and service. This service's port `8080` is the only entry point that needs to be exposed via Ingress. You can access StackState without configuring Ingress by forwarding this port:

```text
kubectl port-forward service/<helm-release-name>-stackstate-k8s-router 8080:8080 --namespace stackstate
```

When configuring Ingress, make sure to allow for large request body sizes \(50MB\) that may be sent occasionally by data sources like the StackState Agent or the AWS integration.

For more details on configuring Ingress, have a look at the page [Configure Ingress docs](/setup/install-stackstate/kubernetes_openshift/ingress.md).

### Namespace resource limits

It isn't recommended to set a ResourceQuota as this can interfere with resource requests. The resources required by StackState will vary according to the features used, configured resource limits and dynamic usage patterns, such as Deployment or DaemonSet scaling.

If it's necessary to set a ResourceQuota for your implementation, the namespace resource limit should be set to match the node [sizing requirements](requirements.md#resource-requirements).

## Client \(browser\)

To use the StackState GUI, you must use one of the following web browsers:

* Chrome
* Firefox
