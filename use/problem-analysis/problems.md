# What is a problem?

## Overview

When a component or relation reports a DEVIATING \(orange\) or CRITICAL \(red\) state, StackState will identify this as a problem in your IT environment. As StackState is aware of the connections and dependencies between components in the topology, related unhealthy state changes can be grouped together into a single problem with a single root cause. This is helpful because it will:

* **Speed up problem investigation** - all unhealthy elements affected by a single root cause can be found in a dedicated sub-view.
* **Reduce noise** - the evolution of the problem can be be tracked as a single entity, rather than a collection of individual, unhealthy elements.

![Problems in View Details pane](../../.gitbook/assets/v45_problem_summary.png)

## What is a StackState problem?

A problem in StackState is the collection of unhealthy components that can be attributed to a single root cause. A problem contains the following components:

* A single root cause - this is the unhealthy component at the bottom of the dependency chain.
* Any number of contributing causes - these are all of the unhealthy components that depend on the root cause.

## Problem lifecycle

A problem is [created](#problem-created) when the health state of a component in a view changes to DEVIATING or CRITICAL.

Updates to the health state of other components in the view may result in new problems being created and/or an existing problem being [updated](#problem-updated) to include a new contributing cause. 

The root cause of an existing problem may also change, for example if an existing root cause component switches to a healthy state, or if a previously healthy upstream dependency switches to an unhealthy state. StackState will assess these changes and update the affected problem or problems accordingly. This may result in a new problem being created, or existing problems being updated or [subsumed](#problem-subsumed).

![problem lifecycle](/.gitbook/assets/problem_lifecycle_animation.gif)

### Problem created

A problem is created when a component's health state changes to DEVIATING or CRITICAL. All other components in the landscape with an unhealthy state that can be attributed to the same root cause will be added to the same problem. It is possible for a single unhealthy component to be a contributing cause in two separate problems. If there are two potential root cause components for a component's unhealthy state, StackState will see this as two separate problems.

### Problem updated

A problem will be updated if a component in the landscape switches its state to DEVIATING or CRITICAL and becomes a new contributing cause or root cause for an existing problem.

### Problem subsumed

If a component switches its state to unhealthy and would become the new root cause for more than one existing problem, StackState will combine all of these problems into one problem. The original problems will all be incorporated into the oldest problem with the same root cause \(subsumed\) and the oldest problem will have its root cause updated to be the new root cause component. This would happen, for example, if an upstream dependency of two root cause components switched to an unhealthy state.

The following events will be generated:

* One `Problem updated` event for the oldest problem.
* `Problem subsumed` events will be generated for all other problems.

### Problem resolved

When the root cause and all contributing cause components have changed to a CLEAR \(green\) health state, the problem is considered as resolved and will no longer be visible in the StackState UI. A `Problem resolved` event will be generated.

If the components change back to an unhealthy state in the future, this will be reported as a new problem in StackState.


## Changes to problem root cause




### One problem, two root causes

If the root cause component of a problem switches its state to healthy, the next unhealthy component at the bottom of the dependency chain will become the new root cause. If there are two or more potential new root causes, StackState will split the problem. As each problem can only have one root cause, a new problem will be created for each potential root cause.

The following events will be generated:

* One `Problem updated` event for the problem whose new root cause with the oldest health state change timestamp of all new root causes. 
* `Problem created` events for all other new problems.

## See also

* [How to navigate through a problem in the StackState UI](problem_investigation.md)
* [Anomaly detection](../concepts/anomaly-detection.md)
* [Problem notifications](problem_notifications.md)

