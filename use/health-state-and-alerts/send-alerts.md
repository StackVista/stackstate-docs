---
description: Use event handlers to trigger an alert or automated action on component or view state changes.
---

# Send alerts

## Overview

When something goes wrong within your IT environment StackState can alert you or your team mates with a message in the form of an email, Slack message, mobile ping or an HTTP POST request to any URL. Alerts can contain detailed content on the trigger event and possible root cause. This guide will help you set this up.

![StackState alert in Slack](./gitbook/assets/v421_slack_alert.png)

## How an alert is triggered

Alerts are triggered in response to health state changes on an element or view. The health state of an element is derived from metrics and events data in the telemetry streams assigned to it, whereas the health state of a view is calculated based on the combined health state of elements within it. Propagated state changes can also be used to trigger alerts, however, this can result in a lot of noise. 

The process to trigger an event is as follows:

1. [Telemetry streams](/use/health-state-and-alerts/add-telemetry-to-element.md) attached to an element provide metrics and events data.
2. A [health check](/use/health-state-and-alerts/add-a-health-check.md) attached to the element listens to the available telemetry streams and reports a health state based on its configured parameters.
3. When the reported health state of an element changes, a chain of [state change events](#state-change-events) are generated:
    - `HealthStateChangedEvent` for the element itself.
    - `PropagatedStateChangedEvent` for all other elements that have been impacted by the element's state change.
    - `ViewStateChangedEvent` for each view containing the element. Note that this event type is only generated when a view's [view state configuration criteria](/use/health-state-and-alerts/configure-view-health.md) are met.
4. Event handlers associated with each view listen to the generated state change events and [trigger the configured alerts and actions](#add-an-event-handler-to-a-view).

## Add an event handler to a view

Event handlers respond to health state change events and run event handler functions to generate alerts and trigger automated actions. You can add an event handler to a view from the StackState UI. 

![Add an event handler](/.gitbook/assets/v42_event_handlers_tab.png)

1. Select **Events Settings** on the left.
2. Click **ADD NEW EVENT HANDLER**.
3. Select the trigger event and event handler to run: 
    - **On event** - the type of [state change events](#state-change-events) that should trigger the alert or automated action.
    - **Run event handler** - the event handler function that will run whenever the selected state change event type is generated. StackState ships with event handler functions that can send an alert via email, Slack or SMS, or POST to an HTTP webhook. You can also create your own custom functions. [Read more about event handler functions](/configure/topology/event-handlers.md#event-handler-functions).
4. Enter the required details, these will vary according to the event handler function you have selected.
5. Click **SAVE**.

## State change events

In StackState, metrics and events data flow through topology elements in telemetry streams. These telemetry streams are used by [health checks](/use/health-state-and-alerts/add-a-health-check.md) to determine the health state of the element. For every change in health state, at least one state change event is generated. Event handlers can be added to a view to listen to state change events generated within the view and trigger an alert or action when a configured threshold is passed.

The event types generated when an element state changes are described in the table below.

| Event type | Description |
|:---|:---|
| `HealthStateChangedEvent` | **State change of an element**<br />Generated when the health state of an element changes. These events will be listed in the StackState UI [Events Perspective](/use/views/events_perspective.md). |
| `PropagatedStateChangedEvent` | **Propagated state change of an element**<br />Generated whenever the health state of one of an element’s dependencies changes. These events are not visible in the StackState UI, but can be used for alerting. |
| `ViewStateChangedEvent` | **State change of entire view**<br />Generated only when the health state of a significant number of elements in a view changes. These events are not visible in the StackState UI, but can be used for alerting. |

You can [add an event handler to a view](#add-an-event-handler-to-a-view) to trigger alerts or automated actions on specific state change events.

## See also

- [Add a health check](/use/health-state-and-alerts/add-a-health-check.md)
- [Configure an SMTP server to send email alerts](/configure/topology/configure-email-alerts.md)
- [Event handlers](/configure/topology/event-handlers.md)
- [Create a custom event handler function](/configure/topology/event-handlers.md#create-a-custom-event-handler-function)
- [Set up email alerting](/configure/topology/configure-email-alerts.md)

