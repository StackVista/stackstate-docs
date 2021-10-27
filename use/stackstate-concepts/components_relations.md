# Components and Relations

## Components

A component is anything that has a run-time state and some relation with other components. Some component examples are a load balancer, a database server, a network switch, or a business service. It is possible to define custom components, and they can be anything - the granularity and range can be defined according to the needs. Each component is of a specific type. Types can be configured.

A component consists of:

1. The name of the component.
2. An icon in the middle that represents either the component itself or the component type.
3. An inner color is representing the health state.
4. An outer color is representing the propagated health state. This state depends on other components or relations.

![](/.gitbook/assets/021_topology_elements.png)

### Grouping

Components of the same type and/or state can optionally be grouped together into a single element. Grouped components are represented by a hexagon in the topology visualization. The size of the component group's hexagon in the topology visualization represents the number of components in the group:

* Less than 100 components = small hexagon
* 100 to 150 components = medium hexagon
* More than 150 components = large hexagon

You can customize the grouping of components in the [Visuzalization settings](/use/stackstate-ui/views/visualization_settings.md).

## Relations

A relation connects two components or groups of components. Relations have some similarities with components. Just like a component, they can have a state and a propagated state. In the StackState topology perspective, relations are shown as lines connecting components or component groups.

### Relation types

Relations in StackState can be either direct or indirect. The type of relation is indicated by the type of line connecting the components. You can customize the types of relations displayed in the [visuzalization settings](/use/stackstate-ui/views/visualization_settings.md).

* **Direct relations** link two components that have a direct connection to each other. 
* **Indirect relations** link two components that are connected together via a path of invisible components.

| Relation type | Description |
| :--- | :--- |
| ![](/.gitbook/assets/relation_comp_comp.svg) | A **direct relation** between two components is indicated by a solid line. The direction of the arrowhead shows the direction of the dependency. |
| ![](/.gitbook/assets/relation_indirect_comp_comp.svg) | An **indirect relation** between two components is shown as a dashed line.  The direction of the arrowhead shows the direction of the dependency. |
| ![](/.gitbook/assets/relation_group_comp.svg) | Both a **direct relation** and an **indirect relation** between a component and a component group will be shown as a combination of a solid and a dashed line. **This type of relation could contain a combination of direct, indirect and/or no relations to one or more components in the group.** |

### Dependencies and propagation

If a relation indicates a dependency, the line will have an arrowhead showing the direction of the dependency. A dependency could be in one direction or in both directions, indicating that two components depend on each other, for example a network device talking to another networking device that has a bi-directional connection.

[Health state will propagate](../health-state/health-state-in-stackstate.md#propagated-health-state) from one component to the next upwards along a chain of dependencies. If the relation does not show a dependency between the components it connects \(no arrowhead\), it can be considered as merely a line in the visualizer or a connection in the stack topology.


