---
description: How to install the Autonomous Anomaly Detector.
---

# Autonomous Anomaly Detector

## Overview

Anomaly detection identifies abnormal behavior in your fast-changing IT environment. This helps direct the attention of IT operators to the root cause of problems or can provide an early warning.

Installing the Autonomous Anomaly Detector StackPack will enable the Autonomous Anomaly Detector \(AAD\). The AAD analyzes metric streams in search of any anomalous behavior based on its past. Upon detecting an anomaly, the AAD will mark the stream under inspection with an annotation that is easily visible in the StackState user interface. An `Metric Stream Anomaly Event` for the incident will also be generated which can be inspected at on the [Events Perspective](../../use/stackstate-ui/perspectives/events_perspective.md).

The AAD requires zero configuration. It is fully autonomous in selecting the metric streams it will apply anomaly detection to, and the appropriate machine learning algorithms to use for each. Note that a [training period](#training-period) is required before AAD can begin to report anomalies.

## Installation

{% hint style="info" %}
**StackState Self-Hosted**

### Prerequisites

The AAD StackPack can only be installed within a [Kubernetes setup](../../setup/installation/kubernetes_install/). Please make sure that this is supported by your StackState installation.

It is also possible to [install the AAD standalone](../../setup/installation/kubernetes_install/aad_standalone.md) within Kubernetes.

If you are not sure that you have a Kubernetes setup or would you like to know more, contact [StackState support](https://support.stackstate.com/hc/en-us).
{% endhint %}

### Install the Autonomous Anomaly Detector \(AAD\) StackPack

To install the AAD StackPack, simply press the install button. No other actions need to be taken. A [training period](#training-period) is required before AAD can begin to report anomalies.

### Training period

The AAD will need to train on your data before it can begin reporting anomalies. With data collected in 1 minute buckets, AAD requires a 3 day training period. If historic data exists for relevant metric streams, this will also be used for training the AAD. In this case, the first results can be expected within an hour.

## Frequently Asked Questions

### How does the AAD decide what to work on?

The AAD scales to large environments by autonomously prioritizing metric streams based on its knowledge of the 4T data model and user feedback. The metric stream selection algorithm ranks metric streams based on the criteria below:

* The top ranking is given to metric streams with [anomaly health checks](../../use/health-state/anomaly-health-checks.md).
* Components in views that have the most stars by the most users are ranked highest.
* From those components, the metric streams with the highest priorities are ranked highest. See [how to set the priority for a stream](../../configure/telemetry/how_to_use_the_priority_field_for_components.md).

You cannot directly control the stream selected, but you can steer the metric stream selection of the AAD by manipulating the above mentioned factors.

### Can I get alerted based on anomalies?

Yes. The AAD itself does not alert on anomalies found, but [anomaly health checks](../../use/health-state/anomaly-health-checks.md) can be placed on components to automatically change the health status of the component to `DEVIATING`. This health state change event can then trigger notifications via event handlers.

### How fast are anomalies detected?

After an initial [training period](#training-period), the AAD ensures that prioritized metric streams are checked for anomalies in a timely fashion. Anomalies occurring in the highest prioritized metric streams are detected within about 5 minutes.

{% hint style="info" %}
**StackState Self-Hosted**

### How do I know what the AAD is working on?

The status UI of the AAD provides various metrics and indicators, including details of what it is currently doing \(see [troubleshooting](../../setup/installation/kubernetes_install/aad_standalone.md#troubleshooting)\).
{% endhint %}

## Uninstall

To uninstall the AAD StackPack, simply press the uninstall button. No other actions need to be taken.

## Release Notes

Release notes for the AAD StackPack are given below.

Note that from StackState release v4.3 the AAD is configured, installed and upgraded as a part of StackState standard installation, therefore AAD Kubernetes service releases are no longer mentioned below.

**Autonomous Anomaly Detector StackPack v0.9.2 \(02-04-2021\)**

* Common version bumped from 2.4.3 to 3.0.0
* StackState min version bumped to 4.3.0

**Autonomous Anomaly Detector StackPack v0.8.1 \(22-03-2021\)**

* Check function has been moved to common StackPack

**Autonomous Anomaly Detector StackPack v0.8.0 \(19-03-2021\)**

* Autonomous metric stream anomaly detection check function.

**Autonomous Anomaly Detector StackPack v0.7 \(19-02-2021\)**

* Autonomous Anomaly Detector service GA.

**Autonomous Anomaly Detector StackPack v0.6 BETA \(13-10-2020\)**

* Documentation fixes and minor maintenance work.

**Autonomous Anomaly Detector StackPack v0.2.2 BETA \(04-09-2020\)**

* Releasing Autonomous Anomaly Detector service BETA.

## See also

* [Anomaly detection](../../use/introduction-to-stackstate/anomaly-detection.md)
* [Anomaly health checks](../../use/health-state/anomaly-health-checks.md)
