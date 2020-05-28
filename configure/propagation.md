---
title: Configuring State Propagation
kind: Documentation
aliases:
  - /configuring/propagation/
---

# Configuring state propagation

Propagation defines how a propagated state flows from one component to the next. Propagation always flows from dependencies to dependent components and relations. Note that this is the opposite direction of the relation arrows in the graph.

By default the propagation for components and relations is set to transparent propagation. It determines the propagated state for a component or relation by taking the maximum of the propagated state of all its dependencies and its own state. For example:

* A component has an own state of `DEVIATING` and a dependency that has a propagated state of `CRITICAL`. The propagated state of the component will be `CRITICAL`.
* A component has an own state of `CRITICAL` and a dependency that has a propagated state of `CLEAR`. The propagated state of the component will be `CRITICAL`.
* A component has an own state of `CLEAR`, a dependency with propagated state of `DEVIATING` and a dependency with a propagated state of CLEAR. The propagated state of the component will be `DEVIATING`.

In some situations this type of propagation is undesirable, therefore a different propagation can be selected for a component or relation via their edit dialogs. In the edit dialog you can select different 'propagation functions'. An example of an alternative propagation is 'cluster propagation'. When a component is a cluster component a `CRITICAL` state should typically only propagate when the cluster quorum is in danger.

## Propagation function

A propagation function can take multiple parameters as input and produces a new propagated state as output. To determine the new propagated state of an element \(component or relation\) it has access to the element itself, the element's dependencies and the transparent state that has already been calculated for the element.

The Groovy programming language can be used when defining a propagation function. StackState makes available several functions to define propagation logic. Available functions are listed below.

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
</table>A propagation function can return one of the following health states:

* `UNKNOWN`
* `DEVIATING`
* `CRITICAL`
* `CLEAR`

