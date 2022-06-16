---
description: StackState Self-hosted v5.0.x
---

# Components

## Overview

A component is anything that has a run-time state and some relation with other components. Some component examples are a load balancer, a database server, a network switch, or a business service. It is possible to define custom components, and they can be anything - the granularity and range can be defined according to the needs. Each component is of a specific type. Types can be configured.

A component consists of:

1. The name of the component.
2. An icon in the middle that represents either the component itself or the component type.
3. The component color represents the component's [own health state](/use/health-state/about-health-state.md#element-own-health-state).
4. An outer color indicates an unhealthy [propagated health state](/use/health-state/about-health-state.md#propagated-health-state) (`DEVIATING` or `CRITICAL`). The propagated health state is calculated based on the health state of components or relations that the component depends upon.

![](/.gitbook/assets/021_topology_elements.png)

## Detailed component information

When a component is selected by clicking on it, detailed information about the component is shown in the right panel **Selection details** tab. This includes:

* Metadata, such as the component name, type and any labels
* [Run state](/use/concepts/components.md#run-state)
* [Health checks](/use/health-state/add-a-health-check.md)
* [Telemetry streams](/use/metrics-and-events/telemetry_streams.md)

Click SHOW ALL PROPERTIES to open a pop-up with all details of the component, including the YAML definition.

![Detailed component information](/.gitbook/assets/v50_component_with_details.png)

## Component groups

Components of the same type and/or state can optionally be grouped together into a single element. Grouped components are represented by a circle in the topology visualization. The component group will be named `... group`. For example a group of components with type `pod` will be named `pod group`.

The size of the component group's circle in the topology visualization represents the number of components in the group:

* Less than 100 components = small circle
* 100 to 150 components = medium circle
* More than 150 components = large circle

You can customize the grouping of components in the [Visualization settings](/use/stackstate-ui/views/visualization_settings.md).

## Run state

Some components in StackState will report a **Run state**, for example, AWS EC2 instances. This is different to the [health state](/use/health-state/about-health-state.md) and indicates the component’s operational state. The run state can be `DEPLOYING`, `DEPLOYED`, `STARTING`, `STARTED`, `STOPPING`, `STOPPED` or `UNKNOWN`. It is not used in the calculation of a component's health state.

For every change in run state, a `Run state changed` event is generated. These events are visible in the [Events Perspective](/use/stackstate-ui/perspectives/events_perspective.md) and can help to correlate changes in the deployment state of components with problems in an environment.