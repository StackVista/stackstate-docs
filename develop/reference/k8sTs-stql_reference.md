---
description: StackState for Kubernetes troubleshooting
---

# StackState Query Language \(STQL\)

## Overview

This page describes how to use the built-in StackState Query Language \(STQL\) to write advanced topology component filters. STQL queries are used in StackState to write [advanced topology filters](../../use/views/k8s-filters.md#advanced-topology-filters).

An STQL query consists of [component filters](#component-filters) and [functions](#functions). The query output is a component, or set of components, filtered from the complete topology.

## Component filters

Component filters are used in two ways in STQL:

* Define the set of components to be included in the query output.
* Specify the set of components to be handled by an in-built STQL function.

### Filters

The filters described below can be combined using the available [operators](#operators) to achieve complex selections of components.

| Filter | Default | Description                                                                                                                                                                                                                                                                                                                                                                                                            |
| :--- | :--- |:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `domain` | "all" | Components in the specified domain\(s\).                                                                                                                                                                                                                                                                                                                                                                               |
| `environment` | "all" | Components in the named environment.                                                                                                                                                                                                                                                                                                                                                                                   |
| `healthstate` | "all" | Components with the named health state.                                                                                                                                                                                                                                                                                                                                                                                |
| `label` | "all" | Components with the named labels.                                                                                                                                                                                                                                                                                                                                                                                      |
| `layer` | "all" | Components in the named layer.                                                                                                                                                                                                                                                                                                                                                                                         |
| `name` | "all" | Components with the specified name.                                                                                                                                                                                                                                                                                                                                                                                    |
| `type` | "all" | Components of the specified type.                                                                                                                                                                                                                                                                                                                                                                                      |
| `identifier` | "all" | Components with the specified URN identifier. The identifier filter is only compatible with basic filtering when it's specified using `identifier IN (...)` and combined with other filters using an `OR` operator. When the set filter is compatible with basic filtering, the number of component identifiers queried will be reported in the [**Other filters** box](../../use/views/k8s-filters.md#other-filters). |

### Operators

The operators described below are available to use in STQL queries. Note that boolean operators will be executed in the standard order: NOT, OR, AND.

| Operator | Description | Example                                              |
|:---|:---|:-----------------------------------------------------|
| = | Equality matching | `name = "cert-manager"`                              |
| != | Inequality matching | `name != "coredns"`                                  |
| IN | Value is in subset | `name in ("cert-manager", "cluster_autoscaler")`     |
| NOT | Negation | `name NOT in ("cert-manager", "cluster_autoscaler")` |
| AND and OR | Filter based on more than one condition or sub-query | `name = "cert-manager" OR type = "deployment"`         |
| () | Use parenthesis to group results | `(name = … AND type = …) OR (…)`                     |

For example:

```yaml
# Return all components named cert-manager or coredns regardless of type:
  name = "cert-manager" OR name = "coredns"

# Return only deployments named coredns and configmaps named kube-root-ca.crt:
  (name = "coredns" AND type = "deployment") OR (name = "kube-root-ca.crt" AND type = "configmap")

```

### Wildcard

You can use `*` as a full wildcard in a component filter. It isn't possible to filter for partial matches using a wildcard character.

### Examples

```text
# Select all components
name = "*"

# Select all components with name "etcd-manager"
name = "etcd-manager"

# Select all components in the "Containers" layer:
layer = "Containers"

# Select all components named either "etcd-manager" or "coredns" that don't have a label "cluster-name:prod.stackstate.io"
name IN ("etcd-manager","coredns") NOT label = "cluster-name:prod.stackstate.io"

# Select all components named "coredns" that don't have a label "bck" or "test"
name = "cert-manager" NOT label in ("image_name:cert-manager/cert-manager-controller:testA", "image_name:cert-manager/cert-manager-controller:testB")
```

## Functions

### withNeighborsOf

The function withNeighborsOf extends STQL query output, adding connected components in the specified direction\(s\). The number of topology levels included can be adjusted up to a maximum of 15.

`withNeighborsOf(components=(), levels=, direction=)`

To be compatible with basic filtering, the function can only be combined with other filters using an `OR` operator. When an advanced filter includes a function `withNeighborsOf` that's compatible with basic filtering, the number of components whose neighbors are queried for is shown in the [**Other filters** box](../../use/views/k8s-filters.md#other-filters).

#### Parameters / fields

| Parameter | Default | Allowed values | Description |
| :--- | :--- | :--- | :--- |
| `components` | "all" | A component filter | The component\(s\) for which the neighbors will be returned, see [component filters](#component-filters). |
| `levels` | 1 | "all", \[1:14\] | The number of levels to include in the output. Use "all" to display all available levels \(maximum 15\) |
| `direction` | "both" | "up", "down", "both" | **up**: only components that depend on the named component\(s\) will be added  **down**: only dependencies of the named component\(s\) will be added  **both**: components that depend on and dependencies of the named component\(s\) will be added. |

#### Example

The example below will return all components in the application layer that have a health state of either `DEVIATING` or `CRITICAL`. Components with names "appA" or "appB" and their neighbors will also be included.

```text
layer = "Containers"
  AND (healthstate = "CRITICAL" OR healthstate = "DEVIATING")
  OR withNeighborsOf(components = (name in ("cert-manager","coredns")))
```

## Compatibility basic and advanced filters

### Basic to advanced filtering

You can switch from basic to advanced filtering by selecting **Advanced** under **Filter Topology** in the **View Filters** panel.

It's always possible to switch from basic to advanced filtering. The selected basic filters will be converted directly to an STQL query.

### Advanced to basic filtering

You can switch from advanced to basic filtering by selecting **Basic** under **Filter Topology** in the **View Filters** panel.

It isn't always possible to switch from advanced filtering to basic filtering. Mpst simple queries can be converted to basic filters, however, some advanced queries aren't compatible with basic filters.

* Basic filters can't contain an inequality.
* Basic filters don't use `=`, they're always formatted using the `IN` operator. For example `name IN ("cert-manager”)` and not `name = "cert-manager”`.
* Basic filters use AND/OR in a specific way:
  - All items in each basic filter box are joined with an **OR**: `layer IN ("Containers", "Services", "Storage")`
  - The different basic filter boxes are chained together with an **AND**: `layer IN ("Containers") AND domain IN ("cluster.test.stackstate.io”)`
  - The **Include components** basic filter box (`name`) is the exception - this is chained to the other filter boxes with an OR: `layer IN ("Containers") AND domain IN ("cluster.test.stackstate.io") OR name IN ("cert-manager”)`
  - To be compatible with basic filtering, the **withNeighborsOf** function and **identifier** filter must be joined to other filters with an **OR**: `layer in ("Containers") OR identifier IN ("urn:kubernetes:/cluster.test.stackstate.io:kube-system:pod/cert-manager-7749f44bb4-vspjj:container/cert-manager")`

If you try to switch from an advanced filter to a basic filter and the query isn't compatible, StackState will ask for confirmation before removing the incompatible filters. To keep the filters, you can choose to stay in advanced filtering.

## See also

* [Basic topology filters](../../use/views/k8s-filters.md#basic-topology-filters)
* [Topology filter limits](../../use/views/k8s-filters.md#topology-filtering-limits)
* [How to filter topology in the StackState UI](../../use/views/k8s-filters.md)

