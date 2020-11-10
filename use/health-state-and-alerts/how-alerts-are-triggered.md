---
description: Understand how alerts are triggered in StackState.
---

## Overview

When something goes wrong within your IT environment, StackState can alert you or your team with a message in the form of an email, private message, mobile ping or incident report. Additionally, StackState can trigger automation to take corrective measures.

## How an alert is triggered

Alerts are triggered in response to health state changes on an element. The health state is derived from metrics and events data in telemetry streams. The process from a change in an element's health state to an alert being triggered is described below.

1. Telemetry streams attached to the element provide related metrics and events data.
2. Health checks attached to the element listen to the available telemetry streams and report a health state based on the configured parameters.
3. When the reported health state of an element changes, a chain of [state change events](#state-change-events) are generated:
    - `HealthStateChangedEvent` for the element itself.
    - `PropagatedStateChangedEvent` for all elements that depend on the element.
    - `ViewStateChangedEvent` a single event for the entire view. Note that this event type will only be generated if the configured [view state change criteria](/use/health-state-and-alerts/configure-view-health.md) are met.
4. Event handlers associated with the view listen to the generated state change events and trigger the [configured alerts and actions](/use/health-state-and-alerts/add-an-alert.md).

## State change events

In StackState, metrics and events flow through topology elements in telemetry streams. These telemetry streams are used by [health checks](/use/health-state-and-alerts/create-a-health-check.md) to determine the health state of each element. For every change in health state, a state change event is generated. Event handlers can be added to a view to listen to the generated state change events and  [take action](/use/health-state-and-alerts/add-an-alert.md) if a configured threshold is passed.

The event types generated when an element state changes are described in the table below.

| Event | Event type | Description |
|:---|:---|:---|
| State change of an element | `HealthStateChangedEvent` | Generated when the health state of an element changes. |
| Propagated state change of an element | `PropagatedStateChangedEvent` | Generated whenever the health state of one of an elementt’s dependencies changes. These events are not visible in the StackState UI, but can be used for alerting. |
| State change of entire view | `ViewStateChangedEvent` | Generated only when the health state of a significant number of components in a view changes. These events are not visible in the StackState UI, but can be used for alerting. |

![Health state change events in the Events Perspective](/.gitbook/assets/event-perspective.png)

## See also

- [Create a health check](/use/health-state-and-alerts/create-a-health-check.md)
- [Configure the view health state](/use/health-state-and-alerts/configure-view-health.md)
- [Checks and streams](/configure/telemetry/checks_and_streams.md)
- [Add an alert](/use/health-state-and-alerts/add-an-alert.md)