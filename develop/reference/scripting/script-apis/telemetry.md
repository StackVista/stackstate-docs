---
description: Functions for accessing telemetry
---

# Telemetry - script API

{% hint style="warning" %}
**This page describes StackState version 4.4.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/develop/reference/scripting/script-apis/telemetry).
{% endhint %}

## Function `query`

A telemetry query is a conjunction of equality conditions. E.g. `name = 'system.load.norm.15' and host='localhost'`. There are several builder methods available that help to refine query time range, limit the number of points returned, or set a metric field.

```text
Telemetry.query(dataSourceName: String, query: String)
```

{% hint style="warning" %}
As of yet, telemetry queries only support metric queries. If you need event queries, please enter a feature request at [support.stackstate.com](https://support.stackstate.com)
{% endhint %}

**Args:**

* `dataSourceName` - name of the data source.
* `query` - set of equality conditions.

**Returns:**

`AsyncScriptResult[TelemetryScriptApiQueryResponse]`

**Builder methods:**

* `aggregation(method: String, bucketSize: String)` - returns aggregated telemetry using `method` and `bucketSize`. See the [available aggregation methods](telemetry.md#aggregation-methods).
* `start(time: Instant)` - sets the [start time](time.md) of the query, for example `-3h`.
* `end(time: Instant)` - sets the [end time](time.md) of the query, for example `-1h`.
* `window(start: Instant, end: Instant)` - sets query [time range](time.md). Use only `start` to get all telemetry up to now or only `end` to get all telemetry up to an instant in time.
* `limit(points: Int)` - limits the number of points returned, applicable to none aggregated queries.
* `metricField(fieldName: String)` - optional, but may be required for some data sources. Sets a field that holds metric value. 
* `compileQuery()` - returns the telemetry query that was created with this function and the builder methods. After this builder method no more builder methods can be called.

**Examples:**

* Get raw metric by query

  ```text
  Telemetry
    .query("StackState Metrics", "name='system.load.norm' and host='host1'")
    .metricField("value")
  ```

* Get metric aggregated using Mean during with bucket size 1 minute:

  ```text
  Telemetry
    .query("StackState Metrics", "name='system.load.norm' and host='host1'")
    .metricField("value")
    .aggregation("99th percentile", "1m") // get 99th percentile of each minute
  ```

* Query metrics starting 3 hours ago till now:

  ```text
  Telemetry
    .query("StackState Metrics", "name='system.load.norm' and host='host1'")
    .metricField("value")
    .start("-3h") // starting from 3 hours ago
  ```

* Query metrics starting beginning of the data till last hour ago:

  ```text
  Telemetry
    .query("StackState Metrics", "name='system.load.norm' and host='host1'")
    .metricField("value")
    .end("-1h") // ending 1 hour ago
  ```

* Query metrics within time range starting 3 hours ago up to 1 hour ago:

  ```text
  Telemetry
    .query("StackState Metrics", "name='system.load.norm' and host='host1'")
    .metricField("value")
    .window("-3h", "-1h") // from 3 hours ago to 1 hour ago
  ```

* Query metrics from field "value" and limits points returned:

  ```text
  Telemetry
    .query("StackState Metrics", "name='system.load.norm' and host='host1'")
    .metricField("value")
    .limit(100)
  ```

## Aggregation methods

The following aggregation methods are available for use with telemetry:

* `MEAN` - mean
* `PERCENTILE_25` - 25 percentile
* `PERCENTILE_50` - 50 percentile
* `PERCENTILE_75` - 75 percentile
* `PERCENTILE_90` - 90 percentile
* `PERCENTILE_95` - 95 percentile
* `PERCENTILE_98` - 98 percentile
* `PERCENTILE_99` - 99 percentile
* `MAX` - maximum
* `MIN` - minimum
* `SUM` - sum
* `EVENT_COUNT` - the number of occurrences during bucket interval
* `SUM_NO_ZEROS` - sum of the values \(missing values from a data source won't be filled with zeros\)
* `EVENT_COUNT_NO_ZEROS` - the number of occurrences during bucket interval \(missing values from a data source won't be filled with zeros\)

