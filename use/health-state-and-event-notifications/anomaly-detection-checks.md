---
title: Anomaly detection checks
kind: documentation
---

## Overview

[Autonomous Anomaly Detector (AAD)](../../stackpacks/add-ons/aad.md) looks for anomalies in the IT environment and annotates telemetry with anomalies and also sends anomaly events.
The anomaly annotations are displayed in the metric charts as on the example below:

![Anomaly example](../../.gitbook/assets/anomaly-chart-write-latency.png)

The anomaly events can be viewed in the [event perspective](../../use/views/events_perspective.md) when event category `Anomalies` is selected in the filter.

![Anomaly events](../../.gitbook/assets/anomaly-events-in-events-perspective.png)

## How anomaly checks work

In order to direct user attention to a proper part of IT Landscape an anomaly check can be created for a MetricStream.

## Anomaly check functions

### Autonomous metric stream anomaly detection

The functions triggers DEVIATING health state for a metric stream and anomaly direction. The function is available once [AAD](../../stackpacks/add-ons/aad.md) StackPack is installed.

**Arguments**:

| Argument Name | Type | Description |
| :--- | :--- | :--- |
| metricStream | Metric Stream Id | The id of the metric stream from the component the check is created on. |
| event | StackState Events | The event argument will be an instance of anomaly event if the check is configured with `Anomaly Events` filter. (see more about anomaly event  ) |
| anomalyDirection | Anomaly Direction | The direction of the anomaly: RISE/DROP/ANY. |

## See also

* [Autonomous Anomaly Detector](../../stackpacks/add-ons/aad.md)
* [Anomaly check functions](../../configure/telemetry/anomaly-check-functions.md)
* [Checks and telemetry streams](checks_and_streams.md)
