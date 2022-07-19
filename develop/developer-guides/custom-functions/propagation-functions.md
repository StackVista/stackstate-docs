---
description: StackState Self-hosted v5.0.x 
---

# Propagation functions

## Overview

Propagation defines how a propagated state flows from one component to the next. Propagation always flows from dependencies to dependent components and relations. Note that this is the opposite direction of the relation arrows in the graph.

A propagated state is returned as one of the following health states:

* `CRITICAL`
* `FLAPPING`
* `DEVIATING`
* `UNKNOWN`

A component's propagated state is calculated using a propagation function, which is set during synchronization.

## Propagation type

### Auto propagation \(default\)

Returns the transparent state. This is the maximum of the component's own state and the propagated state of all dependencies. For example:

| Dependency state | Component state | Transparent state |
| :--- | :--- | :--- |
| `CRITICAL` | `DEVIATING` | `CRITICAL` |
| `CLEAR` | `CRITICAL` | `CRITICAL` |
| `DEVIATING` | `CLEAR` | `DEVIATING` |

### Propagation functions

Propagation functions can be defined and used to calculate the propagated state of a component. Some propagation functions are installed as part of a StackPack. For example, Quorum based cluster propagation, which will propagate a `DEVIATING` state when the cluster quorum agrees on deviating and a `CRITICAL` state when the cluster quorum is in danger. You can also write your own [custom propagation functions](propagation-functions.md#create-a-custom-propagation-function). A full list of the propagation functions available in your StackState instance can be found in the StackState UI, go to **Settings** &gt; **Functions** &gt; **Propagation Functions**

{% hint style="info" %}
To specify a propagation function that should be used to calculate the propagated state a component, add the [`"propagation"` block](#specify-propagation-functi on-in-template) to the component template used in topology synchronization.
{% endhint %}

## Create a custom propagation function

You can write custom propagation functions to determine the new propagated state of an element \(component or relation\). The propagation function can then be specified in the template used to synchronize topology.

A propagation function can take multiple parameters as input and produces a new propagated state as output. To calculate a propagated state, a propagation function has access to the element itself, the element's dependencies and the transparent state that has already been calculated for the element.

![Custom propagation function](../../../.gitbook/assets/v50_propagation-function.png)

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
| `.fullComponent()` | Returns a JSON-style representation of the component. This is the same format as is obtained from the `Show Json` properties menu for a component, or by using a [topology query](../../reference/scripting/script-apis/topology.md) in analytics. |
| `then { component -> ... }` | An async lambda function where the main logic for the propagation function resides. `component` is the component variable, which has properties that can be accessed using `.<property name>`. For example, `.type` returns component type id. |
|  |  |

### Parameters

A propagation function script takes system and user defined parameters. 

#### System parameters

System parameters are predefined parameters passed automatically to the script at run time.

| System parameter | Description |
| :--- | :--- |
| `transparentState` | The precomputed transparent state if returned from the script will lead to transparent propagation |
| `component` | The id of the current component |

#### User parameters

User parameters can optionally be defined and used in the script. The value must be provided when the function is [configured in the component template](#specify-propagation-function-in-template).

### Execution

Propagation functions can be run with execution set to either [Asynchronous](propagation-functions.md#asynchronous-execution) \(recommended\) or [Synchronous](propagation-functions.md#synchronous-execution).

#### Asynchronous execution

Functions that run with asynchronous execution can make an HTTP request and use [StackState script APIs](../../reference/scripting/script-apis/) in the function body. This gives you access to parts of the topology/telemetry not available in the context of the propagation itself. You can also use the available [element properties and methods](propagation-functions.md#available-properties-and-methods).

{% hint style="danger" %}
**Keep performance aspects in mind when developing functions with asynchronous execution**  
The script APIs provide super-human levels of flexibility and even allow querying standalone services. Consider extreme cases where the function is executed on all components and properly assess system impact. StackState comes with a number of StackPacks that include tuned propagating functions. Changes to those functions are possible, but may impact the stability of the system.
{% endhint %}

#### Synchronous execution

Running a propagation function with synchronous execution places limitations on both the capability of what it can achieve, and the number of functions that can be run in parallel. Synchronous propagation functions do, however, have access to `stateChangesRepository` information that is not available if the function runs with asynchronous execution.

`stateChangesRepository` can be used to return:

* The propagating state of an element
* The number of elements with a particular propagating state
* The highest state of a given set of elements

See available [properties and methods](propagation-functions.md#available-properties-and-methods).

### Available properties and methods

Several element properties and methods are available for use in propagation functions. Functions with synchronous execution also have access to `stateChangesRepository` methods.

#### Element properties and methods

The `element` properties and methods listed below can be used in propagation functions with either **asynchronous and synchronous execution**. Functions with synchronous execution also have access to [stateChangesRepository methods](propagation-functions.md#statechangesrepository-methods).

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

You can add logging statements to a propagation function for debug purposes, for example, with `log.info("message")`. Logs will appear in `stackstate.log`. Read how to [enable logging for functions](../../../configure/logging/).

## Component template

### Specify a propagation function

The default propagation used in StackState is [Auto propagation](#auto-propagation-default). If another type of propagation should be applied to a component, this must be specified in the component template and applied during topology synchronization. In most cases this will be handled by the StackPack responsible for synchronization of the component. 

To manually specify a non-default propagation function, a `"propagation"` block should be added to the template used for topology synchronization: 

```yaml
"propagation": {
  "_type": "Propagation",
  "function": <id-of-the-function-to-use>,
  "arguments": []
  },
```

The propagation block requires the following keys;
- **_type** - specifies that the JSON block defines a Propagation.
- **arguments** - a list of any user parameters that the propagation function requires. System parameters are provided during run time and do not need to be specified here.
  - **type** - the type of the parameter, as specified in the propagation function.
  - **parameter** - the node ID of the propagation function’s user parameter. This can be obtained using a `get` helper.
  - **<PARAMETER_NAME>** - the value to be passed as an argument to the propagation function. The value is expected to be of the type specified in **type**.
- **function** the node ID of the propagation function to use. This can be obtained using a `get` helper.

### Examples

For example:

{% tabs %}
{% tab title="Example with system parameters only" %}
The example component template below uses a `get` helper to obtain the ID of the propagation function with the identifier `urn:stackpack:common:propagationfunction:active-failover`

Component template `"propagation"` block:

```bash
...
"propagation": {
  "_type": "Propagation",
  "arguments": [],
  "function": {{ get "urn:stackpack:common:propagationfunction:active-failover" }},
  },
...
```

Propagation function:

![Propagation function](/.gitbook/assets/v50_propagation_function_system_parameters_identifier.png)


{% endtab %}
{% tab title="Example with system and user parameters" %}
The component template example below includes a user parameter that will be passed to the propagation function together with the standard system parameters. The arguments list in the component template extract contains one argument that matches the propagation function’s user parameter `relationType`

Component template `"propagation"` block:

```bash
...
"propagation": {
  "_type": "Propagation",
  "arguments": [{
    "_type": "ArgumentRelationTypeRef",
    "parameter": {{ get "urn:stackpack:common:propagationfunction:stop-propagation-for-relation-type" "Type=Parameter;Name=relationType" }},
    "relationType": {{ get "urn:stackpack:common:relationtype:is-hosted-on" }}
    }],
  "function": {{ get "urn:stackpack:common:propagationfunction:stop-propagation-for-relation-type" }},
  },
...
```

Propagation function:

![Propagation function](/.gitbook/assets/v50_propagation_function_user_parameters_identifier.png)

{% endtab %}
{% endtabs %}

## See also

* [StackState script APIs](../../reference/scripting/script-apis/)
* [Enable logging for functions](../../../configure/logging/)

