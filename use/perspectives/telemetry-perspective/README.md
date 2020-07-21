---
description: See metrics of the components in your IT landscape.
---

# Telemetry Perspective

The Telemetry Perspective shows telemetry streams for your [view](../topology-perspective/views.md) and provides an automatic dashboard. Instead of pre-defining which streams you want to see, StackState automatically delivers all the relevant information for any part of your landscape.

## Telemetry and Components

The Telemetry perspective can be adjusted in two different ways: by selecting a narrow and specific Topology and changing the view to Telemetry Perspective, or by opening a new Telemetry Perspective and using the [Component Selector](how_to_narrow_the_telemetry_perspective.md). 

The first option, unless the current Topology selection has been restricted to 5 components, results in Telemetry Perspective for the five newest unhealthy components \(critical, deviating\). If there are no unhealthy components, then Telemetry Perspective shows the last five components that changed their state. You can narrow your Telemetry perspective using the [Component Selector](how_to_narrow_the_telemetry_perspective.md). 

The second option allows you to select up to 5 components from the currently selected Topology and show their telemetry side by side.

## Charts

![Telemetry Perspective](../../../.gitbook/assets/telemetryperspective.png)

Charts are showing Telemetry Data of selected components in near real-time - they are fetching data every 30 seconds. If a process is stopped and no more data is received, then eventually, the process will leave the chart as the data shifts left at least every 30 seconds. If there is more data that comes in during the 30 second interval it will be pushed to a chart. A single chart can display multiple lines for the same metric when multiple components are selected - this grouping is based on the name of the stream. It is possible to cycle through each of these streams and depict them as a single line in a single chart using the arrow controls on the chart.

## Time travel

Time traveling with the Telemetry Perspective is also possible. When time traveling, the currently selected Topology is time traveled, and the telemetry of those components are depicted in the charts. It is possible that the selected component may no longer exist in the time traveled state, no data for this component will be shown.

## Ordering

The Telemetry Perspective orders the streams based on their [priority](how_to_use_the_priority_field_for_components.md). 



