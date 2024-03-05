---
description: StackState SaaS
---

# What is a problem?

## Overview

When a component or relation reports a `DEVIATING` \(orange\) or `CRITICAL` \(red\) state, StackState will identify this as a problem in your IT environment. As StackState is aware of the connections and dependencies between components in the topology, related unhealthy state changes can be grouped together into a single problem with a single probable root cause. This is helpful because it will:

* **Speed up problem investigation** - all unhealthy elements affected by a single root cause can be found in a dedicated subview.
* **Reduce noise** - the evolution of the problem can be tracked as a single entity, rather than a collection of individual, unhealthy elements.

![Problems in View summary](/.gitbook/assets/v51_problem_summary.png)

## Topology elements in a problem

A problem in StackState is a collection of unhealthy elements (components and relations) that can all be attributed to a single probable root cause. Each problem has one root cause element and any number of contributing causes.

### Root cause

The root cause is the unhealthy element at the bottom of the dependency chain. Each problem has a single root cause, this element is considered the probable root cause for the problem. A change in the health state of elements might result in a change to the root cause of a problem. For example:

- A previously healthy upstream dependency switches to an unhealthy state. The existing root cause is no longer the unhealthy element at the bottom of the dependency chain. All affected problems will be updated to reflect the new root cause element. This update may result in existing problems being subsumed.
- The existing root cause switches its state to healthy. As the root cause must have an unhealthy state, the next contributing cause in the dependency chain will become the new root cause. If there is more than one possible new root cause element, new problems will be created - one for each root cause.

When the root cause element changes, a `Problem updated` event is generated. Note that the update might also result in a new problem being created or an existing problem being subsumed.

➡️ [Learn more about the problem lifecycle](problem-lifecycle.md)

### Contributing causes

A problem can contain any number of contributing causes. These are all the unhealthy elements that depend on the problem's root cause element. A change in the health state of elements might result in contributing causes being added to or removed from an existing problem. It's possible for a single unhealthy element to be a contributing cause in two separate problems - if there are two potential root cause elements for an element's unhealthy state, StackState will see this as two separate problems. 

When a contributing cause element is added or removed, a `Problem updated` event is generated.

➡️ [Learn more about the problem lifecycle](problem-lifecycle.md)

## Time window of a problem

A problem is considered to start one hour before the timestamp of the first reported unhealthy state it contains and end five minutes after the last change to an unhealthy state. Note that the first unhealthy state in the problem might not have been reported by the root cause component. If a component in the problem changes to an unhealthy state or a new component is added to the problem, the problem time window will be extended to include this state change.

## See also

* [How to navigate through a problem in the StackState UI](problem_investigation.md)
* [Problem lifecycle](problem-lifecycle.md)
* [Anomaly detection](../concepts/anomaly-detection.md)
* [Problem notifications](problem_notifications.md)
