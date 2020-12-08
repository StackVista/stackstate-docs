# Send telemetry

## Overview

StackState can either pull telemetry from a data source or can receive pushed telemetry. Pushed telemetry is stored by StackState, while pulled telemetry is not. Pushed telemetry is stored for the duration of the configured retention period. This page describes how telemetry can be pushed.

There are several ways to send telemetry to StackState. A large number of [integrations](/stackpacks/integrations) are provided out of the box that may help you get started. If there is no out of the box integration you can send telemetry to StackState using either HTTP or the [StackState CLI](/setup/installation/cli-install.md).

## Send telemetry over HTTP

The StackState receiver API is responsible for receiving both telemetry and topology. By default, the receiver API is hosted at:

```
https://<baseUrl>:<receiverPort>/stsAgent/intake?api_key=<API_KEY>
``` 

Both the baseUrl and API\_KEY are set during installation, for details see:

- [Kubernetes install - configuration parameters](/setup/installation/kubernetes_install/install_stackstate.md#generate-valuesyaml) 
- [Linux install - configuration parameters](/setup/installation/linux_install/install_stackstate.md#configuration-options-required-during-install) 


Telemetry is sent to the receiver API via HTTP POST and has a common JSON object for all messages. One message can contain multiple metrics and multiple events.

```javascript
{
  "collection_timestamp": 1548855554, // the epoch timestamp for the collection
  "events": {}, // see section on events
  "internalHostname": "localdocker.test", // the host that is sending this data
  "metrics": [], // see the section on "metrics", below
  "service_checks": [],
  "topologies": [] // used for sending topology data
}
```

{% hint style="info" %}
Depending on your StackState configuration, received metrics or events that are too old will be ignored.
{% endhint %}

## Metrics

Metrics can be sent to the StackState receiver API using the `metrics` property. Every metric has the following details:
 
- **name** - The metric name. Must not start with any of the following prefixes: `host`, `labels`, `name`, `tags` , `timeReceived`, `timestamp`, `tags` or `values`.
- **timestamp** - The epoch timestamp of the metric.
- **value** - The value of the metric.
- **hostname** - The host this metric is from.
- **type** - The type of metric. Can be `gauge`, `count`, `rate`, `counter` or `raw`.
- **tags** - Optional.  A list of key/value tags to associate with the metric.

Example of a single metric:

```javascript
[
  "test.metric", // the metric name
  1548857152,
  10.0, // double - value of the metric
  {
    "hostname": "localdocker.test",
    "tags": [ 
      "tag_key1:tag_value1",
      "tag_key2:tag_value2"
    ],
    "type": "gauge"
  }
]
```

Multiple metrics can be sent in one message. The `timestamp` and `value` of the metric is used to plot the metrics as a time series. The `name` and `tags` can be used to define a metric stream in StackState.

You can send metrics to StackState using the [StackState CLI `metric send`](/develop/reference/cli_reference.md#sts-metric-send) command or as JSON via HTTP POST. For example:

{% tabs %}
{% tab title="curl" %}
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
{% endtab %}
{% endtabs %}

## Events

Events can be sent to the StackState receiver API using the `events` property. Every event has the following details:

- **name** - The event name. Must not start with any of the following prefixes: `eventType`, `host`, `labels`, `message`, `name`, `tags`, `timeReceived`, `timestamp` or `title`.
- **timestamp** - The epoch timestamp for the event.
- **context** - Includes details of the source system for an event:
    - **category** - The event category. Can be `Activities`, `Alerts`, `Anomalies`, `Changes` or `Others`.
    - **element_identifiers** - The [identifiers for the topology element\(s\)](/configure/identifiers.md#topology-identifiers) the event relates to. 
    - **source** - The name of the system from which the event originates, for example AWS, Kubernetes or JIRA.
    - **data** - Optional.  A list of key/value details about the event, for example a configuration version.
    - **source_id** - Optional. The original identifier of the event in the source system.
    - **source_links** - Optional.  A list of links related to the event, for example a dashboard or the event in the source system.
- **event_type** - Describes the event being sent. This should generally end with the suffix `Event`, for example `ConfigurationChangedEvent`, `VersionChangedEvemt`.
- **msg_text** - Optional. The text body of the event.
- **msg_title** - Optional. The title of the event.
- **source_type_name** - Optional. The source event type name.
- **tags** - Optional. A list of key/value tags to associate with the event.

Example of a single event:

```javascript
"event.test": [ // The event name
  {
    "context": {
      "category": "Changes",
      "data": { 
        "data_key1":"data_value1",
        "data_key2":"data_value2"
      },
      "element_identifiers": [
        "element_identifier1",
        "element_identifier2"2
      ],
      "source": "source_system",
      "source_links": [
        {
          "title": "link_title",
          "url": "link_url"
        }
      ]
    },
    "event_type": "event_typeEvent",
    "msg_title": "event_title",
    "msg_text": "event_text",
    "source_type_name": "source_event_type",
    "tags": [
      "tag_key1:tag_value1",
      "tag_key2:tag_value2",
    ],
    "timestamp": 1607432944
  }
]

```

Multiple events can be sent in one message. Any of an event's properties can be used to define an event stream in StackState.

You can send events to StackState with the [StackState CLI `event send`](/develop/reference/cli_reference.md#sts-event-send) command or as JSON via HTTP POST. For example:

{% tabs %}
{% tab title="curl" %}
```javascript
curl -X POST \
 'http://<stackstateURL>/stsAgent/intake?api_key=<API_KEY>' \
 -H 'Content-Type: application/json' \
 -d '{
  "collection_timestamp": 1548857342,
  "events": {
    "event.test01": [ // The event name
      {
        "context": {
          "category": "Changes",
          "data": { 
            "data_key1":"data_value1",
            "data_key2":"data_value2"
          },
          "element_identifiers": [
            "element_identifier1",
            "element_identifier2"
          ],
          "source": "source_system",
          "source_links": [
            {
              "title": "link_title",
              "url": "link_url"
            }
          ]
        },
        "event_type": "HealthStateChangedEvent",
        "msg_title": "event_title",
        "msg_text": "event_text",
        "source_type_name": "source_event_type",
        "tags": [
          "tag_key1:tag_value1",
          "tag_key2:tag_value2",
        ],
        "timestamp": 1607432944
      }
    ],
    "event.test02": [ // The event name
      {
        "context": {
          "category": "Changes",
          "data": { 
            "data_key1":"data_value1",
            "data_key2":"data_value2"
          },
          "element_identifiers": [
            "element_identifier1",
            "element_identifier2"
          ],
          "source": "source_system",
          "source_links": [
            {
              "title": "link_title",
              "url": "link_url"
            }
          ]
        },
        "event_type": "HealthStateChangedEvent",
        "msg_title": "event_title",
        "msg_text": "event_text",
        "source_type_name": "source_event_type",
        "tags": [
          "tag_key1:tag_value1",
          "tag_key2:tag_value2",
        ],
        "timestamp": 1607432944
      }
    ]
  "internalHostname": "localdocker.test",
  "metrics": [],
  "service_checks": [],
  "topologies": []
}'
```
{% endtab %}
{% tab title="StackState CLI" %}
```
sts event send "HealthStateChangedEvent" \
    --title "event_title" \
    -i "element_identifier1" "element_identifier2" \
    -s "source_system" \
    -c "Changes" \
    -d '{"data_key1":"data_value1", "data_key2":"data_value2"}'
    --links "link_title1: link_url1" "link_title2: link_url2"
```
{% endtab %}
{% endtabs %}
