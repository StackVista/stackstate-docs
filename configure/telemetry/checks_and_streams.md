# Understanding checks and streams

{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

Checks are the mechanisms through which elements \(components and relations\) get a health state. The state of an element is determined from data in the associated telemetry streams.

* Read more about [checks](checks_and_streams.md#checks)
* Read more about [telemetry streams](checks_and_streams.md#telemetry-streams)

## Checks

Checks determine the health state of an element by monitoring one or more telemetry streams. Each telemetry stream supplies either metrics \(time-series\) or logs \(logs and events\) data.

### Check Functions

StackState checks are based on check functions - reusable, user defined scripts that specify when a health state should be returned. This makes checks particularly powerful, allowing StackState to monitor any number of available telemetry streams. For example, you could write a check function to monitor:

* Are we seeing a normal amount of hourly traffic?
* Have there been any fatal exceptions logged?
* What state did other systems report?

A check function receives parameter inputs and returns an output health state. Each time a check function is executed, it updates the health state of the checks it ran for. If a check function does not return a health state, the health state of the check remains unchanged.

## Telemetry streams

A telemetry stream is a real-time stream of either metric or log data coming from an external monitoring system.

| Data | Description |
| :--- | :--- |
| **Metrics** | Metric, or time-series, data are numeric values over time. A metric can represent any kind of measurement, like a count or a percentage. |
| **Logs** | A log entry is a \(JSON style\) data object with some properties. Each log entry may represent an event or even some state information coming from an external system. StackState is able to synchronize the checks of external systems, such as OpsView or Nagios. These systems report check changes to StackState in a log stream. These log entries are then checked for their data by a check, which in turn can translate into an element state change in StackState. |

### Telemetry stream providers

Telemetry streams are supplied via plugins. Different plugins provide one or multiple types of telemetry streams. For example, the Graphite plugin provides StackState with a metrics telemetry stream, while the Elasticsearch plugin provides metric and log telemetry streams.

### Add telemetry streams

In StackState, telemetry streams need to be linked to elements \(components or relations\). Once a telemetry stream has been linked to an element it can be used as an input for the element's checks. Telemetry streams can also be defined in templates and attached automatically to elements when they are imported by a synchronization.

Read how to [add a telemetry stream to an element](../../use/health-state-and-event-notifications/add-telemetry-to-element.md) or how to [add telemetry during topology synchronization](telemetry_synchronized_topology.md).

### Baselines

A baseline can be attached to a metric stream. The baseline consists of an average, a lowerDeviation and a higherDeviation for batches of metric data. Checks can use the baseline values on a metric stream to trigger a health state change if a batch of metrics deviates from the baseline.

Read more about [anomaly detection with baselines](../../use/health-state-and-event-notifications/anomaly-detection-with-baselines.md) and [baseline functions](../../develop/developer-guides/custom-functions/baseline-functions.md).

## See also

* [Add a health check](../../use/health-state-and-event-notifications/add-a-health-check.md)
* [Add a telemetry stream to an element](../../use/health-state-and-event-notifications/add-telemetry-to-element.md)
* [Use templates to add telemetry streams to your own integrations](telemetry_synchronized_topology.md)
* [Check functions](../../develop/developer-guides/custom-functions/check-functions.md)
* [Anomaly detection with baselines](../../use/health-state-and-event-notifications/anomaly-detection-with-baselines.md)
* [Baseline functions](../../develop/developer-guides/custom-functions/baseline-functions.md)


