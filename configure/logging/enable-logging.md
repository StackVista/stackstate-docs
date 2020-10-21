---
description: Enable logging for StackState checks, event handlers and functions
---

# Enable logging

## Overview

For debugging purposes, it may be helpful to enable logging for a StackState check, event handler or function. You can use the StackState CLI to set a logging level for and track messages in `stackstate.log`.  Logging can be enabled for the following:
- Checks
- Event handlers
- Component actions
- Propagation functions
- View state configuration functions

## Add logging to a StackState function

Logging messages can be added to StackState functions and tracked in `stackstate.log`. This is useful for debug purposes.

1. Add a log statement in the function's code. For example:
    - `log.info("message")`
    - `log.info(variable.toString)`
    
2. [Enable logging](#set-the-logging-level-for-a-function-or-event-handler) for the function.


## Enable logging for a check, event handler or function

The logging level can be set in the StackState CLI using the ID of the check, event handler or function. 

1. Find the ID for the function you want to add logging to:
    - [Checks](#checks)
    - [Component actions](#component-actions)
    - [Event handlers](#event-handlers)
    - [Propagation functions](#propagation-functions)
    - [View health state configuration functions](#view-health-state-configuration-functions)

2. Use the [StackState CLI](/setup/cli.md) to set the logging level for the function ID, for example:
```
sts serverlog setlevel <id> DEBUG
```

3. Monitor the `stackstate.log` using the function ID.
```
tail -f stackstate.log | grep <id>
```

## Find the ID for a check, event handler or function

Retrieve the ID for a specific check, event handler or function:
    - [Checks](#checks)
    - [Event handlers](#event-handlers)
    - [Component actions](#component-actions)
    - [Propagation functions](#propagation-functions)
    - [View health state configuration functions](#view-health-state-configuration-functions)

### Analytics environment

#### Component actions

- In the [StackState UI Analytics environment](/develop/scripting/README.md#running-scripts) enter the query below to list all component actions.
- You can use the ID from the output to [enable loggingl](#enable-logging-for-a-check-event-handler-or-function) for the component action.

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
{% tab title="Output" %}
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

- In the [StackState UI Analytics environment](/develop/scripting/README.md#running-scripts) enter the query below to list all event handlers.
- You can use the ID from the output to [enable loggingl](#enable-logging-for-a-check-event-handler-or-function) for the event handler.


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
{% tab title="Output" %}
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

#### Propagation functions

- In the [StackState UI Analytics environment](/develop/scripting/README.md#running-scripts) enter the query below to list all propagation functions. 
- You can use the ID from the output to [enable loggingl](#enable-logging-for-a-check-event-handler-or-function) for the function.

{% tabs %}
{% tab title="Query" %}
```
Graph.query{it.V()
    .hasLabel("PropagationHealthFunction")
    .project("name", "id", "type")
    .by("name")
    .by(__.id())
    .by(__.label())
}
```
{% endtab %}
{% tab title="Output" %}
```
[
  {
    "id": 36569776373133,
    "name": "Quorum based cluster propagation",
    "type": "PropagationHealthFunction"
  },
  {
    "id": 32271358816814,
    "name": "Decreasing propagated health state",
    "type": "PropagationHealthFunction"
  },
  {
    "id": 105550770677720,
    "name": "Stop propagation",
    "type": "PropagationHealthFunction"
  },
  {
    "id": 16688530732364,
    "name": "Active/active failover",
    "type": "PropagationHealthFunction"
  },
  {
    "id": 279133974122155,
    "name": "Propagate when running",
    "type": "PropagationHealthFunction"
  }
]
```
{% endtab %}
{% endtabs %}

#### View health state configuration functions

- In the [StackState UI Analytics environment](/develop/scripting/README.md#running-scripts) enter the query below to list all view health state configuration functions. 
- You can use the ID from the output to [enable loggingl](#enable-logging-for-a-check-event-handler-or-function) for the function.

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
{% tab title="Output" %}
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

#### Checks

You can find the ID of a check in the StackState UI.

1. Click on a component to open the component details.
2. Click on **...** and select **Show JSON**.
3. Find the section for "checks"
4. Find the check you want to set the logging level for and copy the value from the field `id`.

![Show JSON](/.gitbook/assets/v41_show-json.png)

- You can use the ID from the output to [enable loggingl](#enable-logging-for-a-check-event-handler-or-function) for the check.

## See also

- [StackState CLI](/setup/cli.md)
- [StackState UI Analytics environment](/develop/scripting/README.md#running-scripts)