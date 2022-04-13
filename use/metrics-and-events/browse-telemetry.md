---
description: StackState Self-hosted v4.6.x
---

# Browse telemetry

## Overview

The StackState UI displays a visualization of filtered data for each configured telemetry stream.

Telemetry streams are added to elements automatically when they are imported to StackState or you can manually [add a single telemetry stream](add-telemetry-to-element.md) to a single component.

## Telemetry inspector

Click on any of the telemetry stream charts, or select **Inspect stream** from its context menu, to open the telemetry inspector.

![Telemetry inspector](../../.gitbook/assets/v46_telemetry-inspector.png)

Within the telemetry inspector you can adjust the selected metric as well as the filters, time window and aggregation applied to the data source. Changes made here will not be saved to the telemetry stream attached to the element.

### Anomalies feedback

The table below the metric graph shows details of the found anomalies.  Users can give feedback on an anomaly in the form of a thumbs-up ("well spotted") or thumbs-down ("false positive").  For more elaborate feedback it is possible to leave comments.  Anomalies with feedback can be exported using the [CLI](../../../develop/reference/cli_reference) and sent to StackState, to enable improvement of the [Autonomous Anomaly Detector](../../add-ons/aad).

{% hint style="warning" %}
Comments are included in the data sent to StackState, so take care not to include sensitive data.
{% endhint %}

## See also

* [Add a single telemetry stream to a component](add-telemetry-to-element.md)
* [Monitor a telemetry stream with a health check](../health-state/add-a-health-check.md)
* [Use templates to add telemetry streams to your own integrations](../../configure/telemetry/telemetry_synchronized_topology.md "StackState Self-Hosted only")
