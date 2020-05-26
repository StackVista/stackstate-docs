---
title: Basic Concepts
kind: Documentation
---
This is an overview of the most basic concepts of StackState.

## Components

A component is anything that has a run-time state and some relation with other components. Some examples of components are a load-balancer, a database server, a network switch or a business service. You can define your own component types, so they can be anything. The granularity and range is up to you. The same actually holds true for relations.

A component consists of:

 1. The name of the component written on top.
 1. An icon in the middle that represents either the component itself or the component type.
 1. An inner color representing the health state. In the example's case the color is green, so the component is reporting it's `clear`.
 1. An outer color representing the propagated health state. In the example's case the color is orange, so the component got a `deviating` from a component or relation it depends on.

### Manually adding components

Go to the **palette pane**. Choose one of the component types and drag it on to the stack visualization. A popup will appear to ask you about the name of the component.

By right clicking on the component icon in the view, a context menu is presented which permits:

1. to hide the component from the view, by adding the component to the hidden components in the view's Hide tab;
1. to show the component's neighbors, by adding the component to the components for which to show the neighbors in the view's Show tab;
1. to show the component's root cause, by adding the component to the components for which to show the root cause in the view's Show tab.

### Manually editing components

By clicking on a component the component details pane will open. By clicking on the three dots in the top right next to the component details you can edit the details of the component.

On this pane it is also possible to create checks for components. Checks require !data streams! that are linked to the component. Under the section **Linked data streams** you can see all the data streams that are linked to a component.

### Manually linking data streams

A data stream originates from a data source that can be accessed through one of the available plugins. The plugins that allow you to link data streams can be found by their icons on the toolbar on the right in the view. From there you can drag a data stream on top of a component to link it to the component.

To connect two components to each other simply drag one of the component on top of the other component. A popup will appear asking you for the !relation type! that you would like the relation between the components to have. If the relation is a one-way dependency, the component that you have dragged on top of the other component will depend on that component, in other words the arrow will point in the direction of the component you have dragged to.

Automatic creation and maintenance of existing components/relations, including checks and linked data streams, is possible  through **synchronization** or the REST API.

Synchronization is a way for you to keep your stack synchronized based on some data source. This may be a provisioning tool, service registry, discovery tool, CMDB or some custom data source that keeps information on components and their relations. Multiple synchronization sources can be used for different parts of the stack.

## Component Types

Each component is of a specific component type. Component types can be configured in the left pane of a view.

## Domains

Domains are a way to logically group components. They are shown as columns in the stack visualization.

The order of the layers can be configured by dragging the layer up and down in the viewpoint pane. The order is the same for all users of StackState.

## Environments

Environments are meant for grouping components. They are meant to model DTAP environment: development, testing, acceptance, production, but can of course be used for other purposes as well.  A component can belong to one *or multiple* environments. This can be useful when modeling for example a database is used for both the development and the testing environment.

Environments share all same layers and domains.  Typically you look at a single environment at a time, but multiple environments can be visualized at the same time.

Environments can also be used within StackState to do modeling work without affecting the rest of the stack. One may for example create a couple of components and place them on a temporary environment. Once you are finished working you can move the components to the environment where you want to place the components.

## Health States

Each component and each relation has two health states:

 1. **Health state**
 1. **Propagated health state**

The health state is the state that the component or relation itself reported via one of its checks. This state is visualized by the inner color of the component or relation.

The propagated health state is the state that the component or relation has received via one or multiple of its dependencies. This state is visualized by the outer color.

The health state colors are:

 * **Gray** - UNKNOWN. No health state is known. There are no checks defined.
 * **Green**  - CLEAR. Everything is okay.
 * **Orange** - DEVIATING. Action is needed soon otherwise something will go wrong.
 * **Red** - CRITICAL. Something has gone wrong and is causing problems. Action is needed immediately.

These **health states are ordered** by importance. That means that if a `deviating` and a `critical` are reported for the same component, the `critical` will be the overriding health state.

## Layers

Layers are a way to logically group !components!. They are shown as rows in the stack visualization.

The order of the layers can be configured in Settings page under Layers section. The order is the same for all users of StackState.

## Relations

A relation connects two components. A relation shares many similarities with a component. Just like a component it has an own state (color of the circle in the middle) and a propagated state (color of the line). Just like components it also has checks and data streams.

### Manually linking data streams

Just like you would link a data stream to a component (by dragging a data stream on top of component) you can link a data stream to a relation by dragging it on top of the relation. The plugins that allow you to link data streams can be found by their icons on the toolbar on the right in the view.

## Relation types

All relations in StackState are of a specific relation type. The relation types can be configured in the left palette pane of a !view!.

If a relation is a dependency it propagates states from one component to the next, dependent on the direction. Otherwise it can be considered as merely a line in the visualizer or a connection in the stack topology.

* A one way dependency relation is a relation that propagates state from one component to the next based on the direction of the relation.
* A dependency direction in both directions propagates states to both connected components, in other words it would be a circular dependency.

## Views

Typically IT stacks contain way too many components for all these components and their relations to be visualized all at once. Therefore StackState introduces the concept of a view. A view defines what you want to see and what not. A view can be saved with a name as a kind of bookmark.

All components in the stack belong to at least one layer, one domain and one environment. One way of determining what you want to see in StackState is by showing or hiding layers, domains and environments. Simply click on the eye icon on the left of them.

In addition to layers, domains and environments, other parts of the stack can be shown or hidden based on a few other criteria:

 * Individual components can be revealed or explicitly hidden.
 * Groups of components can be revealed or explicitly hidden via their labels.
 * Components can be shown based on their state relation with other components.
