---
description: StackState SaaS
---

# StackState Query Language \(STQL\)

## Overview

This page describes how to use the built-in StackState Query Language \(STQL\) to write advanced topology component filters. STQL queries are used in StackState to write [advanced topology filters](../../use/stackstate-ui/filters.md#advanced-topology-filters).

An STQL query consists of [component filters](stql_reference.md#component-filters) and [functions](stql_reference.md#functions). The query output is a component, or set of components, filtered from the complete topology.

{% hint style="success" "self-hosted info" %}

**StackState Self-Hosted**

Extra information for the [StackState Self-Hosted product](https://docs.stackstate.com/):

    
STQL queries can be combined with scripts in the Analytics environment.

{% endhint %}

## Component filters

Component filters are used in two ways in STQL:

* Define the set of components to be included in the query output.
* Specify the set of components to be handled by an in-built STQL function.

### Filters

The filters described below can be combined using the available [operators](#operators) to achieve complex selections of components.

| Filter | Default | Description |
| :--- | :--- | :--- |
| `domain` | "all" | Components in the specified domain\(s\). |
| `environment` | "all" | Components in the named environment. |
| `healthstate` | "all" | Components with the named health state. |
| `label` | "all" | Components with the named labels. |
| `layer` | "all" | Components in the named layer. |
| `name` | "all" | Components with the specified name. |
| `type` | "all" | Components of the specified type. |
| `identifier` | "all" | Components with the specified URN identifier. The identifier filter is only compatible with basic filtering when it's specified using `identifier IN (...)` and combined with other filters using an `OR` operator. When the set filter is compatible with basic filtering, the number of component identifiers queried will be reported in the [**Other filters** box](/use/stackstate-ui/filters.md#other-filters). |

### Operators

The operators described below are available to use in STQL queries. Note that boolean operators will be executed in the standard order: NOT, OR, AND.

| Operator | Description | Example |
|:---|:---|:---|
| = | Equality matching | `name = "DLL_DB"` |
| != | Inequality matching | `name != "DLL_DB"` |
| IN | Value is in subset | `name in ("DLL_DB", "J2EE_04")` |
| NOT | Negation | `name NOT in ("DLL_DB", "J2EE_04")` |
| AND and OR | Filter based on more than one condition or sub-query | `name = "DLL_DB" OR type = "database"` |
| () | Use parenthesis to group results | `(name = … AND type = …) OR (…)` |

For example:

```yaml
# Return all components named DLL_DB or J2EE_04 regardless of type:
  name = DLL_DB OR name = J2EE_04 

# Return only databases named DLL_DB and host systems named J2EE_04:
  (name = DLL_DB AND type = database) OR (name = J2EE_04 AND type = "host systems")

```

### Wildcard

You can use `*` as a full wildcard in a component filter. It isn't possible to filter for partial matches using a wildcard character.

### Examples

```text
# Select all components
name = "*"

# Select all components with name "serviceB"
name = "serviceB"

# Select all components in the "application" layer:
layer = "application"

# Select all components named either "appA" or "appB" that don't have a label "bck"
name IN ("appA","appB") NOT label = "bck"

# Select all components named "appA" that don't have a label "bck" or "test"
name = "appA" NOT label in ("bck", "test")
```

## Functions

### withNeighborsOf

The function withNeighborsOf extends STQL query output, adding connected components in the specified direction\(s\). The number of topology levels included can be adjusted up to a maximum of 15.

`withNeighborsOf(components=(), levels=, direction=)`

To be compatible with basic filtering, the function can only be combined with other filters using an `OR` operator. When an advanced filter includes a function `withNeighborsOf` that's compatible with basic filtering, the number of components whose neighbors are queried for is shown in the [**Other filters** box](/use/stackstate-ui/filters.md#other-filters). 

#### Parameters / fields

| Parameter | Default | Allowed values | Description |
| :--- | :--- | :--- | :--- |
| `components` | "all" | A component filter | The component\(s\) for which the neighbors will be returned, see [component filters](stql_reference.md#component-filters). |
| `levels` | 1 | "all", \[1:14\] | The number of levels to include in the output. Use "all" to display all available levels \(maximum 15\) |
| `direction` | "both" | "up", "down", "both" | **up**: only components that depend on the named component\(s\) will be added  **down**: only dependencies of the named component\(s\) will be added  **both**: components that depend on and dependencies of the named component\(s\) will be added. |

#### Example

The example below will return all components in the application layer that have a health state of either `DEVIATING` or `CRITICAL`. Components with names "appA" or "appB" and their neighbors will also be included.

```text
layer = "application"
  AND (healthstate = "CRITICAL" OR healthstate = "DEVIATING")
  OR withNeighborsOf(components = (name in ("appA","appB")))
```

### withCauseOf - DEPRECATED

The `withCauseOf` function has been deprecated. This functionality has been replaced by the Root Cause Analysis section in the visualizer. The construct will be parsed, but won't produce any additional components.

## Compatibility basic and advanced filters

You can switch between basic and advanced filtering by selecting **Basic** or **Advanced** under **Filter Topology** in the **View Filters** panel.

It's always possible to switch from Basic to Advanced filtering. The selected basic filters will be converted directly to an STQL query. For simple queries it's also possible to switch from Advanced to Basic filtering, however, some advanced queries aren't compatible with basic filters. 

* Basic filters can't contain an inequality.
* Basic filters don't use `=`, rather they're formatted using the `IN` operator. For example `name IN ("DLL_DB”)` and not `name = "DLL_DB”`.
* Basic filters use AND/OR in a specific way:
    - All items in each basic filter box are joined with an **OR**: `layer IN ("business service", "applications", "databases")`
    - The different basic filter boxes are chained together with an **AND**: `layer IN ("business service") AND domain IN ("online banking”)`
    - The **Include components** basic filter box (name) is the exception - this is chained to the other filter boxes with an OR: `layer IN ("business service") AND domain IN ("online banking") OR name IN ("DLL_DB”)`
    - The advanced filtering options **withNeighborsOf** function and **identifier** are only compatible with basic filtering if they're joined to other filters with an **OR**: `layer in ("Processes") OR identifier IN ("urn:test:component")`
  
If you try to switch from an Advanced filter to a Basic filter and the query isn't compatible, StackState will let you know and ask for confirmation to continue as you will lose some set filters. Alternatively, you can choose to stay in advanced filtering.


## See also

* [Basic topology filters](/use/stackstate-ui/filters.md#basic-topology-filters)
* [Topology filter limits](../../use/stackstate-ui/filters.md#topology-filtering-limits)
* [How to filter topology in the StackState UI](../../use/stackstate-ui/filters.md)

