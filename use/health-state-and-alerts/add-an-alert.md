---
description: Use event handlers to trigger an alert or automated action on component or view state changes.
---

# Set up alerting

## Overview

StackState can be configured to send out alerts or trigger automated actions in response to changes in the health state. Event handlers assigned to a view will run when state change events are generated either by an element in the view or by the view itself. 

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
| Propagated state change of an element | `PropagatedStateChangedEvent` | Generated whenever the health state of one of an element’s dependencies changes. These events are not visible in the StackState UI, but can be used for alerting. |
| State change of entire view | `ViewStateChangedEvent` | Generated only when the health state of a significant number of elements in a view changes. These events are not visible in the StackState UI, but can be used for alerting. |

![Health state change events in the Events Perspective](/.gitbook/assets/event-perspective.png)

## Event handlers 

Event handlers are functions that run in response to an event. A number of event handlers are included out of the box, or you could create your own:

- **Email**: Send an email alert to a specified email address. Note that an [SMTP server must be configured](/configure/topology/configure-email-alerts.md) in StackState to send email alerts.
- **HTTP webhook POST**: Send an HTTP POST request to a specified URL.
- **Slack**: Send a notification to a specified Slack webhook URL.
- **SMS**: Send an SMS alert (MessageBird) to a specified phone number.

## Add an event handler to a view

You can add an event handler to a view from the StackState UI Events Perspective.

![Add an event handler](/.gitbook/assets/event_handlers_tab.png)

1. Go to the [Events Perspective](/use/views/events_perspective.md).
2. Select **Events Settings** on the left.
3. Click **ADD EVENT HANDLER**.
4. Select the type of [state change events](#state-change-events) that should trigger an alert or automated action:
5. Select the [event handler](#event-handlers) function that should run whenever the selected event type is generated.
6. Enter the required details, these will vary according to the event handler function you have selected.
7. Click **SAVE**.

## See also

- [Configure an SMTP server to send email alerts](/configure/topology/configure-email-alerts.md)
- [Events Perspective](/use/views/events_perspective.md)

