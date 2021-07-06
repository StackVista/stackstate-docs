# Visualization settings

## Overview

Visualization settings let you customize how components in the view and the relations between them are displayed. Each view contains all components that match the saved topology filter. You may want or need to optimize the way in which these components are visualized in the topology perspective. A number of visualization options can be adjusted to achieve the best visibility for your situation and environment:

* [Group components](#components-grouping)
* [Organize components](#grid-options) by layers or domains
* [Show indirect relations](#relations-settings) between components
* [Show the root cause](#root-cause) for problem components

Changes made to the visualization settings are saved together with the view.

## Root cause

The root cause visualization settings allow you to make the same changes as can be done with the lightening bolt buttons in the top right corner of the topology visualization. By default, this will be set to **don't show root cause**. When enabled, the view will be automatically expanded to show dependencies that are impacting DEVIATING or CRITICAL propagated health states of components in the view.

## Grid options

The components in the topology perspective can optionally be organized in a grid, with layers grouped in rows and domains visualized as columns. The grid is turned on by default. When no grid options are selected, no grid is displayed.

For example, if you have a business service visualization of a stack that comes from four or five different sources, the source (domain) they are coming from will not be so important in the visualization. This could be a good situation to visualize the topology with **organize by domains** switched off.

## Components grouping

StackState can optionally group together components within the same view. A view can have no grouping, so that's exploding everything on the screen, or we can group together components in one of three different ways.

* **Auto grouping** - TODO

* **Group by state and type** - for example we have multiple business services, and these services all have the same component type – type business service - and they all also all have the green color, that’s a CLEAR health state. These components will be grouped together into one group. When they are grouped, they will get a new icon - a hexagon - that depicts a group of components of the same type and the same health. If one of grouped components changes its health state and turns red, that’s a CRITICAL health state, then it will pop out of that group. At a certain point if more components from this group turn red they will form their own group next to the original group that was green.

* **group by type, state and relation** - the same as Group by state and type, but will also respect the relations between components. You can imagine that if we group everything together based on the type and state, ome information on how the components are related to each other might be lost. This option allows us to group components but maintain that information. 

By default, grouping is enabled, also there is a certain threshold before grouping happens, the minimum components in a group. By default, the minimum group size is 2, so if we have one component of a certain type and health state, then when the next component comes along that has the same state and type they will group together because they are 2 components of the same type and health state. If we set this value to eight for example, then we would need to have at least 8 components with the same state type and possibly relations for them to group together.

## Relations settings

Another option in the view visualization settings is showing indirect relations. 
So, what are indirect relations? Well, if we take a landscape with three components that are all dependent on each other.  If we then created a view in which only two of those components are included - for example, the first and last components – we would see both components, but we would not see a relation between them anymore. In this case, we would probably still want to know that there is an indirect path between those two components and that's where this functionality comes in. 

If we enable show indirect relations in the view visualizations settings, then StackState will draw a dotted line between those two components to show that there is a path between them passes through components that are not included on the view. 

* A solid line between two components indicates that there is a direct relation between them 
* StackState shows a dotted line when two components have a path between them, but the full path is not visible in the current view.

Show indirect relations is switched off by default. If we take a view of three components again and remove the Applications layer. That will hide the middle component. With show indirect relations disabled there are no connection between the remaining components - it appears that these components are not connected at all - you see the tree of connected components at the top and then 4 components at the bottom that are not connected to anything, with no relations between them. 

If we enable show all indirect relations, there will always be a dotted line marking all indirect connections between the components. That could work out to be a heavy operation on a large topology and might slow down the topology visualization. We don’t need to enable indirect relations here to show them the view expands to show Root Cause Only components. 

