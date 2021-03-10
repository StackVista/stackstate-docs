---
title: Alerting on anomalies
kind: documentation
---

## Overview

[Autonomous Anomaly Detector (AAD)](../../stackpacks/add-ons/aad.md) looks for anomalies in the IT environment and annotates telemetry with anomalies and also sends anomaly events.
The anomaly annotations are displayed in the metric charts as on the example below:

![Anomaly example](../../.gitbook/assets/anomaly-chart-write-latency.png)

The anomaly events can be viewed in the [event perspective](../../use/views/events_perspective.md) when event category `Anomalies` is selected in the filter.

![Anomaly events](../../.gitbook/assets/anomaly-events-in-events-perspective.png)

## How alerting on anomalies works

In order to direct user attention to a proper part of IT Landscape an alerting check can be created for a MetricStream.

## Alerting check functions

### Autonomous metric stream anomaly detection

The functions triggers DEVIATING health state for a metric stream and anomaly direction. The function is available once [AAD](../../stackpacks/add-ons/aad.md) StackPack is installed.

**Arguments**:

| Argument Name | Type | Description |
| :--- | :--- | :--- |
| metricStream | Metric Stream Id | The id of the metric stream from the component the check is created on. |
| event | StackState Events | The topology event is the anomaly event if the check is configured with `Anomaly Events` filter. |
| anomalyDirection | Anomaly Direction | The direction of the anomaly: RISE/DROP/ANY. |

## See also

* [Autonomous Anomaly Detector](../../stackpacks/add-ons/aad.md)
* [Anomaly alerting check functions](../../configure/telemetry/anomaly-alerting-check-functions.md)
* [Checks and telemetry streams](checks_and_streams.md)
