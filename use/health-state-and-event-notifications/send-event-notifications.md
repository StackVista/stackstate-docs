---
description: >-
  Use event handlers to send an event notification to an outside system when a component or view health state changes.
---

# Send event notifications

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

When something goes wrong within your IT environment, StackState can send event notifications to alert you or your team mates. A message can be sent in the form of an email, Slack message, mobile ping or an HTTP POST request to any URL. Event notifications can contain detailed content on the trigger event and possible root cause. This guide will help you set this up.

![StackState event notification in Slack with possible root cause information](/.gitbook/assets/slack_alert.png)

## How an event notification is triggered

Event notifications are triggered in response to health state changes on an element or view. The health state of an element is derived from metrics and events data in the telemetry streams assigned to it, whereas the health state of a view is calculated based on the combined health state of elements within it. Propagated state changes can also be used to trigger event notifications, however, this can result in a lot of noise.

The process to trigger an event is as follows:

1. [Telemetry streams](add-telemetry-to-element.md) attached to an element provide metrics and events data.
2. A [health check](add-a-health-check.md) attached to the element listens to the available telemetry streams and reports a health state based on its configured parameters.
3. When the reported health state of an element changes, a chain of [state change events](/use/health-state-and-event-notifications/send-event-notifications.md#state-change-events) are generated:
   * `HealthStateChangedEvent` for the element itself.
   * `PropagatedStateChangedEvent` for all other elements that have been impacted by the element's state change.
   * `ViewStateChangedEvent` for each view containing the element. Note that this event type is only generated when a view's [view state configuration criteria](/use/health-state-and-event-notifications/configure-view-health.md) are met.
4. Event handlers associated with each view listen to the generated state change events and trigger the configured event notifications and actions.

## Add an event handler to a view

Event handlers respond to health state change events and run event handler functions to generate event notifications and trigger automated actions. You can add an event handler to a view from the StackState UI.

![Add an event handler](/.gitbook/assets/v42_event_handlers_tab.png)

1. Select **Events Settings** on the left.
2. Click **ADD NEW EVENT HANDLER**.
3. Select the trigger event and event handler to run: 
   * **On event** - the type of [state change events](/use/health-state-and-event-notifications/send-event-notifications.md#state-change-events) that should trigger the event notification or automated action.
   * **Run event handler** - the event handler function that will run whenever the selected state change event type is generated. StackState ships with event handler functions that can send an event notification via email, Slack or SMS, or POST to an HTTP webhook. You can also create your own custom functions. [Read more about event handler functions](/configure/topology/event-handlers.md#event-handler-functions).
4. Enter the required details, these will vary according to the event handler function you have selected.
5. Click **SAVE**.

## State change events

In StackState, metrics and events data flow through topology elements in telemetry streams. These telemetry streams are used by [health checks](/use/health-state-and-event-notifications/add-a-health-check.md) to determine the health state of the element. For every change in health state, at least one state change event is generated. Event handlers can be added to a view to listen to state change events generated within the view and trigger an event notification or action when a configured threshold is passed.

The event types generated when an element state changes are described in the table below.

| Event type | Description |
| :--- | :--- |
| `HealthStateChangedEvent` | **State change of an element**<br />Generated when the health state of an element changes. These events will be listed in the StackState UI [Events Perspective](/use/views/events_perspective.md). |
| `PropagatedStateChangedEvent` | **Propagated state change of an element**<br />Generated whenever the health state of one of an element’s dependencies changes. These events are not visible in the StackState UI, but can be used for trigger an event notification. |
| `ViewStateChangedEvent` | **State change of entire view**<br />Generated only when the health state of a significant number of elements in a view changes. These events are not visible in the StackState UI, but can be used to trigger event notifications.<br />**Note** that there may be a slight delay between the generation of a `HealthStateChangedEvent` for an element and the resulting `ViewStateChangedEvent`. This can cause the reported state of a view to differ from the actual state of elements within it. |

You can [add an event handler to a view](#add-an-event-handler-to-a-view) to trigger event notifications or automated actions on specific state change events.

## See also

* [Add a health check](/use/health-state-and-event-notifications/add-a-health-check.md)
* [Configure an SMTP server to send email event notifications](/configure/topology/configure-email-event-notifications.md)
* [More about event handlers](/configure/topology/event-handlers.md)
* [Create a custom event handler function](/configure/topology/event-handlers.md#create-a-custom-event-handler-function)

