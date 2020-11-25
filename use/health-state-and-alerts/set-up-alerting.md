---
description: Use event handlers to trigger an alert or automated action on component or view state changes.
---

# Set up alerting

## Overview

When something goes wrong within your IT environment StackState can alert you or your team mates with a message in the form of an email, private message, mobile ping or incident report. Additionally, StackState can trigger automation to take corrective measures. This guide will help you set this up.

## How an alert is triggered

Alerts are triggered in response to health state changes on an element or view. The health state of an element is derived from metrics and events data in the telemetry streams assigned to it, whereas the health state of a view is calculated based on the combined health state of elements within it. Propagated state changes can also be used to trigger alerts, however, this can result in a lot of noise. 

The process to trigger an event is as follows:

1. [Telemetry streams](/use/health-state-and-alerts/add-telemetry-to-element.md) attached to an element provide metrics and events data.
2. A [health check](/use/health-state-and-alerts/add-a-health-check.md) attached to the element listens to the available telemetry streams and reports a health state based on its configured parameters.
3. When the reported health state of an element changes, a chain of [state change events](#state-change-events) are generated:
    - `HealthStateChangedEvent` for the element itself.
    - `PropagatedStateChangedEvent` for all elements that depend on the element.
    - `ViewStateChangedEvent` for each view containing the element. Note that this event type is only generated when a view's [view state configuration criteria](/use/health-state-and-alerts/configure-view-health.md) are met.
4. Event handlers associated with each view listen to the generated state change events and [trigger the configured alerts and actions](#add-an-event-handler-to-a-view).

## Add an event handler to a view

Event handlers respond to health state change events and run event handler functions to generate alerts and trigger automated actions. You can add an event handler to a view from the StackState UI. 

![Add an event handler](/.gitbook/assets/event_handlers_tab.png)

1. Select **Events Settings** on the left.
2. Click **ADD EVENT HANDLER**.
3. Select the trigger event and event handler: 
    - **On event** - the type of [state change events](#state-change-events) that should trigger an alert or automated action.
    - **Run event handler** - the [event handler function](/configure/topology/event-handlers.md#event-handler-functions) that should run whenever the selected state change event type is generated. StackState ships with event handler functions that can send a message via email, Slack or SMS, or POST to an HTTP webhook. You can also create your own.
4. Enter the required details, these will vary according to the event handler function you have selected.
5. Click **SAVE**.

## State change events

In StackState, metrics and events flow through topology elements in telemetry streams. These telemetry streams are used by [health checks](/use/health-state-and-alerts/add-a-health-check.md) to determine the health state of the element. For every change in health state, at least one state change event is generated. Event handlers can be added to a view to listen to the generated state change events within the view and trigger an alert or action when a configured threshold is passed.

The event types generated when an element state changes are described in the table below.

| Event type | Description |
|:---|:---|
| `HealthStateChangedEvent` | **State change of an element**<br />Generated when the health state of an element changes. |
| `PropagatedStateChangedEvent` | **Propagated state change of an element**<br />Generated whenever the health state of one of an element’s dependencies changes. These events are not visible in the StackState UI, but can be used for alerting. |
| `ViewStateChangedEvent` | **State change of entire view**<br />Generated only when the health state of a significant number of elements in a view changes. These events are not visible in the StackState UI, but can be used for alerting. |

You can [add an event handler to a view](#add-an-event-handler-to-a-view) to trigger alerts or automated actions on specific state change events.

## See also

- [Add a health check](/use/health-state-and-alerts/add-a-health-check.md)
- [Configure an SMTP server to send email alerts](/configure/topology/configure-email-alerts.md)
- [Event handlers](/configure/topology/event-handlers.md)
- [Create a custom event handler function](/configure/topology/event-handlers.md#create-a-custom-event-handler-function)
- [Set up email alerting](/configure/topology/configure-email-alerts.md)

