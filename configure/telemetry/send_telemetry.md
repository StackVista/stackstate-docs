---
description: StackState Self-hosted v5.0.x 
---

# Push telemetry to StackState over HTTP

## Overview

StackState can either pull telemetry from a data source or can receive pushed telemetry. Pushed telemetry is stored by StackState, while pulled telemetry is not. Pushed telemetry is stored for the duration of the configured retention period. This page describes how telemetry can be pushed.

There are several ways to send telemetry to StackState. A large number of [integrations](../../stackpacks/integrations/) are provided out of the box that may help you get started. If there is no out of the box integration you can send telemetry to StackState using either HTTP or the [StackState `stac` CLI](/setup/cli/cli-stac.md).

## StackState Receiver API

The StackState Receiver API accepts topology, telemetry and health data in a common JSON object. By default, the receiver API is hosted at:

{% tabs %}
{% tab title="Kubernetes" %}
```text
https://<STACKSTATE_BASE_URL>/receiver/stsAgent/intake?api_key=<STACKSTATE_RECEIVER_API_KEY>
```

The `<STACKSTATE_BASE_URL>` and `<STACKSTATE_RECEIVER_API_KEY>` are set during StackState installation, for details see [Kubernetes install - configuration parameters](../../setup/install-stackstate/kubernetes_install/install_stackstate.md#generate-values-yaml).
{% endtab %}

{% tab title="Linux" %}
```text
https://<STACKSTATE_BASE_URL>:<STACKSTATE_RECEIVER_PORT>/stsAgent/intake?api_key=<STACKSTATE_RECEIVER_API_KEY>
```

The `<STACKSTATE_BASE_URL>` and `<STACKSTATE_RECEIVER_API_KEY>` are set during StackState installation, for details see [Linux install - configuration parameters](../../setup/install-stackstate/linux_install/install_stackstate.md#configuration-options-required-during-install).
{% endtab %}
{% endtabs %}

## Common JSON object

Topology, telemetry and health data are sent to the receiver API via HTTP POST. There is a common JSON object used for all messages. One message can contain multiple metrics and multiple events.

```javascript
{
  "collection_timestamp": 1548855554, // the epoch timestamp for the collection
  "events": {}, // see the section on "events", below
  "internalHostname": "localdocker.test", // the host that is sending this data
  "metrics": [], // see the section on "metrics", below
  "service_checks": [],
  "topologies": [], // used for sending topology data
  "health" // used for sending health data
}
```

{% hint style="info" %}
Depending on your StackState configuration, received metrics or events that are too old will be ignored.
{% endhint %}

## Metrics

Metrics can be sent to the StackState Receiver API using the `"metrics"` property of the [common JSON object](send_telemetry.md#common-json-object).

### JSON property: "metrics"

{% tabs %}
{% tab title="Example metric JSON" %}
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
{% endtab %}
{% endtabs %}

Every metric has the following details:

* **name** - The metric name. Must not start with any of the following prefixes: `host`, `labels`, `name`, `tags` , `timeReceived`, `timestamp`, `tags` or `values`.
* **timestamp** - The epoch timestamp of the metric.
* **value** - The value of the metric.
* **hostname** - The host this metric is from.
* **type** - The type of metric. Can be `gauge`, `count`, `rate`, `counter` or `raw`.
* **tags** - Optional.  A list of key/value tags to associate with the metric.

The `timestamp` and `value` are used to plot the metric as a time series. The `name` and `tags` can be used to define a metric stream in StackState.

### Send metrics to StackState

Multiple metrics can be sent in one JSON message via HTTP POST. For example:

{% tabs %}
{% tab title="curl" %}
```javascript
curl -X POST \
 'http://<STACKSTATE_BASES_URL>/stsAgent/intake?api_key=<STACKSTATE_RECEIVER_API_KEY>' \
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

You can also send metrics to StackState using the `stac` CLI `metric send` command.

## Events

Events can be sent to the StackState Receiver API using the `"events"` property of the [common JSON object](send_telemetry.md#common-json-object).

All events in StackState relate to a topology element or elements. Any properties of an event can be used to define a log stream in StackState.

### JSON property: "events"

{% tabs %}
{% tab title="Example event JSON" %}
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
{% endtab %}
{% endtabs %}

Events have the following details:

* An event name. this must not start with any of the following prefixes: `eventType`, `host`, `labels`, `message`, `name`, `tags`, `timeReceived`, `timestamp` or `title`.
* **context** - Optional. Includes details of the source system for an event. Events that contain a context will be visible in the StackState [Events Perspective](../../use/stackstate-ui/perspectives/events_perspective.md) for views that contain a component with a matching source identifier. Events without a context will be available in StackState as a log stream:
  * **category** - The event category. Can be `Activities`, `Alerts`, `Anomalies`, `Changes` or `Others`.
  * **element\_identifiers** - The [identifiers for the topology element\(s\)](../topology/identifiers.md#topology-identifiers) the event relates to. These are used to bind the event to a topology element or elements. 
  * **source** - The name of the system from which the event originates, for example AWS, Kubernetes or JIRA.
  * **data** - Optional.  A list of key/value details about the event, for example a configuration version.
  * **source\_identifier** - Optional. The original identifier of the event in the source system.
  * **source\_links** - Optional.  A list of links related to the event, for example a dashboard or the event in the source system.
* **event\_type** - Describes the event being sent. This should generally end with the suffix `Event`, for example `ConfigurationChangedEvent`, `VersionChangedEvent`.
* **msg\_text** - Required. The text body of the event.
* **msg\_title** - Required. The title of the event.
* **source\_type\_name** - Optional. The source event type name.
* **tags** - Optional. A list of key/value tags to associate with the event.
* **timestamp** - The epoch timestamp for the event.

### Send events to StackState

Multiple events can be sent in one JSON message via HTTP POST. You can also send a single event to StackState using the `stac` CLI `event send` command. For example:

{% tabs %}
{% tab title="curl" %}
```javascript
curl -X POST \
 'http://<STACKSTATE_BASE_URL>/stsAgent/intake?api_key=<STACKSTATE_RECEIVER_API_KEY>' \
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

{% tab title="CLI: stac" %}
```text
stac event send "HealthStateChangedEvent" \
    --title "event_title" \
    -i "element_identifier1" "element_identifier2" \
    -s "source_system" \
    -c "Changes" \
    -d '{"data_key1":"data_value1", "data_key2":"data_value2"}' \
    --links "link_title1: link_url1" "link_title2: link_url2"
```
{% endtab %}
{% tab title="CLI: sts (new)" %}

Command not available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% endtabs %}

## See also

* [StackState identifiers](../topology/identifiers.md)
* [Events Perspective](../../use/stackstate-ui/perspectives/events_perspective.md)
* [Events tutorial](../../develop/tutorials/events_tutorial.md)

