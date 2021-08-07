---
title: Configuring State Propagation
kind: Documentation
aliases:
  - /configuring/propagation/
---

# State propagation

{% hint style="warning" %}
**This page describes StackState version 4.0.**

The StackState 4.0 version range is End of Life \(EOL\) and **no longer supported**. We encourage customers still running the 4.0 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

Propagation defines how a propagated state flows from one component to the next. Propagation always flows from dependencies to dependent components and relations. Note that this is the opposite direction of the relation arrows in the graph.

By default the propagation for components and relations is set to transparent propagation. It determines the propagated state for a component or relation by taking the maximum of the propagated state of all its dependencies and its own state. For example:

* A component has an own state of `DEVIATING` and a dependency that has a propagated state of `CRITICAL`. The propagated state of the component will be `CRITICAL`.
* A component has an own state of `CRITICAL` and a dependency that has a propagated state of `CLEAR`. The propagated state of the component will be `CRITICAL`.
* A component has an own state of `CLEAR`, a dependency with propagated state of `DEVIATING` and a dependency with a propagated state of CLEAR. The propagated state of the component will be `DEVIATING`.

In some situations this type of propagation is undesirable, therefore a different propagation can be selected for a component or relation via their edit dialogs. In the edit dialog you can select different 'propagation functions'. An example of an alternative propagation is 'cluster propagation'. When a component is a cluster component a `CRITICAL` state should typically only propagate when the cluster quorum is in danger.

## Propagation function

A propagation function can take multiple parameters as input and produces a new propagated state as output. To determine the new propagated state of an element \(component or relation\) it has access to the component itself, the component's dependencies and the transparent state that has already been calculated for the element.

The propagation function can be defined using two styles:

* The new style. Such a function can use `async` script apis in the function body.

  It will be set to this style by default if a new propagation function is created in settings.

* The old style. This is the function which uses old sync apis and limited in functionality. It exists for backward compatibility and on attempt to modify it the message below will be shown.

  ```text
  This propagation function is now deprecated and hence it is not editable. Any new propagation should use asynchronous API.
  ```

  It is not possible to modify an old function body. The user is expected to create a new one using new APIs.

  More about the async vs sync differences can be found [here](../develop/functions.md)

### The new style propagation function

The async propagation function is written in StackState Scripting Language using wide set of script apis. Please check the [scripting](../develop/scripting/) page for the references of what functions can be used.

The function script takes system and user defined parameters. The system parameters are predefined parameters passed automatically to the script:

* `transparentState` - the precomputed transparent state if returned from the script will lead to transparent propagation
* `componentId` - the id of the current component

A propagation function can return one of the following health states:

* `UNKNOWN`
* `DEVIATING`
* `CRITICAL`
* `CLEAR`

  Warning! The async script apis provide super-human level of flexibility and even allow querying standalone services, therefore during propagation function development it is important to keep performance aspects in mind. It is required to consider the extreme cases where the propagation function is executed on all components and properly assess system impact. StackState is coming with a number of stackpacks with tuned propagating functions. Changes to those functions are possible, but may impact the stability of the system.

#### Example: 'Hello world' propagation function

The simplest possible function that can be written is given below:

```text
    return DEVIATING
```

This function will always return `DEVIATING` propagated state.

#### Example: Propagate DEVIATING state if the component is not in a running state

It is possible to implement more complicated logic in the propagation function. The example of the script that propagates the DEVIATING state in case if component is not running:

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

* The `componentId` is passed as long and it has to be resolved using using `Component.withId(componentId)` combinator.
* The `.fullComponent()` returns component in Json-style representation the same as the one that can be obtained from `Show Json` component menu or using [topology query](https://github.com/StackVista/stackstate-docs/tree/2a35ff75e2776ea2cad1cb30ce416fc43be32884/develop/scripting/topology/README.md) in analytics.
* `then { component -> ... }` is an async lambda function where the main logic for the propagation function resides.

  The `component` is the component variable which has properties that can be accessed using `.<property name>` notations. e.g. `.type` returns component type id.

* The logic above checks if component has specific type and not in running state then it will propagate `DEVIATING` state.

It is possible to add user logging from the script for debug purposes, e.g `log.info("message")`. The logs will appear in `stackstate.log`.

### The old style propagation function \(deprecated\)

The old style function is written using sync apis. The function takes the following parameters:

| Parameter | Description |
| :--- | :--- |
| element | reference to current component |
| stateChangesRepository | the state change helper class, see the detailed methods below |
| transparentState | the transparent state value |
| log | script logger |

StackState makes available several elements to define propagation logic. Available functions are listed below.

<table>
  <thead>
    <tr>
      <th style="text-align:left">Function</th>
      <th style="text-align:left">Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left"><code>element.name</code>
      </td>
      <td style="text-align:left">returns the name of the current <code>element</code>.</td>
    </tr>
    <tr>
      <td style="text-align:left"><code>element.type</code>
      </td>
      <td style="text-align:left">returns the type of the current <code>element</code>.</td>
    </tr>
    <tr>
      <td style="text-align:left"><code>element.version</code>
      </td>
      <td style="text-align:left">returns a component version, Optional.</td>
    </tr>
    <tr>
      <td style="text-align:left"><code>element.isComponent()</code>
      </td>
      <td style="text-align:left">returns <code>true</code> when <code>element</code> is a component, false
        in case of a relation.</td>
    </tr>
    <tr>
      <td style="text-align:left"><code>element.getDependencies()</code>
      </td>
      <td style="text-align:left">when the <code>element</code> is a component the command returns a set of
        the outgoing relations and when <code>element</code> is relation the command
        returns a set of components.</td>
    </tr>
    <tr>
      <td style="text-align:left"><code>element.getDependencies().size()</code>
      </td>
      <td style="text-align:left">returns the number of dependencies.</td>
    </tr>
    <tr>
      <td style="text-align:left">
        <p><code>stateChangesRepository</code>
        </p>
        <p><code>.getPropagatedHealthStateCount(&lt;set of elements&gt;, &lt;health state&gt;)</code>
        </p>
      </td>
      <td style="text-align:left">returns the number of elements in the set that have a certain health state.
        Health state can be <code>CRITICAL</code> for example.</td>
    </tr>
    <tr>
      <td style="text-align:left">
        <p><code>stateChangesRepository</code>
        </p>
        <p><code>.getHighestPropagatedHealthStateFromElements(&lt;set of elements&gt;)</code>
        </p>
      </td>
      <td style="text-align:left">return the highest propagated health state based on the given set of elements.</td>
    </tr>
    <tr>
      <td style="text-align:left">
        <p><code>stateChangesRepository.getState(element)</code>
        </p>
        <p><code>.getHealthState().intValue</code>
        </p>
      </td>
      <td style="text-align:left">return <code>element</code>&apos;s health state.</td>
    </tr>
    <tr>
      <td style="text-align:left">
        <p><code>stateChangesRepository.getState(element)</code>
        </p>
        <p><code>.getPropagatedHealthState().getIntValue()</code>
        </p>
      </td>
      <td style="text-align:left">return <code>element</code>&apos;s propagated health state.</td>
    </tr>
    <tr>
      <td style="text-align:left"><code>element.runState()</code>
      </td>
      <td style="text-align:left">return the <code>element</code>&apos;s run state</td>
    </tr>
  </tbody>
</table>

