---
description: StackState SaaS
---

# Visualization settings

## Overview

Visualization settings let you customize how components in the view and the relations between them are displayed. Each view contains all components that match the saved topology filter. You may want or need to optimize the way in which these components are visualized in the topology perspective. A number of visualization options can be adjusted to achieve the best visibility for your situation and environment:

* [Group components](visualization_settings.md#components-grouping)
* [Organize components](visualization_settings.md#grid-options) by layers or domains
* [Show indirect relations](visualization_settings.md#relations-settings) between components
* [Show the root cause](visualization_settings.md#root-cause) for problem components

Changes made to the visualization settings are saved together with the view.

## Root cause

The root cause visualization settings allow you to make the same changes as can be done with the lightening bolt buttons in the top right corner of the topology visualization. By default, this will be set to **don't show root cause**. When enabled, the view will be automatically expanded to show dependencies that are impacting `DEVIATING` or `CRITICAL` propagated health states of components in the view.

## Grid options

The components in the topology perspective can optionally be organized in a grid, with layers grouped in rows and domains visualized as columns. The grid is turned on by default. When no grid options are selected, no grid is displayed.

* **Organize by layers** - Components of the same layer are placed in the same grid row in the topology visualization. Disable to remove the rows from the grid.
* **Organize by domains** - Components of the same domain are placed in the same grid column in the topology visualization. Disable to remove the columns from the grid.

For example, if you have a business service visualization of a stack that comes from four or five different sources, the source \(domain\) they're coming from won't be so important in the visualization. This could be a good situation to visualize the topology with **organize by domains** switched off.

## Components grouping

Topology visualizations of large numbers of components can become hard to read. StackState can group together components within the same view. Grouping brings the number of components and relations down to something visually more manageable.

Grouping is enabled by default and respects the selected [grid options](visualization_settings.md#grid-options) - components must be in the same grid row/column to be grouped together.

Three types of grouping are available, or you can choose not to group components together:

* **No grouping** - Components and relations aren't grouped in any way.
* **Auto grouping** - Grouping settings are automatically adjusted to keep the number of components or component groups visualized below 35.
* **Group by state and type** - Components of the same type and with the same health state are grouped together into one group. If one of the grouped components changes its health state and no longer matches the health state of the component group, it will pop out of the group. If other components of the same type have the same health state, a new group will be created.
* **Group by type, state and relation** - Components are grouped together as with **group by state and type** while maintaining information about relations to components outside of the group. All components in a group have the same source and target connection. This is useful because grouping components together by state and type alone can cause some information on relations for the components in the group to be lost.

### Minimum components in a group 

For **group by state and type** and **group by type, state and relation**, a threshold must be passed before any grouping happens - the Minimum components in a group. 

By default, the minimum group size is 2, this means that if there is one component of a certain type and health state in a view, then when the next component comes along that has the same state and type a component group will be created. If the threshold value is set higher, to 8 for example, then at least 8 components with the same state type \(and possibly relations\) would be required for a group to be created.

## Relations settings

Another option in the view visualization settings is showing indirect relations. So, what are indirect relations? Well, if we take a landscape with three components that are all dependent on each other. If we then created a view in which only two of those components are included - for example, the first and last components – we would see both components, but we would not see a relation between them anymore. In this case, we would probably still want to know that there is an indirect path between those two components and that's where this functionality comes in.

If we enable show indirect relations in the view visualizations settings, then StackState will draw a dotted line between those two components to show that there is a path between them passes through components that aren't included on the view.

* A solid line between two components indicates that there is a direct relation between them 
* StackState shows a dotted line when two components have a path between them, but the full path isn't visible in the current view.

Show indirect relations is switched off by default. If we take a view of three components again and remove the Applications layer. That will hide the middle component. With show indirect relations disabled there are no connection between the remaining components - it appears that these components aren't connected at all - you see the tree of connected components at the top and then 4 components at the bottom that aren't connected to anything, with no relations between them.

If we enable show all indirect relations, there will always be a dotted line marking all indirect connections between the components. That could work out to be a heavy operation on a large topology and might slow down the topology visualization. We don’t need to enable indirect relations here to show them the view expands to show Root Cause Only components.

➡️ [Learn more about indirect relations](/use/concepts/relations.md#relation-types)