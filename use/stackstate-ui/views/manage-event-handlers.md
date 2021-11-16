# Manage event handlers

## Overview

Event handlers attached to a StackState view listen to generated StackState events.  Event notifications can be sent or actions can be triggered in response to health state change events or problem events generated within the view.

## Configured event handlers

When you open the **Manage Event Handlers** pane on the left-hand side of the StackState UI, a list of all event handlers currently configured for the view is displayed. You can add, edit and remove event handlers from here.

## Add event handler

You can add an event handler to a view from the StackState UI.

![Add an event handler](/.gitbook/assets/v45_event_handlers_tab.png)

1. Select **Manage Event Handlers** on the left.
2. Click **ADD NEW EVENT HANDLER**.
3. Select the trigger event and event handler to run:
   * **On event** - the [event types](/use/metrics-and-events/event-notifications.md#event-types-for-notifications) that should trigger the event notification or automated action.
   * **Run event handler** - the [event handler function](#event-handler-functions) that will run whenever the selected event type is generated.
4. Enter the required details, these will vary according to the event handler function you have selected.
5. Click **SAVE**.

## Event handler functions

Event handlers listen to events generated within a view. When the configured event type is generated, the event handler function is run to send an event notification or trigger an action in a system outside of StackState. For example, an event handler function could send an email or make a POST to a webhook URL. A number of default event handler functions are included out of the box with StackState.

StackState ships with the following event handler functions that track **health state change events** in a view:

| Event handler function | Health state change events | Problem events | Description |
| :--- | --- | --- | :--- |
| **Slack** | ✅ | ✅ | Requires the [Slack StackPack](/stackpacks/integrations/slack.md). Sends a message with detailed content on the trigger event and possible root cause to the configured Slack webhook URL. See [how to create a Slack Webhook \(slack.com\)](https://api.slack.com/messaging/webhooks). |
| **HTTP webhook POST** | ✅ | - | Sends an HTTP webhook POST request to the specified URL. |
| **SMS** | ✅ | - | Sends details of a health state change event using MessageBird. |

{% hint style="success" "self-hosted info" %}

* An email event handler is available that sends details of a health state change event using a [configured SMTP server](/configure/topology/configure-email-event-notifications.md).

* You can [create your own custom event handler functions](/develop/developer-guides/custom-functions/event-handler-functions.md).

* Event handlers can also run in response to **problem events** using [custom event handler functions](/develop/developer-guides/custom-functions/event-handler-functions.md).
  
* A full list of the event handler functions available in your StackState instance can be found in the StackState UI, go to **Settings** &gt; **Functions** &gt; **Event Handler Functions**

{% endhint %}

## See also

* [Add a health check](/use/health-state/add-a-health-check.md)
* [Configure an SMTP server to send email event notifications](/configure/topology/configure-email-event-notifications.md "StackState Self-Hosted only")
* [Custom event handlers](/develop/developer-guides/custom-functions/event-handler-functions.md "StackState Self-Hosted only")
* [Create a custom event handler function](/develop/developer-guides/custom-functions/event-handler-functions.md "StackState Self-Hosted only")
* [Create a Slack Webhook \(slack.com\)](https://api.slack.com/messaging/webhooks)
