---
title: Configuring State Propagation
kind: Documentation
aliases:
    - /configuring/propagation/
---
Propagation defines how a propagated state flows from one component to the next. Propagation always flows from dependencies to dependent components and relations. Note that this is the opposite direction of the relation arrows in the graph.

By default the propagation for components and relations is set to transparent propagation. It determines the propagated state for a component or relation by taking the maximum of the propagated state of all its dependencies and its own state. For example:

* A component has an own state of `DEVIATING` and a dependency that has a propagated state of `CRITICAL`. The propagated state of the component will be `CRITICAL`.
* A component has an own state of `CRITICAL` and a dependency that has a propagated state of `CLEAR`. The propagated state of the component will be `CRITICAL`.
* A component has an own state of `CLEAR`, a dependency with propagated state of `DEVIATING` and a dependency with a propagated state of CLEAR. The propagated state of the component will be `DEVIATING`.

In some situations this type of propagation is undesirable, therefore a different propagation can be selected for a component or relation via their edit dialogs. In the edit dialog you can select different 'propagation functions'. An example of an alternative
propagation is 'cluster propagation'. When a component is a cluster component a `CRITICAL` state should typically only propagate when the cluster quorum is in danger.

## Propagation function

A propagation function can take multiple parameters as input and produces a new propagated state as output. To determine the new propagated state of an element (component or relation) it has access to the element itself, the element's dependencies and the
transparent state that has already been calculated for the element.

The Groovy programming language can be used when defining a propagation function. StackState makes available several functions to define propagation logic. Available functions are listed below.

| Function | Description |
| -------- | --- |
| element.name | returns the name of the current `element`. |
| element.type | returns the type of the current `element`. |
| element.version | returns a component version, Optional. |
| element.isComponent() | returns `true` when `element` is a component, false in case of a relation. |
| element.getDependencies() | when the `element` is a component the command returns a set of the outgoing relations and when `element` is relation the command returns a set of components. |
| element.getDependencies().size() | returns the number of dependencies. |
| stateChangesRepository.getPropagatedHealthStateCount(`<set of elements>`, `<health state>`) | returns the number of elements in the set that have a certain health state. Health state can be `CRITICAL` for example. |
| stateChangesRepository.getHighestPropagatedHealthStateFromElements(`<set of elements>`) | return the highest propagated health state based on the given set of elements. |
| stateChangesRepository.getState(element).getHealthState().intValue | return `element`'s health state. |
| stateChangesRepository.getState(element).getPropagatedHealthState().getIntValue() | return `element`'s propagated health state. |
| element.runState() | return the `element`'s run state |

A propagation function can return one of the following health states:

* `UNKNOWN`
* `DEVIATING`
* `CRITICAL`
* `CLEAR`
