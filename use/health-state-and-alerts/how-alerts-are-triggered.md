---
description: How alerts are triggered in StackState
---

## Overview

When something goes wrong within your IT environment, StackState can alert you or your team with a message in the form of an email, private message, mobile ping or incident report. Additionally, StackState can trigger automation to take corrective measures.

## Events that trigger alerts

In StackState, telemetry flows through topology components as either metric or event streams. These telemetry streams are used by [health checks](/use/health-state-and-alerts/create-a-health-check.md) to determine the health state of each component. 

For every change in health state, an event is generated. These events can be linked with event handlers to [send out an alert](/use/health-state-and-alerts/add-an-alert.md) or to trigger some type of automation.

- **View state change event**<br />Generated only when the health state of a significant number of components in a view changes. These events are not visible in the event stream or Events Perspective, but can be used for alerting.
- **Health state change event**<br />Generated when the health state of a component changes.
- **Propagated health state change event**<br />Generated whenever the health state of one of a component’s dependencies changes. These events are not visible in the event stream or Events Perspective, but can be used for alerting.

![Health state change events in the Events Perspective](/.gitbook/assets/event-perspective.png)

## How an alert is triggered

The flow of events that lead to an alert follow this path:

1. A health check changes health state, for example it becomes `critical`.
2. The health state of the associated component changes
    - An event is generated and shown in the event stream on the right and in the Events Perspective.
3. The health state propagates to other components, updating their propagated health state. 
    - An event is generated for all affected components. These events are not visible in the event stream, but can be used for alerting.
4. A view that contains these components may also change health state based on these changes. 
    - A `view state change` event to be created. These events are not shown in the event stream.
5. Event handlers associated with the view will send the configured alerts or trigger the configured actions.

## See also

- [Create a health check](/use/health-state-and-alerts/create-a-health-check.md)
- [Configure the view health state](/use/health-state-and-alerts/configure-view-health.md)
- [Checks and streams](/configure/telemetry/checks_and_streams.md)
- [Add an alert](/use/health-state-and-alerts/add-an-alert.md)