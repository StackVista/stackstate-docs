---
description: StackState Self-hosted v5.0.x
---

# What is a problem?

## Overview

When a component or relation reports a DEVIATING \(orange\) or CRITICAL \(red\) state, StackState will identify this as a problem in your IT environment. As StackState is aware of the connections and dependencies between components in the topology, related unhealthy state changes can be grouped together into a single problem with a single probable root cause. This is helpful because it will:

* **Speed up problem investigation** - all unhealthy elements affected by a single root cause can be found in a dedicated sub-view.
* **Reduce noise** - the evolution of the problem can be be tracked as a single entity, rather than a collection of individual, unhealthy elements.

![Problems in View Summary](/.gitbook/assets/v50_problem_summary.png)

## Topology elements in a problem

A problem in StackState is a collection of unhealthy elements (components and relations) that can all be attributed to a single probable root cause. Each problem contains one root cause element and any number of contributing causes.

### Root cause

The root cause is the unhealthy element at the bottom of the dependency chain. Each problem contains a single root cause, this element is considered the probable root cause for the problem. A change in the health state of elements might result in a change to the root cause of a problem. For example:

- A previously healthy upstream dependency switches to an unhealthy state. The existing root cause is no longer the unhealthy element at the bottom of the dependency chain. All affected problems will be updated to reflect the new root cause element. This update may result in existing problems being subsumed.
- The existing root cause switches its state to healthy. As the root cause must have an unhealthy state, the next contributing cause in the dependency chain will become the new root cause. If there is more than one possible new root cause element, new problems will be created - one for each root cause.

When the root cause element changes, a `Problem updated` event is generated. Note that the update might also result in a new problem being [created](#problem-created) or an existing problem being [subsumed](#problem-subsumed).

### Contributing causes

A problem can contain any number of contributing causes. These are all of the unhealthy elements that depend on the problem's root cause element. A change in the health state of elements might result in contributing causes being added to or removed from an existing problem. It is possible for a single unhealthy element to be a contributing cause in two separate problems - if there are two potential root cause elements for an element's unhealthy state, StackState will see this as two separate problems. 

When a contributing cause element is added or removed, a `Problem updated` event is generated.

## Problem lifecycle

### Problem created

If an element's health state changes to DEVIATING (orange) or CRITICAL (red) and the probable root cause is not already part of an existing problem, a new problem will be created. All other elements in the landscape with an unhealthy state that can be attributed to the same root cause will be added to the same problem as contributing causes. 

When a problem is created, the following events are generated:

* A `Problem created` event for each created problem.

![Problem created](/.gitbook/assets/problem_created_animation.gif)

### Problem updated

A problem will be updated if an element in the landscape switches its state to DEVIATING (orange) or CRITICAL (red) and becomes a new contributing cause or root cause for an existing problem. A problem will also be updated if one of the included elements changes its state to healthy (green).

When a problem is updated, the following events are generated:

* A `Problem updated` event for each update to a problem.

{% hint style="info" %}
Updates to an existing problem may result in another existing problem being [subsumed](#problem-subsumed) or a new problem being [created](#problem-created).
{% endhint %}

![Problem updated](/.gitbook/assets/problem_updated_animation.gif)

### Problem subsumed

If an element switches its state to unhealthy and would become the new root cause for more than one existing problem, StackState will combine all of these problems into one problem. The oldest of the problems will be updated to have the new root cause element and all other problems with the same root cause are subsumed. This would happen, for example, if an upstream dependency of two root cause elements switched to an unhealthy state.

When a problem is subsumed, the following events are generated:

* A `Problem updated` event for the oldest problem - the only problem that remains.
* A `Problem subsumed` event for each other (subsumed) problem.

![Problem subsumed](/.gitbook/assets/problem_subsumed_animation.gif)

### Problem resolved

When the root cause and all contributing cause elements have changed to a CLEAR \(green\) health state, the problem is considered as resolved and will no longer be visible in the StackState UI. 

When a problem is resolved, the following event is generated:

* A `Problem resolved` event for the resolved problem.

{% hint style="info" %}
If elements from the problem change back to an unhealthy state in the future, this will be reported as a new problem in StackState.
{% endhint %}

![Problem resolved](/.gitbook/assets/problem_resolved_animation.gif)

## See also

* [How to navigate through a problem in the StackState UI](problem_investigation.md)
* [Anomaly detection](../concepts/anomaly-detection.md)
* [Problem notifications](problem_notifications.md)
