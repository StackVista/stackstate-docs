---
title: Propagation
kind: Documentation
---
Propagation defines how a propagated state flows from one component to the next. Propagation always flows from dependencies to dependent components and relations. Note that this is the opposite direction of the relation arrows in the graph.

By default the propagation for components and relations is set to transparent propagation. It determines the propagated state for a component or relation by taking the maximum of the propagated state of all its dependencies and its own state. For example:

* A component has a own state of DEVIATING and a dependency that has a propagated state of CRITICAL. The propagated state of the component will be CRITICAL.
* A component has a own state of CRITICAL and a dependency that has a propagated state of CLEAR. The propagated state of the component will be CRITICAL.
* A component has a own state of CLEAR, a dependency with propagated state of DEVIATING and a dependency with a propagated state of CLEAR. The propagated state of the component will be DEVIATING.

In some situations this type of propagation is undesirable, therefore a different propagation can be selected for a component or relation via their edit dialogs. In the edit dialog you can select different 'propagation functions'. An example of an alternative
propagation is 'cluster propagation'. When a component is a cluster component a CRITICAL state should typically only propagate when the cluster quorum is in danger.

## Propagation function

A propagation function can take multiple parameters as input and produces a new propagated state as output. To determine the new propagated state of an element (component or relation) it has access to the element itself, the element's dependencies and the
transparent state that has already been calculated for the element.
