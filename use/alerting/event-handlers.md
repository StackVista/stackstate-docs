---
description: StackState Kubernetes Troubleshooting
---

## Overview

When something goes wrong within your IT environment, StackState can use event handlers to notify you or your teammates. A message can be sent in the form of an email, Slack message, mobile ping or an HTTP POST request to any URL. Alerts can contain detailed content on the trigger event and possible root cause. 

![StackState event notification in Slack with possible root cause information](../../.gitbook/assets/slack_alert.png)

## Event handlers

Event handlers added to a [custom view](../views/k8s-custom-views.md) can send event notifications or trigger actions in response to [health state change events](#state-change-events). The event handler will listen to events generated within the view and run a configured event handler function when the configured event type is generated.

You can check the configured event handlers for a [custom view](../views/k8s-custom-views.md) and add new event handlers from the StackState UI right panel **Alerts** tab. For details, see [manage event handlers](#manage-event-handlers).

![Event handlers](/.gitbook/assets/v51_configured_event_handlers.png)

### State change events

Metrics and events data flow through StackState topology elements in telemetry streams. These telemetry streams are used by health checks to determine the health state of an element. For every change in health state, at least one state change event is generated. Event notifications or actions can be triggered whenever state changed events are generated for a component in the view.

The event types generated when an element state changes are described below.

* **State change of an element** - a `HealthStateChangedEvent` event is generated when the health state of an element changes. These events will be listed in the StackState UI [Events Perspective](../views/k8s-events-perspective.md).
* **Propagated state change of an element** - a `PropagatedStateChangedEvent` event is generated whenever the health state of one of an element’s dependencies changes. These events aren't visible in the StackState UI, but can be used to trigger an event notification.
* **State change of entire view** - a `ViewStateChangedEvent` event is generated only when the health state of a significant number of elements in a view changes. These events aren't visible in the StackState UI, but can be used to trigger event notifications. 

{% hint style="info" %}
Note that there may be a slight delay between the generation of a `HealthStateChangedEvent` for an element and the resulting `ViewStateChangedEvent`. This can cause the reported state of a view to differ from the actual state of elements within it.
{% endhint %}

## Manage event handlers

Event handlers attached to a [custom view](../views/k8s-custom-views.md) listen to events that are generated in relation to components in the view. Event notifications can then be sent or actions can be triggered in response to health state change events or problem events.

### Configured event handlers

All event handlers configured for the view are listed in the StackState UI right panel **Alerts** tab. You can add, edit and remove event handlers from here. Expand an event handler to see its configured settings. 

![Event handlers](/.gitbook/assets/v51_configured_event_handlers.png)

### Add event handler

You can add an event handler to a view from the StackState UI right panel **Alerts** tab. 

{% hint style="info" %}
Event handlers can only be added to a saved [custom view](../views/k8s-custom-views.md). It isn't possible to add event handlers to other view types (e.g. [kubernetes views](../views/k8s-views.md), [components views](../views/k8s-component-views.md) or [explore views](../views/k8s-explore-views.md)).
{% endhint %}

![Add event handler](/.gitbook/assets/v51_add_event_handler.png)

1. Open a saved [custom view](../views/k8s-custom-views.md).
2. Select the **Alerts** tab in the right panel. If you have any configured event handlers, they will be listed here.
3. To add a new event handler, click **ADD NEW EVENT HANDLER**. The **Add Event Handler** popup opens.
4. Give the event handler a **Name**. 
5. You can optionally add a **Description**. This will be displayed in the tooltip whenever a user hovers the mouse pointer over the event handler name in the right panel Event handlers list.
6. Select the trigger event and the event handler to run:
   * **On event** - the [event type](#state-change-events) that should trigger the event notification or automated action. Note that only events related to components are captured in event handlers, relation-related events will be ignored.
   * **Run event handler** - the event handler function that will run whenever the selected event type is generated.
7. Enter the required details, these will vary according to the event handler function you have selected.
8. Click **SAVE**.

### Event handler functions

Event handlers listen to events generated within a view. When the configured event type is generated, an event handler function is run to send an event notification or trigger an action in a system outside of StackState. For example, an event handler function could send a message to a Slack channel or make a POST to a webhook URL. A number of default event handler functions are included out of the box with StackState, these are described below.

#### Slack

The Slack event handler function sends a Slack message with detailed information about the trigger event, including the possible root cause, to the configured Slack webhook URL. See [how to create a Slack Webhook \(slack.com\)](https://api.slack.com/messaging/webhooks). 

{% hint style="info" %}
Requires the [Slack StackPack](/stackpacks/integrations/slack.md) to be installed on your StackState instance.
{% endhint %}

#### OpsGenie

The OpsGenie event handler creates an alert in OpsGenie with detailed information on the triggered event.

#### Email

The email event handler function will send details of a health state change event using a [configured SMTP server](/configure/topology/configure-email-event-notifications.md).

#### HTTP webhook POST

The HTTP webhook POST event handler function sends a POST request to the specified URL. 

#### SMS

The SMS event handler function sends an SMS with details of a health state change event using MessageBird.
