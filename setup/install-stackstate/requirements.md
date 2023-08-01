---
description: StackState for Kubernetes troubleshooting Self-hosted
---

# Requirements

## Overview

Requirements for [StackState client \(browser\)](#client-browser) can be found at the bottom of the page.

## Kubernetes and OpenShift

### Supported versions

StackState can be installed on a Kubernetes or OpenShift cluster using the Helm charts provided by StackState. These Helm charts require Helm v3.x to install and are supported on:
* **Kubernetes:** 1.21 to 1.27
* **Amazon Elastic Kubernetes Service (EKS):** 1.20 to 1.27
* **Azure Kubernetes Service (AKS):** 1.20 to 1.26
* **Google Kubernetes Engine (GKE):** 1.21 to 1.27
* **OpenShift:** 4.9 to 4.11

### Resource requirements

For a standard, production, deployment, the StackState Helm chart will deploy backend services in a redundant setup with 3 instances of each service. The number of nodes required for environments with out-of-the-box settings are listed below, note that these may change based on system tuning:

{% tabs %}
{% tab title="Recommended setup" %}

{% hint style="info" %}
The recommended requirements include spare CPU/Memory capacity to ensure smooth application rolling update.
{% endhint %}

Requirements for the recommended high availability setup with backups enabled:

* Node requirements: minimum 8 vCPUs, minimum 32GB memory
* Total of 25 vCPUs available for StackState
* Total of 120 GB memory available for StackState
* Total of 2 TB disk space for data storing services (doesn't include disk space required for backups)

{% endtab %}

{% tab title="Minimal setup" %}
Requirements for the minimal high availability setup with backups enabled:

* Node requirements: minimum 8 vCPUs, minimum 32GB memory
* Total of 18 vCPUs available for StackState
* Total of 98 GB memory available for StackState
* Total of 2 TB disk space for data storing services (doesn't include disk space required for backups)

{% endtab %}

{% tab title="Non-high availability setup" %}
Optionally, a [non-high availability setup](/setup/install-stackstate/kubernetes_openshift/non_high_availability_setup.md) can be configured which has the requirements listed below.

**Recommended setup** 

{% hint style="info" %}
The recommended requirements include spare CPU/Memory capacity to ensure smooth application rolling update.
{% endhint %}

Requirements for the recommended non-high availability setup:

* Node requirements: minimum 8 vCPUs, minimum 32GB memory
* Total of 21 vCPUs available for StackState
* Total of 60 GB memory available for StackState
* Total of 950 GB disk space for data storing services

**Minimal setup**

Requirements for the minimal non-high availability setup:

* Node requirements: minimum 8 vCPUs, minimum 32GB memory
* Total of 14 vCPUs available for StackState
* Total of 60 GB memory available for StackState
* Total of 950 GB disk space for data storing services

{% endtab %}
{% endtabs %}

### Storage

StackState uses persistent volume claims for the services that need to store data. The default storage class for the cluster will be used for all services unless this is overridden by values specified on the command line or in a `values.yaml` file. All services come with a pre-configured volume size that should be good to get you started, but can be customized later using variables as required.

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
