---
description: Build topology queries with STQL
---

The built-in StackState Query Language (STQL) can be used to run advanced queries in the StackState Topology perspective and Analytics environments.

- **Topology**: Use STQL to build [advanced topology filters](/use/perspectives/filters.md#advanced-topology-filters) that zoom in on a specific area of your topology or highlight problem components and their root cause.
- **Analytics**: Combine STQL with scripting to create powerful queries that access the entire 4T data model.

STQL queries consist of [component filters](#component-filters) and [functions](#functions). The query output is a component, or set of components, from the complete topology.

# Component filters

Component filters are used in two ways in STQL:

- Define the set of components to be included in the query output.
- Specify the set of components to be handled by an in-built STQL function.

The filters described below can be combined using boolean operators to achieve complex selections of components. Note that boolean operators will be executed in the standard order: NOT, OR, AND. You can change the order of operations by grouping sections of a query with parentheses (...).

## Filters

| Parameter | Default | Description |
|:---|:---|:---|
| `domain` | "all" | Components in the specified domain(s). |
| `environment` | "all" | Components in the named environment. |
| `healthstate` | "all" | Components with the named health state. |
| `label` | "all" | Components with the named labels. |
| `layer` | "all" | Components in the named layer. |
| `name` | "all" | Components with the specified name. |
| `type` | "all" | Components of the specified type. |

## Wildcard

You can use * as a full wildcard. It is not possible to filter for partial matches using a wildcard character.

## Examples

```
# Select all components
name = "*"

# Select all components with name "serviceB"
name = "serviceB"

# Select all components in the "application" layer:
layer = "application"

# Select all components named either "appA" or "appB" that do not have a label "bck"
name in ("appA","appB") NOT label = "bck"

# Select all components named "appA" that do not have a label "bck" or "test"
name = "appA" NOT label in ("bck", "test")
```

# Functions

## withNeighborsOf

The function withNeighborsOf extends STQL query output, adding connected components in the specified direction(s). The number of topology levels included can be adjusted up to a maximum of 15.

`withNeighborsOf(components=(), levels=, direction=)`

### Parameters / fields

| Parameter | Default | Allowed values | Description |
|:---|:---|:---|:---|
| `components` | "all" | A component filter | The component(s) for which the neighbors will be returned, see [component filters](#component-filters). |
| `levels` | 1 | "all", [1:14] | The number of levels to include in the output. Use "all" to display all available levels (maximum 15) |
| `direction` | "both" | "up", "down", "both" |**up**: only components that depend on the named component(s) will be added <br />**down**: only dependencies of the named component(s) will be added <br />**both**: components that depend on and dependencies of the named component(s) will be added. |

### Example

The example below will return all components in the application layer that have a healthstate of either "CRITICAL" or "DEVIATING". Components with names "appA" or "appB" and their neighbors will also be included.

```
layer = "application"
  AND (healthstate = "CRITICAL" OR healthstate = "DEVIATING")
  OR withNeighborsOf(components = (name in ("appA","appB")))
```

## withCauseOf - DEPRECATED

The `withCauseOf` function has been deprecated. This functionality has been replaced by the Root Cause Analysis section in the visualizer. The construct will be parsed, but will not produce any additional components.

# See also

- [Topology filter limits](/use/perspectives/filters.md#topology-filtering-limits)
- [How to filter topology in the StackState UI](/use/perspectives/filters.md)
- [How to use STQL queries in analytics](/use/queries.md)
- [StackState scripting language (STSL)](/develop/scripting/README.md)