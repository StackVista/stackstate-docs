# State propagation

Propagation defines how a propagated state flows from one component to the next. Propagation always flows from dependencies to dependent components and relations. Note that this is the opposite direction of the relation arrows in the graph.

A propagated state is returned as one of the following health states:

* `UNKNOWN`
* `DEVIATING`
* `FLAPPING`
* `CRITICAL`
* `CLEAR`


## Transparent propagation (default)

By default, the propagation method for components and relations is set to transparent propagation. The propagated state for a component or relation is determined by taking the maximum of the propagated state of all its dependencies and its own state. For example:

| Dependency state | Component state | Propagated state |
|:---|:---|:---|
| CRITICAL | DEVIATING | CRITICAL |
| CLEAR | CRITICAL | CRITICAL |
| DEVIATING | CLEAR | DEVIATING |

## Other propagation methods

In some situations transparent propagation is undesirable. Different propagation functions can be installed as part of a StackPack or you can write your own custom propagation functions. The desired propagation function to use for a component or relation can be set in its edit dialogue.

![Edit component propagation](../.gitbook/assets/v41_edit-component-propagation.png)

For example:

**Quorum based cluster propagation**: When a component is a cluster component, a `CRITICAL` state should typically only propagate when the cluster quorum is in danger.

## Custom propagation functions

It is possible to write your own custom propagation functions to determine the new propagated state of an element \(component or relation\). A propagation function can take multiple parameters as input and produces a new propagated state as output. The propagation function has access to the component itself, the component's dependencies and the transparent state that has already been calculated for the element.

![Custom propagation funtion](../.gitbook/assets/v41_propagation-function.png)

For example, the simplest possible function that can be written is given below. This function will always return `DEVIATING` propagated state.:

```text
    return DEVIATING
```

Propagation functions can be run as either async (default) or synchronous.

* With Async set to **On** the function will be run as [async](#async-propagation-functions)

* With Async set to **Off** the function will be run as [synchronous](#synchronous-propagation-functions).

### Parameters

The propagation function script takes system and user defined parameters. System parameters are predefined parameters passed automatically to the script:

| Parameter | Description |
|:---|:---|
| `transparentState` | The precomputed transparent state if returned from the script will lead to transparent propagation |
| `component` | The id of the current component |

### Async propagation functions (default)

Running as an async function will all you to make an HTTP request. This allows you to use [StackState script APIs](../develop/scripting/script-apis) in the function body and gives you access to parts of the topology/telemetry not available in the context of the propagation.

{% hint style="danger" %}
The async script APIs provide super-human level of flexibility and even allow querying standalone services, therefore during propagation function development it is important to keep performance aspects in mind. Consider extreme cases where the propagation function is executed on all components and properly assess system impact. StackState comes with a number of StackPacks with tuned propagating functions. Changes to those functions are possible, but may impact the stability of the system.
{% endhint %}

For example, you can implement more complicated logic in a propagation function. The script below will propagate a `DEVIATING` state in case a component is not running:

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
| `Component.withId(componentId)` | The `componentId` is passed as long and resolved |
| `.fullComponent()` | Returns a Json-style representation of the component. This is the same format as is obtained from the `Show Json` component menu or by using a [topology query](../develop/scripting/script-apis/topology.md) in analytics. |
| `then { component -> ... }` | An async lambda function where the main logic for the propagation function resides.<br />`component` is the component variable, which has properties that can be accessed using `.<property name>`. For example, `.type` returns component type id.|
|

### Synchronous propagation functions (async Off)

Running the function as synchronous places limitations on both the capability of what the functions can achieve and the number of functions that can be run in parallel, but allows access to `stateChangesRepository` information.

### The old style propagation function \(deprecated\)

The old style function is written using sync apis. The function takes the following parameters:

| Parameter | Description |
| :--- | :--- |
| element | reference to current component |
| stateChangesRepository | the state change helper class, see the detailed methods below |
| transparentState | the transparent state value |
| log | script logger |


### Elements

StackState provides several functions. Note that some of these are only available for synchronous propagation functions.

| Async | Sync | Function | Returns |
|:---:|:---:|:---|:---|
| ✅ | ✅ | `element.name` | The name of the current element. |
| ✅ | ✅ | `element.type` | The type of the current element (component or relation). |
| ✅ | ✅ | `element.version` | Component version (optional). |
| ✅ | ✅ | `element.isComponent()` | Component: `true`.<br />Relation: `false`. |
| ✅ | ✅ | `element.getDependencies()` | Component: A set of the outgoing relations.<br />Relation: A set of components. |
| ✅ | ✅ | `element.getDependencies().size()` | The number of dependencies. |
| ✅ | ✅ | `element.runState()` | The run state of the current element. |
| - | ✅ | `stateChangesRepository`<br />`.getPropagatedHealthStateCount(<set_of_elements>, <health_state>)` | The number of elements in the set that have a certain health state, for example CRITICAL |
| - | ✅ | `stateChangesRepository`<br />`.getHighestPropagatedHealthStateFromElements(<set_of_elements>)` | The highest propagated health state based on the given set of elements. |
| - | ✅ | `stateChangesRepository.getState(element)`<br />`.getHealthState().intValue` | The health state of the element. |
| - | ✅ | `stateChangesRepository.getState(element)`<br />`.getPropagatedHealthState().getIntValue()` | The propagated health state of the element. |


### Logging

You can add user logging from the script for debug purposes, for example, with `log.info("message")`. Logs will appear in `stackstate.log`.
