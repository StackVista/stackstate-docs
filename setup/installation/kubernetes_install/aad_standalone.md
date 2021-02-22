---
description: Standalone Deployment of Autonomous Anomaly Detector Kubernetes Service
---

## Overview

Autonomous Anomaly Detector (AAD) is a StackState service deployed as a part of standard installation. In exceptional cases it is possible to install the standalone AAD Kubernetes service. This is recommended only for the users with advanced knowledge of Kubernetes. The sections below explain how to prepare and perform standalone AAD deployment.

## Node sizing

A minimal deployment of the AAD Kubernetes service with the default options requires one of the following instance types:

* Amazon EKS: 1 instance of type `m4.xlarge`
* Azure AKS: 1 instance of type `F4s v2` \(Intel or AMD CPUs\)
* Self-hosted Kubernetes: 1 instance with 4 CPUs and 6 Gb memory

To handle more streams or to reduce detection latency, the service can be scaled. If you want to find out how to scale the service, contact [StackState support](https://support.stackstate.com/hc/en-us).

The AAD Kubernetes service is stateless and survives restarts. It can be relocated on a different Kubernetes node or bounced. To take full advantage of this capability it is recommended to run the service on low cost AWS Spot Instances and Azure Low Priority VM.

## Installation

### Install the Autonomous Anomaly Detector \(AAD\) StackPack

Install the AAD StackPack from the StackPacks page in StackState.

{% hint style="info" %}
To use the AAD StackPack, the AAD Kubernetes service must also be installed.
{% endhint %}

### Install the Autonomous Anomaly Detector \(AAD\) Kubernetes service

After installing the AAD StackPack, install the AAD Kubernetes service.

#### 1. Get access to quay.io

To be able to pull the Docker image, you will need access to quay.io. Access credentials can be requested from [StackState support](https://support.stackstate.com/hc/en-us).

#### 2. Install Helm

* Install Helm \(version 3\). See the Helm docs [https://helm.sh/docs/intro/install](https://helm.sh/docs/intro/install/)
* Add the StackState Helm repo:

```text
helm repo add stackstate https://helm.stackstate.io`
```

#### 3. Get the latest AAD Kubernetes service helm chart

```text
helm fetch stackstate/anomaly-detection
```

#### 4. Configure AAD Kubernetes service

Create the file `values.yaml` file including the configuration described below and save it to disk:

* **image:**
  * **pullSecretUsername** - the image registry username \(from step 1\)
* **stackstate:**
  * **instance** - the StackState instance URL. This must be a StackState internal URL to keep traffic inside the Kubernetes network and namespace. e.g `http://stackstate-router:8080/` or `http://<releasename>-stackstate-router:8080/`
* **ingress:** - Ingress provides access to the technical interface of the AAD Kubernetes service, this is useful for troubleshooting. The technical interface can be accessed using kube proxy command: `kubectl proxy`. After proxy is running the technical interface can be accessed using the path below.
```text
http://localhost:8001/api/v1/namespaces/<namespace>/services/http:<release-name>-anomaly-detection:8090/proxy/
```
Optionally technical interface can be exposed using ingress configuration. The example below shows how to configure an nginx-ingress controller. Setting up the controller itself is beyond the scope of this document. More information about how to set up Ingress can be found at:
  * [AKS](https://docs.microsoft.com/en-us/azure/aks/ingress-tls)
  * [EKS Official docs](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html) \(not using nginx\)
  * [EKS blog post](https://aws.amazon.com/blogs/opensource/network-load-balancer-nginx-ingress-controller-eks/) \(using nginx\)

{% tabs %}
{% tab title="values.yaml" %}
```text
image:
    pullSecretUsername: <image registry username>

stackstate:
    # Stackstate instance URL
    instance: <stackstate instance url>

# status UI ingress (the configuration below is example for nginx ingress controller)
ingress:
    enabled: true
    hostname: <domain name> # e.g. spotlight.domain.com
    port: 8090              # status page will be available on spotlight.domain.com:8090
    annotations:        
        external-dns.alpha.kubernetes.io/hostname: <domain name> # e.g. spotlight.domain.com
        kubernetes.io/ingress.class: nginx
        nginx.ingress.kubernetes.io/ingress.class: nginx
    hosts:
        - host: <domain name>  # e.g. spotlight.domain.com
```
{% endtab %}
{% endtabs %}

Details of all configuration options are available in the anomaly-detection chart documentation.

```text
helm show all stackstate/anomaly-detection
```

#### 5. Authentication with StackState

By default, AAD Kubernetes Service is configured to use kubernetes `token` authentication, so one does not need to configure anything additional to that AAD Kubernetes service must be installed into the same cluster and namespace as StackState. If this is is not possible there are two other options for authentication:
* Stackstate Api Token authentication. One can obtain token from User Profile page.
```
    ...
stackstate:
  authType: api-token
  apiToken: <stackstate api token>
    ...
```
* Cookie authentication. This type of auth is not recommended and exists only for troubleshooting/testing purposes.
```
    ...
stackstate:
  authType: cookie
  username: <username>
  password: <password>
    ...
```

#### 6. Install the AAD Kubernetes service

Run the command below, specifying the StackState namespace and the image registry password. Note that the AAD Kubernetes service must be installed in the same namespace as StackState to be able to use default token authentication (Otherwise consider other types of authentication above).

```text
helm upgrade anomaly-detector stackstate/anomaly-detection \
    --install \
    --namespace <stackstate-namespace> \
    --set image.pullSecretPassword=<image registry password>
    --values ./values.yaml
```

## Upgrade the AAD Kubernetes service

The AAD Kubernetes service is released and upgraded together with StackState. In case of standalone installation the service upgrade is driven by availability of the new version of the helm chart therefore for upgrading one can follow the steps starting from step 3 - fetching new AAD chart.

## Deactivate the AAD Kubernetes service

To deactivate the AAD Kubernetes service, uninstall the AAD StackPack. The AAD Kubernetes service will continue to run and reserve its compute resources, but anomaly detection will not be executed.

To re-enable the AAD Kubernetes service, you can simply install the AAD StackPack again. It is not necessary to repeat the installation of the AAD Kubernetes service.

## Full uninstall

* Uninstall the AAD Kubernetes service:

  ```text
  helm delete anomaly-detector
  ```

* Uninstall the AAD StackPack
