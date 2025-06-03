---
description: SUSE Observability
---

# Dynamic Threshold Monitors

## Overview

For metrics that vary significantly over time and differ from service to service, a Dynamic Threshold monitor provides simple and performant anomaly detection.  It uses data from 1, 2 or 3 weeks ago in addition to the recent past as context to compare current data to.

Data from the "check window" is compared to that provided by the historic context using the Anderson-Darling test.  This imposes very little assumptions on the data distribution.  The test is particularly sensitive to outliers on the upper and lower ends of the distribution.  The metric can be smooth, spiky or have a couple of "levels" - as data values are compared directly, without any model fitting, the Dynamic Threshod monitor is very robust.

For metrics that vary smoothly over time (e.g. on a timescale of 5 minutes), the effective number of data points is smaller than the raw number.  The DT compensates for this so the same monitor can be used for a wide range of metrics without the need for adjusting its parameters.

There are a couple of parameters that can be set for the monitor function:
* `falsePositiveRate`: say `!!float 1e-8` - the sensitivity of the monitor to deviating behavior.  A lower value suppresses more (false) positives but may also lead to false negatives (unnoticed anomalies).
* `checkWindowMinutes`: say `10` minutes - the check window needs to be balanced between quick alerting (small values) and correctly identified anomalies (high values).  A handful of data points works well in practice.
* `historicWindowMinutes`: say `120` (2 hours) - bracketed around the current time, but then one or more weeks ago - so from 1 hour before the current time to 1 hour after.  Also the 2 hours before the check window are used.  The dynamic threshold monitor compares the distribution of this historic data with the data points in the check window.  
* `historySizeWeeks`: say `2` - the number of weeks that data is taken from for historic context.  Can be `1`, `2` or `3`.
* `removeTrend`: for metrics that have trend behavior (say, number of requests), such that the absolute value differs from week to week, this trend (the average value) can be accounted for.
* `includePreviousDay`: typically `false` - for metrics that do not have a weekly but only a daily pattern, this allows the use of more recent data

## Dynamic Threshold Monitor example

A Monitor implemented using the Dynamic Threshold function looks like:

```
  - _type: "Monitor"
    name: "<name of the monitor>"
    identifier: "urn:custom:monitor:<identifier for the monitor>"
    status: "DISABLED"
    description: "<description>"
    function: {{ get "urn:stackpack:aad-v2:shared:monitor-function:dt" }}
    arguments:
      telemetryQuery:
        query: "<metric to bind to component>"
        unit: s
        aliasTemplate: "<name for the metric>"
      topologyQuery: <topology query for the components to bind to>
      falsePositiveRate: <floating point number, e.g. !!float 1e-8>
      checkWindowMinutes: <integer, e.g. 10>
      historicWindowMinutes: <integer, e.g. 120>
      historySizeWeeks: <integer: 1, 2 or 3>
      includePreviousDay: <boolean>
      removeTrend: <boolean>
    intervalSeconds: 60
    remediationHint: "<how to remediate deviating states>"
```

The monitor can be implemented using the guide at [Add a threshold monitor to components using the CLI](/use/alerting/k8s-add-monitors-cli.md)
