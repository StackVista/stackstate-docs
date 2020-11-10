---
description: Understand how alerts are triggered in StackState.
---

## Overview

When something goes wrong within your IT environment, StackState can alert you or your team with a message in the form of an email, private message, mobile ping or incident report. Additionally, StackState can trigger automation to take corrective measures.

## Alerts are triggered by events

In StackState, telemetry flows through topology components as either metric or event streams. These telemetry streams are used by [health checks](/use/health-state-and-alerts/create-a-health-check.md) to determine the health state of each component. For every change in health state, an event is generated. These events can be linked with event handlers on a view to [send out an alert](/use/health-state-and-alerts/add-an-alert.md) or to trigger some type of automation.

- **View state change event**<br />Generated only when the health state of a significant number of components in a view changes. These events are not visible in the event stream or Events Perspective, but can be used for alerting.
- **Health state change event**<br />Generated when the health state of a component changes.
- **Propagated health state change event**<br />Generated whenever the health state of one of a component’s dependencies changes. These events are not visible in the event stream or Events Perspective, but can be used for alerting.

![Health state change events in the Events Perspective](/.gitbook/assets/event-perspective.png)

## How an alert is triggered

The flow of events that lead to an alert follows this path:

| thing | Description |
|:---|:---|
| Telemetry streams | Telemetry streams attached to an element provide metrics and events.  |
| Health checks | Health checks attached to an element listen to available telemetry streams and report a health state based on the configured parameters. |
| State change events | When the reported health state of an element changes, a chain of state change events are generated:<br />
  - `HealthStateChangedEvent` for the element.<br />
  - `PropagatedStateChangedEvent` for all other elements that depend on the element.<br />
  - `ViewStateChangedEvent` for the entire view. Only generated when the configured criteria are met.  |
| Event handlers | Event handlers associated with the view listen to the generated state change eventsand trigger the [configured alerts and actions](/use/health-state-and-alerts/add-an-alert.md). | 


1. [Health checks](/use/health-state-and-alerts/create-a-health-check.md) attached to elements listen to the associated telemetry streams.
2. The element's health is reported by the health check based on the configured criteria. When a change in the health state is reported, state change events are generated:
    - The actual health state of the element changes. A `HealthStateChangedEvent` event is generated for the element. The event is visible in the StackState UI in the event stream on the right of the Topology Perspective screen and in the Events Perspective.
    - The health state propagates to other elements, updating their propagated health state. A `PropagatedStateChangedEvent` event is generated for all affected elements. These events are not visible in the StackState UI, but can be used for alerting.
    - A view that contains these components may also change health state based on these changes and the [configured view health state](/use/health-state-and-alerts/configure-view-health.md). A `ViewStateChangedEvent` event is generated. These events are not shown in the StackState UI, but can be used for alerting.
5. Event handlers associated with the view listen to the generated state change events and trigger any [configured alerts and actions](/use/health-state-and-alerts/add-an-alert.md).

## See also

- [Create a health check](/use/health-state-and-alerts/create-a-health-check.md)
- [Configure the view health state](/use/health-state-and-alerts/configure-view-health.md)
- [Checks and streams](/configure/telemetry/checks_and_streams.md)
- [Add an alert](/use/health-state-and-alerts/add-an-alert.md)