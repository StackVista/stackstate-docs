---
description: See the architecture of your IT landscape.
---

# Topology Perspective

The Topology Perspective displays the components in your IT landscape and their relationships.

![](../../../.gitbook/assets/topoview1.png)

## Components and relations

The Topology Perspective shows components and relations in the selected [view](views.md). Components that have one or more [checks](../../../configure/checks_and_streams.md#checks) configured will have a calculated [health state](../../../configure/propagation.md).

## Component details

When a component is selected by clicking on it, the Component Details panel is shown on the right hand side. This panel displays detailed information of the component:

* metadata such as the component's name, type and labels
* [health checks](../../../configure/checks_and_streams.md#checks)
* [telemetry streams](../../../configure/checks_and_streams.md#data-streams)

## Component finder

Locate a specific component in the view by typing the first few letters of it's name. Alternatively, you can select the **Component finder** icon magnifying glass.

## Zoom in, zoom out and Fit to Screen

The **plus** button .zooms in on the topology, the **minus** button zooms out. In between both buttons is the **fit to screen** button which zooms out so the complete topology becomes visible.

## Problem clusters

If one or more components have a critical state, StackState will show the related components and their states as a Problem Cluster in the [View Overview pane](views.md#view-overview).

## Root cause display

If there are components with [telemetry streams](../../../configure/checks_and_streams.md#data-streams) and [health checks](../../../configure/checks_and_streams.md#checks) in your view, the Topology Perspective will calculate a health state and [propagate](../../../configure/propagation.md) this state throughout the graph. This means your view can contain components that have a deviating health state caused by a component that is outside your view.

The Topology Perspective allows you to configure whether to show the root cause if it is outside of your view:

* **Don't show root cause** -- do not show the root cause 
* **Show root cause only** -- only show the root cause component
* **Show full root cause tree** -- show the entire root cause tree

## List mode

The components in the view can also be shown in a list instead of a graph.

