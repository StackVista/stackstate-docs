---
description: Run queries against data from your IT environment.
---

# Analytics

## Overview

?? What is the analytics screen - why is it here and what is it used for?

## The analytics environment

?? Quick description of the screen. Cover:
- How do you get here? 
- Write a query here, get result here, look at history of queries here (is this for all stackstate users or only current user?), code examples here.

![Analytics screenshot](/.gitbook/assets/new_analytics.png)


## Queries

?? What is a query? When is it used? How is it used? How do you write them? Link to relevant other docs

### Example queries

Below are some queries to get you started and an example of the expected output. You can find more code examples in the StackState UI Analytics environment.

- [Get all components related to a specific component](#get-all-components-related-to-a-specific-component)
- [List all components which depend on a specific component and have the state CRITICAL](#list-all-components-which-depend-on-a-specific-component-and-have-the-state-critical)

#### Get all components related to a specific component.

{% tabs %}
{% tab title="Query" %}
```
// Define a name for the component where we start the search. 
def selectedComponent = "Invoicing"`
Topology.query("name = '" + selectedComponent + "'")
```
{% endtab %}
{% tab title="Example result" %}
```
query output
```
{% endtab %}
{% endtabs %}

#### List all components which depend on a specific component and have the state CRITICAL

{% tabs %}
{% tab title="Query" %}
```
// Define a name for the component where we start the search. 
def selectedComponent = "srv02"`
Topology.query
    ("withNeighborsOf(
        direction = 'down', levels = '15', 
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

