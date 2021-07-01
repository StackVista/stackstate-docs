---
description: See the real time state of your IT landscape
---

# Topology Perspective

## Overview

The Topology Perspective displays the components in your IT landscape and their relationships.

![Topology Perspective](../../../.gitbook/assets/v43_topoview1.png)

## Components

The Topology Perspective shows the filtered components and relations in a selected [view](../views/about_views.md) or the entire, unfiltered topology in [explore mode](/use/stackstate-ui/explore_mode.md). Components that have one or more health checks configured will report a calculated [health state](/use/health-state/health-state-in-stackstate.md).

### Types

TODO

### Grouping

[View visuzalization settings](../views/visualization_settings.md)

### Component Details pane

When a component is selected by clicking on it, the **Component Details** pane is shown on the right-hand side of the screen. This panel displays detailed information about the component:

* Metadata, such as the component name, type and any labels.
* [health checks](../../../configure/telemetry/checks_and_streams.md#checks)
* [telemetry streams](../../../configure/telemetry/checks_and_streams.md#data-streams)

### Find component

You can locate a specific component in the topology by clicking `CTRL` + `SHIFT` + `F` and typing the first few letters of the component name. Alternatively, you can select the **Find component** magnifying glass icon in the bottom right corner of the topology visualizer.

See the full list of [StackState keyboard shortcuts](/use/stackstate-ui/keyboard-shortcuts.md).

## Relations

Relations show how components in the topology are connected together. They are represented by a dashed or solid line. Relations that have one or more health checks configured will report a calculated [health state](/use/health-state/health-state-in-stackstate.md).

| Relation type | Description |
|:---|:---|
| ![](/.gitbook/assets/relation_comp_comp.svg) | A solid line denotes a direct relation between two components. |
| ![](/.gitbook/assets/relation_indirect_comp_comp.svg) | A dashed line denotes an indirect relation between two components. This means that another component that is not visualized sits between the two indirectly related components. |
| ![](/.gitbook/assets/relation_comp_group.svg) | A solid line denotes a direct relation between a component and **all components** in a component group. All relations are in the same direction.  |
| ![](/.gitbook/assets/relation_comp_group_dot_1.svg) | A dashed line with a single arrowhead denotes either a direct relation between a component and **some components** in a component group or indirect relations to **some or all** components in the group. All relations are in the same direction. |
| ![](/.gitbook/assets/relation_comp_group_dot_2.svg) | A dashed line with two arrowheads denotes a direct relation between a component and **some components** in a component group. All relations are in the same direction. |


## Filters

The components and events displayed in the topology visualization can be customized by adding filters.

Click the **View Filters** icon in the left-hand side menu to open the view filters. Here you can edit:

* Topology filters: The components displayed in the topology visualization.
* Events filters: The events shown in the **Events** list in the View Details pane on the right-hand side of the screen.

From the **Component Details** or **Relation Details** pane, displayed on the right-hand side of the screen when a component or relation is selected:

* Click on a label to add this to the topology filter. The displayed topology will be expanded to include all components and relationswith the selected label.
* To undo a label selection, click the back button in the browser or edit the topology filter in the view filters.

The View Filters are saved together with the View. For details, see the page [filters](../filters.md).

## Visualization settings

The visualization of components and relations in the topology perspective can be customized in the visualization settings. Click the **Visualization Settings** icon in the left-hand side menu to open the visualization settings menu. Here you can edit:

* Root cause display - to what extent the view should be expanded when an element in the view reports a DEVIATING or CRITICAL health state or propagated health state. 
* Grouping - should all components be displayed individually or should like components be grouped. For details, see [component grouping](#component-grouping).
* Grid - should components be organized by [layer and domain](/use/introduction-to-stackstate/layers_domains_and_environments.md).
* Indirect relations - should relations between components be shown if these connect through other components that are not displayed in the view. For details, see [relations](#relations).

The Visualization Settings are saved together with the View. For details, see the page [Visuzalization settings](../views/visualization_settings.md).

------------





## Interactive navigation

The topology can also be navigated interactively. Hover over any component to bring up the component navigation menu. The available options allow you to change your view respective to the selected component.

### Actions

**Actions** can be used to expand the topology selection in one of the following ways:

* Show all dependencies -- shows all dependencies for selected component
* Show dependencies, 1 level, both directions -- limits displayed dependencies to one level from selected component
* Show Root Cause -- if the selected component is in a non-clear state, adds the root cause tree
* Show Root Cause only -- limits displayed components to the root cause elements

A list of the available actions is included in the component details pane when you select a component and also in the component navigation menu, which is displayed when you hover over a component.

![Actions](../../../.gitbook/assets/v43_actions.png)

The default list of actions can be extended with [component actions](../../../configure/topology/component_actions.md) that are installed as part of a StackPack or you can [write your own](../../../develop/developer-guides/custom-functions/component-actions.md) custom component action functions.

### Dependencies

Hover over any component to bring up the component navigation menu. Select Dependencies to isolate the selected component \(show only that component\) and expand the topology selection in one of the following ways:

* Direction -- choose between **Both**, **Up**, and **Down**
* Depth -- choose between **All**, **1 level**, and **2 levels**

![Dependencies](../../../.gitbook/assets/dependencies.png)

If you require more flexibility in selecting topology, check out the [StackState Query Language \(STQL\)](../../../develop/reference/stql_reference.md).

### Root Cause Analysis

Hover over any component to bring up the component navigation menu. Select Root Cause Analysis to isolate the selected non clear \(e.g. deviating or critical\) and expand the topology selection in one of the following ways:

* **Root cause only** -- only show the probable causing component
* **Full root cause tree** --  show the entire root cause tree

![Root cause](../../../.gitbook/assets/root_cause_analysis.png)

You can also [show root cause outside the current view](topology-perspective.md#root-cause-outside-current-view)


## Zoom in, zoom out and Fit to Screen

There are zoom buttons located in the bottom right corner of the topology visualizer. The **plus** button zooms in on the topology, the **minus** button zooms out. In between both buttons is the **fit to screen** button which zooms out so the complete topology becomes visible.

## Problems

If one or more components have a critical state, StackState will show the related components and their states as a **Problem** in the [View Details pane](../views/about_views.md#the-view-details-pane).

## Root cause outside current view

If there are components with [telemetry streams](../../../configure/telemetry/checks_and_streams.md#data-streams) and [health checks](../../../configure/telemetry/checks_and_streams.md#checks) in your view, the Topology Perspective will calculate a health state and [propagate](../../../develop/developer-guides/custom-functions/propagation-functions.md) this state throughout the graph. The propagated health state will help you to see the risk of affecting other components.

It is possible that your view can contain components that have a deviating propagated health state caused by a component that is outside your view. The Topology Perspective allows you to configure whether to show a root cause even when it is outside of the currently displayed view:

* **Don't show root cause** -- do not show the root cause
* **Show root cause only** -- only show the root cause component
* **Show full root cause tree** -- show the entire root cause tree

![Root cause](../../../.gitbook/assets/v43_show_full_root_cause_tree.png)

## List mode

The components in the topology visualization can also be shown in a list instead of a graph:

![Filtering\(list format\)](../../../.gitbook/assets/v43_list_mode.png)

### Export as CSV

From list mode, the component list can be exported as a CSV file. The CSV file includes `name`, `state`, `type` and `updated` details for each component in the view.

1. From the topology perspective, click the **List mode** icon on the top right of the screen to open the topology in list mode.
2. Click **Download as CSV** from the top of the page.
   * The component list will be downloaded as a CSV file named `<view_name>.csv`.

