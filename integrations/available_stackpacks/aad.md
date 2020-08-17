---
title: Autonomous Anomaly Detection StackPack
kind: documentation
---

## What is the Autonomous Anomaly Detector StackPack?

Anomaly detection helps to find incidents in your fast-changing IT environment and provides insight into the Root Cause. It also directs the attention of IT operators to interesting parts of the IT environment.

Installing this StackPack will enable the Autonomous Anomaly Detector which analyzes various data streams in search of any anomalous behaviour. Upon detecting an anomaly, the Anomaly Detector will mark the stream under inspection with an annotation that is easily visible on the StackState interface. Furthermore, an Anomaly Event will be generated for this incident that can be inspected at a later date on the Events Perspective.

Autonomous Anomaly Detection scales to large environments by prioritizing streams based on its knowledge of the IT environment. The streams with the highest priority will then be examined first. This priority of streams is computed by a machine learning algorithm that learns to maximize the probability that it will prevent an IT issue. It does this based on which streams are intrinsically important such as KPIs and SLAs, the ongoing and historical issues and the relations between streams among other factors. This way Autonomous Anomaly Detection can operate in large environments by allocating the attention where it matters the most.

Please consult the [Autonomous Anomaly Detector documentation](https://l.stackstate.com/stackpack-aad-docs-link) for more information.

## Configuration

StackState's Autonomous Anomaly Detection doesn't need manual configuration. It automatically finds the right machine learning algorithm for each data stream using AutoML. This is a collection of anomaly detection algorithms, the semantics of the data, correlations among data streams, user feedback, and historical IT incidents. Autonomous Anomaly Detection tries different ways to detect anomalies and finds the one that detects the most meaningful anomalies making sure it doesn't have false positives.

## Prerequisites

The Autonomous Anomaly Detector StackPack can only be installed within a Kubernetes setup. Please make sure that your StackState installation does support it.
Please [contact support](https://www.stackstate.com/company/contact/) if you are not sure that is the case or if you would like to know more.


## Supported configurations

The Autonomous Anomaly Detector is supported only on kubernetes.

## Install and Configure

The manual step is required to install Autonomous Anomaly Detector.

### Install Helm and Get the latest anomaly detection chart

1. Install Helm:

  Please see helm docs `https://helm.sh/docs/intro/install`

2. Add stackstate helm repo:

```
helm repo add stackstate https://helm.stackstate.io`
```

3. Fetch the latest chart:

```
helm fetch stackstate/anomaly-detection
```

### Configure Anomaly Detection Service

1. Configure values.yaml file:
 - configure image version tag, e.g 4.1.0-latest
 - stackstate instance url, e.g http://stackstate-server-headless:7070/ or http://\<releasename\>-stackstate-server-headless:7070/   
 - configure status page ingress (optional)

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
    port: 8090
    annotations:        
        external-dns.alpha.kubernetes.io/hostname: <domain name> # e.g. spotlight.domain.com
        kubernetes.io/ingress.class: nginx
        nginx.ingress.kubernetes.io/ingress.class: nginx
    hosts:
        - host: <domain name>  # e.g. spotlight.domain.com        
```

2. Other Configuration Options

More information on possible configuration options are in the chart documentation.

```
helm show all stackstate/anomaly-detection
```

3. Install the anomaly detection chart in the same namespace as stackstate:

```
helm upgrade <release name> stackstate/anomaly-detection \
    --install \
    --namespace <stackstate-namespace> \
    --values ./values.yaml
```

## Uninstalling Anomaly Detection Stackpack:

1. Uninstall anomaly detection service:

```
helm delete <release name>
```

2. Uninstall the AAD stackpack


## Troubleshooting

TBD
