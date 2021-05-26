---
description: Propagate health states from dependencies to dependents
---

# Health state propagation

## Overview

Propagation defines how a propagated state flows from one component to the next. Propagation always flows from dependencies to dependent components and relations. Note that this is the opposite direction of the relation arrows in the graph.

A propagated state is returned as one of the following health states:

* `CRITICAL`
* `DEVIATING`
* `UNKNOWN`

A `CLEAR` health state does not propagate.

## Propagation functions

A component's propagated state is calculated using a propagation function. This can be set as **Propagation** in the component's edit dialogue in the StackState UI.

![Edit component propagation](../../../.gitbook/assets/v43_edit-component-propagation.png)

Propagation functions are used to calculate the propagated state of a component.

* **Transparent propagation \(default\)** - returns the transparent state. This is the maximum of the component's own state and the propagated state of all dependencies. For example:

  | Dependency state | Component state | Transparent state |
  | :--- | :--- | :--- |
  | `CRITICAL` | `DEVIATING` | `CRITICAL` |
  | `CLEAR` | `CRITICAL` | `CRITICAL` |
  | `DEVIATING` | `CLEAR` | `DEVIATING` |

* **Other propagation functions** - some propagation functions are installed as part of a StackPack. For example, Quorum based cluster propagation, which will propagate a `DEVIATING` state when the cluster quorum agrees on deviating and a `CRITICAL` state when the cluster quorum is in danger.
* **Custom propagation functions** - you can write your own [custom propagation functions](/develop/developer-guides/custom-functions/propagation-functions.md).

{% hint style="info" %}
A full list of the propagation functions available in your StackState instance can be found in the StackState UI, go to **Settings** &gt; **Functions** &gt; **Propagation Functions**
{% endhint %}

## See also

* [Propagation functions](/develop/developer-guides/custom-functions/propagation-functions.md)