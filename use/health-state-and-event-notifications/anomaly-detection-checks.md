---
title: Anomaly detection checks
kind: documentation
---

## Overview

[Autonomous Anomaly Detector (AAD)](../../stackpacks/add-ons/aad.md) looks for deviations in the IT environment and annotates telemetry with anomalies and also sends anomaly events. The anomaly events can be viewed in the [event perspective](../../use/views/events_perspective.md) and also can be an input for an anomaly check.

The anomaly check can be created based on the default anomaly check function available from [AAD StackPack](../../stackpacks/add-ons/aad.md). The description of the default check function is given [below](anomaly-detection-checks.md#autonomous-metric-stream-anomaly-detection).

Optionally, custom anomaly check function can be created. More information on custom anomaly check function, parameters and available fields can be found in [anomaly check functions](../../configure/telemetry/anomaly-check-functions.md) section.

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
