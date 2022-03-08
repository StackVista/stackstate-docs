# Baseline functions \(Deprecated\)

{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

{% hint style="warning" %}
Baseline anomaly detection is **Deprecated** and will be removed in the StackState v4.4 release. Please use the [Autonomous Anomaly Detector\)](/stackpacks/add-ons/aad.md).
{% endhint %}

## Overview

A Baseline function defines a calculation that produces a baseline, which is an average, a lowerDeviation and a higherDeviation for a single input metric stream. The metric stream is batched and downsampled. A metric stream that has a baseline calculation attached to it can be used as an input for other functions, like checks.

The baseline function body is a specified as groovy script. Below is an example of a baseline function with metricStream input parameter name.

```text
 def maximum = groovy.util.GroovyCollections.max(metricStream.collect { it.point }).doubleValue()
 def minimum = groovy.util.GroovyCollections.min(metricStream.collect { it.point }).doubleValue()
 def sum = groovy.util.GroovyCollections.sum(metricStream.collect { it.point }).doubleValue()
 def count = metricStream.size()
 return baselineMonitorDataPoint(sum/count,minimum,maximum)
```

## Baseline parameters

### Batch size

Determines the duration by which metrics are batched. Batches are always non-overlapping and the startTime of a batch is aligned to midnight 00:00 AM. A batch size of 1 hour e.g. will split a day of metrics into 24 batches, the first one starting at 00:00 AM until 01:00 AM.

### Fundamental period

The period which is assumed to have recurring similarities and is therefore used by the baseline function to determine which periods can be compared with other periods.

### Training window

The amount of time that is used to select the historical metrics that are used as input for calculating the baseline. When the baseline did not collect enough historical metrics yet to fill the training window, it will not produce a baseline yet.

## See also

* [Checks and telemetry streams](../../../configure/telemetry/checks_and_streams.md)
* [Anomaly detection with baselines](../../../use/health-state-and-event-notifications/anomaly-detection-with-baselines.md)

