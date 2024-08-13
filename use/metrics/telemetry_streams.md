---
description: Rancher Observability Self-hosted v5.1.x 
---

# Telemetry streams

## Overview

A telemetry stream is a real-time stream of either metric or log data coming from an external monitoring system.


### Metric streams

Metric, or time-series, data are numeric values over time. A metric can represent any kind of measurement, like a count or a percentage. 

### Log streams

A log entry is a \(JSON style\) data object with some properties. Each log entry may represent an event or even some state information coming from an external system. Rancher Observability is able to synchronize the checks of external systems, such as OpsView or Nagios. These systems report check changes to Rancher Observability in a log stream. These log entries are then checked for their data by a check, which in turn can translate into an element state change in Rancher Observability.

## Telemetry stream providers

Telemetry streams in Rancher Observability contain log or metrics data that has been retrieved from an external data source. Telemetry can be pushed to Rancher Observability by the Rancher Observability Agent or pulled directly from the data source by a Rancher Observability plugin.

## Add telemetry streams

In Rancher Observability, telemetry streams need to be linked to elements \(components or relations\). Once a telemetry stream has been linked to an element it can be used as an input for the element's health checks. Read how to [add a telemetry stream to an element](add-telemetry-to-element.md).

{% hint style="success" "self-hosted info" %}

Telemetry streams can also be defined in templates and attached automatically to elements when they're imported by a synchronization. Read how to [add telemetry during topology synchronization](../../configure/telemetry/telemetry_synchronized_topology.md).
{% endhint %}

## See also

* [Add a health check based on telemetry streams available in Rancher Observability](../checks-and-monitors/add-a-health-check.md)
* [Add a telemetry stream to an element](add-telemetry-to-element.md)
* [Use templates to add telemetry streams to your own integrations](../../configure/telemetry/telemetry_synchronized_topology.md "Rancher Observability Self-Hosted only")
* [Check functions](../../develop/developer-guides/custom-functions/check-functions.md "Rancher Observability Self-Hosted only")
