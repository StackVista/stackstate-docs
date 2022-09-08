---
description: StackState Self-hosted v5.1.x 
---

# Getting Started

Hi! So, you've just installed StackState and you are ready to get started.[](http://not.a.link "StackState Self-Hosted only")

## StackPacks[](http://not.a.link "StackState Self-Hosted only")

The first step to take is integrating StackState with your IT systems. This can be done by installing one or more [StackPacks](/stackpacks/about-stackpacks.md "StackState Self-Hosted only").

![StackPacks overview](/.gitbook/assets/v51_stackpacks.png "StackState Self-Hosted only")

## Explore topology

After setting up an [integration](/stackpacks/integrations/), you can go to the [Explore Mode](/use/stackstate-ui/explore_mode.md) to explore your IT landscape or visit a specific [view](/use/stackstate-ui/views/about_views.md) from your installed StackPacks.

StackState visualizes components in the Topology Perspective by the layer and domain that they are placed in. These are logical groupings of components. Layers are displayed on the vertical axis. Domains are displayed on the horizontal axis.

You can change which part of the landscape you are viewing \(e.g. layers and domains\) with the [view filters](/use/stackstate-ui/filters.md) on the left bar, or by [hovering over a component](/use/stackstate-ui/perspectives/topology-perspective.md#component-context-menu).

➡️ [Learn more about the Topology Perspective](/use/stackstate-ui/perspectives/topology-perspective.md)

![Explore topology](/.gitbook/assets/v51_topology.png)

## Topology elements

A topology consists of components and relations combined with their health state. Because topologies can get very large, StackState automatically groups the components.

The health state of a component is indicated by two colors:

* The component color indicates the health state that is calculated for the component itself.
* The outer color indicates there is potential impact from unhealthy components or relations that this component depends upon.

The direction of a relation's arrow indicates dependency. For example, `app -> db` means: `app` depends on `db`. Health propagates in the opposite direction to the arrows. So if the `db` component turns red, the outer color of the `app` component will turn red too.

➡️ Learn more about [components](/use/concepts/components.md), [relations](/use/concepts/relations.md) and [health state](/use/concepts/health-state.md)

![Component](/.gitbook/assets/v51_topology_elements.png)

## Timeline

The [timeline](/use/stackstate-ui/timeline-time-travel.md) at the bottom of the screen gives you the ability to go to any point in time. All the information that you see \(component details, metric streams, etc.\) is relative to the topology that existed at the currently selected topology time. Normally, StackState is in **live mode**, this means that StackState automatically displays the latest state of the stack.

➡️ [Learn more about the timeline and time travel](/use/stackstate-ui/timeline-time-travel.md)

![Timeline](/.gitbook/assets/v51_timeline.png)

## Detailed information about components and relations

Select a component or a relation to display detailed information about it in the right panel **Selection details** tab. Click **SHOW ALL PROPERTIES** to open a popup with all details of a component.

![Detailed component information](/.gitbook/assets/v51_component_details.png)

## Telemetry inspector

Both components and relations can have one or multiple telemetry streams. The most common type is a metric stream also known as time series. If you click on a metric stream, you can see the metric stream in a popup.

![Telemetry inspector](/.gitbook/assets/v51_component_details_inspect_metric_stream.png)

If you click on a log stream, you can see the log stream in a popup. Again, there are a number of drill-down capabilities available on the left of the popup.

![Telemetry inspector](/.gitbook/assets/v51_component_details_inspect_log_stream.png)

## Problems

To quickly find the cause of any DEVIATING component, head to the right panel in the selected view where you can find the **Problems** section in the **View summary** tab. It reduces the cognitive flow and provides immediate understanding of ongoing problems. The Problems section will show you the cause of problems in your view. This summary is based on the components impacted in your current view combined with all \(potential\) causes. Problems are automatically clustered by their root cause.

Problems and issues are displayed in the following order:

* StackState prioritizes problems in order of creation date/time, with the oldest problem at the top of the list and the most recently created at the bottom.
* Component-specific issues grouped inside problems are displayed from the most recent ones at the top to the oldest at the bottom of the list.

Not all components displayed in the problem panel are necessarily also visible in the current topology view. To make the root cause of a problem visible, hover a mouse pointer over the component and select `show -> root cause` from the `Actions` menu.

➡️ [Learn more about problems](/use/problem-analysis/about-problems.md)

![Detailed component information](/.gitbook/assets/v51_problem_summary.png)

## Events

To show all events for the selected Topology, select the Events Perspective from the top of the screen. Examples of important events that may appear here are health state changes and changes to the components themselves, like version changes. With [event handlers](/use/metrics-and-events/event-notifications.md), you can configure StackState to react to any events, for example, by automatically creating a ticket or triggering some automation.

![Events Perspective](/.gitbook/assets/v51_events-perspective.png)

The Events Perspective is not the only place you can find events; you can find the latest events in the Events section in the right panel **View summary** tab.

![Events section](/.gitbook/assets/v51_events-section.png)

➡️ [Learn more about the Events Perspective](/use/stackstate-ui/perspectives/events_perspective.md)
