---
title: Analytical queries
kind: Documentation
aliases:
  - /usage/queries/
listorder: 9
---

# Analytics

StackState's 4T \(Topology, Telemetry, Traces and Time\) model can be queried within the analytical environment. Analytical queries can be written in Groovy and have support for [topology queries using STQL](topology_selection_advanced.md). StackState analytical environment can be found at: `<stackstate_url:7070>/#/analytics`. The analytical environment is a full-fledged scripting environment.

## Examples

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

## Scripting

All queries are in-fact Groovy scripts. A full explanation on how StackState scripting works and an overview of all capabilities can be found [here](../develop/scripting/).

