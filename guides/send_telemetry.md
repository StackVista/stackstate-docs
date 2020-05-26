---
title: Send Telemetry
kind: Documentation
listorder: 3
---

<!--
======================================================
OVERVIEW
======================================================
-->

## Overview

This guide details how to send metrics and events to StackState. StackState provides several ways to send telemetry. A growing number of integrations are provided out of the box. These can be found in StackPacks. Anyone can create their own integrations by sending data to the intake api in the right format. Another way is to use the `metric send` or `event send` command of the [stackstate-cli](/setup/cli/). All telemetry is sent to StackStates intake API. By default the intake api is hosted at `<baseUrl>/stsAgent/intake?api_key=<API_KEY>`. Data is sent to the intake api by http POST and has a common formatting for all messages. **Depending on your StackState configuration, metrics or events that are to old may be ignored.**

``` json
{
  "collection_timestamp": 1548855554, int, the epoch timestamp for the collection
  "events": {},
  "internalHostname": "localdocker.test", string, the host that is sending this data
  "metrics": [],
  "service_checks": [],
  "topologies": []
}
```

<!--
======================================================
METRICS
======================================================
-->

## Metrics
A message to the intake api can contain a list of metrics. Every metric has a `name`, its own `timestamp`, `value`, `hostname`, `type` and optionally `tags`.

Example of a metric:
``` json
[
  "test.metric",
  1548857152, int, the epoch timestamp for the metric
  10.0, doable, value of the metric
  {
    "hostname": "localdocker.test", string, the host this metric is from
    "tags": [ (optional) list, a list of tags to associate with this metric
      "tag_key1:tag_value1",
      "tag_key2:tag_value2"
    ],
    "type": "gauge" string, type of metric options: "gauge, count, rate, counter, raw"
  }
]
```

Multiple metrics can be sent in one message. The timestamp of the individual metric is what is used to correctly plot them in time. The name and tags can be used to define a metric stream in StackState.

curl example:

``` json
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

<!--
======================================================
EVENTS
======================================================
-->

## Events
A message to the intake api can contain a map with lists of events. Every event has a `name`, its own `timestamp`, and optionally `msg_title`, `msg_text`, `tags` and `source_type_name`.

``` json
"event.test": [ string, the event name
  {
    "msg_text": "event_text", (optional) string, the text body of the event
    "msg_title": "event_title", (optional) string, the title of the event,
    "source_type_name": "event.test", (optional) string, the source type name
    "tags": [ (optional) list, a list of tags to associate with this event
      "tag_key1:tag_value1",
      "tag_key2:tag_value2"
    ],
    "timestamp": 1548857342 int, the epoch timestamp for the event
  },
  {
    "msg_text": "event_text",
    "msg_title": "event_title",
    "source_type_name": "event.test",
    "tags": [
      "tag_key1:tag_value1",
      "tag_key2:tag_value2"
    ],
    "timestamp": 1548857353
  }
]
```

curl example:

``` json
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
