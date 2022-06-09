---
description: StackState Self-hosted v5.0.x
---

# Telemetry - script API

## Function `query`

A telemetry query is a conjunction of equality conditions. For example, `name = 'system.load.norm.15' and host='localhost'`. There are several builder methods available that help to refine the query time range, limit the number of points returned, or set a metric field.

```text
Telemetry.query(dataSourceName: String, query: String)
```

{% hint style="warning" %}
Telemetry queries only support metric queries. If you need event queries, please enter a feature request at [support.stackstate.com](https://support.stackstate.com)
{% endhint %}

**Args:**

* `dataSourceName` - name of the data source.
* `query` - set of equality conditions.

**Returns:**

`StreamingScriptResult[MetricTimeSeriesResult]`

**Builder methods:**

* `.groupBy(fieldName: String)` - optional. Used to return grouped results from Elasticsearch. Requires `.aggregation()` to be used. If there is no aggregation, a plain metric stream will be returned.
* `aggregation(method: String, bucketSize: String)` - returns aggregated telemetry using `method` and `bucketSize`. See the [available aggregation methods](/use/metrics-and-events/add-telemetry-to-element.md#aggregation-methods).
* `start(time: Instant)` - sets the [start time](time.md) of the query, for example `-3h`.
* `end(time: Instant)` - sets the [end time](time.md) of the query, for example `-1h`.
* `window(start: Instant, end: Instant)` - sets query [time range](time.md). Use only `start` to get all telemetry up to now or only `end` to get all telemetry up to an instant in time.
* `limit(points: Int)` - limits the number of points returned, applicable to none aggregated queries.
* `metricField(fieldName: String)` - optional, but may be required for some data sources. Sets a field that holds metric value. 
* `compileQuery()` - returns the telemetry query that was created with this function and the builder methods. After this builder method no more builder methods can be called.

**Examples:**

* Get metrics aggregated using Mean with bucket size 15 minutes and grouped by the field `host`: 
  
  {% tabs %}
  {% tab title="Query" %}
  ```text
  Telemetry
    .query("StackState Multi Metrics", "")
    .groupBy("host")
    .metricField("jvm_threads_current")
    .start("-15m")
    .aggregation("mean", "15m")
  ```
  {% endtab %}
  {% tab title="Example JSON output" %}
  ```text
  [{
    "_type": "MetricTimeSeriesResult",
    "query": {
      "_type": "TelemetryMetricQuery",
      "aggregation": {
        "bucketSize": 900000,
        "method": "MEAN"
      },
      "conditions": [
        {
          "key": "name",
          "value": "jvm_threads_current"
        }
      ],
      "dataSourceId": 277422153298283,
      "endTime": 1643294849765,
      "groupBy": {
        "fields": ["host"]
      },
      "includeAnnotations": false,
      "metricField": "stackstate.jvm_threads_current",
      "startTime": 1643293949765
    },
    "timeSeries": {
      "_type": "TimeSeries",
      "annotations": [],
      "id": {
        "_type": "TimeSeriesId",
        "groups": {
          "host": "sts-kafka-to-es-multi-metrics_generic-events_topology-events_state-events_sts-events"
        }
      },
      "points": [[1643293800000, 49.46666666666667]],
      "tags": []
    }
  },
  {
    "_type": "MetricTimeSeriesResult",
    "query": {
      "_type": "TelemetryMetricQuery",
      "aggregation": {
        "bucketSize": 900000,
        "method": "MEAN"
      },
      "conditions": [
        {
          "key": "name",
          "value": "jvm_threads_current"
        }
      ],
      "dataSourceId": 277422153298283,
      "endTime": 1643294849765,
      "groupBy": {
        "fields": ["host"]
      },
      "includeAnnotations": false,
      "metricField": "stackstate.jvm_threads_current",
      "startTime": 1643293949765
    },
    "timeSeries": {
      "_type": "TimeSeries",
      "annotations": [],
      "id": {
        "_type": "TimeSeriesId",
        "groups": {
          "host": "sts-kafka-to-es-trace-events"
        }
      },
      "points": [[1636293800000, 54.7]],
      "tags": []
    }
  }]
  ```
  {% endtab %}
  {% endtabs %}

* Processing the [StreamingScriptResult](./../streaming_script_result.md) result data, getting the ids of the resulting timeSeries:

  {% tabs %}
  {% tab title="Query" %}
  ```text
  Telemetry
    .query("StackState Multi Metrics", "")
    .groupBy("host")
    .metricField("jvm_threads_current")
    .start("-15m")
    .aggregation("mean", "15m")
    .then { it.timeSeries.id }
  ```
  {% endtab %}
  {% tab title="Example JSON output" %}
  ```text
  [
    {
      "_type": "TimeSeriesId",
        "groups": {
          "host": "sts-kafka-to-es-multi-metrics_generic-events_topology-events_state-events_sts-events"
        }
      },
      {
        "_type": "TimeSeriesId",
          "groups": {
            "host": "sts-kafka-to-es-trace-events"
          }
      }
    }
  ]
  ```
  {% endtab %}
  {% endtabs %}

* Get raw metric by query
  ```text
  Telemetry
    .query("StackState Metrics", "name='system.load.norm' and host='host1'")
    .metricField("value")
  ```

* Get metric aggregated using Mean with bucket size 1 minute:
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

## See also

* [Streaming script result](./../streaming_script_result.md)