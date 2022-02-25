---
description: Build advanced topology queries with STQL
---

# StackState Query Language \(STQL\)

{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

This page describes how to use the built-in StackState Query Language \(STQL\) to write advanced topology component filters. STQL queries are used in StackState to write [advanced topology filters](../../use/view_filters.md#advanced-topology-filters) and can be combined with scripts in the [Analytics](../../use/analytics.md) environment.

An STQL query consists of [component filters](stql_reference.md#component-filters) and [functions](stql_reference.md#functions). The query output is a component, or set of components, filtered from the complete topology.

## Component filters

Component filters are used in two ways in STQL:

* Define the set of components to be included in the query output.
* Specify the set of components to be handled by an in-built STQL function.

The filters described below can be combined using boolean operators to achieve complex selections of components. Note that boolean operators will be executed in the standard order: NOT, OR, AND. You can change the order of operations by grouping sections of a query with parentheses \(...\).

### Filters

| Filter | Default | Description |
| :--- | :--- | :--- |
| `domain` | "all" | Components in the specified domain\(s\). |
| `environment` | "all" | Components in the named environment. |
| `healthstate` | "all" | Components with the named health state. |
| `label` | "all" | Components with the named labels. |
| `layer` | "all" | Components in the named layer. |
| `name` | "all" | Components with the specified name. |
| `type` | "all" | Components of the specified type. |

### Wildcard

You can use `*` as a full wildcard in a component filter. It is not possible to filter for partial matches using a wildcard character.

### Examples

```text
# Select all components
name = "*"

# Select all components with name "serviceB"
name = "serviceB"

# Select all components in the "application" layer:
layer = "application"

# Select all components named either "appA" or "appB" that do not have a label "bck"
name IN ("appA","appB") NOT label = "bck"

# Select all components named "appA" that do not have a label "bck" or "test"
name = "appA" NOT label in ("bck", "test")
```

## Functions

### withNeighborsOf

The function withNeighborsOf extends STQL query output, adding connected components in the specified direction\(s\). The number of topology levels included can be adjusted up to a maximum of 15.

`withNeighborsOf(components=(), levels=, direction=)`

#### Parameters / fields

| Parameter | Default | Allowed values | Description |
| :--- | :--- | :--- | :--- |
| `components` | "all" | A component filter | The component\(s\) for which the neighbors will be returned, see [component filters](stql_reference.md#component-filters). |
| `levels` | 1 | "all", \[1:14\] | The number of levels to include in the output. Use "all" to display all available levels \(maximum 15\) |
| `direction` | "both" | "up", "down", "both" | **up**: only components that depend on the named component\(s\) will be added  **down**: only dependencies of the named component\(s\) will be added  **both**: components that depend on and dependencies of the named component\(s\) will be added. |

#### Example

The example below will return all components in the application layer that have a health state of either "CRITICAL" or "DEVIATING". Components with names "appA" or "appB" and their neighbors will also be included.

```text
layer = "application"
  AND (healthstate = "CRITICAL" OR healthstate = "DEVIATING")
  OR withNeighborsOf(components = (name in ("appA","appB")))
```

### withCauseOf - DEPRECATED

The `withCauseOf` function has been deprecated. This functionality has been replaced by the Root Cause Analysis section in the visualizer. The construct will be parsed, but will not produce any additional components.

## See also

* [Topology filter limits](../../use/view_filters.md#topology-filtering-limits)
* [How to filter topology in the StackState UI](../../use/view_filters.md)
* [How to use STQL queries in analytics](../../use/analytics.md)
* [StackState scripting language \(STSL\)](scripting/)

