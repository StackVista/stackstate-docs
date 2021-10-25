# Telemetry streams

## Overview

A telemetry stream is a real-time stream of either metric or log data coming from an external monitoring system.

| Data | Description |
| :--- | :--- |
| **Metrics** | Metric, or time-series, data are numeric values over time. A metric can represent any kind of measurement, like a count or a percentage. |
| **Logs** | A log entry is a \(JSON style\) data object with some properties. Each log entry may represent an event or even some state information coming from an external system. StackState is able to synchronize the checks of external systems, such as OpsView or Nagios. These systems report check changes to StackState in a log stream. These log entries are then checked for their data by a check, which in turn can translate into an element state change in StackState. |

### Telemetry stream providers

Telemetry streams are supplied via plugins. Different plugins provide one or multiple types of telemetry streams. For example, the Graphite plugin provides StackState with a metrics telemetry stream, while the Elasticsearch plugin provides metric and log telemetry streams.

### Add telemetry streams

In StackState, telemetry streams need to be linked to elements \(components or relations\). Once a telemetry stream has been linked to an element it can be used as an input for the element's checks. Read how to [add a telemetry stream to an element](add-telemetry-to-element.md).

{% hint style="info" %}
**StackState Self-Hosted**

Telemetry streams can also be defined in templates and attached automatically to elements when they are imported by a synchronization. Read how to [add telemetry during topology synchronization](../../configure/telemetry/telemetry_synchronized_topology).
{% endhint %}

## See also

* [Add a health check based on telemetry streams available in StackState](../health-state/add-a-health-check.md)
* [Add a telemetry stream to an element](add-telemetry-to-element.md)
* [Use templates to add telemetry streams to your own integrations](../../configure/telemetry/telemetry_synchronized_topology.md "StackState Self-Hosted only")
* [Check functions](../../develop/developer-guides/custom-functions/check-functions.md "StackState Self-Hosted only")
