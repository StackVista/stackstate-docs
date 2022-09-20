---
description: StackState Self-hosted v5.1.x 
---

# Manage event handlers

## Overview

Event handlers attached to a StackState view listen to generated StackState events. Event notifications can be sent or actions can be triggered in response to health state change events or problem events generated within the view.

## Configured event handlers

All event handlers currently configured for the view are displayed in the StackState UI right panel **View summary** tab under **Event handlers**. You can add, edit and remove event handlers from here. Expand an event handler to 

![Configured event handlers](/.gitbook/assets/v51_configured_event_handlers.png)

## Add event handler

You can add an event handler to a view from the StackState UI right panel **View summary** tab.

1. Select the **View summary** tab in the right panel.
2. Expand the **Event handlers** section. All currently configured event handlers are listed.
3. To add a new event handler, click **ADD NEW EVENT HANDLER**.
4. Give the event handler a **Name**. 
5. Select the trigger event and event handler to run:
   * **On event** - the [event types](/use/metrics-and-events/event-notifications.md#event-types-for-notifications) that should trigger the event notification or automated action.
   * **Run event handler** - the [event handler function](#event-handler-functions) that will run whenever the selected event type is generated.
6. Enter the required details, these will vary according to the event handler function you have selected.
7. Click **SAVE**.

## Event handler functions

Event handlers listen to events generated within a view. When the configured event type is generated, the event handler function is run to send an event notification or trigger an action in a system outside of StackState. For example, an event handler function could send an email or make a POST to a webhook URL. A number of default event handler functions are included out of the box with StackState.

{% hint style="success" "self-hosted info" %}
* You can [create your own custom event handler functions](/develop/developer-guides/custom-functions/event-handler-functions.md). 
* A full list of the event handler functions available in your StackState instance can be found in the StackState UI, go to **Settings** &gt; **Functions** &gt; **Event Handler Functions**
{% endhint %}

The event handler functions shipped with StackState are described below.

### Slack

{% hint style="info" %}
The slack event handler is available when the [Slack StackPack](/stackpacks/integrations/slack.md) is installed on your StackPack instance.
{% endhint %}

Sends a message with detailed content on the trigger event and possible root cause to the configured Slack webhook URL. See [how to create a Slack Webhook \(slack.com\)](https://api.slack.com/messaging/webhooks). 

Available for use with **Health state change events** and **Problem events**.

### HTTP webhook POST

Sends an HTTP webhook POST request to the specified URL. 

Available for use with **Health state change events**.

### SMS

Sends details of a health state change event using MessageBird.

Available for use with **Health state change events**.

### Email

{% hint style="success" "self-hosted info" %}

An email event handler is available that sends details of a health state change event using a [configured SMTP server](/configure/topology/configure-email-event-notifications.md).
{% endhint %}

## See also

* [Event types for event notifications](/use/metrics-and-events/event-notification.mds#event-types-for-notifications)
* [Add a health check](/use/checks-and-monitors/add-a-health-check.md)
* [Configure an SMTP server to send email event notifications](/configure/topology/configure-email-event-notifications.md "StackState Self-Hosted only")
* [Create a custom event handler function](/develop/developer-guides/custom-functions/event-handler-functions.md "StackState Self-Hosted only")
* [Create a Slack Webhook \(slack.com\)](https://api.slack.com/messaging/webhooks)
