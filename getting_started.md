---
description: StackState SaaS
---

# Getting Started





## Explore topology

After setting up an [integration](/stackpacks/integrations/), you can go to the [Explore Mode](/use/stackstate-ui/explore_mode.md) to explore your IT landscape or visit a specific [view](/use/stackstate-ui/views/about_views.md) from your installed StackPacks.

StackState visualizes components in the Topology Perspective by the layer and domain that they're placed in. These are logical groupings of components. Layers are displayed on the vertical axis. Domains are displayed on the horizontal axis.

You can change which part of the landscape you are viewing \(for example, layers and domains\) with the [view filters](/use/stackstate-ui/filters.md) on the left bar, or by [hovering over a component](/use/stackstate-ui/perspectives/topology-perspective.md#component-context-menu).

➡️ [Learn more about the Topology Perspective](/use/stackstate-ui/perspectives/topology-perspective.md)

![Explore topology](/.gitbook/assets/v51_topology.png)

## Topology elements

A topology consists of components and relations combined with their health state. Because topologies can get very large, StackState automatically groups the components.

The health state of a component is indicated by two colors:

* The component color indicates the health state calculated for the component itself.
* The outer color indicates there is potential impact from unhealthy components or relations that this component depends upon.

The direction of a relation's arrow indicates dependency. For example, `app -> db` means: `app` depends on `db`. Health propagates in the opposite direction to the arrows. So if the `db` component turns red, the outer color of the `app` component will turn red too.

➡️ Learn more about [components](/use/concepts/components.md), [relations](/use/concepts/relations.md) and [health state](/use/concepts/health-state.md)

![Component](/.gitbook/assets/v51_topology_elements.png)

## Timeline

The [timeline](/use/stackstate-ui/timeline-time-travel.md) at the bottom of the screen gives you the ability to go to any point in time. All the information that you see \(component details, metric streams, etc.\) is relative to the topology that existed at the currently selected topology time. Normally, StackState is in **live mode**, this means that StackState automatically displays the latest state of the stack.

➡️ [Learn more about the timeline and time travel](/use/stackstate-ui/timeline-time-travel.md)

![Timeline](/.gitbook/assets/v51_timeline.png)

## Detailed information about components and relations

Select a component or a relation to display detailed information about it in the right panel details tab - the tab will be named according to the element type that you selected. For example, **Component details** when you select a component or **Direct relation details** when you select a relation that links two components with no hidden components in between. Click **SHOW ALL PROPERTIES** to open a popup with all details of a component or direct relation.

![Detailed component information](/.gitbook/assets/v51_component_details.png)

## Telemetry inspector

Both components and relations can have one or multiple telemetry streams. The most common type is a metric stream also known as time series. If you click on a metric stream, you can see the metric stream in a popup.

![Telemetry inspector](/.gitbook/assets/v51_component_details_inspect_metric_stream.png)

If you click on a log stream, you can see the log stream in a popup. Again, there are a number of drill-down capabilities available on the left of the popup.

![Telemetry inspector](/.gitbook/assets/v51_component_details_inspect_log_stream.png)

## Problems

![Detailed component information](/.gitbook/assets/v51_problem_summary.png)

To quickly find the cause of any DEVIATING component, head to the right panel in the StackState UI where you can find the **Problems** section. It provides an immediate understanding of ongoing problems in your IT environment clustered by their root cause and will show you the probable cause of current problems.

* The **View summary** and **Subview summary** tabs give an overview of problems based on the components impacted in the current view or subview. 
* The **Component details** lists all problems that involve the selected component. 
* The **Direct relation details** tab lists all problems that involve the selected direct relation, its source component or its target component. 

Problems and issues are displayed in order of the last problem update with the most recently updated problem at the top of the list and the oldest update at the bottom. Within each problem, component-specific issues are displayed in order of the timestamp of the last health state change, from the most recent at the top of the list to the oldest at the bottom.

Note that some components listed in the problem panel might not be visible in the current topology view. You can open a dedicated problem subview to focus on all of the topology elements involved in a specific problem.

➡️ [Learn more about problems](/use/problem-analysis/about-problems.md)

## Events

To show all events for the selected Topology, select the Events Perspective from the top of the screen. Examples of important events that may appear here are health state changes and changes to the components themselves, like version changes. With [event handlers](/use/events/event-notifications.md), you can configure StackState to react to any events, for example, by automatically creating a ticket or triggering some automation.

![Events Perspective](/.gitbook/assets/v51_events-perspective.png)

The Events Perspective isn't the only place you can find events; you can find the latest events in the Events section in the right panel **View summary** tab and in the details tabs - **Component details** and **Direct relation details**.

![Events section](/.gitbook/assets/v51_events-section.png)

➡️ [Learn more about the Events Perspective](/use/stackstate-ui/perspectives/events_perspective.md)
