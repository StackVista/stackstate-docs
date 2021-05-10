---
description: Automate event notifications and actions based on events
---

# Event handlers

## Overview

Event handlers can be attached to a StackState view to [send event notifications](../../use/health-state-and-event-notifications/send-event-notifications.md) and trigger actions in response to health state change events or problem events generated within the view.

To generate an event notification or trigger an action, the event handler will run an [event handler function](/develop/developer-guides/custom-functions/event-handler-functions.md). This is set in the StackState UI **Events Settings** &gt; **ADD NEW EVENT HANDLER** dialogue as **Run event handler**.

![Add an event handler](../../.gitbook/assets/v43_event_handlers_tab.png)

## Event handler functions

Event handlers listen to events generated within a view. When the configured event type is generated, the event handler function is run to [send an event notification](../../use/health-state-and-event-notifications/send-event-notifications.md) or trigger an action in a system outside of StackState. For example, an event handler handler function could send an email or make a POST to a webhook URL. A number of default event handler functions are included out of the box with StackState, or you can [create your own custom event handler functions](/develop/developer-guides/custom-functions/event-handler-functions.md).

### Health state change events

StackState ships with the following event handler functions that respond to health state change events:

| Event handler function | Description |
| :--- | :--- |
| **Slack** | Sends a message with detailed content on the trigger event and possible root cause to the configured Slack webhook URL. See [how to create a Slack webhook \(slack.com\)](https://api.slack.com/messaging/webhooks). |
| **Email** | Sends details of a health state change event using the [configured SMTP server](configure-email-event-notifications.md). |
| **HTTP webhook POST** | Sends an HTTP webhook POST request to the specified URL. |
| **SMS** | Sends details of a health state change event using MessageBird. |

{% hint style="info" %}
Some of the event handler functions above will be installed as part of a StackPack. A full list of the event handler functions available in your StackState instance can be found in the StackState UI, go to **Settings** &gt; **Functions** &gt; **Event Handler Functions**
{% endhint %}

### Problem events

To run an event handler in response to problem events generated in a view, you will need to [create a custom event handler function](/develop/developer-guides/custom-functions/event-handler-functions.md).

## See also

* [Send event notifications using an event handler function](../../use/health-state-and-event-notifications/send-event-notifications.md)
* [StackState script APIs](../../develop/reference/scripting/script-apis/)
* [How to create a Slack webhook \(slack.com\)](https://api.slack.com/messaging/webhooks)

