---
title: Script API - Telemetry
kind: Documentation
description: Functions for accessing telemetry.
---

# Telemetry - script API

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Function `query`

A telemetry query is a conjunction of equality conditions. E.g. `name = 'system.load.norm.15' and host='localhost'`. There are several builder methods available that help to refine query time range, limit the number of points returned, or set a metric field.

```text
Telemetry.query(dataSourceName: String, query: String)
```

{% hint style="warning" %}
As of yet telemetry queries only support metric queries. If you need event queries please enter a feature request at [support.stackstate.com](https://support.stackstate.com)
{% endhint %}

**Args:**

* `dataSourceName` - name of the data source.
* `query` - set of equality conditions.

**Returns:**

`AsyncScriptResult[TelemetryScriptApiQueryResponse]`

**Builder methods:**

* `aggregation(method: String, bucketSize: String)` - returns aggregated telemetry using `method` and `bucketSize`.
* `start(time: Instant)` - sets the start [time](time.md) of the query, for example `-3h`.
* `end(time: Instant)` - sets the end [time](time.md) of the query, for example `-1h`.
* `window(start: Instant, end: Instant)` - sets query [time](time.md) range. Use only `start` to get all telemetry up to now or only `end` to get all telemetry up to an instant in time.
* `limit(points: Int)` - limits the number of points returned, applicable to none aggregated queries.
* `metricField(fieldName: String)` - sets a field that holds metric value.
* `compileQuery()` - returns the telemetry query that was created with this function and the builder methods. After this builder method no more builder methods can be called.

**Examples:**

* Get raw metric by query

  ```text
  Telemetry.query("Sts Metrics", "name='system.load.norm.15' and host='localhost'")
  ```

* Get metric aggregated using Mean during with bucket size 1 minute:

  ```text
  Telemetry.query("Sts Metrics", "name='system.load.norm.15' and host='localhost'").aggregation("MEAN", "1m")
  ```

* Query metrics starting 3 hours ago till now:

  ```text
  Telemetry.query("Sts Metrics", "name='system.load.norm.15' and host='localhost'").start("-3h")
  ```

* Query metrics starting beginning of the data till last hour ago:

  ```text
  Telemetry.query("Sts Metrics", "name='system.load.norm.15' and host='localhost'").end("-1h")
  ```

* Query metrics within time range starting 3 hours ago up to 1 hour ago:

  ```text
  Telemetry.query("Sts Metrics", "name='system.load.norm.15' and host='localhost'").window("-3h", "-1h")
  ```

* Query metrics from field "value" and limits points returned:

  ```text
  Telemetry.query("Sts Metrics", "name='system.load.norm.15' and host='localhost'").metricField("value").limit(100)
  ```

