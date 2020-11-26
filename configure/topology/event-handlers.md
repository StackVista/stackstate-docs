---
description: Automate alerts and actions based on events
---

# Event handlers

## Overview

Event handlers can be attached to a StackState view to [trigger alerts and actions](/use/health-state-and-alerts/set-up-alerting.md) in response to health state change events generated within the view.

To trigger an alert or action, the event handler will run an [event handler function](#event-handler-functions). This is set in the StackState UI **Add event handler** dialogue as **Run event handler** .

![Add an event handler](/.gitbook/assets/event_handlers_tab.png)

## Event handler functions

Event handlers listen to events generated within the view, when the configured event type is generated the configured event handler function is run to [trigger an alert or action](/use/health-state-and-alerts/set-up-alerting.md) in a system outside of StackState. For example, an alert handler function could send an email or make a POST to a webhook URL. A number of default event handler functions are included out of the box with StackState, or you can [create a custom event handler function](#create-a-custom-event-handler-function). 

StackState ships with the following event handler functions:

- Send details of a health state change event and links to information that can assist with root cause analysis:
    - **Slack** - at the configured Slack web hook URL.
- Send details of a health state change event:
    - **Email** - using the [configured SMTP server](/configure/topology/configure-email-alerts.md).
    - **SMS** - using MessageBird.
- Send an HTTP POST request to a specified URL.

## Create a custom event handler function

You can write custom event handler functions to react to propagated state changes and health state changes of an element or view. 

### Parameters

### Async on/off

Event handler functions can be written as async (default) or synchronous. 

* With Async set to **On** the function will be run as [async](#async-event-handler-functions-default).

* With Async set to **Off** the function will be run as [synchronous](#synchronous-event-handler-functions-async-off).

#### Async event handler functions (default)

An async event handler function has access to the [StackState script APIs](/develop/reference/scripting/script-apis). This allows the function to make an HTTP request and gives access to the whole topology/telemetry.

#### Synchronous event handler functions (async Off)

### Logging

You can add user logging from the script for debug purposes, for example, with `log.info("message")`. Logs will appear in `stackstate.log`. Read how to [enable logging for functions](/configure/logging/).

## See also

- [Enable logging for functions](/configure/logging/)
- [Set up alerting](/use/health-state-and-alerts/set-up-alerting.md)
- [StackState script APIs](/develop/reference/scripting/script-apis)