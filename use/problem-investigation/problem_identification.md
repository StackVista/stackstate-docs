# Problem identification

## Overview

When a component or relation reports a DEVIATING (orange) or CRITICAL (red) state, StackState will identify this as a problem in your IT environment. As StackState is aware of the connections and dependencies between components in the topology, related unhealthy state changes can be grouped together into a single problem with a single root cause. Having access to all unhealthy components affected by a single root in a dedicated sub-view together with related events and will speed up problem investigation .

## What is a StackState problem?

A problem in StackState is the collection of components that relate to a single root cause. A problem is created when a component's health state changes to DEVIATING or CRITICAL. All other components in the landscape with an unhealthy state that can be attributed to the same root cause and their relations will be added to the same problem. Unhealthy components in the problem are classed as either the root cause or a contributing cause:

* **Root cause** - Each problem has a single root cause. This is the unhealthy component at the bottom of the dependency chain.
* **Contributing cause** - A problem can contain any number of contributing causes. These are all of the unhealthy components in the problem, other than the root cause.
* **Healthy components** - A number of healthy components will also be included in a problem. These are all components related to the root cause or one of the contributing causes in both directions:
    - Upstream dependencies of the root cause or one of the contributing causes.
    - Downstream components with an unhealthy [propagated state](/configure/topology/propagation.md) that originates from either the root cause or one of the contributing causes.

It is possible for a single unhealthy component to be part of two separate problems. If there are two potential root cause components for a component's unhealthy state, StackState will see this as two separate problems. 

## Changes to root cause

Changes in the health state of components in the landscape may result in the root cause of problems being updated. Perhaps an existing root cause switches to a healthy state or a previously healthy upstream dependency switches to an unhealthy state. 

If a new unhealthy component would become the new root cause for more than one existing problem, StackState will combine these into one problem. The more recent of the original problems will be incorporated into the oldest problem (subsumed) and the oldest problem will have its root cause updated to be the new root cause component. This would happen, for example, if an upstream dependency of two root cause components switched to an unhealthy state.

If the root cause component of a problem switches its state to healthy, the next unhealthy component at the bottom of the dependency chain become the root cause. If there are two or more potential new root causes, StackState will split the problem. As each problem can only have one root cause, a new problem will be created for each potential root cause. 

## Problem resolution

When the root cause and all contributing cause components have changed to a CLEAR (green) health state, the problem is considered as resolved and will no longer be visible in the StackState UI. If the components change back to an unhealthy state in the future, this will be reported as a new problem in StackState.

## See also

- [How to navigate through a problem in the StackState UI](/use/problem-investigation/problem_navigation.md)
- [Anomaly detection](/use/introduction-to-stackstate/anomaly-detection.md)
- [Send event notifications](/use/health-state-and-event-notifications/send-event-notifications.md)