---
description: See the architecture of your IT landscape.
---

# Topology Perspective

The Topology Perspective displays the components in your IT landscape and their relationships.

## Components and relations

The Topology Perspective shows components and relations in the selected [view](views.md). Components that have one or more [checks](../../../configure/checks_and_streams.md#checks) configured will have a calculated [health state](../../../configure/propagation.md).

## Component details

When a component is selected by clicking on it, the Component Details panel is shown on the right hand side. This panel displays detailed information of the component:

* metadata such as the component's name, type and labels
* health checks
* telemetry streams

## Component finder

Locate a specific component in the view by typing the first few letters of it's name. Alternatively, you can select the **Component finder** icon magnifying glass.

## Zoom in, zoom out and Fit to Screen

The **plus** button .zooms in on the topology, the **minus** button zooms out. In between both buttons is the **fit to screen** button which zooms out so the complete topology becomes visible.

## Problem clusters

If one or more components have a critical state, StackState will show the related components and their states as a Problem Cluster in the [View Overview pane](views.md#view-overview).

## Root cause display

The Topology Perspective can optionally show the root cause of a problem cluster in the view:

* Don't show root cause
* Show root cause only
* Show full root cause tree 

## List mode

The components in the view can also be shown in a list instead of a graph.

