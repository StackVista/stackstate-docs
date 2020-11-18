---
description: Use StackState to detect anomalies in your IT infrastructure
---

## Overview

StackState can detect anomalies in your IT infrastructure by monitoring the metric streams attached to elements. There are two methods of anomaly detection available:

- [Autonomous anomaly detection](#autonomous-anomaly-detection) using machine learning models.
- [Baseline anomaly detection](#baseline-anomaly-detection) using configured metric baseline values.

Each metric stream can use either autonomous or baseline anomaly detection. It is not possible to use both types of anomaly detection on one metric stream at the same time. This means that any metric stream configured with a baseline will not be picked up for anomaly detection by the Autonomous Anomaly detector. 

## Autonomous anomaly detection

The StackState Autonomous Anomaly Detector StackPack works fully autonomously to identify anomalies in your IT environment. When installed and enabled, it will determine for itself the best configuration of its machine learning models and the metric streams that should be prioritized for anomaly detection. No configuration is required although you can influence the selection of telemetry streams by giving a them higher priority.

Read more about the [Autonomous Anomaly Detector (BETA)](/stackpacks/add-ons/aad.md).


## Baseline anomaly detection

Each metric stream can have metric baselines manually configured or set by a template. The baselines determine the normal operating values of a metric stream and can be used in health checks and to trigger alerts. Note that any metric stream with a base line configured will not be picked up for autonomous anomaly detection.

Read more about [anomaly detection with baselines](/use/baselining.md)

 