---
description: StackState Self-hosted v5.1.x 
---

# Topology Perspective

## Overview

The Topology Perspective displays the components in your IT landscape and their relationships.

![Topology Perspective](/.gitbook/assets/v51_topology.png)

## Legend

Click on the Legend button (?) in the bottom right of the screen to display an explanation of the icons and colors used in the topology visualization.

![Topology Perspective - legend](/.gitbook/assets/v51_topology_legend.png)

## Components

The Topology Perspective shows the filtered components and relations in a selected [view](../views/about_views.md) or the entire, unfiltered topology in [explore mode](../explore_mode.md). Components that have one or more health checks configured will report a calculated [health state](../../concepts/health-state.md).

* Select a component to display [detailed component information](/use/concepts/components.md#component-details) in the right panel details tab - **Component details**.
* Hover over a component to open the [component context menu](#component-context-menu).

➡️ [Learn more about components](/use/concepts/components.md#components)

### Component context menu

When you hover the mouse pointer over a component, the component context menu is displayed. This gives you information about the component, this includes:

* The component name and type
* [Health state](/use/concepts/health-state.md) and [propagated health state](/use/concepts/health-state.md#element-propagated-health-state) of the component.
* [Top metrics](/use/metrics/top-metrics.md) for the component.
* [Shortcuts](#shortcuts) specific to the component.
* [Actions](#actions) specific to the component.

![Component context menu](/.gitbook/assets/v51_component_context_menu.png)

### Actions

Actions can be used to expand the topology selection to show all dependencies for the selected component. Other actions may be available for specific components, such as component actions that are installed as part of a StackPack.

{% hint style="success" "self-hosted info" %}

You can configure [component actions](../../../configure/topology/component_actions.md) in the **Settings** page or create [custom component actions](../../../develop/developer-guides/custom-functions/component-actions.md).
{% endhint %}

A list of the available **Actions** is included in the right panel details tab when you select a component - **Component details**. Actions are also listed in the component context menu, which is displayed when you hover the mouse pointer over a component.

![Actions](../../../.gitbook/assets/v51_actions.png)

### Shortcuts

Shortcuts give you direct access to detailed information about the specific component:

* **Show properties** - Opens the properties popup for the component. This is the same as clicking **SHOW ALL PROPERTIES** in the right panel details tab when detailed information about a component is displayed - **Component details**.
* **Investigate in subview** - Opens a subview containing only this component. The subview allows you to investigate a single component in all perspectives without needing to adjust the view filters. This is the same as clicking INVESTIGATE IN SUBVIEW in the right panel details tab when detailed information about a component is displayed - **Component details**.

## Relations

Relations show how components in the topology are connected together. They're represented by a dashed or solid line and have an arrowhead showing the direction of dependency between the components they link. [Health state will propagate](../../concepts/health-state.md#element-propagated-health-state) from one component to the next, from dependencies to dependent components. Relations that have one or more health checks configured will report a calculated health state.

Select a relation to open detailed information about it in the right panel details tab - **Direct relation details**, **Indirect relation details** or **Grouped relation details** depending on the relation type that has been selected.

➡️ [Learn more about relations](/use/concepts/relations.md)

![Indirect relation path](/.gitbook/assets/v51_indirect_relation_details.png)

## Filters

The components and events displayed in the topology visualization can be customized by adding filters.

Click the **View Filters** icon in the left menu to open the view filters. Here you can edit the filters applied to the displayed topology and events:

* **Topology filters** - filter the components displayed in the topology visualization.
* **Events filters** - filter the events shown in the **Events** list in the right panel **View summary** and details tabs - **Component details** and **Direct relation details**.

Select an element to show detailed information about it in the right panel details tab. Click a label under **Properties** in the details tab to add this to the topology filter. The displayed topology will be expanded to include all components and relations with the selected label. To undo a label selection, click the back button in the browser or edit the topology filter in the view filters.

The view filters are saved together with the View. For details, see the page [filters](../filters.md).

## Problems

If one or more components in a view have a CRITICAL state, StackState will show the related components and their states as a **Problem** in the [View summary](../views/about_views.md#view-summary).

## Navigation

### Zoom in and out

There are zoom buttons located in the bottom right corner of the topology visualizer. The **plus** button zooms in on the topology, the **minus** button zooms out. In between both buttons is the **fit to screen** button which zooms out so the complete topology becomes visible.

### Find component

You can locate a specific component in the topology by clicking `CTRL` + `SHIFT` + `F` and typing the first few letters of the component name. Alternatively, you can select the **Find component** magnifying glass icon in the bottom right corner of the topology visualizer.

See the full list of [StackState keyboard shortcuts](../keyboard-shortcuts.md).

### Show root cause

A view can contain components with a `DEVIATING` [propagated health state](/use/concepts/health-state.md#element-propagated-health-state) (outer color) caused by a component that's not included in the view itself. By default, these components are not displayed, however, the topology visualization can be configured to automatically expand and show all root cause components currently affecting the components within the view. Three settings are available:

* **Don't show root cause** (default) - only components matching the current topology filters are displayed.
* **Show root cause only** - the topology filters are automatically expanded to include the root cause component of any component with a `CRITICAL` or `DEVIATING` propagated health state. Indirect relations are visualized if a component directly depends on at least one invisible component that leads to the root cause.
* **Show full root cause tree** - the topology filters are automatically expanded to include the full path to the root cause component of any component with a `CRITICAL` or `DEVIATING` propagated health state.

![Root cause](/.gitbook/assets/v51_show_full_root_cause_tree.png)

## List mode

The components in the topology visualization can also be shown in a list instead of a graph:

![Filtering\(list format\)](../../../.gitbook/assets/v51_list_mode.png)

### Export as CSV

From list mode, the component list can be exported as a CSV file. The CSV file includes `name`, `state`, `type` and `updated` details for each component in the view.

1. From the topology perspective, click the **List mode** icon on the top right to open the topology in list mode.
2. Click **Download as CSV** from the top of the page.
   * The component list will be downloaded as a CSV file named `<view_name>.csv`.

### Visualization settings

The visualization of components and relations in the topology perspective can be customized in the visualization settings. Click the **Visualization Settings** icon in the top right of the topology visualizer to open the visualization settings menu. 

![Visualization settings menu](.gitbook/assets/v52_visualization_settings.png)

Here you can edit:

* Grid options - organize components by [layer and domain](../../concepts/layers_domains_environments.md).
* Components grouping - display components individually or join like components together in component groups. For details, see [component grouping](/use/concepts/components.md#grouping).
* Relations settings - show or hide indirect relations between components. For details, see [indirect relations](/use/concepts/relations.md#indirect-relations).

The Visualization Settings are saved together with the View. For details, see the page [Visualization settings](../views/visualization_settings.md).