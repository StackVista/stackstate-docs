---
description: StackState SaaS
---

# Problem lifecycle

## Overview

After a problem has been identified in the StackState topology, it will be tracked and updated accordingly as the health state of elements change. Whenever there is a change to a problem, an associated event will be generated in StackState. These problem events can be used to [trigger problem notifications](problem_notifications.md), such as a message to a Slack channel.

The stages in the problem lifecycle and associated StackState events are described on this page:

1. [Problem created](#problem-created) - a new problem is identified.
2. [Problem updated](#problem-updated) - a change to an existing problem.
3. [Problem subsumed](#problem-subsumed) - a problem becomes part of an older problem.
4. [Problem resolved](#problem-resolved) - all affected elements in a problem are now healthy.

## Problem created

If an element's health state changes to `DEVIATING` (orange) or `CRITICAL` (red) and the probable root cause isn't already part of an existing problem, a new problem will be created. All other elements in the landscape with an unhealthy state that can be attributed to the same root cause will be added to the same problem as contributing causes. 

When a problem is created, the following events are generated:

* A `Problem created` event for each created problem.

![Problem created](/.gitbook/assets/v51_problem_created_animation.gif)

## Problem updated

A problem will be updated if an element in the landscape switches its state to `DEVIATING` (orange) or `CRITICAL` (red) and becomes a new contributing cause or root cause for an existing problem. A problem will also be updated if one of the included elements changes its state to healthy (green).

When a problem is updated, the following events are generated:

* A `Problem updated` event for each update to a problem.

{% hint style="info" %}
Updates to an existing problem may result in another existing problem being [subsumed](#problem-subsumed) or a new problem being [created](#problem-created).
{% endhint %}

![Problem updated](/.gitbook/assets/v51_problem_updated_animation.gif)

## Problem subsumed

If an element switches its state to unhealthy and would become the new root cause for more than one existing problem, StackState will combine all of these problems into one problem. The oldest of the problems will be updated to have the new root cause element and all other problems with the same root cause are subsumed. This would happen, for example, if an upstream dependency of two root cause elements switched to an unhealthy state.

When a problem is subsumed, the following events are generated:

* A `Problem updated` event for the oldest problem - the only problem that remains.
* A `Problem subsumed` event for each other (subsumed) problem.

![Problem subsumed](/.gitbook/assets/v51_problem_subsumed_animation.gif)

## Problem resolved

When the root cause and all contributing cause elements have changed to a CLEAR \(green\) health state, the problem is considered as resolved and will no longer be visible in the StackState UI. 

When a problem is resolved, the following event is generated:

* A `Problem resolved` event for the resolved problem.

{% hint style="info" %}
If elements from the problem change back to an unhealthy state in the future, this will be reported as a new problem in StackState.
{% endhint %}

![Problem resolved](/.gitbook/assets/v51_problem_resolved_animation.gif)

## See also

* [What is a problem?](about-problems.md)
* [How to navigate through a problem in the StackState UI](problem_investigation.md)
* [Anomaly detection](../concepts/anomaly-detection.md)
* [Problem notifications](problem_notifications.md)
