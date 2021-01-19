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

If you have [permission](configure/security/rbac/rbac_permissions.md) to access the analytics menu (default for all power users and admins) then you can access the analytics environment from the main menu. There are also places in the user-interface where you can be directed to analytical environment if some data is available in the form of a query, a link will then say "Open in Analytics".

The analytics environment is divided into two sections:
 
 * The query you want to execute on the left
 * The results and query history on the right.

When executing a query for the first time, the result of the query is displayed in preview form if a preview is available for the type of data that is requested (e.g. a metric chart or a topology view), otherwise the data will be shown in Json form.

Every query that you've executed while navigating to StackState is shown in the query history with the result at that point in time.  

![Analytics screenshot](/.gitbook/assets/new_analytics.png)

## Previews

Results of queries are typically displayed in raw JSON form, unless there is a preview available. Previews are currently available for:
 
 - Topology query results (see [Topology.query](develop/reference/scripting/script-apis/topology.md#function-query))
 - Telemetry query results (see [Telemetry.query](develop/reference/scripting/script-apis/telemetry.md#function-query))
 - Telemetry predictions (see [Prediction.predictMetrics](develop/reference/scripting/script-apis/prediction.md#function-predictmetrics))
 - STML reports (see [UI.showReport](develop/reference/scripting/script-apis/ui.md#function-showreport))

## Queries

In the analytics environment you use a combination of the [StackState Scripting Language \(STSL\)](develop/reference/scripting/README.md) and the [StackState Query Language \(STQL\)](develop/reference/stql_reference.md) to build your queries and scripts. 

A query is a regular STSL script. For example when you run the query: `1+1` you will get the result `2`.

As a part of a STSL script you can invoke the StackStake Query Language. A simple example of an analytical query that uses both STSL and STQL is:

```
Topology.query('environment in ("Production")').components()
```

[Topology.query](develop/reference/scripting/script-apis/topology.md) is a regular script function which takes a STQL query (`environment in ("Production")`) as an argument. The `.components()` at the end, a so-called builder method, ensures that only the components and not the relations between these components are retrieved from the topology.

The combination of STSL and STQL allows you to chain together multiple queries. The following example gets all metrics of all databases in the production environment of the last day:

```
Topology
    .query('environment in ("Production") AND type = "Database"')
    .components()
    .metricStreams()
    .thenCollect { metricStream -> 
        Telemetry.query(metricStream)
            .aggregation("95th percentile"", "15m")
            .start("-1d")
    }
```

This analytical query first gets all metrics streams of components from the `Production` environment which are of the type `Database`. The result of that query is used to build up telemetry queries against these metric streams.

The full list of available function can be found [here](develop/reference/scripting/script-apis/README.md). Read about [async script results](develop/reference/scripting/async_script_result.md) to learn about chaining.

### Example queries

Below are some queries to get you started with an example of their expected output. You can find more examples in the StackState UI Analytics environment itself.

- [Find the number of relations between two components](#find-the-number-of-relations-between-two-components)
- [Compare the Staging environment to the Production environment](#compare-the-staging-environment-to-the-production-environment)
- [Predict disk space of a server for the next week ](#predict-disk-space-of-a-server-for-the-next-week)

#### Find the number of relations between two components

{% tabs %}
{% tab title="Query" %}
```
Topology.query('name IN ("Alice", "Bob")')
  .relations()
  .count()
```
{% endtab %}
{% tab title="Example result" %}
```
1
```
{% endtab %}
{% endtabs %}

#### Compare the Staging environment to the Production environment

{% tabs %}
{% tab title="Query" %}
```
Topology.query('environment = "Staging"')
    .diff(Topology.query('environment = "Production"'))
    .then { diff ->
        diff
            .diffResults[0]
            .result
            .addedComponents
            .collect { comp -> comp.name }
    }```
{% endtab %}
{% tab title="Example result" %}
```
[
  "customer E_appl02",
  "MobileApp",
  "customer B_appl01",
  "customer E_appl01",
  "customer B_appl02"
]
```
{% endtab %}
{% endtabs %}

#### Predict disk space of a server for the next week 

{% tabs %}
{% tab title="Query" %}
```
Prediction.predictMetrics("linear", "7d",
    Telemetry.query("StackState metrics", 'host="lnx01" AND name="diskspace" AND mount="/dev/disk1s1"')
        .metricField("value")
        .aggregation("min", "1d")
        .start("-4w") // based on last month
        .compileQuery()
).predictionPoints(7).then { result -> resut.prediction  }
```
{% endtab %}
{% tab title="Example result" %}
```
{
    "_type":"MetricTelemetryData",
    "data":[
        [
            52.35911407877176,
            1611091854483
        ],
        [
            51.400303131762215,
            1611092754483
        ],
        [
            48.64705240252446,
            1611093654483
        ],
        [
            49.62017120667122,
            1611094554483
        ],
        [
            49.55251201458979,
            1611095454483
        ],
        [
            54.46042805305259,
            1611096354483
        ],
        [
            48.681355107261204,
            1611097254483
        ],
    ],
    "dataFormat":[
        "value",
        "timestamp"
    ],
    "isPartial":false
}
```
{% endtab %}
{% endtabs %}

## See also

- [Scripting in StackState](/develop/reference/scripting/README.md)
- [StackState script APIs](/develop/reference/scripting/script-apis)
- [StackState Query Language STQL](/develop/reference/stql_reference.md)