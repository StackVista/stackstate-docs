---
description: StackState Self-hosted v4.6.x
---

# Components 

## Overview

A relation connects two [components or groups of components](/use/concepts/components.md). Relations have some similarities with components. Just like a component, they can have a state and a propagated state. In the StackState topology perspective, relations are shown as lines connecting components or component groups.

## Relation types

Relations in StackState can be either direct or indirect. The type of relation is indicated by the type of line connecting the components. You can customize the types of relations displayed in the [visualization settings](/use/stackstate-ui/views/visualization_settings.md).

* **Direct relations** link two components that have a direct connection to each other. 
* **Indirect relations** link two components that are connected together via a path of invisible components.

| Relation type | Description                                                                                                                                                                                                                                                                                                                                                                                                                    |
| :--- |:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ![](/.gitbook/assets/relation_comp_comp.svg) | A **direct relation** between two components is indicated by a solid line. The direction of the arrowhead shows the direction of the dependency.                                                                                                                                                                                                                                                                               |
| ![](/.gitbook/assets/relation_indirect_comp_comp.svg) | An **indirect relation** between two components is shown as a dashed line.  The direction of the arrowhead shows the direction of the dependency. Select an indirect relation to view the path between the components in the right panel **Selection details** tab.                                                                                                                                                            |
| ![](/.gitbook/assets/relation_group_comp.svg) | Both a **direct relation** and an **indirect relation** between a component and a component group will be shown as a combination of a solid and a dashed line. **This type of relation could contain a combination of direct, indirect and/or no relations to one or more components in the group.** Select a grouped relation to display full details of the included relations in the right panel **Selection details** tab. |

Select a relation to display detailed information about it in the right panel **Selection details** tab. 

![Indirect relation path](/.gitbook/assets/v46_indirect_relation_path.png)

## Dependencies and propagation

If a relation indicates a dependency, the line will have an arrowhead showing the direction of the dependency. A dependency could be in one direction or in both directions, indicating that two components depend on each other, for example a network device talking to another networking device that has a bi-directional connection.

[Health state will propagate](../health-state/about-health-state.md#propagated-health-state) from one component to the next upwards along a chain of dependencies. If the relation does not show a dependency between the components it connects \(no arrowhead\), it can be considered as merely a line in the visualizer or a connection in the stack topology.
