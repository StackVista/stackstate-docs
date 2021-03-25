# Problem navigation

## Overview

Unhealthy components in a view are grouped into [problems](/use/problem-investigation/problem_identification.md) based on how they are connected. Problems are reported in the View Details pane on the right of the screen under **Problems**. They are listed in reverse order, with the oldest problem in the view at the top of the list. CLick on a problem to open the [Problem Details pane](#problem-details-pane) with further information about the problem.

![View Details pane](/.gitbook/assets/v43_view_details_problems.png)

## Problem Details pane

The Problem Details pane gathers together information about unhealthy components in a problem (the root cause and contributing causes), as well as a list of events that may have triggered the problem ([probably causes](#probable-causes)). It's a great place to start investigating a problem.

Click the **SHOW AS SUBVIEW** button to open the components and relations in a problem in a dedicated, temporary subview.

## Probable causes

For each reported problem, StackState will list all events that are likely to have contributed to the problem. These are all events of type **Version changed**, **Anomaly** or **Element properties changed** for components in the problem that occur within the problem time window. If no relevant events are available in StackState, the list will be empty.

Note that the probable causes in a problem details pane may include events that occurred outside of the current time window.

## Problem subview

From the problem details pane, click the **SHOW AS SUBVIEW** button to open the components and relations in a problem in a dedicated, temporary subview. A problem subview includes more components than would be shown by selecting to show the full root cause tree for unhealthy components in a view. The following components are included in the subview:
 
 - the problem root cause
 - all contributing causes 
 - all healthy components connected to the root cause or a contributing cause component

### Anomaly events



### Element properties changed events


### Version changed events


## See also

- [Problem identification](/use/problem-investigation/problem_identification.md)
- [Anomaly detection](/use/introduction-to-stackstate/anomaly-detection.md)
- [Send event notifications](/use/health-state-and-event-notifications/send-event-notifications.md)