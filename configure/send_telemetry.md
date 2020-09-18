---
title: Send Telemetry
kind: Documentation
aliases:
  - /configuring/send_telemetry/
listorder: 3
---

# Send telemetry

## Overview

StackState can either pull telemetry from a data source or can receive pushed telemetry. Pushed telemetry is stored by StackState, while pulled telemetry is not. Pushed telemetry is stored for the duration of the configured retention period. This page describes how telemetry can be pushed.

There are several ways to send telemetry to StackState. A large number of [integration](../integrations/)s are provided out of the box that may help you get started. If there is no out of the box integration you can send telemetry to StackState using either HTTP or the [CLI](../setup/cli.md).

## Sending telemetry over HTTP

StackState's receiver API is responsible for receiving both telemetry and topology. By default the receiver API is hosted at `https://<baseUrl>:<receiverPort>/stsAgent/intake?api_key=<API_KEY>`. Both the base URL and API\_KEY are

Telemetry is sent to the receiver API via HTTP POST and has a common JSON object for all messages. One message can contain mutliple metrics and multiple events.

```javascript
{
  "collection_timestamp": 1548855554, // int - the epoch timestamp for the collection
  "events": {}, // see section on events
  "internalHostname": "localdocker.test", // string - the host that is sending this data
  "metrics": [], // see section on metrics
  "service_checks": [],
  "topologies": [] // used for sending topological data
}
```

**Note:** Depending on your StackState configuration, metrics or events that are too old will be ignored.

## Metrics

Metrics can be sent to the receiver API using the `metrics` property. Every metric has a `name`, `timestamp`, `value`, `hostname`, `type` and optionally a set of `tags`.

Example of a single metric:

```javascript
[
  "test.metric", // string - name of the metric
  1548857152, // int - the epoch timestamp for the metric
  10.0, // double - value of the metric
  {
    "hostname": "localdocker.test", // string - the host this metric is from
    "tags": [ // (optional) list - a list of tags to associate with this metric. Colon separated key/value pairs.
      "tag_key1:tag_value1",
      "tag_key2:tag_value2"
    ],
    "type": "gauge" // string - type of metric options: gauge, count, rate, counter, raw
  }
]
```

Multiple metrics can be sent in one message. The `timestamp` and `value` of the metric is what is used to plot the metrics as a time series. The `name` and `tags` can be used to define a metric stream in StackState.

curl example:

```javascript
curl -X POST \
 'http://<stackstateURL>/stsAgent/intake?api_key=<API_KEY>' \
 -H 'Content-Type: application/json' \
 -d '{
  "collection_timestamp": 1548857167,
  "events": {},
  "internalHostname": "localdocker.test",
  "metrics": [
    [
      "test.metric",
      1548857152,
      10.0,
      {
        "hostname": "localdocker.test",
        "tags": [
          "tag_key1:tag_value1",
          "tag_key2:tag_value2"
        ],
        "type": "gauge"
      }
    ],
    [
      "test.metric",
      1548857167,
      10.0,
      {
        "hostname": "localdocker.test",
        "tags": [
          "tag_key1:tag_value1",
          "tag_key2:tag_value2"
        ],
        "type": "gauge"
      }
    ]
  ],
  "service_checks": [],
  "topologies": []
}'
```

You can also send metrics to StackState with the CLI `metric send` command.

{% hint style="warning" %}
Metric names cannot start with any of the following prefixes:

* `host`
* `name`
* `timestamp`
* `timeReceived`
* `labels`
* `tags`
* `values`
{% endhint %}

## Events

Events can be sent to the receiver API using the `events` property. Every event has a `name`, `timestamp`, and optionally `msg_title`, `msg_text`, `tags` and `source_type_name`.

Example of a single event:

```javascript
"event.test": [ // string - the event name
  {
    "msg_text": "event_text", // (optional) string - the text body of the event
    "msg_title": "event_title", // (optional) string - the title of the event,
    "source_type_name": "event.test", // (optional) string - the source type name
    "tags": [ // (optional) list - a list of tags to associate with this event. Colon separated key/value pairs.
      "tag_key1:tag_value1",
      "tag_key2:tag_value2"
    ],
    "timestamp": 1548857342 // int - the epoch timestamp for the event
  }
]
```

Multiple events can be sent in one message. Any of an events' properties can be used to define an event stream in StackState.

curl example:

```javascript
curl -X POST \
 'http://<stackstateURL>/stsAgent/intake?api_key=<API_KEY>' \
 -H 'Content-Type: application/json' \
 -d '{
  "collection_timestamp": 1548857342,
  "events": {
    "event.test01": [
      {
        "msg_text": "event_text",
        "msg_title": "event_title",
        "source_type_name": "event.test",
        "tags": [
          "tag_key1:tag_value1",
          "tag_key2:tag_value2"
        ],
        "timestamp": 1548857342
      },
      {
        "msg_text": "event_text",
        "msg_title": "event_title",
        "source_type_name": "event.test",
        "tags": [
          "tag_key1:tag_value1",
          "tag_key2:tag_value2"
        ],
        "timestamp": 1548857340
      }
    ],
    "event.test02": [
      {
        "msg_text": "event_text",
        "msg_title": "event_title",
        "source_type_name": "event.test",
        "tags": [
          "tag_key1:tag_value1",
          "tag_key2:tag_value2"
        ],
        "timestamp": 1548857342
      }
    ]
  },
  "internalHostname": "localdocker.test",
  "metrics": [],
  "service_checks": [],
  "topologies": []
}'
```

You can also send events to StackState with the CLI `event send` command.

{% hint style="warning" %}
Event names cannot start with any of the following prefixes:

* `host`
* `name`
* `title`
* `eventType`
* `message`
* `timestamp`
* `timeReceived`
* `labels`
* `tags`
{% endhint %}

