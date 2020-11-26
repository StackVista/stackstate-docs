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

StackState ships with the event handler functions:

- Send details of a health state change event and links to information that can assist with root cause analysis:
    - **Slack** - at the configured Slack webhook URL.
- Send details of a health state change event:
    - **Email** - using the [configured SMTP server](/configure/topology/configure-email-alerts.md).
    - **SMS** - using MessageBird.
- Send an HTTP webhook POST request to a specified URL.

## Create a custom event handler function

You can write custom event handler functions to react to propagated state changes and health state changes of an element or view. 

### Parameters

An event handler function script takes system and user defined parameters. System parameters are predefined parameters passed automatically to the script. The **view** system parameter is passed to every event handler function, this provides ???. An **event** user parameter is also required, this is the event stream that will be used to trigger the event handler function.

### Async on/off

Event handler functions can be written as async (default) or synchronous. 

* With Async set to **On** the function will be run as [async](#async-event-handler-functions-default). This gives the function access to the StackState script APIs.

* With Async set to **Off** the function will be run as [synchronous](#synchronous-event-handler-functions-async-off).

#### Async event handler functions (default)

An async event handler function has access to the [StackState script APIs](/develop/reference/scripting/script-apis). This allows the function to make an HTTP request using the [HTTP script API](/develop/reference/scripting/script-apis/http.md) and gives access to the whole topology/telemetry. Currently only the **Slack** event handler function shipped with StackState will run as an async function, this allows more extensive details around an event to be included in alerts sent to Slack such as links to relevant data and a possible root cause. 

#### Synchronous event handler functions (async Off)

All event handler functions developed before StackState v4.2 and the email, SMS and HTTP webhook event handler functions shipped with StackState v4.2 run as synchronous functions. 

### Available properties and methods

### Plugins

Event handler functions use plugins to send notifications to external systems. The current plugins are available for use in custom event handler functions:

| Plugin | Async | Usage | Description |
|:---|:---|:---|:---|
| email | - | `emailPlugin.sendEmail("to", "subject", "body")` | |  
| HTTP webhook | - | `webhookPlugin.sendMessage("url", "json"` | |
| Slack | ✅ | `slackPlugin.sendSlackMessage(slackWebHookUrl, "message")` | |
| SMS | - | `smsPlugin.sendSMSMessage(token, to, "message")`| |


### Logging

You can add user logging from the script for debug purposes, for example, with `log.info("message")`. Logs will appear in `stackstate.log`. Read how to [enable logging for functions](/configure/logging/).

## See also

- [Enable logging for functions](/configure/logging/)
- [Set up alerting](/use/health-state-and-alerts/set-up-alerting.md)
- [StackState script APIs](/develop/reference/scripting/script-apis)