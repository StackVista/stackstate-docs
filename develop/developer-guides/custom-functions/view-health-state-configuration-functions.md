---
description: StackState Self-hosted v5.0.x 
---

# View health state configuration functions

## Overview

A view health state configuration function is a user defined script that takes user parameters and has access to a `viewSummary` variable that can be used to get summary information on the \(states of\) the components and relations in the view.

## Create a custom view health state configuration function

To create, update or delete a view state configuration, go to **Settings** -&gt; **Functions** -&gt; **View Health State Configuration Functions**.

A view health state configuration function receives a `viewSummary` as well as any **User parameters** named in the function. It needs to return value from the `viewHealthStates` enum - one of `UNKNOWN`, `CLEAR`, `DEVIATING` or `CRITICAL`.

## Available properties and methods

The `viewSummary` is available to all view health state configuration functions and gives access to the following methods:

| Method | Returns |
| :--- | :--- |
| `countHealthState` | A count of all components with a specified state. See [countHealthState and countPropagatedHealthState](view-health-state-configuration-functions.md#counthealthstate-and-countpropagatedstate). |
| `countPropagatedHealthState` | A count of all elements with a specified propagated state. See [countHealthState and countPropagatedHealthState](view-health-state-configuration-functions.md#counthealthstate-and-countpropagatedstate). |
| `viewSummary` | A list of the states of all elements in the view. See [ElementState](view-health-state-configuration-functions.md#elementstate). |

### countHealthState and countPropagatedHealthState

The methods `countHealthState` and `countPropagatedHealthState` return a count of all components in the view with a specified state. For example:

```text
viewSummary.countPropagatedHealthState(propagatedHealthStates.DEVIATING)
```

Note that `countPropagatedHealthState` will return a count of all elements with a specified propagated state. As both the originating component and all relations have a propagated health state these will be included in the returned count. This means that a `DEVIATING` propagated health state count of a view with one deviating component will be three. Two for the components \(originating and propagated\) and one for the relation.

In the script example below, `minCriticalHealthStates` and `minDeviatingHealthStates` are user parameters. These are named in the view health state configuration function and set by the user when the view health state is configured.

```groovy
if (viewSummary.countHealthState(healthStates.CRITICAL) >= minCriticalHealthStates) {
   return viewHealthStates.CRITICAL;
} else if (viewSummary.countHealthState(healthStates.DEVIATING) >= minDeviatingHealthStates) {
   return viewHealthStates.DEVIATING;
} else {
   return viewHealthStates.CLEAR;
}
```

### ElementState

The states of all components and relations in the view can be accessed as a list from `viewSummary` using `ElementState`. `ElementState` has the following properties:

* `elementId`
* `stateId`
* `name`
* `layer`
* `domain`
* A list of `environments`
* A list of `labels`
* Element `type`
* `healthState`
* `propagatedHealthState`

This can be used to query particular elements in the view. In the example below, a CRITICAL state will be returned if any component of type DB reports a `DEVIATING` state. In all other cases a CLEAR state will be returned:

```groovy
if (viewSummary.getStates().any{elementState -> (elementState.type == "DB") && (elementState.healthState >= healthStates.DEVIATING ) } ) {
   return viewHealthStates.CRITICAL;
} else {
   return viewHealthStates.CLEAR;
}
```

## See also

* [Configure the view health](../../../use/checks-and-monitors/configure-view-health.md)

