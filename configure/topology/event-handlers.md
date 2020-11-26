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

{% hint style="info" %}
Some of the event handler functions above will be installed as part of a StackPack. A full list of the event handler functions available in your StackState instance can be found in the StackState UI, go to **Settings** > **Functions** > **Event Handler Functions**
{% endhint %}

## Create a custom event handler function

You can write custom event handler functions to react to propagated state changes and health state changes of an element or view and use a plugin to send an alert to a system outside of StackState. 

### Parameters

An event handler function script takes system and user defined parameters. System parameters are predefined parameters passed automatically to the script. The **view** system parameter is passed to every event handler function and provides details of the view the event handler is in. An **event** user parameter is also required, this is the event stream that will be used to trigger the event handler function. The properties that can be retrieved from the view and event parameters are described below, see [available properties](#available-properties)

### Async on/off

Event handler functions can be written as async (default) or synchronous. 

* With Async set to **On** the function will be run as [async](#async-event-handler-functions-default). This gives the function access to the StackState script APIs.

* With Async set to **Off** the function will be run as [synchronous](#synchronous-event-handler-functions-async-off).

#### Async event handler functions (default)

An async event handler function has access to the [StackState script APIs](/develop/reference/scripting/script-apis). This allows the function to make an HTTP request using the [HTTP script API](/develop/reference/scripting/script-apis/http.md) and gives access to the whole topology/telemetry. Currently only the **Slack** event handler function shipped with StackState will run as an async function, this allows more extensive details around an event to be included in alerts sent to Slack, such as links to relevant data and a possible root cause. 

Event handler functions use plugins to interact with external systems, not all plugins are available for use with async functions. See [plugins](#plugins) below for further details. The [available properties](#properties-for-async-functions) that can be retrieved from the default parameters are described below.

#### Synchronous event handler functions (async Off)

All event handler functions developed before StackState v4.2 and the email, SMS and HTTP webhook event handler functions shipped with StackState v4.2 run as synchronous functions. This places limitations on both the capability of what they can achieve and the number of functions that can be run in parallel.

Event handler functions use plugins to interact with external systems, synchronous event handler functions can use all available plugins. See [plugins](#plugins) below for further details. The [available properties](#properties-for-synchronous-functions) that can be retrieved from the default parameters are described below.

### Available properties

#### Properties for synchronous functions

The parameters and properties described below can be used in synchronous event handler functions.

The `view` properties listed below can be used in **synchronous** event handler functions, they return details of the view the event handler is in. Note that `view`  or `scope` parameter name can be used, or an alias.
- `view.getName` - returns the name of the view
- `view.getDescription` - returns the description
- `view.getQuery` - returns an STQL query of the view
- `view.getIdentifier` - 
- `view.getTags` - 

The `event` properties for different event types below can be used in **synchronous** event handler functions, they return details of the received event. Note that `event` is the default parameter name, but this can be modified if you choose.
        
- A **HealthStateChangedEvent** is generated when an element's own health state changes.
    - `event.HealthStateChangedEvent.getNewStateRef` - returns an object representing the current state of the element.
    - `event.HealthStateChangedEvent.getOldStateRef` - returns an object representing the previous state of the element.
    - `event.HealthStateChangedEvent.getCauseId` -
    - `event.HealthStateChangedEvent.getTriggeredTimestamp` -

- A **PropagatedHealthStateChangedEvent** is generated when the propagated health state of an element changes.
    - `event.PropagatedHealthStateChangedEvent.getStateChanges` - returns the chain og elements through which the health state change propagated.
    - `event.PropagatedHealthStateChangedEvent.getCauseId` -
    - `event.PropagatedHealthStateChangedEvent.getTriggeredTimestamp` - 

- A **ViewHealthStateChangedEvent** is generated when the health state of the entire view changes.
    - `event.ViewHealthStateChangedEvent.getNewStateRef` - returns an object representing the current state of the view.
    - `event.ViewHealthStateChangedEvent.getOldStateRef` - returns an object representing the previous state of the view.
    - `event.ViewHealthStateChangedEvent.getCauseId` -
    - `event.ViewHealthStateChangedEvent.getTriggeredTimestamp` -

#### Properties for async functions

The parameters and properties described below can be used in async event handler functions.

The `view` properties listed below can be used in **async** event handler functions, they return details of the view the event handler is in.
- `view.name` - returns the view name.
- `view.description` - returns the view description.
- `view.query` -  returns an STQL query of the view.
- `view.identifier` -
- `view.tags` -

The `event` properties for different event types below can be used in **async** event handler functions, they return details of the received event. Note that `event` is the default parameter name, but this can be modified if you choose.

- A **HealthStateChangedEvent** is generated when an element's own health state changes.
    - `event.HealthStateChengedEvent.triggeredTimestamp` -
    - `event.HealthStateChengedEvent.transactionId` -
    - `event.HealthStateChengedEvent.identifier` -
    - `event.HealthStateChengedEvent.stackElement` -
    - `event.HealthStateChengedEvent.newState` - returns the current state of the element.
    - `event.HealthStateChengedEvent.oldState` - returns the previous state of the element.
    - `event.HealthStateChengedEvent.causeId` -

- A **PropagatedHealthStateChangedEvent** is generated when the propagated health state of an element changes.
    - `event.PropagatedHealthStateChangedEvent.triggeredTimestamp` -
    - `event.PropagatedHealthStateChangedEvent.transactionId` -
    - `event.PropagatedHealthStateChangedEvent.identifier` -
    - `event.PropagatedHealthStateChangedEvent.stateChanges` - returns the chain of elements through which the health state change propagated.
    - `event.PropagatedHealthStateChangedEvent.causeId` -

- A **ViewHealthStateChangedEvent** is generated when the health state of the entire view changes.
    - `event.ViewHealthStateChangedEvent.triggeredTimestamp` -
    - `event.ViewHealthStateChangedEvent.transactionId` -
    - `event.ViewHealthStateChangedEvent.identifier` -
    - `event.ViewHealthStateChangedEvent.viewHealthState` -
    - `event.ViewHealthStateChangedEvent.oldState` - returns the previous health state of the view.
    - `event.ViewHealthStateChangedEvent.newState` - returns the health state of the view.
    - `event.ViewHealthStateChangedEvent.causeId` -

### Plugins

Event handler functions use plugins to send notifications to external systems. The plugins available for use in custom event handler functions are listed below. Note that not all plugins can be used in an async event handler function:

| Plugin | Async | Description |
|:---|:---|:---|
| email | - | Sends an email using the [configured SMTP server](/configure/topology/configure-email-alerts.md).<br />`emailPlugin.sendEmail(to, subject, "body")` |
| HTTP webhook | - | Sends an HTTP POST request with the specified content to a URL.<br />`webhookPlugin.sendMessage(url, "json")` | |
| Slack | ✅ | Sends a notification message to a Slack webhook. The message can contain detailed content on the trigger event and possible root cause.<br />`slackPlugin.sendSlackMessage(slackWebHookUrl, "message")` |
| SMS | - | Sends an SMS using MessageBird with the specified token.<br />`smsPlugin.sendSMSMessage(token, "to", "message")`|


### Logging

You can add logging statements to an event handler function for debug purposes, for example, with `log.info("message")`. Logs will appear in `stackstate.log`. Read how to [enable logging for functions](/configure/logging/).

## See also

- [Enable logging for functions](/configure/logging/)
- [Set up alerting](/use/health-state-and-alerts/set-up-alerting.md)
- [StackState script APIs](/develop/reference/scripting/script-apis)