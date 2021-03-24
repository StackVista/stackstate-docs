# Problem identification

## Overview

When a component or relation reports a DEVIATING (orange) or CRITICAL (red) state, StackState will identify this as a problem in your IT environment. As StackState is aware of the connections and dependencies between elements in the topology, related unhealthy state changes can be grouped together into a single problem with a single root cause. This is helpful because it will:
 
 - **Speed up problem investigation** - all unhealthy elements affected by a single root cause can be found in a dedicated sub-view.
 - **Reduce noise** - the evolution of the problem can be be tracked as a single entity, rather than a collection of individual, unhealthy elements.

## What is a StackState problem?

A problem in StackState is the collection of elements that relate to a single root cause. A problem is created when an element's health state changes to DEVIATING or CRITICAL. All other components in the landscape with an unhealthy state that can be attributed to the same root cause and their relations will be added to the same problem. Unhealthy components in the problem are classed as either the root cause or a contributing cause:

* **Root cause** - Each problem has a single root cause. This is the unhealthy element at the bottom of the dependency chain.
* **Contributing cause** - A problem can contain any number of contributing causes. These are all unhealthy elements, other than the root cause, that are included in the problem.

{% hint style="success" %}
A problem includes more components than would be shown by selecting to show the full root cause tree for unhealthy components in a view. Problems contain the root cause, all contributing causes and all healthy components connected to the root cause or a contributing cause component.
{% endhint %}

It is possible for a single unhealthy component to be part of two separate problems. If there are two potential root cause components for a single unhealthy component, this will be seen as two separate problems in the StackState. It is possible that a future update to the health state of other components in the landscape may result in these two problems in fact being shown to have a single root cause. In this case, the more recent of the two problems will be subsumed by the older problem, and the older problem will have its root cause updated.


## Problem time window

A problem is considered to start at the point in time when the oldest unhealthy component changed state to an unhealthy state. This does not need to be the root cause component. The end of the problem is seen as five minutes after the last change to an unhealthy state of a component included in the problem. If a new component changes state and is added to the problem, the problem time window will be extended to include this.


## Problem resolution

TODO: When is a problem classed as "resolved"? Is it possible to view a history of problems?

## See also

- [How to navigate through a problem in the StackState UI](/use/problem-investigation/problem_navigation.md)
- [Anomaly detection](/use/introduction-to-stackstate/anomaly-detection.md)
- [Send event notifications](/use/health-state-and-event-notifications/send-event-notifications.md)