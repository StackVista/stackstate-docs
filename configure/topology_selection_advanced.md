---
title: Advanced topology selection
kind: Documentation
aliases:
  - /usage/topology_selection_advanced/
listorder: 2
---

# Advanced topology queries with STQL

The topology in StackState is likely much bigger than what you care about at any given time. StackState allows you to filter the topology to locate the part of the topology you are interested in.

If you want full control over your topology selection, you can use advanced topology selection. Advanced topology selection is used via the _advanced filter bar_, accessed by selecting _Advanced_ on the basic filter panel. The advanced filter bar allows you to select topology using StackState's built-in query language.

![Advanced filter example](../.gitbook/assets/query_advanced_with_neighbours%20%281%29.png)

StackState Query Language \(STQL\) has the following core concepts:

* [**Functions**](topology_selection_advanced.md#functions); STQL uses functions as a base functions have a Typed output.
* [**Boolean logic**](topology_selection_advanced.md#boolean-logic); Boolean logic can be used inside the query parameter of the components function and can be used between functions
* [**Query blocks**](topology_selection_advanced.md#output-functions); To define group specific parts of the query and set their preference

### Functions

Function always have an output type and can have have one or more arguments.

* The function and its parameters are split with white space
* The name and parameter of the arguments are split by an `=` symbol.

  Example: `"name='DLL_DB'"` or `withNeighborsOf(components = (name = "myApp"))`.

* If a function has multiple arguments they can be split using a `,`

List of functions:

| Name | Output type | Description |
| :--- | :--- | :--- |
| [components](topology_selection_advanced.md#function-components) | Set\ | Selection of components |
| [withNeighborsOf](topology_selection_advanced.md#function-withNeighborsOf) | Set\ | select the neighbors of \(specific\) components |
| [withCauseOf](topology_selection_advanced.md#function-causeOf) | Set\ | `DEPRECATED` |

STQL is a language which will defer execution till the moment the data is needed.

### Types

STQL is a Typed language, this means that all functions have typed input parameters and output. Not all functions work with all types. Types in STQL are inferred where possible. The following types are available:

* `Component`
* `Set<Component>`

### Boolean logic

The boolean operators are by default executed in the following order: First `NOT`, then `OR` and as of last rule `AND` if you want to change the order you can use [query blocks](topology_selection_advanced.md#query-blocks)

* `AND` If you want to have a rule that combines two [basic filters](topology_selection_advanced.md#components-basic-filter) in one rule you can use AND. `AND` will combine the LEFT and RIGHT [basic filters](topology_selection_advanced.md#components-basic-filter) as one result. Example: `layer = "application" AND healthstate = "CRITICAL"`
* `OR` If you want to have a rule that combines the output of two [basic filters](topology_selection_advanced.md#components-basic-filter) in a query you can use OR. `OR` will combine the LEFT and RIGHT [basic filters](topology_selection_advanced.md#components-basic-filter) as one result. Example: `layer = "application" AND healthstate = "CRITICAL"`
* `NOT` This rule subtracts all the results matching the right-hand side from the left-hand side. Example: `NOT (name = "AppA" OR name = "AppB")`. This example will select all components except the ones with the name "AppA" or "AppB".

### Query blocks

If you want to combine multiple boolean operators `OR` or `AND` combinations and control the order, you can use `( ... )` to do this. Example: `(name = "AppA" OR name = "AppB") AND layer = "Application"`. Now the `name = "AppA" OR name = "AppB"` is executed first, and both will be checked for the layer = "Application". Without the code block only "AppB" will be checked for the layer = "Application" because the default order is `NOT`, then `AND` and as of last rule`OR`.

### Component functions

A functions can have one ore more parameters. Parameters can be named and are typed. For example `withNeighborsOf(components = (name = "DLL_DB"), levels = "10", direction = "both")`

#### components

The `components` function is the implicit function used to select components based on a filter with support for key/value pair selection. All key-value pair filters added are implicitly filtering properties of components in your topology.

**output type**

`Set<Component>`

**parameters**

filter=`<basic filter>`

**The basic filter syntax: &lt;key&gt; &lt;operator&gt; &lt;value&gt;**

The key can be any key from the key/value pairs which you can put on a component. Or the following special keys:

* `name`, The name of the component
* `healthstate`, The own healthstate of the component
* `label`, Matching label\(s\) of the component
* `layer`, Matching layers of the component
* `domain`, Matching layers of the component
* `environment`, Matching layers of the component

The [basic filter operators](topology_selection_advanced.md) are:

* equals: `=`
* in list `in`
* not equals `!=`

**Basic usage**

The default behavior of a key-value filter is that it filters on properties of components:

* `name = "AppA"`
* `name = "AppA" OR healthstate = "CRITICAL"`

In other words:

* basic = syntax of query:

  `layer = "application"`

* name based selection

  `name in ("ApplicationA", "ApplicationB")`

#### withNeighborsOf

The withNeighborsOf function is used to append the ouput of the stream with neighbouring components.

**output type**

`Set<Component>`

**parameters:**

`direction=(optional, default=both) <direction>` The direction can be `up` for components which depend on this component and `down` for dependencies. `both` can be used for the combination of `up` and `down`.

`levels=(optional, detault=1)<levels>` `levels` is the number of levels you want to repeat this function. Use `all` to continue till there are no more levels. This is limited to 15.

`components=(optional, default=all components in input)<set-of-components>` The component for which the neighbours should be returned

#### withCauseOf `DEPRECATED`

This functionality is deprecated and is replaced by the "Root Cause Analysis" section in the visualizer settings. The construct will be parsed but does not produce any additional components.

### Query examples

* Select all components with name `serviceB`: `name = "serviceB"`
* Select all components in the `application` layer: `layer = "application"`
* Select all components in the `application` layer that have either healthstate `CRITICAL` or `DEVIATING`. Also include components with names `appA` or `appB` and their neighbors: `layer = "application" AND (healthstate = "CRITICAL" OR healthstate = "DEVIATING") OR withNeighborsOf(components = (name IN ("appA","appB")))`
* Select all components in the `application` layer that have a healthstate other than `CRITICAL`. Also include components with names `service A` or `service B`. Also include the neighbors of component `AppA` : `layer = "application" AND healthstate != "CRITICAL" OR (name in ("serviceA", "serviceB")) OR withNeighborsOf(components = (name = "AppA"), levels = "2")`

### Syntax help

If you \(start to\)type a word at the beginning of a new code block \(after the beginning of the line or after an `AND` or `OR`\):

* Autocomplete keys

If you are at the end of a key

* Autocomplete [filter operators](topology_selection_advanced.md#components-basic-filter-operators) like `=`, `!=`, `in`

If you \(start to\)type a word after a basic filter operator

* If the key is not 'name'; autocomplete values with a multi-select drop-down with a search to filter values down
* If the key is 'name'; autocomplete values starting with the typed letters \(start with a minimum of 2 letters\)

## Using STQL in analytics

STQL can be also be used in the [analytics](../use/queries.md) environment in combination with [scripting](../develop/scripting/) to create powerful queries that do not only query the topology, but the entire 4T data model.

