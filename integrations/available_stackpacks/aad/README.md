---
title: Autonomous Anomaly Detection StackPack
kind: documentation
---
[//]: # (Overview section)
# Overview

## What is the Autonomous Anomaly Detector StackPack?

Anomaly detection helps to find incidents in your fast-changing IT environment and provides insight into the Root Cause. It also directs the attention of IT operators into root cause of incidents.

Installing this StackPack will enable the Autonomous Anomaly Detector (AAD). The Anomaly Detector analyzes metric streams in search of any anomalous behaviour based on its past. Upon detecting an anomaly, the Anomaly Detector will mark the stream under inspection with an annotation that is easily visible in the StackState interface. Furthermore, an Anomaly Event will be generated for this incident that can be inspected at a later date on the Events Perspective.

The AAD requires zero configuration. It is fully autonomous in making decisions about which metric streams it will apply anomaly detection and which machine learning algorithms it will use for the different metric stream.

## How does the AAD decide what to work on?

The AAD scales to large environments by autonomously prioritizing metric streams based on its knowledge of the 4T data model and user feedback. The streams with the highest priority will be examined first. This priority of streams is computed by an algorithm that learns to maximize the probability that it will prevent an IT issue. It does this based on which streams are intrinsically important such as KPIs and SLAs, the ongoing and historical issues and the relations between streams among other factors. This way Autonomous Anomaly Detection can operate in large environments by allocating the attention where it matters the most.

The way this stream selection algorithm currently works is as follows:
 * Component in views that have the most stars are selected.
 * From those components, only high priority metric streams ([read more](/use/how_to_use_the_priority_field_for_components.md) about priorities) are selected.

You can not control directly what the AAD picks, but you can steer the AAD by starring views and setting the priority of streams to `high`.

## How fast are anomalies detected?

The AAD also ensures that prioritized metric streams are checked for anomalies in a timely fashion. Anomalies in the highest prioritized metric streams are detected within about 5 minutes.

## How do I know what the AAD is working on?

The status UI of anomaly detection kubernetes service provides various metrics and indicators providing details on what it is doing at the moment.

## Prerequisites

The Autonomous Anomaly Detector StackPack can only be installed within a [Kubernetes](/setup/installation/kubernetes/README.md) setup. Please make sure that your StackState installation does support it.
Please [contact support](https://www.stackstate.com/company/contact/) if you are not sure that is the case or if you would like to know more.

*Node sizing*

The minimal deployment of the AAD service with default options (5 workers) requires the following instance types:

* Amazon EKS: 1 instance of type `m4.xlarge`
* Azure AKS: 1 instance of type `F4s v2` \(Intel or AMD cpu's\)

To handle more streams or to reduce the detection latency the service can be scaled by increasing number of workers.
The general scalability rule is that 1 extra worker requires allocating 1 CPU and 1 Gb of RAM extra.

The AAD service is stateless and survives restarts. It can be relocated on a different kubernetes node or bounced.
To take full advantage of this capability it is recommended to run the service on low cost AWS Spot Instances and Azure Low Priority VM.

[//]: # (Install section)
# Install

To install the AAD you need to install the anomaly detector separately. Please follow the steps below.

### 1. Get access to quay.io

  To be able to pull the Docker image, please request access credentials from StackState [support](https://www.stackstate.com/company/contact/).

### 2. Install Helm

* Install Helm (version 3):

Please see helm docs `https://helm.sh/docs/intro/install`

* Add the stackstate helm repo:

```
helm repo add stackstate https://helm.stackstate.io`
```

### 3. Get the latest anomaly detection chart

```
helm fetch stackstate/anomaly-detection
```

### 4. Configure the Anomaly Detection Chart

* Configure values.yaml file:

  Create `values.yaml` file as described below and save it on disk:

  - configure image version tag, e.g or simply put this `4.1.0-latest`
  - configure image registry username (from step 1)
  - stackstate instance url, e.g `http://stackstate-server-headless:7070/` or `http://<releasename>-stackstate-server-headless:7070/`
  - configure status interface ingress (useful for troubleshooting). The ingress provides the access to the technical interface of anomaly detection kubernetes service.

```
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

The example below shows how to configure an nginx-ingress controller. Setting up the controller itself is beyond the scope of this document.
More information about how to setup ingress you can find on the links below:

* [AKS](https://docs.microsoft.com/en-us/azure/aks/ingress-tls)
* [EKS Official docs](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html) \(not using nginx\)
* [EKS blog post](https://aws.amazon.com/blogs/opensource/network-load-balancer-nginx-ingress-controller-eks/) \(using nginx\)

More information on other configuration options is provided in the chart documentation.

```
helm show all stackstate/anomaly-detection
```

### 5. Install the Anomaly Detection Chart

To install, run the command below specifying stackstate namespace and image registry password:

Note that you must install chart in the same namespace as stackstate chart.

```
helm upgrade anomaly-detector stackstate/anomaly-detection \
    --install \
    --namespace <stackstate-namespace> \
    --set image.pullSecretPassword=<image registry password>
    --values ./values.yaml
```

# Deactivate the Anomaly Detection service

The anomaly detection service can be deactivated by uninstalling the stackpack.

In this case the the anomaly detection kubernetes service will still keep running and reserve its compute resources, but will not execute anomaly detection.

To re-enable you can simply install the StackPack again. You then don't need to repeat the installation of the anomaly detection kubernetes service.

# Uninstall the Autonomous Anomaly Detector Stackpack:

* Uninstall the anomaly detection kubernetes service:

```
helm delete anomaly-detector
```

* Uninstall the AAD stackpack

[//]: # (Troubleshooting section)

# Troubleshooting

In order to get the details about technical state and also for troubleshooting one can browse the status UI of the anomaly detection kuberentes service.
The status UI can be turned on by enabling debug interface ingress (see `Install` section).

With the help of the status UI one can get answers for the following questions:
* Is the anomaly detection service running?

  The access to status UI indicates that the service is running. If the UI is not accessible it means the service is not running or the ingress is not configured (see `Install` section).

* Can the anomaly detection kubernetes service reach StackState?

  This can be verified by the **Top errors** and **Last stream polling results** sections of status UI. The errors there usually indicate connection problems.

* Has anomaly detection kubernetes service selected streams for anomaly detection?

  **Anomaly Detection Summary** section showing total time of all registered streams, if no streams are selected it will be zero.

* Is the anomaly detection kubernetes service detecting anomalies?

  The section **Top Anomalous Streams** is showing the streams with the highest number of anomalies. No streams in this section means that no anomalies detected.

  Besides that the **Anomaly Detection Summary** section showing various metrics that are relevant, e.g. total time of all registered streams, total checked time, total time of all anomalies detected.

* Is anomaly detection kubernetes service scheduling streams?

  The **Job Progress** tab showing ranked list of streams with scheduling progress. Each stream show the last time it was scheduled.

Besides that it allows to see various information about the scheduling progress, possible errors, ML models selected and job statistics.

[//]: # (Release notes section)

# Release Notes

## 0.2.2 (2020-09-04)

**Beta Release**
- Releasing Autonomous Anomaly Detector service Beta
