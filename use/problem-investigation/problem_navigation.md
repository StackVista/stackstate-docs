# Problem navigation

## Overview

Unhealthy components in a view are grouped into [problems](/use/problem-investigation/problem_identification.md) based on how they are connected in the topology. When StackState identifies a problem this will be reported in the View Details pane on the right of the screen under **Problems**. Problems are listed by the timestamp of the health state change for the root cause component - you will find the oldest problem in the view at the bottom of the list. Click on a problem to open the [Problem Details pane](#problem-details-pane) with further information about the problem.

![View Details pane](/.gitbook/assets/v43_view_details_problems.png)

## Problem Details pane

The Problem Details pane gathers together all the information you need to get started investigating a problem in your landscape. All unhealthy components in the problem (the root cause and contributing causes) are listed here. Events that may have triggered the unhealthy state changes in the problem are listed under [Probable Causes](#probable-causes).

Click the **INVESTIGATE IN SUBVIEW** button to open all components and relations in a problem in a dedicated, temporary [problem subview](#problem-subview).

## Probable causes

For each reported problem, StackState will list all events that are likely to have contributed to unhealthy state changes in the problem. These could be events of type **Anomaly**, **Element properties changed** or **Version changed** that occurred within the [problem time window](/use/problem-investigation/problem_identification.md#time-window-of-a-problem) and relate to components in the problem. If no relevant probable cause events are available in StackState, the list will be empty.

{% hint style="info" %}
Note that the probable causes in a problem details pane may include events that occurred outside of the currently selected time window. You may need to adjust the time window in the timeline to open an event.
{% endhint %}

### Anomaly events

Anomaly events are generated whenever an anomaly is detected by the [Autonomous Anomaly Detector](/stackpacks/add-ons/aad.md). For metric stream anomalies, details of the metric stream where the anomaly was found are available in the event details pane.

1. Click on a Metric stream anomaly event in the Events Perspective
    - The event details pane opens on the right of the screen.
    - The affected stream is displayed highlighting the detected anomaly.
2. Click on the metric stream graph or select **inspect** from its menu (**...**) to open the [telemetry browser](/use/views/browse-telemetry.md) and inspect the stream in more detail.

![Metric stream anomaly event details](/.gitbook/assets/v43_event_metric_stream_anomaly.png) 

### Element properties changed events

Element properties changed events are generated whenever any of the properties of a component are updated. Exact details of the change are available from the event details pane.

1. Click on an Element properties changed event in the Events Perspective.
    - The event details pane opens on the right of the screen.
2. Click **Show all changes** in the event details pane.
    - A diff of the old and new properties is displayed.
    
![View all changes](/.gitbook/assets/v43_event_view_all_changes.png)

### Version changed events

Version changed events are generated whenever the `version` property of a component is updated. Details of the old version and new version are included in the full list of event properties.

1. Click on a Version changed event in the Events Perspective.
    - The event details pane opens on the right of the screen.
2. Click on SHOW EVENT PROPERTIES in the event details pane.
    - The full list of event properties are displayed.
3. Scroll down to find the old and new version numbers.

![Event properties - old and new version details](/.gitbook/assets/v43_event_properties_version_changed.png)

## Problem subview

A problem subview is a temporary StackState view. The filters applied to a problem subview return all components related to the [problem](/use/problem-investigation/problem_identification.md#what-is-a-stackstate-problem) root cause and any contributing causes within the [problem time window](#time-window-of-a-problem).

Within a problem subview, you have access to all perspectives containing data specific to the problem time window and involved components. The applied filters can be adjusted, but it is not possible to save the subview. You can share the problem subview with other StackState users, including any modifications you have made, as a link.

To exit the Problem Subview, click on the view name in the top bar of the StackState UI.

![Breadcrumbs with view name](/.gitbook/assets/v43_problem_subview_breadcrumb.png)

### Time window of a problem

A problem is considered to start one hour before the timestamp of the first reported unhealthy state it contains and end five minutes after the last change to an unhealthy state. Note that the first unhealthy state in the problem might not have been reported by the root cause component. If a component in the problem changes to an unhealthy state or a new component is added to the problem, the problem time window will be extended to include this state change.

## See also

- [Problem identification](/use/problem-investigation/problem_identification.md)
- [Anomaly detection](/use/introduction-to-stackstate/anomaly-detection.md)
- [Send event notifications](/use/health-state-and-event-notifications/send-event-notifications.md)