# Top metrics

## Overview

When you hover the mouse pointer over a component in the Topology Perspective, the component context menu is displayed. This contains a list of the three top metrics for the component, together with the most recently retrieved metric value. Click the metric name to open the associated metric stream in the [telemetry inspector](/use/metrics-and-events/browse-telemetry.md).

![Top metrics](/.gitbook/assets/v51_component_context_menu.png)

## Change the displayed metrics

The metrics displayed are taken from the three metric streams displayed at the top of the **Telemetry** list. The order of the **Telemetry** list is defined by the **Priority** assigned to each telemetry stream and then by the name of the telemetry stream. To change the top metrics displayed in the component context menu, [set the telemetry stream priority](/use/metrics-and-events/set-telemetry-stream-priority.md) to place the required telemetry streams at the top of the **Telemetry** list.

![Top metrics and telemetry streams](/.gitbook/assets/v51_top_metrics_streams.png)

## Reported metric values

The metric values displayed are the current metric value of the associated metric stream. If no value is available, or the last received metric is more than a few seconds old, `n/a` will be displayed. Click the metric name to open the stream in the [telemetry inspector](/use/metrics-and-events/browse-telemetry.md) and browse all retrieved values.

## See also

* [Component context menu](/use/stackstate-ui/perspectives/topology-perspective.md#component-context-menu)
* [Telemetry inspector](/use/metrics-and-events/browse-telemetry.md)
* [Set telemetry stream priority](/use/metrics-and-events/set-telemetry-stream-priority.md)