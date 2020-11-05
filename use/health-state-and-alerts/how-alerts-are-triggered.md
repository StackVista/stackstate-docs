---
description: How alerts are triggered in StackState
---

## Overview

When something goes wrong within your IT environment, StackState can alert you or your team with a message in the form of an email, private message, mobile ping or incident report. Additionally, StackState can trigger automation to take corrective measures.

## Events that trigger alerts

In StackState, telemetry flows through topology components as either metric or event streams. These telemetry streams are used by [health checks](/use/health-state-and-alerts/create-a-health-check.md) to determine the health state of each component. 

For every change in health state, an event is generated. These events can be linked with event handlers to [send out an alert](/use/health-state-and-alerts/add-an-alert.md) or to trigger some type of automation.

- **View health state change event**<br />Generated only when the health state of a significant number of components in a view changes.
- **Own health state change event**<br />Generated when the health state of a component changes.
- **Propagated health state change event**<br />Generated whenever the health state of one of a component’s dependencies changes.

![Health state change events in the Events Perspective](/.gitbook/assets/event-perspective.png)

The entire flow of events that lead to an alert follow this path:

* A check changes health state \(e.g. becomes `critical`\).
* This causes the component to change state for which an event is shown in the event stream pane \(in a view click on the bell icon on the far right\).
* The health state propagates to other components that causes their propagated health state to change based on the propagation function of each component. This triggers an event for all affected components. These events are not visible in the event stream, but can be used for alerting.
* A view that contains these components can also change health state based on these changes. This triggers a `view state change` event to be created. These events are not shown in the event stream.
* Events that are triggered by components contained in a view or by the view changing state itself can trigger event handlers.
* Event handlers are configured on views and can send alerts or trigger some kind of automation.

## See also

- [Create a health check](/use/health-state-and-alerts/create-a-health-check.md)
- [Configure the view health state](/use/health-state-and-alerts/configure-view-health.md)
- [Checks and streams](/configure/telemetry/checks_and_streams.md)
- [Add an alert](/use/health-state-and-alerts/add-an-alert.md)