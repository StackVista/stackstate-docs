---
title: Autonomous Anomaly Detection StackPack
kind: documentation
---

# Autonomous Anomaly Detector

## Overview

### What is the Autonomous Anomaly Detector StackPack?

Anomaly detection identifies incidents in your fast-changing IT environment and provides insights into their root cause. This directs the attention of IT operators to the root cause of incidents.

Installing the Autonomous Anomaly Detector StackPack will enable the Autonomous Anomaly Detector \(AAD\). The AAD analyzes metric streams in search of any anomalous behavior based on its past. Upon detecting an anomaly, the AAD will mark the stream under inspection with an annotation that is easily visible in the StackState interface. An Anomaly Event for the incident will also be generated and stored, this can be inspected at a later date on the Events Perspective.

The AAD requires zero configuration. It is fully autonomous in selecting the metric streams it will apply anomaly detection to and the appropriate machine learning algorithms to use for each.

### How does the AAD decide what to work on?

The AAD scales to large environments by autonomously prioritizing metric streams based on its knowledge of the 4T data model and user feedback. Streams with the highest priority will be examined first. The prioritization of streams is computed by an algorithm that learns to maximize the probability of preventing an IT issue. To operate in large environments, attention must be allocated where it matters the most. The AAD achieves this based on its knowledge of streams that are intrinsically important \(such as KPIs and SLAs\), ongoing and historical issues, relations between streams and other relevant factors.

The stream selection algorithm works as follows:

* Components in Views that have the most stars are selected.
* From those components, only high priority metric streams are selected. See - [how to set the priority for a stream](/configure/telemetry/how_to_use_the_priority_field_for_components.md).

You cannot directly control the stream selected, but you can steer the selection by starring Views and setting the priority of streams to `high`.

### How fast are anomalies detected?

The AAD ensures that prioritized metric streams are checked for anomalies in a timely fashion. Anomalies occurring in the highest prioritized metric streams are detected within about 5 minutes.

### How do I know what the AAD is working on?

The status UI of the anomaly detection Kubernetes service provides various metrics and indicators, including details of what it is currently doing.

### Prerequisites

The AAD StackPack can only be installed within a [Kubernetes setup](/setup/kubernetes_install/README.md). Please make sure that this is supported by your StackState installation.

If you are not sure that you have a Kubernetes setup or would you like to know more, contact [StackState support](https://www.stackstate.com/contact/).

#### Node sizing

A minimal deployment of the anomaly detection Kubernetes service with the default options requires one of the following instance types:

* Amazon EKS: 1 instance of type `m4.xlarge`
* Azure AKS: 1 instance of type `F4s v2` \(Intel or AMD CPUs\)
* Self-hosted Kubernetes: 1 instance with 4 CPUs and 6 Gb memory

To handle more streams or to reduce detection latency, the service can be scaled. If you want to find out how to scale the service, contact [StackState support](https://www.stackstate.com/contact/).

The anomaly detection Kubernetes service is stateless and survives restarts. It can be relocated on a different Kubernetes node or bounced. To take full advantage of this capability it is recommended to run the service on low cost AWS Spot Instances and Azure Low Priority VM.

## Install

### Install the Autonomous Anomaly Detector \(AAD\) StackPack

Install the AAD StackPack from the StackPacks page in StackState.

{% hint style="info" %}
To use the AAD StackPack, the anomaly detection Kubernetes service must also be installed.
{% endhint %}

### Install the anomaly detection Kubernetes service

After installing the AAD StackPack, install the anomaly detection Kubernetes service.

#### 1. Get access to quay.io

To be able to pull the Docker image, you will need access to quay.io. Access credentials can be requested from [StackState support](https://www.stackstate.com/contact/).

#### 2. Install Helm

* Install Helm \(version 3\). See the Helm docs [https://helm.sh/docs/intro/install](https://helm.sh/docs/intro/install/)
* Add the StackState Helm repo:

```text
helm repo add stackstate https://helm.stackstate.io`
```

#### 3. Get the latest StackState anomaly-detection chart

```text
helm fetch stackstate/anomaly-detection
```

#### 4. Configure the anomaly-detection Chart

Create the file `values.yaml` file including the configuration described below and save it to disk:

* **image:**
  * **tag** - the image version e.g `4.1.0-release`
  * **pullSecretUsername** - the image registry username \(from step 1\)
* **stackstate:**
  * **instance** - the StackState instance url. This must be a StackState internal url to keep traffic inside the Kubernetes network and namespace. e.g `http://stackstate-server-headless:7070/` or `http://<releasename>-stackstate-server-headless:7070/`
* **ingress:** - Ingress provides access to the technical interface of the anomaly detection Kubernetes service, this is useful for troubleshooting. The example below shows how to configure an nginx-ingress controller. Setting up the controller itself is beyond the scope of this document. More information about how to set up Ingress can be found at:
  * [AKS](https://docs.microsoft.com/en-us/azure/aks/ingress-tls)
  * [EKS Official docs](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html) \(not using nginx\)
  * [EKS blog post](https://aws.amazon.com/blogs/opensource/network-load-balancer-nginx-ingress-controller-eks/) \(using nginx\)

```text
image:
    tag: <image tag>
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

Details of all configuration options are available in the anomaly-detection chart documentation.

```text
helm show all stackstate/anomaly-detection
```

#### 5. Install the anomaly-detection chart

Run the command below, specifying the StackState namespace and the image registry password. Note that the anomaly-detection chart must be installed in the same namespace as the StackState chart.

```text
helm upgrade anomaly-detector stackstate/anomaly-detection \
    --install \
    --namespace <stackstate-namespace> \
    --set image.pullSecretPassword=<image registry password>
    --values ./values.yaml
```

## Deactivate the anomaly detection Kubernetes service

To deactivate the anomaly detection Kubernetes service, uninstall the AAD StackPack.

After the AAD StackPack has been uninstalled, the anomaly detection Kubernetes service will continue to run and reserve its compute resources, but anomaly detection will not be executed.

To re-enable the anomaly detection Kubernetes service, you can simply install the AAD StackPack again. It is not necessary to repeat the installation of the anomaly detection Kubernetes service.

## Full uninstall

* Uninstall the anomaly detection Kubernetes service:

  ```text
  helm delete anomaly-detector
  ```

* Uninstall the AAD StackPack

## Troubleshooting

The status UI provides details on the technical state of the anomaly detection Kubernetes service. You can use it to retrieve information about scheduling progress, possible errors, the ML models selected and job statistics.

To access the status UI, the status interface Ingress must be configured in the anomaly-detection chart \(see the `Install` section\).

Common questions that can be answered in the status UI:

* **Is the anomaly detection Kubernetes service running?**
  * The status UI is accessible: The service is running.
  * The status UI is not available: Either the service is not running, or the Ingress has not been configured \(See the install section\).
* **Can the anomaly detection Kubernetes service reach StackState?** Check the sections **Top errors** and **Last stream polling results**.  Errors here usually indicate connection problems.
* **Has the anomaly detection Kubernetes service selected streams for anomaly detection?** The section **Anomaly Detection Summary** shows the total time of all registered streams, if no streams are selected it will be zero.
* **Is the anomaly detection Kubernetes service detecting anomalies?** The section **Top Anomalous Streams** shows the streams with the highest number of anomalies. No streams in this section means that no anomalies have been detected.  The section **Anomaly Detection Summary** shows other relevant metrics, such as total time of all registered streams, total checked time and total time of all anomalies detected.
* **Is the anomaly detection Kubernetes service scheduling streams?** The tab **Job Progress** shows a ranked list of streams with scheduling progress, including the last time each stream was scheduled.

## Release Notes

### 0.2.2 \(2020-09-04\)

**Beta Release**

* Releasing Autonomous Anomaly Detector service Beta
