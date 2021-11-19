---
description: Pull telemetry from existing telemetry sources using the concept of mirroring.
---

# Mirroring Telemetry

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

Mirroring is a way to connect StackState to third-party telemetry data sources. In the case of mirroring StackState does not require the telemetry to be present within StackState's telemetry data source, but will retrieve the telemetry whenever it needs it. This means you can work with existing telemetry as if it were just a part of the 4T data model.

### When to use mirroring

Mirroring has some major _advantages_:

* Cost savings on both storage and bandwidth.
* Data access is always fresh.
* All data is always available; in some cases throttling limits may prevent all data from being transferred, so mirroring is the only viable option.

There are however also some _disadvantages_:

* Availability and retention of the data depends on the availability and retention of the data source.
* If StackState requires streaming data it is forced to start polling data from the data source. When dealing with lots of streaming data, the limits that made mirroring a good idea in the first place now cause the same problems.
* StackState has to make an outgoing connection to the mirror, which means that you will have to allow StackState to access your mirror. In order to secure these connections, firewalls rules may need to be configured. Especially in large enterprise this may cause installation delays.

If you wish to use mirroring, but need a solution to any of the above disadvantages we recommend that you [contact us](http://support.stackstate.com).

To get started with mirroring, have a look at our [mirroring tutorial](../tutorials/mirror_tutorial.md).

## Mirror Architecture

Before mirroring StackState used to work with a plugin system to allow it to work with third-party telemetry data sources. Still some telemetry sources are accessed via the custom plugin method, but over time these will be deprecated in favor of the mirroring architecture, which builds on the plugin architecture.

Mirroring is performed using two components: the `Mirror Plugin` and a remote telemetry system called the `Mirror`. The Mirror Plugin is a StackState plugin configured to talk to the Mirror. The plugin requires the Mirror to implement the Mirror REST API. In its turn, the Mirror acts as a gateway to the target telemetry system and is implemented as a webserver.

The StackState instance has to be able to open a connection to the mirror. There is some work planned to use the agent to reverse the connection, but this is not available as of yet.

The Mirror is intended to be stateless and to proxy StackState requests to the target telemetry system. The Mirror can be implemented in any technology or programming language. The only requirement is that it implements the Mirror REST API described below.

## Mirror REST API

The Mirror API consists of 4 methods:

* Test Connection
* Get Field Names
* Get Field Values
* Get Metric Values

All the requests are POST requests and input/output is passed in the JSON body of the request or response.

### Common Request Information

Each request JSON contains a number of fields. The following fields are common:

* Connection Details
* Query Equality Conditions
* Time Range
* Result Set Limit

#### Connection Details

The field `connectionDetails` is mandatory and must be present in each request. The field contains arbitrary JSON configuration for connecting to the target system. This is a flexible configuration, and it is up to the Mirror implementor to decide what configuration elements are required. For example, a target telemetry source URL, timeouts, API key, and many others.

Example:

```text
  ...
  "connectionDetails" : {
        "port": 9900,
        "host": "prometheus.local.com",
        "requestTimeout": 15000,
        "nan_interpretation": "ZERO"
  }
  ...
```

#### Query Equality Conditions

Query Conditions are used to select a subset of the telemetry from the target telemetry system. Query Conditions are a list of equality conditions interpreted as a conjunction of equality statements, i.e. all conditions are interpreted as a logical `AND`.

Please see the example below:

```text
    ...
   "conditions": [
        {"key":"stringField", "value": { "value": "foobar", "_type": "StringValue" }, "_type": "EqualityCondition" },
        {"key":"doubleField", "value": { "value": 42.0, "_type": "DoubleValue" }, "_type": "EqualityCondition" },
        {"key":"booleanField", "value": { "value": true, "_type": "BooleanValue" }, "_type": "EqualityCondition" }
    ],
    ...
```

The equality condition consists of the key and value. The `key` is of type string, and it contains the name of the variable/field/label in the remote monitoring system. The `value` is a JSON object that contains the actual value of one of three types: string, double or boolean.

#### Time Range

The time range parameters are `startTime` and `endTime`, each holding a timestamp in epoch milliseconds indicating the query date range.

```text
    ...
    "startTime": 1504174208940,
    "endTime": 1504347008940,    
    ...
```

#### Result Set Limit

The field "limit" asks the Mirror to return only a subset of the results.

```text
    ...
    "limit": 42,
    ...
```

### Common Response Information

The Mirror is expected to reply with the header `X-MIRROR-API-KEY` and the StackState Mirror Plugin should compare it with the API key configured in the StackState server.

## Method: Test Connection

This API is a way to test the connection with the remote telemetry system.

```text
Path: api/connection
```

Sample request:

```text
{
  "_type": "TestConnectionRequest",
  "connectionDetails" : {
    "port": 9900,
    "host": "prometheus.local.com",
    "requestTimeout": 15000,
    "nan_interpretation": "ZERO"
  }
}
```

If the Mirror can successfully connect to the remote telemetry system, it should reply with the following success response:

```text
{"status": "OK", "_type": "TestConnectionResponse"}
```

In case there was an error while connecting to the remote telemetry system, the Mirror should return a failure response:

```text
{
  "status": "FAILURE",
  "error": {"_type": "MetricStoreConnectionError", "details": "Prometheus is not healthy."},
  "_type": "TestConnectionResponse"
}
```

The error field may contain more detailed error information.

## Method: Field Names

This API retrieves field names from the remote telemetry system.

```text
Path: api/field/name
```

Sample request:

```text
{
    "connectionDetails": { "host": "localhost", "port": 9000, "requestTimeout": 15000 },
    "query": {
        "conditions": [
            {"key":"stringField", "value": { "value": "foobar", "_type": "StringValue" }, "_type": "EqualityCondition" },
            {"key":"doubleField", "value": { "value": 42.0, "_type": "DoubleValue" }, "_type": "EqualityCondition" },
            {"key":"booleanField", "value": { "value": true, "_type": "BooleanValue" }, "_type": "EqualityCondition" }
        ],
        "startTime": 1504174208940,
        "endTime": 1504347008940,
        "limit": 2147483647,
        "latestFirst": true,
        "_type": "FieldNamesQuery"
    },
    "_type": "FieldNamesRequest"
}
```

The `FieldNamesRequest` request type contains a `FieldNamesQuery` object. The query object contains `conditions`, `startTime`, `endTime`, and `limit` acting as a filter for the result field list. These parameters help the user to do continuous refinement of available field names during configuration of a telemetry stream.

A successful response should contain the list of field descriptors for the fields in the format below:

```text
{
  "fields": [
    {"_type": "FieldDescriptor", "classified": false, "fieldName": "field1", "fieldType": "STRING"},
    {"_type": "FieldDescriptor", "classified": false, "fieldName": "field2", "fieldType": "BOOLEAN"},
    {"_type": "FieldDescriptor", "classified": false, "fieldName": "field3", "fieldType": "DOUBLE"}
  ],
  "isPartial": false,
  "_type":"FieldNamesResponse"
}
```

The interpretation of the field descriptor is given below:

* `fieldName` - the name of the field.
* `fieldType` - one of three `STRING`, `NUMBER`, `BOOLEAN`
* `classified` - indicates that special care need to be taken when logging or displaying the values of this field.

## Method: Field Values

This API retrieves field values from the remote monitoring system.

```text
Path: api/field/value
```

Sample request:

```text
{
    "connectionDetails": {
        "host": "localhost",
        "port": 9000,
        "requestTimeout": 15000
    },
    "query": {
        "conditions": [
            {"key": "stringField", "value": { "value": "foobar", "_type": "StringValue" }, "_type": "EqualityCondition" }
        ],
        "field": { "fieldName": "string", "fieldType": "STRING", "classified": false, "_type": "FieldDescriptor"},
        "fieldValuePrefix": "cpu.",
        "startTime": 1504174208940,
        "endTime": 1505124608940,
        "limit": 2147483647,
        "offset": 0,
        "latestFirst": true,
        "_type": "FieldValuesQuery"
    },
    "_type":"FieldValuesRequest"
}
```

The FieldValuesResponse holds the list of possible values:

```text
{
    "values": [
        {"value": "value1", "_type": "CompleteValue"},
        {"value": "cpu.*", "_type": "FieldValuePattern"}
    ],
    "isPartial": false,
    "_type":"FieldValuesResponse"
}
```

There are two types of values: `CompleteValue`, and `FieldValuePattern`. The `CompleteValue` indicates that the `value` field contains a full value token. The `FieldValuePattern` specifies the partial value that can be used as a `fieldValuePrefix` in subsequent refinement requests.

## Method: Get Metric Values

The Get Metric Values API allows fetching metric values.

```text
Path: api/metric
```

There are two types of metric queries: raw and aggregated.

Sample raw metric request:

```text
{
    "connectionDetails": { "host": "localhost", "port": 9000, "requestTimeout": 15000 },
    "query": {
        "conditions": [
            {"key": "string", "value": {"value": "stringValue2", "_type": "StringValue"}, "_type": "EqualityCondition"},
            {"key": "double", "value": {"value": 2.0, "_type": "DoubleValue"}, "_type": "EqualityCondition"},
            {"key": "boolean", "value": {"value": true, "_type": "BooleanValue"}, "_type": "EqualityCondition"}
        ],
        "startTime": 1504400400000,
        "endTime": 1504411200000,
        "metricField": "rawValue",
        "limit": 100500,
        "_type": "MetricsQuery"
    },
    "_type": "MetricsRequest"
}
```

A raw metric request is executed when one wants to fetch raw \(non aggregated\) values from the remote telemetry system. The Mirror can recognize this query by the absence of the optional `aggregation` object in the `query` field. Besides common fields, there is a `metricField` which optionally indicates the source field for metric values.

An example response of the raw metric query is given below:

```text
{
    "telemetry": {
        "points": [
            [1.0, 1555408501000],
            [2.0, 1555408601000],
            [3.0, 1555408701000]
        ],
        "dataFormat": ["value", "timestamp"],
        "isPartial": false,
        "_type": "RawMetricTelemetry"
    },
    "_type": "MetricsResponse"
}
```

The fields have the following meaning:

* the `points` list contains several sublists each representing one data point
* the field name positions of values in the data point sublist is specified by the `dataFormat` field
* the field `isPartial` indicates if the response has been truncated either by application of the `limit` field or by the telemetry store itself. In this case, the user should take action and execute another metric request specifying the last point timestamp as `request`.`query`.`startTime` to retrieve truncated values.

Sample aggregated metric request:

```text
{
    "connectionDetails": { "host": "localhost", "port": 9000, "requestTimeout": 15000 },
    "query":{
        "conditions":[
            {"key":"string", "value": {"value": "stringValue2", "_type":"StringValue"}, "_type": "EqualityCondition"},
            {"key":"double", "value": {"value": 2.0, "_type":"DoubleValue"}, "_type": "EqualityCondition"},
            {"key":"boolean", "value": {"value": true, "_type":"BooleanValue"}, "_type": "EqualityCondition"}
        ],
        "aggregation": {
            "method": "MAX",
            "bucketSizeMillis": 3600000,
            "_type": "Aggregation"
        },
        "startTime": 1504400400000,
        "endTime": 1504411200000,
        "metricField": "double",
        "limit": 100500,
        "_type": "MetricsQuery"
    },
    "_type": "MetricsRequest"
 }
```

The request is the same as for raw query with one exception, The `aggregation` field is not empty and holds the aggregation `method` and aggregation bucket size `bucketSizeMillis`. The aggregation is done using the batching windowing method.

The following aggregation methods are supported by the Mirror Plugin:

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

An example response of an aggregated query request is given below:

```text
{
    "telemetry": {
        "points": [
            [1.0, 1555408501000, 1555408511000],
            [2.0, 1555408601000, 1555408611000],
            [3.0, 1555408701000, 1555408711000]
        ],
        "dataFormat": ["value", "startTimestamp", "endTimestamp"],
        "isPartial": false,
        "_type": "AggregatedMetricTelemetry"
    },
    "_type": "MetricsResponse"
}
```

The fields have the same meaning as for the raw metric query. The only difference is that the `points` sublists contain `startTimestamp` and `endTimestamp` fields indicating aggregated bucket start and stop time. The positions are specified in the `dataFormat` format field.

### Error responses

In case of a Mirror request failure the Mirror may reply with the following errors:

* Remote metric system connection issues

  ```text
  {
  "_type": "MetricStoreConnectionError",
  "details": "Unable to connect to remote metrics store."
  }
  ```

* Metric not found error

  ```text
  {
  "_type": "MetricNotFoundError",
  "metric": "service_request_seconds"
  "details": "Metric is not configured."
  }
  ```

* Mirror or remote metric system does not support metric type

  ```text
  {
  "_type": "UnsupportedFieldTypeError",
  "mirrorType": "BOOLEAN"
  }
  ```

* If the failure does not fall into any previous category then mirror can return generic `RemoteMirrorError`.

  ```text
  {
  "_type": "RemoteMirrorError",
  "summary": "Arbitrary remote error summary"
  "details": "Arbitrary remote error details"
  }
  ```
