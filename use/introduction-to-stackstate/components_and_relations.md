# Components and Relations

## Components

A component is anything that has a run-time state and some relation with other components. Some component examples are a load balancer, a database server, a network switch, or a business service. It is possible to define custom components, and they can be anything - the granularity and range can be defined according to the needs. Each component is of a specific type. Types can be configured.

A component consists of:

1. The name of the component.
2. An icon in the middle that represents either the component itself or the component type.
3. An inner color is representing the health state.
4. An outer color is representing the propagated health state. This state depends on other components or relations.

## Relations

A relation connects two components or groups of components. Relations have some similarities with components. Just like a component, they can have a state and a propagated state. 

In the StackState topology perspective, relations are shown as lines connecting components or component groups. If a relation indicates a dependency, the line will have an arrowhead showing the direction of the dependency. Health state will propagate from one component to the next upwards along a chain of dependencies. If the relation does not show a dependency between the components it connects (no arrowhead), it can be considered as merely a line in the visualizer or a connection in the stack topology.

* A relation showing dependency in one direction will propagate state from one component to the next based on the direction of the relation.
* A relation showing dependency in both directions will propagate state to both connected components, in other words it would be a circular dependency.
* A relation showing no dependency will not propagate state

![](/.gitbook/assets/propagation_2.svg)



