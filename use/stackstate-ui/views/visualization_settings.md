---
description: StackState Self-hosted v5.1.x 
---

# Visualization settings

## Overview

Visualization settings let you customize how components in the view and the relations between them are displayed. Each view contains all components that match the saved topology filter. You may want or need to optimize the way in which these components are visualized in the topology perspective. A number of visualization options can be adjusted to achieve the best visibility for your situation and environment:

* [Group components](visualization_settings.md#components-grouping)
* [Organize components](visualization_settings.md#grid-options) by layers or domains
* [Show indirect relations](visualization_settings.md#relations-settings) between components

Changes made to the visualization settings are saved together with the view.

Click the **Visualization Settings** icon in the top right of theÏ topology visualizer to open the visualization settings menu. 

![Visualization settings menu](.gitbook/assets/v52_visualization_settings.png)

## Root cause

The root cause visualization settings allow you to make the same changes as can be done with the lightening bolt buttons in the top right corner of the topology visualization. By default, this will be set to **don't show root cause**. When enabled, the view will be automatically expanded to show dependencies that are impacting `DEVIATING` or `CRITICAL` propagated health states of components in the view.

## Grid options

The components in the topology perspective can optionally be organized in a grid, with layers grouped in rows and domains visualized as columns. The grid is turned on by default. When no grid options are selected, no grid is displayed.

* **Organize components by Layers** - Components of the same layer are placed in the same grid row in the topology visualization. Disable to remove the rows from the grid.
* **Organize components by Domains** - Components of the same domain are placed in the same grid column in the topology visualization. Disable to remove the columns from the grid.

For example, the source \(domain\) of components might not be important in a business service visualization of a stack that comes from four or five different sources. This could be a good situation to switch off **organize components by Domains** in the topology visualization.

## Components grouping

Topology visualizations of large numbers of components can become hard to read. StackState can optionally group together like components within the same view. This reduces the number of displayed components and relations, and simplifies the topology visualization.

Grouping is enabled by default and respects the selected [grid options](visualization_settings.md#grid-options) - components must be in the same grid row and column to be grouped together.

Three types of grouping are available, or you can choose not to group components together:

* **Auto grouping** - Grouping settings are automatically adjusted to keep the number of components or component groups visualized below 35.
* **No grouping** - Components and relations aren't grouped in any way.
* **Group by type and state** - Components of the same type and with the same health state are grouped together into one group. If one of the grouped components changes its health state and no longer matches the health state of the component group, it will pop out of the group. If other components of the same type have the same health state, a new group will be created.
* **Group by type, state and relation** - Components are grouped together as with **group by type and state** while maintaining information about relations to components outside the group. All components in a group have the same source and target connection. This is useful because grouping components together by state and type alone can cause some information on relations for the components in the group to be lost.

### Minimum components in a group 

For **group by type and state** and **group by type, state and relation**, a threshold must be passed before any grouping happens - the **Minimum components in a group**. 

By default, the minimum group size is 2. Whenever there are two or more components of a certain type and health state in a view, they will be placed in a component group. If the threshold value is set higher, to 8 for example, then 8 components with the same state, type \(and possibly relations\) are required for a group to be created.

## Relations settings

Another option in the view visualization settings is to show indirect relations. So, what are indirect relations? Well, in a landscape with three components that are all dependent on each other. If a view was created that only included the first and last components, both components would be visible in the view, but no relation between them would be shown. In this case, it could be helpful to know that there is an indirect path between the two components and that's where this functionality comes in.

When **Show all indirect relations** is enabled in the view visualizations settings, StackState will draw a dotted line between the two components. This shows that there is a path between the components that passes through other components that aren't included in the view.

* A solid line between two components indicates that there is a direct relation between them.
* A dotted line between two components indicates that there is a path between them, but the full path isn't visible in the current view.

By default, indirect relations aren't shown in a view. When show all indirect relations is enabled, there will always be a dotted line marking all indirect connections between components. On a large topology, that could work out to be a heavy operation and this might slow down the topology visualization.

➡️ [Learn more about indirect relations](/use/concepts/relations.md#relation-types)