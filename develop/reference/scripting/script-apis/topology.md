---
description: StackState Self-hosted v4.6.x
---

{% hint style="warning" %}
**This page describes StackState version 4.6.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/develop/reference/scripting/script-apis/topology).
{% endhint %}

\

# Topology - script API

## Function `query`

Query the topology at any point in time. Builder methods available for extracting components, relations and comparing topological queries.

```text
Topology.query(query: String)
```

**Args:**

* `query` - a [STQL query](../../stql_reference.md).

**Returns:**

`AsyncScriptResult[TopologyScriptApiQueryResponse]`

**Builder methods:**

* `at(time: Instant or Timeslice)` - specifes a [time](time.md) for which the query should be executed. 
  * Use an `instant` to query for transactions that started at a specific timestamp including at any point in the past. 
  * Use the `currentTimeslice` to query for all transactions currently started or in progress.
* `repeatAt(time: Instant)` - repeats the same query but at a different exact [time](time.md).
* `diff(queryResult: TopologyScriptApiQueryResponse)` - compares this query with another query. A query should be the result of a call to this function.
* `diffWithPrev(queryResult: TopologyScriptApiQueryResponse)` - compares this query with the last query in the chain. A query should be the result of a call to this function. This builder method is only available after the `diff` builder method was called.
* `components()` - returns a summary of the components. After this builder method no more builder methods can be called.
* `fullComponents()` - returns the component with all their data. After this builder method no more builder methods can be called.
* `problems()` - returns problems for a given query along with the root cause and its contributing problems.
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

* Get all the names of components from the test environment using [`thenCollect`](../async_script_result.md#transforming-a-list-using-thencollect):

  ```text
  Topology.query('environments in ("test")')
    .components()
    .thenCollect { it.name }
  ```

* Get the first root problem's first failing check - likely a major root cause of a problem in the queried topology:

  ```text
    Topology
    .query('environments in ("test")')
    .problems()
    .then{ problems -> 
        problems.isEmpty()? null : problems[0].failingCheckNames[0] 
    }
  ```

