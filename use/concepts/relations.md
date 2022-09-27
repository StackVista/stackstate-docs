---
description: StackState Self-hosted v5.1.x 
---

# Relations 

## Overview

A relation connects two [components or groups of components](/use/concepts/components.md). Relations have some similarities with components. Just like a component, they can have a health state and a propagated health state. In the StackState topology perspective, relations are shown as lines connecting components or component groups.

## Relation types

Relations in StackState can be either direct or indirect. The type of relation is indicated by the type of line connecting the components. Relations that connect to a component group are represented as grouped relations, these can contain a combination of direct and indirect relations and may connect to all or only some of the components included in the group. Select a relation in the topology visualizer to display detailed information about it in the right panel details tab - **Direct relation details**, **Indirect relation details** or **Grouped relation details** depending on the relation type that you selected. 

You can customize the types of relations displayed in the [visualization settings](/use/stackstate-ui/views/visualization_settings.md).

### Direct relations

![](/.gitbook/assets/v51_relation_comp_comp.png)  

Direct relations link two components that have a direct connection to each other. A **direct relation** between two components is indicated by a solid line. The direction of the arrowhead shows the direction of the dependency. Select an direct relation to detailed information about the relation in the right panel details tab - **Direct relation details**.     

#### Direct relation details

![Direct relation details](/.gitbook/assets/v51_direct_relation_details.png)

The **Direct relation details** tab is shown in the StackState UI right panel when a direct relation is selected in the topology visualizer. This includes:

* **Properties** - metadata, such as the relation type and any labels. Click SHOW ALL PROPERTIES to open a pop-up with all details of the relation.
* **Components** - the source component and target component that the relation connects.
* **Health** - reports the relation [health state](/use/concepts/health-state.md) as calculated by StackState. Expand to see all [health checks](/use/checks-and-monitors/checks.md) and [monitors](/use/checks-and-monitors/monitors.md) attached to the component.
* **Propagated health** - reports the relation's [propagated health state](/use/concepts/health-state.md#propagated-health-state). This is derived from the health state of the components and relations that the relation depends upon.
* **Problems** - lists all [problems](/use/problem-analysis/about-problems.md) that involve the selected relation. 
* **Events** - the latest 10 [events](/use/concepts/events.md) that relate to the selected relation. Click VIEW ALL to open the Events perspective in a [subview](/use/stackstate-ui/views/about_views.md#subview) containing only the relation component. 
* **Telemetry** - all [telemetry streams](/use/metrics-and-events/telemetry_streams.md) linked to the relation.

### Indirect relations

![](/.gitbook/assets/v51_indirect_relation_comp_comp.png)

Indirect relations link two components that are connected together via a path of invisible components. Indirect relations in a view will be displayed when **Show all indirect relations** is enabled in the [visualization settings](/use/stackstate-ui/views/visualization_settings.md). An **indirect relation** between two components is shown as a dashed line.  The direction of the arrowhead shows the direction of the dependency. Select an indirect relation to view the full path between the components in the right panel details tab - **Indirect relation details**.     

#### Indirect relation details

![Indirect relation details](/.gitbook/assets/v51_indirect_relation_details.png)

The **Indirect relation details** tab is shown in the StackState UI right panel when an indirect relation is selected in the topology visualizer. The full path, including all components that connect the source and the target component, is shown. From here you can click on a component or relation between components to jump to the associated **Component details** tab or **Direct relation details** tab where you will find detailed information about the selected component or relation.

### Grouped relations

![](/.gitbook/assets/v51_relation_group_comp.png) 

Relations between a component group and a component or component group are shown in the topology visualizer as a combination of a solid and a dashed line. This type of relation is called a grouped relation and could contain a combination of direct relations and indirect relations and could connect to one or more components in the component group. Select a grouped relation to display full details of the included relations in the right panel details tab - **Grouped relation details**. 

#### Grouped relation details

![Grouped relation details](/.gitbook/assets/v51_grouped_relation_details.png)

The **Grouped relation details** tab is shown in the StackState UI right panel when a grouped relation is selected in the topology visualizer. This shows all relations included in the group. From here you can click on a component or relation between components to open the associated **Component details** tab or **Direct relation details** tab with detailed information about the selected component or relation.

## Relation details

![Relation details](/.gitbook/assets/v51_relation_details.png)

When a relation is selected by clicking on it, detailed information about the component is shown in the right panel details tab - **Direct relation details**, **Indirect relation details** or **Grouped relation details**, depending on the type of relation that has been selected. For details of the tab content, see the relation types [direct relations](#direct-relations), [indirect relations](#indirect-relations) and [grouped relations](#grouped-relations).

## Dependencies and propagation

If a relation indicates a dependency, the line will have an arrowhead showing the direction of the dependency. A dependency could be in one direction or in both directions, indicating that two components depend on each other, for example a network device talking to another networking device that has a bi-directional connection.

[Health state will propagate](health-state.md#propagated-health-state) from one component to the next upwards along a chain of dependencies. If the relation does not show a dependency between the components it connects \(no arrowhead\), it can be considered as merely a line in the visualizer or a connection in the stack topology.

## See also

* [Topology perspective](/use/stackstate-ui/perspectives/topology-perspective.md)
* [Components](/use/concepts/relations.md)
* [Health state propagation](/use/concepts/health-state.md#propagated-health-state)
* [View visualization settings](/use/stackstate-ui/views/visualization_settings.md)