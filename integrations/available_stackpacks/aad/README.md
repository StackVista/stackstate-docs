---
title: Autonomous Anomaly Detection StackPack
kind: documentation
---
[//]: # (Overview section)
# Overview

## What is the Autonomous Anomaly Detector StackPack?

Anomaly detection helps to find incidents in your fast-changing IT environment and provides insight into the Root Cause. It also directs the attention of IT operators to interesting parts of the IT environment.

Installing this StackPack will enable the Autonomous Anomaly Detector which analyzes various data streams in search of any anomalous behaviour. Upon detecting an anomaly, the Anomaly Detector will mark the stream under inspection with an annotation that is easily visible on the StackState interface. Furthermore, an Anomaly Event will be generated for this incident that can be inspected at a later date on the Events Perspective.

Autonomous Anomaly Detection scales to large environments by prioritizing streams based on its knowledge of the IT environment. The streams with the highest priority will then be examined first. This priority of streams is computed by a machine learning algorithm that learns to maximize the probability that it will prevent an IT issue. It does this based on which streams are intrinsically important such as KPIs and SLAs, the ongoing and historical issues and the relations between streams among other factors. This way Autonomous Anomaly Detection can operate in large environments by allocating the attention where it matters the most.

## Prerequisites

The Autonomous Anomaly Detector StackPack can only be installed within a [Kubernetes](/setup/installation/kubernetes/README.md) setup. Please make sure that your StackState installation does support it.
Please [contact support](https://www.stackstate.com/company/contact/) if you are not sure that is the case or if you would like to know more.

*Node sizing*

The standard deployment of the AAD service with default options (5 workers) requires the following instance types:

* Amazon EKS: 1 instance of type `m4.xlarge`
* Azure AKS: 1 instance of type `F4s v2` \(Intel or AMD cpu's\)

It is advantageous to run the service on AWS Spot Instances and Azure Low Priority VM.

In general the scalability rule is that for 1 extra worker it is required to allocate 1 CPU and 1 Gb of RAM.

[//]: # (Install section)
# Install

The manual step is required to install Autonomous Anomaly Detector.

### Install Helm and Get the latest anomaly detection chart

* Install Helm:

Please see helm docs `https://helm.sh/docs/intro/install`

* Add stackstate helm repo:

```
helm repo add stackstate https://helm.stackstate.io`
```

* Fetch the latest chart:

```
helm fetch stackstate/anomaly-detection
```

### Configure Anomaly Detection Chart

## Configure values.yaml file:

  - configure image version tag, e.g `4.1.0-latest`
  - stackstate instance url, e.g `http://stackstate-server-headless:7070/` or `http://<releasename>-stackstate-server-headless:7070/`
  - configure debug interface ingress (optional, useful for troubleshooting). The ingress provides the access to the technical interface of anomaly detection service.

```
image:
    # Image tag "4.1.0-latest"
    tag: <image tag>
stackstate:
    # Stackstate instance URL
    instance: <stackstate url>

# Optionally one can configure status page ingress (the configuration below is relevant for nginx ingress controller)   
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

More information on possible configuration options are in the chart documentation.

```
helm show all stackstate/anomaly-detection
```

## Install Anomaly detection chart

The anomaly detection chart is required to be deployed to the same namespace as StackState chart.

```
helm upgrade <release name> stackstate/anomaly-detection \
    --install \
    --namespace <stackstate-namespace> \
    --values ./values.yaml
```
## Deactivate Anomaly Detection service

The anomaly detection service can be deactivated by uninstalling the stackpack.

In this case the service will hold the resources but will not execute anomaly detection.

## Uninstall Anomaly Detection Stackpack:

* Uninstall anomaly detection service:

```
helm delete <release name>
```

* Uninstall the AAD stackpack

[//]: # (Configuration section)
# Configuration

StackState's Autonomous Anomaly Detection doesn't need manual fine-grained configuration.
It gives high level controls to the user in the following ways:
* The stream priority can be set to `HIGH` and this will let anomaly detector to know that this stream is important
* The user can prioritize parts of landscape for for anomaly detection by starring a [View](/use/views.md). The more stars view has got, the high its rank and the high chance that the components in the view are scheduled for anomaly detection.

Autonomous Anomaly Detection Service automatically finds the right machine learning algorithm for each data stream using AutoML. This is a collection of anomaly detection algorithms, the semantics of the data, correlations among data streams, user feedback, and historical IT incidents. Autonomous Anomaly Detection tries different ways to detect anomalies and finds the one that detects the most meaningful anomalies making sure it doesn't have false positives.

[//]: # (Use section)

# Use

Once the streams and views are configured, the Autonomous Anomaly Detection service selects streams using script API query and schedule detection jobs for them.
Detected anomalies appear in several places:
* All anomalies appear as annotations in metric charts in [Component Details](/getting_started.md#component-relation-details) and in [Metric inspector](/getting_started.md#metric-inspector)
* The Anomalies with HIGH severity will appear as events in [Event Perspective](/use/perspectives/event-perspective.md). Clicking on the event will open the event details pane where one can see the details of the anomaly.

[//]: # (Troubleshooting section)

# Troubleshooting

In order to get the details about technical state and also for troubleshooting one can browse the debug UI of the anomaly detector service.
The debug UI can be turned on by enabling debug interface ingress (see `Install` section).

With the help of the debug UI one can get answers for the following questions:
* Is the anomaly detection service running?

  The access to debug UI indicates that the service is running. If the UI is not accessible it means the service is not running or the ingress is not configured (see `Install` section).

* Can anomaly detection service reach StackState?

  This can be verified by the **Top errors** and **Last stream polling results** sections of debug UI. The errors there usually indicate connection problems.

* Is anomaly detection service detecting anomalies?

  The section **Top Anomalous Streams** is showing the streams with the highest number of anomalies. No streams in this section means no anomalies detected.

  Besides that the **Anomaly Detection Summary** section showing various metrics that are relevant, e.g. total time of all registered streams, total checked time, total time of all anomalies detected.

* Is anomaly detection service scheduling streams?

  The **Job Progress** tab showing ranked list of streams with scheduling progress. Each stream show the last time it was scheduled.

Besides that it allows to see various information about the scheduling progress, possible errors, ML models selected and job statistics.

[//]: # (Release notes section)

# Release Notes

## 0.2.2 (2020-09-04)

**Beta Release**
- Releasing Autonomous Anomaly Detector service Beta
