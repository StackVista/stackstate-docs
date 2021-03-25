---
description: Propagate health states from dependencies to dependents
---

# Health state propagation

{% hint style="warning" %}

**This page describes StackState version 4.2**<br />Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

Propagation defines how a propagated state flows from one component to the next. Propagation always flows from dependencies to dependent components and relations. Note that this is the opposite direction of the relation arrows in the graph.

A propagated state is returned as one of the following health states:

* `CRITICAL`
* `FLAPPING`
* `DEVIATING`
* `UNKNOWN`

A component's propagated state is calculated using a [propagation function](propagation.md#propagation-functions). This can be set as **Propagation** in the component's edit dialogue in the StackState UI.

![Edit component propagation](../../.gitbook/assets/v42_edit-component-propagation.png)

## Propagation functions

Propagation functions are used to calculate the propagated state of a component.

* **Transparent propagation \(default\)** - returns the transparent state. This is the maximum of the component's own state and the propagated state of all dependencies. For example:

  | Dependency state | Component state | Transparent state |
  | :--- | :--- | :--- |
  | `CRITICAL` | `DEVIATING` | `CRITICAL` |
  | `CLEAR` | `CRITICAL` | `CRITICAL` |
  | `DEVIATING` | `CLEAR` | `DEVIATING` |

* **Other propagation functions** - some propagation functions are installed as part of a StackPack. For example, Quorum based cluster propagation, which will propagate a `DEVIATING` state when the cluster quorum agrees on deviating and a `CRITICAL` state when the cluster quorum is in danger.
* **Custom propagation functions** - you can write your own [custom propagation functions](propagation.md#create-a-custom-propagation-function).

{% hint style="info" %}
A full list of the propagation functions available in your StackState instance can be found in the StackState UI, go to **Settings** &gt; **Functions** &gt; **Propagation Functions**
{% endhint %}

## Create a custom propagation function

You can write custom propagation functions to determine the new propagated state of an element \(component or relation\). A propagation function can take multiple parameters as input and produces a new propagated state as output. To calculate a propagated state, a propagation function has access to the element itself, the element's dependencies and the transparent state that has already been calculated for the element.

![Custom propagation funtion](../../.gitbook/assets/v42_propagation-function.png)

The simplest possible function that can be written is given below. This function will always return a `DEVIATING` propagated state:

```text
    return DEVIATING
```

You can also use a propagation function to implement more complicated logic. For example, the script below will return a `DEVIATING` state in case a component is not running:

```text
Component
  .withId(componentId)
  .fullComponent()
  .then { component ->
    if (component.runState.runState != "RUNNING") {
      return DEVIATING
    } else {    
      return transparentState
    }
  }
```

This code works as follows:

| Code | Description |
| :--- | :--- |
| `.withId(componentId)` | The `componentId` is passed as long and resolved |
| `.fullComponent()` | Returns a JSON-style representation of the component. This is the same format as is obtained from the `Show Json` component properties menu or by using a [topology query](../../develop/reference/scripting/script-apis/topology.md) in analytics. |
| `then { component -> ... }` | An async lambda function where the main logic for the propagation function resides. `component` is the component variable, which has properties that can be accessed using `.<property name>`. For example, `.type` returns component type id. |
|  |  |

### Parameters

A propagation function script takes system and user defined parameters. System parameters are predefined parameters passed automatically to the script:

| System parameter | Description |
| :--- | :--- |
| `transparentState` | The precomputed transparent state if returned from the script will lead to transparent propagation |
| `component` | The id of the current component |

### Async On / Off

Propagation functions can be run as either async \(default\) or synchronous.

* With Async set to **On** the function will be run as [async](propagation.md#async-propagation-functions-default).
* With Async set to **Off** the function will be run as [synchronous](propagation.md#synchronous-propagation-functions-async-off).

#### Async propagation functions \(default\)

Running as an async function will allow you to make an HTTP request and use [StackState script APIs](../../develop/reference/scripting/script-apis/) in the function body. This gives you access to parts of the topology/telemetry not available in the context of the propagation itself. You can also use the available [element properties and methods](propagation.md#available-properties-and-methods).

{% hint style="danger" %}
**Keep performance aspects in mind during async function development**  
The script APIs provide super-human levels of flexibility and even allow querying standalone services. Consider extreme cases where the function is executed on all components and properly assess system impact. StackState comes with a number of StackPacks that include tuned propagating functions. Changes to those functions are possible, but may impact the stability of the system.
{% endhint %}

#### Synchronous propagation functions \(async Off\)

Running a propagation function as synchronous places limitations on both the capability of what it can achieve and the number of functions that can be run in parallel. Synchronous propagation functions do, however, have access to `stateChangesRepository` information that is not available if the function runs as async. `stateChangesRepository` can be used to return:

* The propagating state of an element
* The number of elements with a particular propagating state
* The highest state of a given set of elements

See available [properties and methods](propagation.md#available-properties-and-methods).

### Available properties and methods

Several element properties and methods are available for use in propagation functions. Synchronous functions also have access to stateChangesRepository methods.

#### Element properties and methods

The `element` properties and methods listed below can be used in **async and synchronous** propagation functions. Synchronous functions also have access to [stateChangesRepository methods](propagation.md#statechangesrepository-methods).\_\_

* `element.name` - Returns the name of the current element.
* `element.type` - Returns type of the current element.
* `element.version` - Returns the component version \(optional\).
* `element.runState()` - Returns the run state of the current element.
* `element.isComponent()` - Returns True if element is a component and False if element is a relation.
* `element.getDependencies().size()` - Returns the number of dependencies.
* `element.getDependencies()` - Returns a set of the outgoing relations \(for components\) or a set of components \(for relations\).

#### StateChangesRepository methods

{% hint style="info" %}
The `stateChangesRepository` methods listed below are **only available in synchronous** propagation functions.
{% endhint %}

* `stateChangesRepository.getPropagatedHealthStateCount(<set_of_elements>, <health_state>)` Returns the number of elements in the set that have a certain health state, for example CRITICAL.
* `stateChangesRepository.getHighestPropagatedHealthStateFromElements(<set_of_elements>)` Returns the highest propagated health state based on the given set of elements.
* `stateChangesRepository.getState(element).getHealthState().intValue` Returns the health state of the element.
* `stateChangesRepository.getState(element).getPropagatedHealthState().getIntValue()` Returns the propagated health state of the element.

### Logging

You can add logging statements to a propagation function for debug purposes, for example, with `log.info("message")`. Logs will appear in `stackstate.log`. Read how to [enable logging for functions](../logging/).

## See also

* [StackState script APIs](../../develop/reference/scripting/script-apis/)
* [Enable logging for functions](../logging/)

