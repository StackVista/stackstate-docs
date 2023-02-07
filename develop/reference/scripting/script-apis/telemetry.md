---
description: StackState Self-hosted v5.1.x 
---

# Telemetry - script API

Telemetry queries specify how metric data should be aggregated.  These can be used to define [monitors](/use/checks-and-monitors/monitors.md) and [metric bindings](/use/metrics/metric_bindings.md).

{% hint style="warning" %}
Telemetry queries only support metric queries. If you need event queries, please enter a feature request at [support.stackstate.com](https://support.stackstate.com)
{% endhint %}

## Function: `Telemetry.promql(query: String)`

Querying metric data can be done with a language that is backwards-compatible with [PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/).

### Query language

A few extensions to the basic PromQL language are available, inspired by [Grafana](https://grafana.com/docs/grafana/latest/datasources/prometheus/) and [MetricsQL](https://docs.victoriametrics.com/MetricsQL.html).

* aggregation functions take an optional `limit` modifier that specifies how many results are returned at most
* it is not necessary to specify a range when creating a *range vector*.  The default range is the *step* size, specified when executing the query
* some template variables, familiar to Grafana users, are available to let queries adapt to execution parameters

#### Template variables

* `${__interval}` - the value depends on the step size, but always being bigger than twice the *scrape interval*. This allows all data to be used in rollup functions (like `*_over_time`), independently of the step size.
* `${__rate_interval}` - the value also depends on the step size, but always being bigger than 4 times the *scrape interval* and step size plus at least one *scrape interval*.  This is intended to be used with (rollup) functions that calculate rates of change, like `rate` and `increase`.  Using `${__rate_interval}` makes sure that there is always a value when zooming in (a small step size) and every value change occurs in at least one range (with big step sizes).

### Builder methods

Time can be specified in a few ways:
* *absolute*: by an object of type [`Instant`](time.md), it's `Long` (millis since epoch) or `String` representation
* *relative to the current time*: as a `String` matching `[+-][0-9]+[smhdw]`

Methods available on the PromQL query builder:
* `start(t)` - start time of the range of data
* `step(d)` - duration of a time step specified as a `String` matching `[0-9]+[smhdw]`
* `end(t)` - (optional) end time of the range of data - *now* when not specified
* `window(start, end)` - (optional) specify start and end time together
* `unit(s)` - (optional) unit of measurement; used in the UI to display sensible labels
* `description(s)` - (optional) description of the metrics returned by the query

### Examples
- [Total CPU usage over the last 15 minutes, per container and host:](#total-cpu-usage-over-the-last-15-minutes-per-container-and-host)
- [Process the StreamingScriptResult result data, getting the ids of the resulting time series](#process-the-streamingscriptresult-result-data-getting-the-ids-of-the-resulting-time-series)
- [Get raw metric by query](#get-raw-metric-by-query)
- [Get quantile of metric with bucket size 1 minute](#get-quantile-of-metric-with-bucket-size-1-minute)
- [Query metrics within time range starting 3 hours ago up to 1 hour ago](#query-metrics-within-time-range-starting-3-hours-ago-up-to-1-hour-ago)
- [Limit the number of points returned](#limit-the-number-of-points-returned)
- [Calculate rate of change](#calculate-rate-of-change)

#### Total CPU usage over the last 15 minutes, per container and host:

  {% tabs %}
  {% tab title="Query" %}
  ```groovy
  Telemetry
    .promql("sum by (sts_host,kube_container_name) (docker_cpu_usage[15m])")
    .start("-5m")
    .step("1m")
  ```
  {% endtab %}
  {% tab title="Example JSON output" %}
  ```json
  [{
    "_type": "MetricTimeSeriesResult",
    "query": {
      "_type": "PromqlMetricQuery",
      "query": "sum by (sts_host,kube_container_name) (docker_cpu_usage[15m])",
      "startTime": 1673456145933,
      "step": 60000
    },
    "timeSeries": {
      "_type": "TimeSeries",
      "annotations": [],
      "id": {
        "_type": "TimeSeriesId",
        "elementId": null,
        "groups": {
          "kube_container_name": "alertmanager",
          "sts_host": "i-05d1ff78ba28cad74"
        }
      },
      "points": [
        [ 1673456100000, 0.274122028626 ],
        [ 1673456160000, 0.300760551062 ],
        [ 1673456220000, 0.269277321161 ],
        [ 1673456280000, 0.286609625284 ],
        [ 1673456340000, 0.287780892103 ],
        [ 1673456400000, 0.268471193804 ]
      ],
      "tags": []
    }
  },
  {
    "_type": "MetricTimeSeriesResult",
    "query": {
      "_type": "PromqlMetricQuery",
      "query": "sum by (sts_host,kube_container_name) (docker_cpu_usage[15m])",
      "startTime": 1673456145933,
      "step": 60000
    },
    "timeSeries": {
      "_type": "TimeSeries",
      "annotations": [],
      "id": {
        "_type": "TimeSeriesId",
        "elementId": null,
        "groups": {
          "kube_container_name": "alertmanager",
          "sts_host": "i-0e77e44af7ceec0b9"
        }
      },
      "points": [
        [ 1673456100000, 0.334061492382 ],
        [ 1673456160000, 0.374827266571 ],
        [ 1673456220000, 0.428966416951 ],
        [ 1673456280000, 0.292552082547 ],
        [ 1673456340000, 0.404165248034 ],
        [ 1673456400000, 0.357563059397 ]
      ],
      "tags": []
    }
  }]
  ```
  {% endtab %}


#### Process the [StreamingScriptResult](../streaming-script-result.md) result data, getting the ids of the resulting time series

  {% tabs %}
  {% tab title="Query" %}
  ```groovy
  Telemetry
    .promql("sum by (sts_host,kube_container_name) (docker_cpu_usage[15m])")
    .start("-5m")
    .step("1m")
    .then { it.timeSeries.id }
  ```
  {% endtab %}
  {% tab title="Example JSON output" %}
  ```json
  [{
    "_type": "TimeSeriesId",
    "elementId": null,
    "groups": {
      "kube_container_name": "spotlight",
      "sts_host": "i-0d31c502c50fb56e7"
    }
  }, {
    "_type": "TimeSeriesId",
    "elementId": null,
    "groups": {
      "kube_container_name": "server",
      "sts_host": "i-032a4fec678ef4026"
    }
  }]
  ```
  {% endtab %}
  {% endtabs %}

#### Get raw metric by query
  ```groovy
  Telemetry
    .promql("system_load_1{sts_host='host1'}")
    .start("-5m")
    .step("1m")
  ```

#### Get quantile of metric with bucket size 1 minute
  ```groovy
  Telemetry
    .promql("quantile_over_time(0.99, system_load_1{sts_host='host1'})")
    .start("-10m")
    .step("1m")
  ```

#### Query metrics within time range starting 3 hours ago up to 1 hour ago

  ```groovy
  Telemetry
    .promql("system_load_1{sts_host='host1'}")
    .window("-3h", "-1h") // from 3 hours ago to 1 hour ago
  ```

#### Limit the number of points returned

  ```groovy
  Telemetry
    .promql("max by (sts_host) (system_load_1) limit 20")
    .start("-1h")
    .step("1m")
  ```

#### Calculate rate of change

  ```groovy
  Telemetry
    .promql("rate(kubernetes_memory_requests[${__rate_interval}])")
    .start("-1h")
    .step("1m")
  ```


### High-cardinality metrics

For high-cardinality metrics, the number of time steps that can be retrieved at once is limited.  So it may happen that a query executed as an instance query returns more time series than when it is interpreted as a range query.  The way to fix this is to make the [time series selector](https://prometheus.io/docs/prometheus/latest/querying/basics/#time-series-selectors) more specific, by adding additional label matchers.

## (Deprecated) Function: `Telemetry.query(dataSourceName: String, query: String)`

A telemetry query is a conjunction of equality conditions. For example, `name = 'system.load.norm.15' and host='localhost'`. There are several builder methods available that help to refine the query time range, limit the number of points returned, or set a metric field.

### Args

* `dataSourceName` - name of the data source.
* `query` - set of equality conditions.

### Returns

{% hint style="info" %}
The output format of the Telemetry API changed in StackState v5.0. If you are running an earlier version of StackState, see the documentation for [StackState v4.6 documentation \(docs.stackstate.com/v/4.6\)](https://docs.stackstate.com/v/4.6/develop/reference/scripting/script-apis/telemetry).
{% endhint %}

`StreamingScriptResult[MetricTimeSeriesResult]`

### Builder methods

* `.groupBy(fieldName: String)` - optional. Used to return grouped results from Elasticsearch. Requires `.aggregation()` to be used. If there is no aggregation, a plain metric stream will be returned.
* `aggregation(method: String, bucketSize: String)` - returns aggregated telemetry using `method` and `bucketSize`. See the [available aggregation methods](/use/metrics/add-telemetry-to-element.md#aggregation-methods).
* `start(time: Instant)` - sets the [start time](time.md) of the query, for example `-3h`.
* `end(time: Instant)` - sets the [end time](time.md) of the query, for example `-1h`.
* `window(start: Instant, end: Instant)` - sets query [time range](time.md). Use only `start` to get all telemetry up to now or only `end` to get all telemetry up to an instant in time.
* `limit(points: Int)` - limits the number of points returned, applicable to non-aggregated queries.
* `metricField(fieldName: String)` - optional, but may be required for some data sources. Sets a field that holds metric value. 
* `compileQuery()` - returns the telemetry query that was created with this function and the builder methods. After this builder method no more builder methods can be called.

### Examples

- [Get metrics aggregated using Mean with bucket size 15 minutes and grouped by the field `host`:](#get-metrics-aggregated-using-mean-with-bucket-size-15-minutes-and-grouped-by-the-field-host)
- [Process the StreamingScriptResult result data, getting the ids of the resulting time series](#process-the-streamingscriptresult-result-data-getting-the-ids-of-the-resulting-time-series-1)

#### Get metrics aggregated using Mean with bucket size 15 minutes and grouped by the field `host`: 
  
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

#### Process the [StreamingScriptResult](../streaming-script-result.md) result data, getting the ids of the resulting time series

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

## See also

* [Streaming script result](../streaming-script-result.md)
