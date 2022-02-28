---
description: StackState Self-hosted v4.6.x
---

# Components

## Overview

A component is anything that has a run-time state and some relation with other components. Some component examples are a load balancer, a database server, a network switch, or a business service. It is possible to define custom components, and they can be anything - the granularity and range can be defined according to the needs. Each component is of a specific type. Types can be configured.

A component consists of:

1. The name of the component.
2. An icon in the middle that represents either the component itself or the component type.
3. An inner color represents the component's [own health state](/use/health-state/about-health-state.md#element-health-state).
4. An outer color represents the [propagated health state](/use/health-state/about-health-state.md#propagated-health-state). This state depends on other components or relations.

![](/.gitbook/assets/021_topology_elements.png)

## Component Details pane

When a component is selected by clicking on it, the **Component Details** pane is shown on the right-hand side of the screen. This panel displays detailed information about the component:

* Metadata, such as the component name, type and any labels.
* [Run state](/use/health-state/run-state.md)
* [Health checks](/use/health-state/add-a-health-check.md)
* [Telemetry streams](/use/metrics-and-events/telemetry_streams.md)

## Component groups

Components of the same type and/or state can optionally be grouped together into a single element. Grouped components are represented by a hexagon in the topology visualization. The size of the component group's hexagon in the topology visualization represents the number of components in the group:

* Less than 100 components = small hexagon
* 100 to 150 components = medium hexagon
* More than 150 components = large hexagon

You can customize the grouping of components in the [Visualization settings](/use/stackstate-ui/views/visualization_settings.md).

## Run state

Some components in StackState will report a **Run state**. This is different to the [health state](/use/health-state/about-health-state.md), for example, StackState will report a run state for components on AWS EC2 instances. The run state indicates the component’s operational state, this can be `DEPLOYING`, `DEPLOYED`, `STARTING`, `STARTED`, `STOPPING` or `STOPPED`. For every change in run state, a `Run state changed` event is generated. These are visible in the Events Perspective and can help to correlate changes in deployment state with problems in an environment.

The run state of a component is not used to calculate the component's health state.