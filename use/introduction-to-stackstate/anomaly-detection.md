---
description: Use StackState to detect anomalies in your IT infrastructure
---

## Overview

StackState can detect anomalies in your IT infrastructure by monitoring the metric streams attached to elements. There are two methods of anomaly detection available:

- [Autonomous anomaly detection](#autonomous-anomaly-detection) using machine learning models.
- [Baseline anomaly detection](#baseline-anomaly-detection) using configured metric baseline values.

Each metric stream can use either autonomous or baseline anomaly detection. It is not possible to use both types of anomaly detection on one metric stream at the same time. This means that any metric stream configured with a baseline will not be picked up for anomaly detection by the Autonomous Anomaly detector. 

## Autonomous anomaly detection



Read more about the [Autonomous Anomaly Detector (BETA)](/stackpacks/add-ons/aad.md).


## Baseline anomaly detection



Read more about [anomaly detection with baselines](/use/baselining.md)

 