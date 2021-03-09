---
title: Alerting on Anomalies
kind: documentation
---

## Overview

Autonomous Anomaly Detector (AAD) looks for anomalies in the IT environment and informs the user about possible issues by sending Anomaly Events.
A user can highlight parts of IT landscape that with the help of Check Function.

## Alerting functions from AAD StackPack

[AAD](../../stackpacks/add-ons/aad.md) StackPack contains check function 'Autonomous Metric Stream Anomaly Detection'.

Check Function parameters:

* anomalyDirection - RISE, DROP or ANY
* metricStream - indicates metric stream where to look for anomalies
* event - it is configured to Anomaly Events

## See also

* [Autonomous Anomaly Detector](../../stackpacks/add-ons/aad.md)
* [Checks and telemetry streams](checks_and_streams.md)
