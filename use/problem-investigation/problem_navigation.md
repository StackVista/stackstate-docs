# Problem navigation

## Overview

Unhealthy components in a view are grouped into [problems](/use/problem-investigation/problem_identification.md) based on how they are connected. Problems are reported in the View Details pane on the right of the screen under **Problems**. They are listed in reverse order, with the oldest problem in the view at the top of the list. CLick on a problem to open the [Problem Details pane](#problem-details-pane) with further information about the problem.

![View Details pane](/.gitbook/assets/v43_view_details_problems.png)

## Problem Details pane

The Problem Details pane gathers together all the information you need to get started investigating a problem in your landscape. All unhealthy components in the problem (the root cause and contributing causes). Events that may have triggered the unhealthy state changes in the problem are listed as the [probable causes](#probable-causes).

Click the **SHOW AS SUBVIEW** button to open all components and relations in a problem in a dedicated, temporary [problem subview](#problem-subview).

## Probable causes

For each reported problem, StackState will list all events that are likely to have contributed to the problem. Events of type **Anomaly**, **Element properties changed** or **Version changed** for components in the problem that occur within the [problem time window](/use/problem-investigation/problem_identification.md#time-window-of-a-problem)could be considered as probable causes. If no relevant events are available in StackState, the list will be empty.

{% hint style="info" %}
Note that the probable causes in a problem details pane may include events that occurred outside of the current time window. You may need to adjust the time window to open an event.
{% endhint %}

### Anomaly events



### Element properties changed events


### Version changed events


## Problem subview

A problem subview is a temporary StackState view with filters that return components and relations related to the problem and a time window that matches the [problem time window](/use/problem-investigation/problem_identification.md#time-window-of-a-problem)

All components that are related to the problem are included in the problem subview. This includes more components than would be shown by selecting to show the [full root cause tree](/use/views/topology-perspective.md#root-cause-outside-current-view). The following components are included in the problem subview:
 
 - the root cause of the problem
 - all contributing causes 
 - all healthy components connected to the root cause or a contributing cause component
 
Within the problem subview you have access to all perspectives with data specific to the problem time window and involved components. The applied filters can be adjusted, but it is not possible to save the subview. You can share the problem subview, including your modifications, with other StackState users using the link.

To exit the Problem Subview, click on the view name in the top bar of the StackState UI.

![Breadcrumbs with view name]

## See also

- [Problem identification](/use/problem-investigation/problem_identification.md)
- [Anomaly detection](/use/introduction-to-stackstate/anomaly-detection.md)
- [Send event notifications](/use/health-state-and-event-notifications/send-event-notifications.md)