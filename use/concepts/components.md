---
description: StackState Self-hosted v5.1.x 
---

# Components

## Overview

A component is anything that has a run-time state and some relation with other components. Some component examples are a load balancer, a database server, a network switch, or a business service. It is possible to define custom components, and they can be anything - the granularity and range can be defined according to the needs. Each component is of a specific type. Types can be configured.

A component consists of:

1. The name of the component.
2. An icon in the middle that represents either the component itself or the component type.
3. The component color represents the component's [own health state](/use/concepts/health-state.md#element-own-health-state).
4. An outer color indicates an unhealthy [propagated health state](/use/concepts/health-state.md#propagated-health-state) (`DEVIATING` or `CRITICAL`). The propagated health state is calculated based on the health state of components or relations that the component depends upon.

![](/.gitbook/assets/v51_topology_elements.png)

## Detailed component information

When a component is selected by clicking on it, detailed information about the component is shown in the right panel details tab - **Component details**. This includes:

* **Properties** - metadata, such as the component name, type and any labels. Click SHOW ALL PROPERTIES to open a pop-up with all details of the component, including the YAML definition.
* **Relations** - the number of other components that the component is connected to, note that this will also include any connections the component has with components that sit outside the current view. Expand to see details of each [relation](/use/concepts/relations.md).
* **Actions** - the available [actions](/use/stackstate-ui/perspectives/topology-perspective.md#actions) for the component.
* **Health** - reports the component [health state](/use/concepts/health-state.md) as calculated by StackState. Expand to see all [health checks](/use/checks-and-monitors/checks.md) and [monitors](/use/checks-and-monitors/monitors.md) attached to the component.
* **Propagated health** - reports the [propagated health state](/use/concepts/health-state.md#propagated-health-state). This is derived from the health state of the components and relations that the component depends upon.
* **Run state** - the [run state](/use/concepts/components.md#run-state) of the component (when available).
* **Problems** - lists all [problems](/use/problem-analysis/about-problems.md) that involve the selected component. 
* **Events** - [events](/use/concepts/events.md) related to the selected component.
* **Telemetry** - [telemetry streams](/use/metrics-and-events/telemetry_streams.md) linked to the component.

![Component details](/.gitbook/assets/v51_component_with_details.png)

## Grouping

Components of the same type and/or state can optionally be grouped together into a single element. Grouped components are represented by a circle in the topology visualization. The component group will be named `<COMPONENT_TYPE> group`. For example a group of components with type `pod` will be named `pod group`.

The size of the component group's circle in the topology visualization represents the number of components in the group:

* Less than 100 components = small circle
* 100 to 150 components = medium circle
* More than 150 components = large circle

The way in which components are grouped can be customized in the [view visualization settings](/use/stackstate-ui/views/visualization_settings.md#components-grouping).

## See also

* [Topology perspective](/use/stackstate-ui/perspectives/topology-perspective.md)
* [Relations](/use/concepts/relations.md)
* [View visualization settings](/use/stackstate-ui/views/visualization_settings.md)