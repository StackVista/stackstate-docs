---
title: Script API - Topology
kind: Documentation
description: Functions for accessing the topology.
---

# Script API: Topology

{% hint style="warning" %}
**This page describes StackState version 4.0.**

The StackState 4.0 version range is End of Life \(EOL\) and **no longer supported**. We encourage customers still running the 4.0 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Function `query`

Query the topology at any point in time. Builder methods available for extracting components, relations and comparing topological queries.

```text
Topology.query(query: String)
```

**Args:**

* `query` - a [STQL query](../../../configure/topology_selection_advanced.md).

**Returns:**

`AsyncScriptResult[TopologyScriptApiQueryResponse]`

**Builder methods:**

* `at(time: Instant)` - sets the exact [time](time.md) at which the query needs to be executed.
* `repeatAt(time: Instant)` - repeats the same query but at a different exact [time](time.md).
* `diff(queryResult: TopologyScriptApiQueryResponse)` - compares this query with another query. A query should be the result of a call to this function.
* `diffWithPrev(queryResult: TopologyScriptApiQueryResponse)` - compares this query with the last query in the chain. A query should be the result of a call to this function. This builder method is only available after the `diff` builder method was called.
* `components()` - returns a summary of the components. After this builder method no more builder methods can be called.
* `fullComponents()` - returns the component with all their data. After this builder method no more builder methods can be called.
* `relations()` - returns a summary of the relations. After this builder method no more builder methods can be called.
* `fullRelations()` - returns the relations with all their data. After this builder method no more builder methods can be called.

**Examples:**

* Get the test environment:

  ```text
  Topology.query('environments in ("test")')
  ```

* Get the test environment yesterday:

  ```text
  Topology.query('environments in ("test")').at('-1d')
  ```

* Get test environment one hour ago, two hours ago and three hours ago.

  ```text
  Topology.query('environments in ("test")').at('-1h').repeatAt('-2h').repeatAt('-3h')
  ```

* Get the component that differ between the test and production environment:

  ```text
  Topology.query('environments in ("test")').diff(Topology.query('environments in ("production")')).components()
  ```

* Get the difference between the test environment one week ago and now:

  ```text
  def q = 'environments in ("test")'
  Topology.query(q).at('-1w').diff(Topology.query(q))
  ```

* Get all the names of components from the test environment:

  ```text
  Topology.query('environments in ("test")')
    .components()
    .thenCollect { it.name }
  ```

