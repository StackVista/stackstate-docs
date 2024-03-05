---
description: StackState SaaS
---

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

**StackState Self-Hosted**

Extra information for the [StackState Self-Hosted product](https://docs.stackstate.com/):

    * You can create your own custom event handler functions.
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

**StackState Self-Hosted**

Extra information for the [StackState Self-Hosted product](https://docs.stackstate.com/):

    The email event handler function will send details of a health state change event using a configured SMTP server.

Can be triggered by **Health state change events** only.
{% endhint %}

### Custom functions

{% hint style="success" "self-hosted info" %}

**StackState Self-Hosted**

Extra information for the [StackState Self-Hosted product](https://docs.stackstate.com/):

    You can create your own custom event handler functions.
{% endhint %}

## See also

* [Event types for event notifications](/use/events/event-notifications.md#event-types-for-notifications)
* [Add a health check](/use/checks-and-monitors/add-a-health-check.md)
* [Create a Slack Webhook \(slack.com\)](https://api.slack.com/messaging/webhooks)
