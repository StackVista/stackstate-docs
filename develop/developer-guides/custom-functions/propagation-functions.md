# Propagation functions

## Overview

Propagation defines how a [propagated health state](/use/health-state/health-state-in-stackstate.md#propagated-health-state) flows from one component to the next. A component's propagated state is calculated using a propagation function. This can be set as **Propagation** in the component's edit dialogue in the StackState UI.

![Edit component propagation](../../../.gitbook/assets/v43_edit-component-propagation.png)

## Propagation functions

Propagation functions are used to calculate the propagated state of a component.

### Transparent propagation \(default\)

Transparent propagation returns the transparent state. This is the maximum of the component's own state and the propagated state of all dependencies. For example:

  | Dependency state | Component state | Transparent state |
  | :--- | :--- | :--- |
  | `CRITICAL` | `DEVIATING` | `CRITICAL` |
  | `CLEAR` | `CRITICAL` | `CRITICAL` |
  | `DEVIATING` | `CLEAR` | `DEVIATING` |

Transparent propagation can be configured in two ways: 

- It can be set as the [default propagation function](propagation-functions.md#default-propagation-functions).
- It can be [imported](../../../setup/data-management/backup_restore/configuration_backup.md#import-configuration) as a [custom propagation function](propagation-functions.md#create-a-custom-propagation-function) using the export JSON below:

{% tabs %}
{% tab title="transparent_propagation.stj" %}
```json
{
  "_version": "1.0.31",
  "nodes": [{
    "_type": "PropagationFunction",
    "async": false,
    "id": -1,
    "identifier": "urn:stackpack:common:propagation-function:transparent-propagation",
    "name": "Transparent propagation",
    "parameters": [],
    "script": {
      "_type": "NativeFunctionBody",
      "nativeFunctionBodyId": "TRANSPARENT_PROPAGATION"
    }
  }],
  "timestamp": "2021-06-15T14:57:31.725+02:00[Europe/Amsterdam]"
}
```
{% endtab %}
{% endtabs %}

### Auto propagation

Auto propagation returns the auto state. This propagation acts as a noise suppressor for the parts of the infrastructure that are subject to frequent fluctuations in health states. Auto propagation is similar to [transparent propagation](#transparent-propagation-default) with two differences:

- If a component's own health state is `DEVIATING`, this is always excluded from calculation of the propagated state.
- If a component's own health state is `CRITICAL`, after 2 hours this is excluded from calculation of the propagated state. At this point, the propagated state is calculated as the maximum propagated state of all dependencies only. 

#### CRITICAL state timeout

The time which the `CRITICAL` own state of a component should be included in the calculation of its propagated state can be configured. By default, the timeout for a `CRITICAL` is set to 2 hours. After this time, the propagated state of a component will be calculated as the maximum propagated state of all dependencies only.

{% tabs %}
{% tab title="Kubernetes" %}

To configure the `CRITICAL` state timeout, add the following to the `values.yaml` used to deploy StackState:

```yaml
stackstate:
  components:
    state:
      config: |
        stackstate.stateService.autoPropagation.criticalStateExpirationTimeout = 15 minutes
```
{% endtab %}
{% tab title="Linux" %}

To configure the `CRITICAL` state timeout, add the following configuration to the file `etc/application_stackstate.conf` 

```text
stackstate.stateService.autoPropagation.criticalStateExpirationTimeout = 15 minutes
```
{% endtab %}
{% endtabs %}

For example:

  | Dependency propagated state | Component own state | Auto state | Description |
  | :--- | :--- | :--- | :--- |
  | `CLEAR` | `DEVIATING` | `CLEAR` | `DEVIATING` own state of component does not propagate. |
  | `CLEAR` | `CRITICAL` | `CRITICAL` > `CLEAR` | `CRITICAL` own state of component will propagate for 2 hours only. After 2 hours, the auto state is calculated as the maximum propagated state of dependencies (`CLEAR`). |
  | `DEVIATING` | `DEVIATING` | `DEVIATING` | `DEVIATING` propagated state of dependency will propagate. |
  | `DEVIATING` | `CRITICAL` | `CRITICAL` > `DEVIATING` | `CRITICAL` own state of component will propagate for 2 hours only. After 2 hours, the auto state is calculated as the maximum propagated state of dependencies (`DEVIATING`). |
  | `CRITICAL` | `DEVIATING` | `CRITICAL` | `CRITICAL` propagated state of dependency will propagate. |
  | `CRITICAL` | `CRITICAL` | `CRITICAL` | `CRITICAL` propagated state of dependency will propagate and continue to propagate after 2 hours. |
  | `DEVIATING` | `CLEAR` | `DEVIATING` | `DEVIATING` propagated state of dependency will propagate. |
  | `CRITICAL` | `CLEAR` | `CRITICAL` | `CRITICAL` propagated state of dependency will propagate and continue to propagate after 2 hours. |

### Other propagation functions

Some other propagation functions are installed as part of a StackPack. For example, Quorum based cluster propagation, which will propagate a `DEVIATING` state when the cluster quorum agrees on deviating and a `CRITICAL` state when the cluster quorum is in danger. You can also write your own [custom propagation functions](propagation-functions.md#create-a-custom-propagation-function).

For details of all propagation functions available in your StackState instance, go to **Settings** > **Functions** > **Propagation functions** in the StackState UI.

## Default propagation functions

If no propagation function is configured for a component, the configured default propagation function will be invoked. This can be either [Auto Propagation](#auto-propagation) or [Transparent Propagation](#transparent-propagation-default). For performance reasons, it is not possible to configure a custom propagation function as the default.

The default propagation function can be configured using the following option:

{% tabs %}
{% tab title="Kubernetes" %}
Add the following to the `values.yaml` used to deploy StackState:

```yaml
stackstate:
  components:
    state:
      config: |
        stackstate.stateService.defaultPropagation = Auto // Transparent
```

{% endtab %}
{% tab title="Linux" %}

Add the following configuration to the file `etc/application_stackstate.conf` 

```text
stackstate.stateService.defaultPropagation = Auto // Transparent
```
{% endtab %}
{% endtabs %}

## Create a custom propagation function

You can write custom propagation functions to determine the new propagated state of an element \(component or relation\). A propagation function can take multiple parameters as input and produces a new propagated state as output. To calculate a propagated state, a propagation function has access to the element itself, the element's dependencies and the transparent state that has already been calculated for the element.

![Custom propagation function](../../../.gitbook/assets/v43_propagation-function.png)

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
      return autoState
    }
  }
```

This code works as follows:

| Code | Description |
| :--- | :--- |
| `.withId(componentId)` | The `componentId` is passed as long and resolved |
| `.fullComponent()` | Returns a JSON-style representation of the component. This is the same format as is obtained from the `Show Json` component properties menu or by using a [topology query](../../reference/scripting/script-apis/topology.md) in analytics. |
| `then { component -> ... }` | An async lambda function where the main logic for the propagation function resides. `component` is the component variable, which has properties that can be accessed using `.<property name>`. For example, `.type` returns component type id. |
|  |  |

### Parameters

A propagation function script takes system and user defined parameters. System parameters are predefined parameters passed automatically to the script:

| System parameter | Description |
| :--- | :--- |
| `transparentState` | The precomputed transparent state. If returned from the script, will lead to [transparent propagation](#transparent-propagation-default). |
| `autoState` | The precomputed auto state. If returned from the script, will lead to [auto propagation](#auto-propagation). |
| `component` | The id of the current component |

### Execution

Propagation functions can be run with execution set to either [Asynchronous](#asynchronous-execution) \(recommended\) or [Synchronous](#synchronous-execution).

#### Asynchronous execution

Functions that run with asynchronous execution can make an HTTP request and use [StackState script APIs](/develop/reference/scripting/script-apis/README.md) in the function body. This gives you access to parts of the topology/telemetry not available in the context of the propagation itself. You can also use the available [element properties and methods](propagation-functions.md#available-properties-and-methods).

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

Several element properties and methods are available for use in propagation functions. Functions with synchronous execution also have access to stateChangesRepository methods.

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

You can add logging statements to a propagation function for debug purposes, for example, with `log.info("message")`. Logs will appear in `stackstate.log`. Read how to [enable logging for functions](/configure/logging/README.md).

## See also

* [Health state propagation](/use/health-state/health-state-in-stackstate.md#propagated-health-state)
* [StackState script APIs](/develop/reference/scripting/script-apis/README.md)
* [Enable logging for functions](/configure/logging/README.md)
