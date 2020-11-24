# Checks and telemetry streams

## Overview

Checks are the mechanisms through which elements (components and relations) get a health state. The state of an element is determined from data in the associated telemetry streams.

- Read more about [checks](#checks)
- Read more about [telemetry streams](#data-streams)

## Checks

Checks determine the health state of an element by monitoring one or more telemetry streams. Each telemetry stream supplies either metrics (time-series) or events (logs and events) data. 

### Check Functions

StackState checks are based on check functions - reusable, user defined scripts that specify when a health state should be returned. This makes checks particularly powerful, allowing StackState to monitor any number of available telemetry streams. For example, you could write a check function to monitor:

* Are we seeing a normal amount of hourly traffic?
* Have there been any fatal exceptions logged?
* What state did other systems report?

A check function receives parameter inputs and returns an output health state. Each time a check function is executed, it updates the health state of the checks it ran for. If a check function does not return a health state, the health state of the check remains unchanged.

## Telemetry streams

A telemetry stream is a real-time stream of either metric or event data coming from an external monitoring system.

| Data | Description | 
|:---|:---|
| Metrics | Metric, or time-series, data are numeric values over time. A metric can represent any kind of measurement, like a count or a percentage. |
| Events | An event is a \(JSON style\) data object with some properties. Each event may represent a log entry or even some state information coming from an external system. StackState is able to synchronize the checks of external systems, like OpsView or Nagios. These systems report check changes to StackState as events. These events are then checked for their data by a check, which in turn can translate this into an element's state in StackState. |

### Telemetry stream providers

Telemetry streams are supplied via plugins. Different plugins provide one or multiple types of data streams. For example, the Graphite plugin provides StackState with a metrics telemetry stream, while the Elasticsearch plugin provides metrics and events telemetry streams.

### Add telemetry streams

In StackState, telemetry streams need to be linked to elements (components or relations). Once a telemetry stream has been linked to an element it can be used as an input for the element's checks. Read how to [add a telemetry stream to an element](/use/health-state-and-alerts/add-telemetry-to-element.md).

### Configure a baseline for a metric stream

A baseline can be attached to a metric stream. The baseline consists of an average, a lowerDeviation and a higherDeviation for batches of metric data. Checks can use baseline values on a metric stream to trigger an alert when a batch of metrics deviate from the baseline. Read more about [anomaly detection with baselines](/use/health-state-and-alerts/anomaly-detection-with-baselines.md).

### Baseline Functions

A Baseline function defines a calculation that produces a baseline, which is \[an average, a lowerDeviation and a higherDeviation\] for a single input metric stream. The metric stream is batched and downsampled. A metric stream that has a baseline calculation attached to it can be used as an input for other functions, like checks.

The baseline function body is a specified as groovy script. Below is an example of a baseline function with metricStream input parameter name.

```text
     def maximum = groovy.util.GroovyCollections.max(metricStream.collect { it.point }).doubleValue()
     def minimum = groovy.util.GroovyCollections.min(metricStream.collect { it.point }).doubleValue()
     def sum = groovy.util.GroovyCollections.sum(metricStream.collect { it.point }).doubleValue()
     def count = metricStream.size()
     return baselineMonitorDataPoint(sum/count,minimum,maximum)
```

### Baseline parameters

**Batch size**

Determines the duration by which metrics are batched. Batches are always non-overlapping and the startTime of a batch is aligned to midnight 00:00 AM. A batch size of 1 hour e.g. will split a day of metrics into 24 batches, the first one starting at 00:00 AM until 01:00 AM.

**Fundamental period**

The period which is assumed to have recurring similarities and is therefore used by the baseline function to determine which periods can be compared with other periods.

**Training window**

The amount of time that is used to select the historical metrics that are used as input for calculating the baseline. When the baseline did not collect enough historical metrics yet to fill the training window, it will not produce a baseline yet.

