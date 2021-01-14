---
description: Run queries against data from your IT environment.
---

# Analytics

## Overview

The analytics environment is where you can directly query the [4T data model](use/introduction-to-stackstate/4t_data_model.md). Additionally you can use the analytics environment to build and test your StackState scripts, since the analytics environment uses the StackState Scripting Language as a basis for querying StackState.

Here are a few example of queries you could execute in the analytics environment:
 - Get all the names of all pods running in a namespace.
 - Determine the maximum latency of a service since yesterday. 
 - Find all machines indirectly connected to a set of APIs.
 - Show which databases have been updated since last week.

Queries that you create in the analytics environment can be used to investigate issues, automate processes and build reports. 

## The analytics environment

?? Quick description of the screen. Cover:
- How do you get here? 
- Write a query here, get result here, look at history of queries here (is this for all stackstate users or only current user?), code examples here.

![Analytics screenshot](/.gitbook/assets/new_analytics.png)

## Queries

In the analytics environment you use a combination of the [StackState Scripting Language \(STSL\)](develop/reference/scripting/README.md) and the [StackState Query Language \(STQL\)](develop/reference/stql_reference.md) to build your queries and scripts. 

A query is a regular STSL script. As a part of a script you can invoke the StackStake Query Language. The simplest example is

```
Topology.query("""environment in ("Production")""").components()
```

[Topology.query](develop/reference/scripting/script-apis/topology.md) is a regular script function which takes a STQL query as a parameter. The `.components()` at the end ensures that only the components and not the relations between these components are retrieved from the topology.

The combination of STSL and STQL allows you to chain together multiple queries. 

The following query gets all components in the `QA` environment that also exist in the `Production` environment by building a creating a STQL query from the results of another STQL query. 

```
// get components in the Production environment.
Topology.query("""environment IN ("Production")""").components() 
    // collect the names of all the components.
    .thenCollect { component -> component.name }
    .then { names ->
        // surround names with quotes and separate with commas, e.g ['a', 'b'] -> '"a","b"'
        def namesList = names.collect { "\"$it\""}.join(",")
        // get components in the QA environment that also exist in the Production environment
        Topology.query("""environment IN ("QA") AND name IN ($namesList)""").components()
    }
```

The full list of available function can be found [here](develop/reference/scripting/script-apis/README.md). Read about [async script results](develop/reference/scripting/async_script_result.md) to learn about how the results of one computation can be chained with another.

### Example queries

Below are some queries to get you started with an example of their expected output. You can find more code examples in the StackState UI Analytics environment.

- [Get all components related to a specific component](#get-all-components-related-to-a-specific-component)
- [List all components that depend on a specific component and have the state CRITICAL](#list-all-components-that-depend-on-a-specific-component-and-have-the-state-critical)
- [List a service with components it is depending on down to N levels of depth](#list-a-service-with-components-it-is-depending-on-down-to-n-levels-of-depth)

#### Get all components related to a specific component.

{% tabs %}
{% tab title="Query" %}
```
// Define a name for the component where we start the search 
def selectedComponent = "Invoicing"

Topology.query("name = '" + selectedComponent + "'")
```
{% endtab %}
{% tab title="Example result" %}
```
query output
```
{% endtab %}
{% endtabs %}

#### List all components that depend on a specific component and have the state CRITICAL

{% tabs %}
{% tab title="Query" %}
```
// Define a name for the component where we start the search 
def selectedComponent = "srv02"

Topology.query(
    "withNeighborsOf(
        direction = 'down', 
        levels = '15', 
        components = (
            name = '" + selectedComponent + "'
        )
    ) 
    and healthState = 'CRITICAL'"
)
```
{% endtab %}
{% tab title="Example result" %}
```
query output
```
{% endtab %}
{% endtabs %}

#### List a service with components it is depending on down to N levels of depth

{% tabs %}
{% tab title="Query" %}
```
// Define a name for the component where we start the search 
def selectedComponent = "Payment_Service"

// Define a search depth    
def N = 3

Topology.query(
    "withNeighborsOf(
        direction = 'down', 
        levels = '" + N + "',
        components = (
            name = '" + selectedComponent + "'
        ) 
    )"
)
```
{% endtab %}
{% tab title="Example result" %}
```
query output
```
{% endtab %}
{% endtabs %}

## See also

- [Scripting in StackState](/develop/reference/scripting/README.md)
- [StackState script APIs](/develop/reference/scripting/script-apis)
- [StackState Query Language STQL](/develop/reference/stql_reference.md)
- other useful links about queries and analytics




>>> OLD PAGE BELOW:


StackState's 4T \(Topology, Telemetry, Traces and Time\) model can be queried within the analytical environment. Analytical queries can be written in Groovy and support the [StackState Query Language \(STQL\)](../develop/reference/stql_reference.md). StackState analytical environment can be found at: `<stackstate_url:7070>/#/analytics`. The analytical environment is a full-fledged scripting environment.

Examples

Get all components which are related to a specific component.

`//Define a name for the component where we start the search. def selectedComponent = "Invoicing"`

`Topology.query("name = '" + selectedComponent + "'")`

List all components which depend on a specific component and have the state CRITICAL

`Define a name for the component where we start the search. def selectedComponent = "srv02"`

`Topology.query("withNeighborsOf(direction = 'down', levels = '15', components = (name = '" + selectedComponent + "')) and healthState = 'CRITICAL'")`

List a service with components it is depending on down to N levels of depth

`//Define a name for the component where we start the search. def selectedComponent = "Payment_Service"`

`//Define a search depth    
def N = 3`

`Topology.query("withNeighborsOf(direction = 'down', components = (name = '" + selectedComponent + "'), levels = '" + N + "') ")`

List a service with components depending on it up to N levels of depth

`//Define a name for the component where we start the search. def selectedComponent = "Payment_Service"`

`//Define a search depth    
def N = 3`

`Topology.query("withNeighborsOf(direction = 'up', components = (name = '" + selectedComponent + "'), levels = '" + N + "') ")`

Give a list of databases.

`Topology.query("Type = 'database'")`

Scripting

All queries are in-fact Groovy scripts. Find out more about [how StackState scripting works](/develop/reference/scripting/README.md).

