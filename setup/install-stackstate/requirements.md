---
description: SUSE Observability Self-hosted
---

# Requirements

## Overview

Requirements for [SUSE Observability client \(browser\)](#client-browser) can be found at the bottom of the page.

## Kubernetes and OpenShift

### Supported versions

SUSE Observability can be installed on a Kubernetes or OpenShift cluster using the Helm charts provided by SUSE Observability. These Helm charts require Helm v3.x to install and are supported on:
* **Kubernetes:** 1.21 to 1.30
* **OpenShift:** 4.9 to 4.14

### Resource requirements

There are different installation options available for SUSE Observability. It is possible to install SUSE Observability either in a High-Availability (HA) or single instance (non-HA) setup. The non-HA setup is recommended for testing purposes only. For production environments, it is recommended to install SUSE Observability in a HA setup. For a standard, production, deployment, the SUSE Observability Helm chart will deploy many services in a redundant setup with 3 instances of each service.

In the table below you can find the resource requirements for the different installation options. For the HA setup you can find different installation profiles depending on the size of the environment being observed.

| | 10 non-HA | 20 non-HA | 50 non-HA | 100 non-HA | 150 HA | 250 HA | 500 HA |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **CPU Requests** | 7,5 | 10,5 | 15 | 25 | 49 | 62 | 86.5 |
| **CPU Limits** | 16 | 21,5 | 30,5 | 50 | 103 | 128 | 176 |
| **Memory Requests** | 22Gi | 28Gi | 32.5Gi | 126.5Gi | 67Gi | 143Gi | 161.5Gi |
| **Memory Limits** | 23Gi | 29Gi | 33Gi | 51,5Gi | 131Gi | 147.5Gi | 166Gi |

These are just the upper and lower bounds of the resources that can be consumed by SUSE Observability in the different installation options. The actual resource usage will depend on the features used, configured resource limits and dynamic usage patterns, such as Deployment or DaemonSet scaling. For our Self-hosted customers, we recommend to start with the default requirements and monitor the resource usage of the SUSE Observability components.

{% hint style="info" %}
The minimum requirements do not include spare CPU/Memory capacity to ensure smooth application rolling updates.
{% endhint %}

For installation of SUSE Observability please follow the installation instructions provided below:
- [Kubernetes](/setup/install-stackstate/kubernetes_openshift/kubernetes_install.md)
- [OpenShift](/setup/install-stackstate/kubernetes_openshift/openshift_install.md)

### Storage

SUSE Observability uses persistent volume claims for the services that need to store data. The default storage class for the cluster will be used for all services unless this is overridden by values specified on the command line or in a `values.yaml` file. All services come with a pre-configured volume size that should be good to get you started, but can be customized later using variables as required.

For our different installation profiles, the following are the defaulted storage requirements:

| | trial | 10 non-HA | 20 non-HA | 50 non-HA | 100 non-HA | 150 HA | 250 HA | 500 HA |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Retention (days)** | 3 | 30 | 30 | 30 | 30 | 30 | 30 | 30 |
| **Storage requirement** | 125GB | 280GB | 420GB | 420GB | 600GB | 2TB | 2TB | 2.5TB |

{% hint style="info" %}
The storage estimates presented take into account a default of 14 days of retention for NONHA and 1 month for HA installations. For short lived test instances the storage sizes can be further reduced.
{% endhint %}

For more details on the defaults used, see the page [Configure storage](/setup/install-stackstate/kubernetes_openshift/storage.md).

### Ingress

By default, the SUSE Observability Helm chart will deploy a router pod and service. This service's port `8080` is the only entry point that needs to be exposed via Ingress. You can access SUSE Observability without configuring Ingress by forwarding this port:

```text
kubectl port-forward service/<helm-release-name>-stackstate-k8s-router 8080:8080 --namespace stackstate
```

When configuring Ingress, make sure to allow for large request body sizes \(50MB\) that may be sent occasionally by data sources like the SUSE Observability Agent or the AWS integration.

For more details on configuring Ingress, have a look at the page [Configure Ingress docs](/setup/install-stackstate/kubernetes_openshift/ingress.md).

### Namespace resource limits

It isn't recommended to set a ResourceQuota as this can interfere with resource requests. The resources required by SUSE Observability will vary according to the features used, configured resource limits and dynamic usage patterns, such as Deployment or DaemonSet scaling.

If it's necessary to set a ResourceQuota for your implementation, the namespace resource limit should be set to match the node [sizing requirements](requirements.md#resource-requirements).

## Client \(browser\)

To use the SUSE Observability GUI, you must use one of the following web browsers:

* Chrome
* Firefox
