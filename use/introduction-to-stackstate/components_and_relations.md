---
title: Components and Relations
kind: Documentation
---

# Components and Relations

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Components

A component is anything that has a run-time state and some relation with other components. Some component examples are a load balancer, a database server, a network switch, or a business service. It is possible to define custom components, and they can be anything - the granularity and range can be defined according to the needs. Each component is of a specific type. Types can be configured.

A component consists of:

1. The name of the component.
2. An icon in the middle that represents either the component itself or the component type.
3. An inner color is representing the health state.
4. An outer color is representing the propagated health state. This state depends on other components or relations.

## Relations

A relation connects two components. A relation shares some similarities with a component. Just like a component, it has its state and a propagated state. All relations in StackState are of a specific relation type.

If a relation is a dependency, it propagates states from one component to the next - depending on the direction. Otherwise, it can be considered as merely a line in the visualizer or a connection in the stack topology.

* A one way dependency relation is a relation that propagates state from one component to the next based on the direction of the relation.
* A dependency direction in both directions propagates states to both connected components, in other words it would be a circular dependency.

