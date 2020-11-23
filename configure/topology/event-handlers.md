---
description: Automate alerts and actions based on events
---

# Event handlers

## Overview

Event handlers can be attached to a StackState view to [trigger alerts and actions](/use/health-state-and-alerts/set-up-alerting.md) in response to a configured event within the view.

To trigger an alert or action, the event handler will run an [event handler function](#event-handler-functions). This can be set as **Run event handler** in the StackState UI **Add event handler** dialogue.

![Add an event handler](/.gitbook/assets/event_handlers_tab.png)

## Event handler functions

Event handlers listen to events and run an event handler function to [trigger an alert or action](/use/health-state-and-alerts/set-up-alerting.md) in a system outside of StackState. For example, send an email or make a POST to a webhook URL. A number of default event handler functions are included out of the box with StackState, or you can [create a custom event handler function](#create-a-custom-event-handler-function). 

StackState ships with the following event handler functions:

- **Email** - send an email alert to a specified email address using the [configured SMTP server](/configure/topology/configure-email-alerts.md).
- **HTTP webhook POST** -  send an HTTP POST request to a specified URL.
- **Slack** - send a notification to a specified Slack webhook URL.
- **SMS** - send an SMS alert (MessageBird) to a specified phone number.

## Create a custom event handler function

You can write custom event handler functions to react to health state changes and propagated state changes of an element or view. 

### Parameters

### Async on/off

Event handler functions can be written as async (default) or synchronous. 

* With Async set to **On** the function will be run as [async](#async-event-handler-functions-default).

* With Async set to **Off** the function will be run as [synchronous](#synchronous-event-handler-functions-async-off).

#### Async event handler functions (default)

An async event handler function has access to the [StackState script APIs](/develop/reference/scripting/script-apis). This allows the function to make an HTTP request and gives access to the whole topology/telemetry.

#### Synchronous event handler functions (async Off)

## See also

- [StackState views](/use/views/README.md)
- [Set up alerting](/use/health-state-and-alerts/set-up-alerting.md)