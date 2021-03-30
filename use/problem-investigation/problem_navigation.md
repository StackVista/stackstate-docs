# Problem navigation

## Overview

Unhealthy components in a view are grouped into [problems](/use/problem-investigation/problem_identification.md) based on how they are connected in the topology. When StackState identifies a problem this will be reported in the View Details pane on the right of the screen under **Problems**. Problems are listed by the timestamp of the health state change for the root cause component - you will find the oldest problem in the view at the bottom of the list. Click on a problem to open the [Problem Details pane](#problem-details-pane) with further information about the problem.

![View Details pane](/.gitbook/assets/v43_view_details_problems.png)

## Problem Details pane

The Problem Details pane gathers together all the information you need to get started investigating a problem in your landscape. All unhealthy components in the problem (the root cause and contributing causes). Events that may have triggered the unhealthy state changes in the problem are listed as the [probable causes](#probable-causes).

Click the **INVESTIGATE IN SUBVIEW** button to open all components and relations in a problem in a dedicated, temporary [problem subview](#problem-subview).

## Probable causes

For each reported problem, StackState will list all events that are likely to have contributed to the problem. Events of type **Anomaly**, **Element properties changed** or **Version changed** for components in the problem that occur within the [problem time window](/use/problem-investigation/problem_identification.md#time-window-of-a-problem) could be considered as probable causes. If no relevant events are available in StackState, the list will be empty.

{% hint style="info" %}
Note that the probable causes in a problem details pane may include events that occurred outside of the current time window. You may need to adjust the time window to open an event.
{% endhint %}

### Anomaly events

TODO: Describe.

### Element properties changed events

TODO: Describe.

### Version changed events

Version changed events are generated whenever the `version` tag of a component is updated. 

## Problem subview

A problem subview is a temporary StackState view with filters that return components and relations related to the problem and a time window that matches the [problem time window](#time-window-of-a-problem)

All components in the [problem](/use/problem-investigation/problem_identification.md#what-is-a-stackstate-problem) are included in the problem subview. This includes more components than would be shown by selecting to show the [full root cause tree](/use/views/topology-perspective.md#root-cause-outside-current-view). 
 
Within the problem subview, you have access to all perspectives with data specific to the problem time window and involved components. The applied filters can be adjusted, but it is not possible to save the subview. You can share the problem subview, including your modifications, with other StackState users as a link.

To exit the Problem Subview, click on the view name in the top bar of the StackState UI.

![Breadcrumbs with view name]

### Time window of a problem

A problem is considered to start one hour before the timestamp of the first reported unhealthy state it contains. Note that this might not have been reported by the root cause component. The end of the problem is seen as five minutes after the last change to an unhealthy state. If a new component changes state and is added to the problem, the problem time window will be extended to include this.

## See also

- [Problem identification](/use/problem-investigation/problem_identification.md)
- [Anomaly detection](/use/introduction-to-stackstate/anomaly-detection.md)
- [Send event notifications](/use/health-state-and-event-notifications/send-event-notifications.md)