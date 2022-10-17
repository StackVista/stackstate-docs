---
description: StackState Self-hosted v5.0.x 
---

# AAD Standalone Deployment

{% hint style="warning" %}
**This page describes StackState version 5.0.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/setup/install-stackstate/kubernetes_install/aad_standalone).
{% endhint %}

## Overview

The Autonomous Anomaly Detector \(AAD\) is a StackState service configured and deployed as a part of standard installation. In some cases the AAD can be deployed standalone using the AAD helm chart, e.g. when StackState and the AAD are deployed in separate kubernetes clusters. The standalone AAD deployment option is recommended only for the users with advanced knowledge of Kubernetes.

The Autonomous Anomaly Detector consists of two components: 

* The AAD Kubernetes service
* The AAD StackPack. 
  
The sections below explain how to configure the AAD Kubernetes service and the AAD StackPack in order to perform standalone deployment. Note that a [training period](#training-period) is required before the AAD can begin to report anomalies.

## Node sizing

A minimal deployment of the AAD Kubernetes service with the default options requires one of the following instance types:

* **Amazon EKS:** 1 instance of type `m4.xlarge`
* **Azure AKS:** 1 instance of type `F4s v2` \(Intel or AMD CPUs\)
* **Self-hosted Kubernetes:** 1 instance with 4 CPUs and 6 Gb memory

To handle more streams or to reduce detection latency, the service can be scaled. If you want to find out how to scale the service, contact [StackState support](https://support.stackstate.com/hc/en-us).

The AAD Kubernetes service is stateless and survives restarts. It can be relocated to a different Kubernetes node or bounced. To take full advantage of this capability, it is recommended to run the service on low cost AWS Spot Instances or Azure low-priority VMs.

## Installation

Standalone deployment consists of two steps: Install the AAD StackPack and install the AAD Kubernetes service.

### Install the AAD StackPack

Install the AAD StackPack from the StackPacks page in StackState.

### Install the AAD Kubernetes service

After installing the AAD StackPack, install the AAD Kubernetes service.

#### 1. Get access to quay.io

To be able to pull the Docker image, you will need access to quay.io. Access credentials can be requested from [StackState support](https://support.stackstate.com/hc/en-us).

#### 2. Install Helm

1. Install Helm \(version 3\). See the Helm docs [https://helm.sh/docs/intro/install](https://helm.sh/docs/intro/install/)
2. Add the StackState Helm repo:

   ```text
    helm repo add stackstate https://helm.stackstate.io`
   ```

#### 3. Get the latest AAD Kubernetes service Helm Chart

```text
    helm fetch stackstate/anomaly-detection
```

#### 4. Configure the AAD Kubernetes service

Create the file `values.yaml` file, including the configuration described below, and save it to disk:

* **image:**
  * **pullSecretUsername** - the image registry username \(from step 1\).
* **stackstate:**
  * **instance** - the StackState instance URL. This must be a StackState internal URL to keep traffic inside the Kubernetes network and namespace. e.g `http://stackstate-router:8080/` or `http://<releasename>-stackstate-router:8080/`

{% tabs %}
{% tab title="values.yaml" %}
```text
image:
    pullSecretUsername: <image registry username>

stackstate:
    # Stackstate instance URL
    instance: <stackstate instance url>
```
{% endtab %}
{% endtabs %}

Details of all configuration options are available in the anomaly-detection chart with the command below.

```text
    helm show all stackstate/anomaly-detection
```

#### 5. Authentication with StackState

By default, the AAD Kubernetes Service is configured to use kubernetes `token` authentication, so one does not need to configure anything additional to that the AAD Kubernetes service must be installed into the same cluster and namespace as StackState. If this is is not possible there are two other options for authentication:

* Stackstate Api Token authentication. One can obtain token from User Profile page.

  ```text
      ...
  stackstate:
    authType: api-token
    apiToken: <stackstate api token>
  ...

* Cookie authentication. This type of auth is not recommended and exists only for troubleshooting/testing purposes.

  ```text
      ...
  stackstate:
    authType: cookie
    username: <username>
    password: <password>
      ...
  ```

#### 6. Install the AAD Kubernetes service

Run the command below, specifying the StackState namespace and the image registry password. Note that the AAD Kubernetes service must be installed in the same namespace as StackState to be able to use default token authentication \(Otherwise consider other types of authentication above\).

  ```text
  helm upgrade anomaly-detector stackstate/anomaly-detection \
      --install \
      --namespace <stackstate-namespace> \
      --set image.pullSecretPassword=<image registry password>
      --values ./values.yaml
  ```

### Training period

The AAD will need to train on your data before it can begin reporting anomalies. With data collected in 1 minute buckets, the AAD requires a 2 hour training period. If historic data exists for relevant metric streams, this will also be used for training the AAD. In this case, the first results can be expected within an hour. Up to a day of data is used for training. After the initial training, the AAD will continuously refine its model and adapt to changes in the data.

## Upgrade a standalone AAD instance

Upgrading a standalone AAD instance consists of two steps: Upgrade the AAD Stackpack and upgrade the AAD Kubernetes Service.

### Upgrade the AAD StackPack

When new version of StackPack is available you can simply click **UPGRADE** on the AAD StackPack page.

### Upgrade the AAD Kubernetes service

The AAD Kubernetes service upgrade is driven by availability of the new version of the helm chart therefore for upgrading one can follow the steps starting from step 3 - fetching new AAD chart.

## Deactivate the AAD instance

To deactivate the AAD, uninstall the AAD StackPack. The AAD Kubernetes service will continue running and reserve its compute resources, but anomaly detection will not be executed.

To re-enable the AAD Kubernetes service, you can simply install the AAD StackPack again. It is not necessary to repeat the installation of the AAD Kubernetes service.

## Full uninstall

To completely remove the AAD Kubernetes service and the AAD StackPack:

* Uninstall the AAD Kubernetes service:

  ```text
  helm delete anomaly-detector
  ```

* Uninstall the AAD StackPack

## See also

* [Autonomous Anomaly Detector StackPack](../../../stackpacks/add-ons/aad.md)

