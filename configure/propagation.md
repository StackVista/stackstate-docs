# State propagation

Propagation defines how a propagated state flows from one component to the next. Propagation always flows from dependencies to dependent components and relations. Note that this is the opposite direction of the relation arrows in the graph.

A propagated state is returned as one of the following health states:

* `CRITICAL`
* `FLAPPING`
* `DEVIATING`
* `CLEAR`
* `UNKNOWN`

## Transparent propagation (default)

By default, the propagation method for components and relations is set to transparent propagation. The propagated state for a component or relation is determined by taking the maximum of the propagated state of all its dependencies and its own state. For example:

| Dependency state | Component state | Propagated state |
|:---|:---|:---|
| CRITICAL | DEVIATING | CRITICAL |
| CLEAR | CRITICAL | CRITICAL |
| DEVIATING | CLEAR | DEVIATING |

## Other propagation methods

In some situations transparent propagation is undesirable. Different propagation functions can be installed as part of a StackPack or you can write your own [custom propagation functions](#custom-propagation-functions). The desired propagation function to use for a component or relation can be set in its edit dialogue.

![Edit component propagation](../.gitbook/assets/v41_edit-component-propagation.png)

For example:

**Quorum based cluster propagation**: When a component is a cluster component, a `CRITICAL` state should typically only propagate when the cluster quorum is in danger.

## Custom propagation functions

It is possible to write your own custom propagation functions to determine the new propagated state of an element \(component or relation\). A propagation function can take multiple parameters as input and produces a new propagated state as output. The propagation function has access to the component itself, the component's dependencies and the transparent state that has already been calculated for the element.

![Custom propagation funtion](../.gitbook/assets/v41_propagation-function.png)

The simplest possible function that can be written is given below. This function will always return a `CLEAR` propagated state, which will stop propagation:

```text
    return CLEAR
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
|:---|:---|
| `.withId(componentId)` | The `componentId` is passed as long and resolved |
| `.fullComponent()` | Returns a Json-style representation of the component. This is the same format as is obtained from the `Show Json` component menu or by using a [topology query](../develop/scripting/script-apis/topology.md) in analytics. |
| `then { component -> ... }` | An async lambda function where the main logic for the propagation function resides.<br />`component` is the component variable, which has properties that can be accessed using `.<property name>`. For example, `.type` returns component type id.|
|

### Parameters

A propagation function script takes system and user defined parameters. System parameters are predefined parameters passed automatically to the script:

| System parameter | Description |
|:---|:---|
| `transparentState` | The precomputed transparent state if returned from the script will lead to transparent propagation |
| `component` | The id of the current component |

### Async On / Off

Propagation functions can be run as either async (default) or synchronous.

* With Async set to **On** the function will be run as [async](#async-propagation-functions-default).

* With Async set to **Off** the function will be run as [synchronous](#synchronous-propagation-functions-async-off).

#### Async propagation functions (default)

Running as an async function will allow you to make an HTTP request. This allows you to use [StackState script APIs](../develop/scripting/script-apis) in the function body and gives you access to parts of the topology/telemetry not available in the context of the propagation.

{% hint style="danger" %}
The async script APIs provide super-human level of flexibility and even allow querying standalone services, therefore during propagation function development it is important to keep performance aspects in mind. Consider extreme cases where the propagation function is executed on all components and properly assess system impact. StackState comes with a number of StackPacks with tuned propagating functions. Changes to those functions are possible, but may impact the stability of the system.
{% endhint %}

#### Synchronous propagation functions (async Off)

Running a propagation function as synchronous places limitations on both the capability of what it can achieve and the number of functions that can be run in parallel. Synchronous propagation functions do, however, have access to `stateChangesRepository` information that is not available if the runs as async. `stateChangesRepository` can be used to return:
- The propagating state of an element
- The number of elements with a particular propagating state
- The highest state of a given set of elements

See [available methods and properties](#available-methods-and-properties).

### Available methods and properties

Several [element properties and methods](#element-properties-and-methods) are available for use in propagation functions. Synchronous functions also have access to [stateChangesRepository methods](#statechangesrepository-methods).

#### Element properties and methods

The `element` properties and methods listed below can be used in async and synchronous propagation functions.

```
# Return the name of the current element
element.name

# Return type of the current element
element.type

# Return the component version (optional)
element.version
```

```
# Return True if element is a component
# Return False if element is a relation
element.isComponent()

# For components: Return a set of the outgoing relations.
# For relations: Return set of components.
element.getDependencies()

# Return the number of dependencies
element.getDependencies().size()
```


- `element.name`<br />Returns the name of the current element.
- `element.type`
- `element.version`
- `element.runState()`
- `element.isComponent()`
- `element.getDependencies()`
- `element.getDependencies().size()`


#### StateChangesRepository methods

The `stateChangesRepository` methods listed below can **only be used in synchronous propagation functions**.

- `stateChangesRepository.getPropagatedHealthStateCount(<set_of_elements>, <health_state>)`
- `stateChangesRepository.getHighestPropagatedHealthStateFromElements(<set_of_elements>)`
- `stateChangesRepository.getState(element).getHealthState().intValue`
- `stateChangesRepository.getState(element).getPropagatedHealthState().getIntValue()`<br />Returns the propagated health state of the element.


| Method / property | Returns |
|:---|:---|
| `element.name` | The name of the current element. |
| `element.type` | The type of the current element (component or relation). |
| `element.version` | Component version (optional). |
| `element.runState()` | The run state of the current element. |
| `element.isComponent()` | Component: `true`.<br />Relation: `false`. |
| `element.getDependencies()` | Component: A set of the outgoing relations.<br />Relation: A set of components. |
| `element.getDependencies().size()` | The number of dependencies. |
| `stateChangesRepository`.getPropagatedHealthStateCount(<set_of_elements>, <health_state>)` | The number of elements in the set that have a certain health state, for example CRITICAL |
| `stateChangesRepository`<br />`.getHighestPropagatedHealthStateFromElements(<set_of_elements>)` | The highest propagated health state based on the given set of elements. |
| `stateChangesRepository.getState(element)`<br />`.getHealthState().intValue` | The health state of the element. |
| `stateChangesRepository.getState(element)`<br />`.getPropagatedHealthState().getIntValue()` | The propagated health state of the element. |

### Logging

You can add user logging from the script for debug purposes, for example, with `log.info("message")`. Logs will appear in `stackstate.log`.
