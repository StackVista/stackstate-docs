---
description: Enable logging for StackState checks, event handlers and functions
---

# Enable logging

## Overview

For debugging purposes, it may be helpful to enable logging for a StackState check, event handler or function. You can use the StackState CLI to set a logging level and then track messages in the file `stackstate.log`.  Logging can be enabled for checks, event handlers, component actions, propagation functions and view state configuration functions. Note that it is not currently possible to enable logging for other function types.

{% hint style="info" %}
Note that logging will be enabled for an instance of a check, event handler or function, not for the function itself.
{% endhint %}

## Enable logging for a check, event handler or function

The logging level can be set in the StackState CLI using the ID of the check, event handler or function. 

1. Find the ID for the check, event handler or function you want to enable logging for:
    - [Checks](#checks-and-propagation-functions)
    - [Event handlers](#event-handlers)
    - [Component actions](#component-actions)
    - [Propagation functions](#checks-and-propagation-functions)
    - [View health state configuration functions](#view-health-state-configuration-functions)

2. Use the [StackState CLI](/setup/cli.md) to set the logging level for the ID, for example:
```
sts serverlog setlevel <id> DEBUG
```

3. Monitor the `stackstate.log` using the ID.
```
tail -f stackstate.log | grep <id>
```

## Add logging to a StackState function

Logging statements can be added to StackState functions and monitored in the `stackstate.log`. This is useful for debug purposes.

1. Add a log statement in the function's code. For example:
    - `log.info("message")`
    - `log.info(variable.toString())`
    
2. [Enable logging](#enable-logging-for-a-check-event-handler-or-function) for the function.


## Find the ID for a check, event handler or function

Retrieve the ID for a specific check, event handler or function:
    - [Checks](#checks-and-propagation-functions)
    - [Event handlers](#event-handlers)
    - [Component actions](#component-actions)
    - [Propagation functions](#checks-and-propagation-functions)
    - [View health state configuration functions](#view-health-state-configuration-functions)

### Analytics environment

#### Component actions

- Execute the query below in the [StackState UI Analytics environment](/develop/scripting/README.md#running-scripts) to list all component actions.
- Use the ID from the query result to [enable logging](#enable-logging-for-a-check-event-handler-or-function) for the component action.

{% tabs %}
{% tab title="Query" %}
```
Graph.query{it.V()
    .hasLabel("ComponentActionDefinition")
    .project("name", "id", "type")
    .by("name")
    .by(__.id())
    .by(__.label())
}
```
{% endtab %}
{% tab title="Example result" %}
```
[
  {
    "id": 154786643410143,
    "name": "test",
    "type": "ComponentActionDefinition"
  }
]
```
{% endtab %}
{% endtabs %}

#### Event handlers

- Execute the query below in the [StackState UI Analytics environment](/develop/scripting/README.md#running-scripts) to list all event handlers.
- Use the ID from the query result to [enable logging](#enable-logging-for-a-check-event-handler-or-function) for the event handler.

{% tabs %}
{% tab title="Query" %}
```
Graph.query{it.V()
    .hasLabel("EventHandler")
    .project("name", "id", "type")
    .by("name")
    .by(__.id())
    .by(__.label())
}
```
{% endtab %}
{% tab title="Example result" %}
```
[
  {
    "id": 275935840353084,
    "name": "test",
    "type": "EventHandler"
  }
]
```
{% endtab %}
{% endtabs %}

#### View health state configuration functions

- Execute the query below in the [StackState UI Analytics environment](/develop/scripting/README.md#running-scripts) to list all view health state configuration functions. 
- Use the ID from the query result to [enable logging](#enable-logging-for-a-check-event-handler-or-function) for the function.

{% tabs %}
{% tab title="Query" %}
```
Graph.query{it.V()
    .hasLabel("ViewHealthStateConfiguration")
    .project("name", "id").by(__.in("HAS_VIEW_STATE_EVENT_HANDLER")
    .properties("name")
    .value())
    .by(__.id())
}
```
{% endtab %}
{% tab title="Example result" %}
```
[
  {
    "id": 199788904929228,
    "name": "Demo - Shared Infra"
  },
  {
    "id": 145007127435760,
    "name": "Demo - Customer B"
  },
  {
    "id": 101484217135893,
    "name": "Demo - Customers View"
  },
  {
    "id": 47738295055704,
    "name": "Demo - Service"
  },
  {
    "id": 155715925953458,
    "name": "Demo - Business Dashboard"
  },
  {
    "id": 240446163862311,
    "name": "Demo - Customer D"
  },
  {
    "id": 58208596693730,
    "name": "Demo - Customer E"
  },
  {
    "id": 176016933421140,
    "name": "Demo - Customer A"
  }
]
```
{% endtab %}
{% endtabs %}

### StackState UI

#### Checks and propagation functions

You can find the ID of check or propagation function for a specific component in the StackState UI.

1. Click on a component to open the component details.
2. Click on **...** and select **Show JSON**.
3. Find the section for `"checks"` or `"propagation"`.
4. Find the check or propagation function that you want to enable logging for and copy the value from the field `id`.

![Show JSON](/.gitbook/assets/v41_show-json.png)

- Use the ID to [enable logging](#enable-logging-for-a-check-event-handler-or-function) for the check or propagation funtion.

## See also

- [StackState CLI](/setup/cli.md)
- [StackState UI Analytics environment](/develop/scripting/README.md#running-scripts)