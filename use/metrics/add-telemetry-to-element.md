---
description: StackState Self-hosted v5.1.x 
---

# Add a telemetry stream

## Overview

Elements in StackState can have a telemetry \(metrics or log\) stream assigned. This provides additional insight into your topology and is required, for example, to [monitor the health of an element](../checks-and-monitors/add-a-health-check.md). If a telemetry stream was not automatically assigned to an element, or you want to add a custom telemetry stream, you can do this manually from the StackState UI.

## Add a telemetry stream to an element

Telemetry streams can be added to any component or direct relation in the StackState Topology Perspective.

![Add a telemetry stream to an element](../../.gitbook/assets/v51_add_telemetry_stream.png)

1. Select the component or direct relation that you want to add a telemetry stream to.
   * Detailed information about the element will be displayed in the right panel details tab - **Component details** or **Direct relation details** depending on the element type that you have selected.
2. Click **ADD NEW STREAM** under **Telemetry** in the right panel details tab.
3. Provide the following details:
   * **Name** - A name for the telemetry stream. This will be visible in the StackState UI.
   * **Data source** - The data source for the telemetry stream. You can select from the standard data sources or add your own in **Settings** &gt; **Telemetry Sources**.
4. Click **NEXT**
5. At the top of the **Add a new stream** popup, select whether to output the telemetry stream as a Metric stream or a Log stream:
   * **Metric stream** \(default\) - use for metrics. Allows for various [aggregation methods](#aggregation-methods) and will be visualized as a timeseries line chart.
   * **Log stream** - use for streams that contain logs and events. Will be visualized as a bar chart.
6. Provide the following details:
   * **Time window** - The selection of time to be shown in the StackState UI. The time window is used for display purposes only and does not affect handling in any way.
   * **Filters** - Select the data relevant to the element. For example, if the data source contains data about all services on a host, select the specific host and service to attach data for.
   * **Select** - for metric streams only, select the metric that you want to retrieve and the function to apply to it.
   * **Priority** - Optional, you can [set a priority for the telemetry stream](set-telemetry-stream-priority.md). This will influence the order in which the stream is displayed in the StackState UI and the way the stream is handled by other services, such as the [Autonomous Anomaly Detector](../../stackpacks/add-ons/aad.md).
7. The stream preview on the right will update to show the incoming log or metric values based on the details you provide.
8. Click **SAVE** to add the stream to the element.
   * You will receive a notification that the stream has been successfully completed.
9. A graph of the selected telemetry stream data will be visible under **Telemetry** in the right panel details tab. You can inspect data in the stream using the [telemetry inspector](browse-telemetry.md).

### Aggregation methods

The following aggregation methods are available:

* `MEAN` - mean
* `PERCENTILE_25` - 25th percentile
* `PERCENTILE_50` - 50th percentile
* `PERCENTILE_75` - 75th percentile
* `PERCENTILE_90` - 90th percentile
* `PERCENTILE_95` - 95th percentile
* `PERCENTILE_98` - 98th percentile
* `PERCENTILE_99` - 99th percentile
* `MAX` - maximum value
* `MIN` - minimum value
* `SUM` - sum of the values
* `EVENT_COUNT` - the number of occurrences during the bucket interval
* `SUM_NO_ZEROS` - sum of the values \(missing values from a data source won't be filled with zeros\)
* `EVENT_COUNT_NO_ZEROS` - the number of occurrences during the bucket interval \(missing values from a data source won't be filled with zeros\)

## See also

* [Autonomous Anomaly Detector](../../stackpacks/add-ons/aad.md)
* [Monitor the health of an element](../checks-and-monitors/add-a-health-check.md)
* [Browse data in a telemetry stream](browse-telemetry.md)
* [Set a priority for the telemetry stream](/use/metrics/set-telemetry-stream-priority.md)
* [Use templates to add telemetry streams to your own integrations](../../configure/telemetry/telemetry_synchronized_topology.md "StackState Self-Hosted only")
