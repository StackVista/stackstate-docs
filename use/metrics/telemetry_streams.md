---
description: StackState SaaS
---

# Telemetry streams

## Overview

A telemetry stream is a real-time stream of either metric or log data coming from an external monitoring system.


### Metric streams

Metric, or time series, data are numeric values over time. A metric can represent any kind of measurement, like a count or a percentage. 

### Log streams

A log entry is a \(JSON style\) data object with some properties. Each log entry may represent an event or even some state information coming from an external system. StackState can synchronize the checks of external systems, such as OpsView or Nagios. These systems report check changes to StackState in a log stream. These log entries are then checked for their data by a check, which in turn can translate into an element state change in StackState.

## Telemetry stream providers

Telemetry streams in StackState contain log or metrics data that has been retrieved from an external data source. Telemetry can be pushed to StackState by the StackState Agent or pulled directly from the data source by a StackState plugin.

## Add telemetry streams

In StackState, telemetry streams need to be linked to elements \(components or relations\). Once a telemetry stream has been linked to an element it can be used as an input for the element's health checks. Read how to [add a telemetry stream to an element](add-telemetry-to-element.md).

{% hint style="success" "self-hosted info" %}

**StackState Self-Hosted**

Extra information for the [StackState Self-Hosted product](https://docs.stackstate.com/):

    
Telemetry streams can also be defined in templates and attached automatically to elements when they're imported by a synchronization. Read how to add telemetry during topology synchronization.
{% endhint %}

## See also

* [Add a health check based on telemetry streams available in StackState](../checks-and-monitors/add-a-health-check.md)
* [Add a telemetry stream to an element](add-telemetry-to-element.md)
