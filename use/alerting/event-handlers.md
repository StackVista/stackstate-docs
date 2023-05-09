---
description: StackState Kubernetes Troubleshooting
---

# Alerts

## Overview

When something goes wrong within your IT environment, StackState can use event handlers to send alerts to notify you or your teammates. A message can be sent in the form of an email, Slack message, mobile ping or an HTTP POST request to any URL. Alerts can contain detailed content on the trigger event and possible root cause. 

![StackState event notification in Slack with possible root cause information](../../.gitbook/assets/slack_alert.png)

## Event handlers

Event handlers added to a StackState view can send event notifications or trigger actions in response to health state change events. The event handler will listen to events generated within the view and run a configured event handler function when the configured [event type](#state-change-events) is generated.

You can check the configured event handlers for a view and add new event handlers from the StackState UI right panel **View summary** tab. For details, see [manage Event Handlers](/use/events/manage-event-handlers.md).

![Event handlers](/.gitbook/assets/v51_configured_event_handlers.png)

### State change events

Metrics and events data flow through StackState topology elements in telemetry streams. These telemetry streams are used by [health checks](../checks-and-monitors/add-a-health-check.md) to determine the health state of an element. For every change in health state, at least one state change event is generated. Event notifications or actions can be triggered whenever state changed events are generated for a component in the view.

The event types generated when an element state changes are described below.

* **State change of an element** - a `HealthStateChangedEvent` event is generated when the health state of an element changes. These events will be listed in the StackState UI [Events Perspective](../stackstate-ui/perspectives/events_perspective.md).
* **Propagated state change of an element** - a `PropagatedStateChangedEvent` event is generated whenever the health state of one of an element’s dependencies changes. These events aren't visible in the StackState UI, but can be used to trigger an event notification.
* **State change of entire view** - a `ViewStateChangedEvent` event is generated only when the health state of a significant number of elements in a view changes. These events aren't visible in the StackState UI, but can be used to trigger event notifications. 

{% hint style="info" %}
Note that there may be a slight delay between the generation of a `HealthStateChangedEvent` for an element and the resulting `ViewStateChangedEvent`. This can cause the reported state of a view to differ from the actual state of elements within it.
{% endhint %}

## See also

* [Out-of-the-box monitors for Kubernetes](/use/alerting/kubernetes-monitors.md)




# Manage event handlers

## Overview

Event handlers attached to a StackState view listen to events that are generated in relation to components in the view. Event notifications can then be sent or actions can be triggered in response to health state change events or problem events.

## Configured event handlers

All event handlers configured for the view are listed in the StackState UI right panel **View summary** tab under **Event handlers**. You can add, edit and remove event handlers from here. Expand an event handler to see its configured settings. 

The badge on the right next to the **Event handlers** section heading shows the number of event handlers configured for the view. 

![Event handlers](/.gitbook/assets/v51_configured_event_handlers.png)

## Add event handler

You can add an event handler to a view from the StackState UI right panel **View summary** tab. 

{% hint style="info" %}
Event handlers can only be added to a saved [view](/use/stackstate-ui/views/about_views.md). It isn't possible to add event handlers to [subviews](/use/stackstate-ui/views/about_views.md#subview) or while in [explore mode](/use/stackstate-ui/explore_mode.md).
{% endhint %}

![Add event handler](/.gitbook/assets/v51_add_event_handler.png)

1. Open a [view](/use/stackstate-ui/views/about_views.md).
2. Select the **View summary** tab in the right panel.
3. Expand the **Event handlers** section. All currently configured event handlers are listed.
4. To add a new event handler, click **ADD NEW EVENT HANDLER**. The **Add Event Handler** popup opens.
5. Give the event handler a **Name**. 
6. You can optionally add a **Description**. This will be displayed in the tooltip whenever a user hovers the mouse pointer over the event handler name in the right panel Event handlers list.
7. Select the trigger event and the event handler to run:
   * **On event** - the [event types](/use/events/event-notifications.md#event-types-for-notifications) that should trigger the event notification or automated action. Note that only events related to components are captured in event handlers, relation-related events will be ignored.
   * **Run event handler** - the [event handler function](#event-handler-functions) that will run whenever the selected event type is generated.
8. Enter the required details, these will vary according to the event handler function you have selected.
9. Click **SAVE**.

## Event handler functions

Event handlers listen to events generated within a view. When the configured event type is generated, an event handler function is run to send an event notification or trigger an action in a system outside of StackState. For example, an event handler function could send a message to a Slack channel or make a POST to a webhook URL. A number of default event handler functions are included out of the box with StackState, these are described below.

{% hint style="success" "self-hosted info" %}
* You can [create your own custom event handler functions](/develop/developer-guides/custom-functions/event-handler-functions.md).
* A full list of the event handler functions available in your StackState instance can be found in the StackState UI. Go to **Settings** &gt; **Functions** &gt; **Event Handler Functions**.
{% endhint %}

### Slack

The Slack event handler function sends a Slack message with detailed information about the trigger event, including the possible root cause, to the configured Slack webhook URL. See [how to create a Slack Webhook \(slack.com\)](https://api.slack.com/messaging/webhooks). 

Can be triggered by **Health state change events** and **Problem events**.

{% hint style="info" %}
Requires the [Slack StackPack](/stackpacks/integrations/slack.md) to be installed on your StackState instance.
{% endhint %}

### HTTP webhook POST

The HTTP webhook POST event handler function sends a POST request to the specified URL. 

Can be triggered by **Health state change events** only.

### SMS

The SMS event handler function sends an SMS with details of a health state change event using MessageBird.

Can be triggered by **Health state change events** only.

### Email

{% hint style="success" "self-hosted info" %}
The email event handler function will send details of a health state change event using a [configured SMTP server](/configure/topology/configure-email-event-notifications.md).

Can be triggered by **Health state change events** only.
{% endhint %}

### Custom functions

{% hint style="success" "self-hosted info" %}
You can [create your own custom event handler functions](/develop/developer-guides/custom-functions/event-handler-functions.md).
{% endhint %}

## See also

* [Event types for event notifications](/use/events/event-notifications.md#event-types-for-notifications)
* [Add a health check](/use/checks-and-monitors/add-a-health-check.md)
* [Configure an SMTP server to send email event notifications](/configure/topology/configure-email-event-notifications.md "StackState Self-Hosted only")
* [Create a custom event handler function](/develop/developer-guides/custom-functions/event-handler-functions.md "StackState Self-Hosted only")
* [Create a Slack Webhook \(slack.com\)](https://api.slack.com/messaging/webhooks)

