---
description: StackState Self-hosted v5.0.x 
---

# Component - script API

{% hint style="warning" %}
**This page describes StackState version 5.0.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/develop/reference/scripting/script-apis/component).
{% endhint %}

## Function: `withId`

Get access to a component by its ID.

### Args

* `id` - id of the component we are querying for. Each component has a unique randomly assigned id number.

**Builder methods**

Each of the methods below give you a Async result with a set of properties

- `at(time: Instant or Timeslice)` - specifes a [time](time.md) for which the query should be executed. 
- `get` - Gets components details in full with following fields:
    ```text
    id
    name
    description
    lastUpdateTimestamp
    type
    layer
    domain
    environments
    state
    runState
    outgoingRelations
    incomingRelations
    synchronized
    failingChecks
    iconbase64
    visible
    ```

- `checks` - Gets a list of component checks each with the following fields:
    ```text
    id
    lastUpdateTimestamp`
    name
    description
    remediationHint
    function
    arguments
    state
    syncCreated
    ```

- `domain` - Gets the domain the component belongs to with the following fields:
    ```text
    id
    lastUpdateTimestamp
    name
    description
    order
    identifier
    ```

- `streams` - Gets a list of component streams each with the following fields:
    ```text
    id
    lastUpdateTimestamp
    name
    description
    priority
    dataType
    dataSource
    query
    ```

- `type` - Gets the component type of the given component with the following fields:
    ```text
    id
    lastUpdateTimestamp
    name
    description
    iconbase64
    identifier
    ```

- `layer` - Gets the layer for the component with the following fields:
    ```text
    id
    lastUpdateTimestamp
    name
    description
    order
    identifier
    ```

- `environments` - Gets a list of environments this component belongs to with following fields:
    ```text
    id
    lastUpdateTimestamp
    name
    description
    identifier
    ownedBy
    ```

- `propagation` - Get the propagation for the component if any with the following fields:
    ```text
    id
    lastUpdateTimestamp
    function
    arguments
    ```

### Examples

This example returns the name of the layer for the component with id `123`. After getting the layer the [AsyncScriptResult](../async-script-result.md) `then` function is used to get the name of the layer.

```text
Component.withId(123).layer().then { it.name }
```

