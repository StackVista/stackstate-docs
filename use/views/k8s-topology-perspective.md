---
description: Rancher Observability
---

# Topology Perspective

## Overview

The Topology Perspective displays the components in your IT landscape and their relationships.

![Topology perspective](../../.gitbook/assets/k8s/k8s-topology-perspective.png)

## Legend

Click on the Legend button (?) in the bottom right of the screen (just below the zoom controls) to display an explanation of the icons and colors used in the topology visualization.

![Topology perspective legend](../../.gitbook/assets/k8s/k8s-topology-perspective-legend.png)

## Components

The Topology Perspective shows the filtered components and relations in a selected [view](k8s-view-structure.md). Components that have one or more [monitors](../../use/alerting/k8s-monitors.md) configured will report a calculated health state.

* Select a component to display detailed component information in the right panel details tab - **Component details**.
* Hover over a component to open the [component context menu](#component-context-menu).

### Component context menu

When you hover the mouse pointer over a component, the component context menu is displayed. This gives you information about the component, which includes:

* The component name and type
* Health state
* [Actions](#actions) specific to the component
* [Shortcuts](#shortcuts) specific to the component

![Component context menu](../../.gitbook/assets/k8s/k8s-component-contex-menu.png)

### Actions

Actions can be used to expand the topology selection to show all dependencies for the selected component. Other actions may be available for specific components, such as component actions that are installed as part of a StackPack.

A list of the available **Actions** is included in the right panel details tab when you select a component - **Component details**. Actions are also listed in the component context menu, which is displayed when you hover the mouse pointer over a component.

### Shortcuts

Shortcuts give you direct access to detailed information about the specific component:

* **Open component view** - Opens the [component view](k8s-component-views.md) for this component. The component view provides you with a bird's eye view of everything that matters about this component and its direct neighbors, depending on the component type you are viewing.
* **Explore component** - Opens an [explore view](k8s-explore-views.md) containing only this component. The explore view allows you to investigate a single component from all perspectives without needing to adjust the view filters. Double-clicking a component achieves the same result.
* **Show properties** - Opens the properties popup for the component. This is the same as clicking **SHOW ALL PROPERTIES** in the right panel details tab when detailed information about a component is displayed - **Component details**.

## Relations

Relations show how components in the topology are connected together. They're represented by a dashed or solid line and have an arrowhead showing the direction of dependency between the components they link. 

* **Direct relation** - components connected by network and any other form of direct relationship
* **Indirect relation** - relationships between components due to network traffic or other dependencies, excluding connections to and from external components that are not in your current topology selection
* **Grouped relation** - a combination of direct relations and indirect relations and connects one or more components in the component group

Select a relation to open detailed information about it in the right panel details tab.

## Visualization settings

The way components and relations are displayed in the topology perspective can be customized in the visualization settings menu in the top right corner of the visualizer.  The Visualization Settings are saved together with the View.
 
### Grid options

The components in the topology perspective can optionally be organized in a grid, with layers grouped in rows and domains visualized as columns. The grid is turned on by default. When no grid options are selected, no grid is displayed.

* **Organize by layers** - Components of the same layer are placed in the same grid row in the topology visualization. Disable to remove the rows from the grid.
* **Organize by domains** - Components of the same domain are placed in the same grid column in the topology visualization. Disable to remove the columns from the grid.

For example, if you have a business service visualization of a stack that comes from four or five different sources, the source \(domain\) they're coming from won't be so important in the visualization. This could be a good situation to visualize the topology with **organize by domains** switched off.

### Components grouping

Topology visualizations of large numbers of components can become hard to read. Rancher Observability can group together components within the same view. Grouping brings the number of components and relations down to something visually more manageable.

Grouping is enabled by default and respects the selected [grid options](#grid-options) - components must be in the same grid row/column to be grouped together.

Three types of grouping are available, or you can choose not to group components together:

* **No grouping** - Components and relations aren't grouped in any way.
* **Auto grouping** - Grouping settings are automatically adjusted to keep the number of components or component groups visualized below 35.
* **Group by state and type** - Components of the same type and with the same health state are grouped together into one group. If one of the grouped components changes its health state and no longer matches the health state of the component group, it will pop out of the group. If other components of the same type have the same health state, a new group will be created.
* **Group by type, state and relation** - Components are grouped together as with **group by state and type** while maintaining information about relations to components outside of the group. All components in a group have the same source and target connection. This is useful because grouping components together by state and type alone can cause some information on relations for the components in the group to be lost.


## Navigation

### Zoom in and out

There are zoom buttons located in the bottom right corner of the topology visualizer. The **plus** button zooms in on the topology, the **minus** button zooms out. In between both buttons is the **fit to screen** button which zooms out so the complete topology becomes visible.

### Find component

You can locate a specific component in the topology by clicking `CTRL` + `SHIFT` + `F` and typing the first few letters of the component name. Alternatively, you can select the **Find component** magnifying glass icon in the bottom right corner of the topology visualizer.

See the full list of [Rancher Observability keyboard shortcuts](/use/stackstate-ui/k8sTs-keyboard-shortcuts.md).

### Show root cause

If there are components with monitors on them which are outside the view but might influence the component in the view, the Topology Perspective will show the health state of all components shown.

* **Don't show root cause** - Don't show the root causes of components shown by the current topology filters.
* **Show root cause only** - Only show the root causes of components shown by the current topology filters that have a `CRITICAL` or `DEVIATING` propagated health. Indirect relations are visualized if a component directly depends on at least one invisible component that leads to the root cause.
* **Show full root cause tree** - Show all paths from components shown by the current topology filters that have a `CRITICAL` or `DEVIATING` propagated health to their root causes.

![Root cause](../../.gitbook/assets/k8s/k8s-show-root-cause.png)

## List mode

The components in the topology visualization can also be shown in a list instead of a graph:

![Filtering\(list format\)](../../.gitbook/assets/k8s/k8s-topology-perspective-list-mode.png)

### Export as CSV

From list mode, the component list can be exported as a CSV file. The CSV file includes `name`, `state`, `type` and `updated` details for each component in the view.

1. From the topology perspective, click the **List mode** icon on the top right to open the topology in list mode.
2. Click **Download as CSV** from the top of the page.
   * The component list will be downloaded as a CSV file named `<view_name>.csv`.
