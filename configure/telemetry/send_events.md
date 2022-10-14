---
description: StackState Self-hosted v5.1.x 
---

# Push events to StackState over HTTP

## Overview

StackState can either pull events from a data source or can receive pushed events. Pushed events are stored by StackState, while pulled events are not. Pushed events are stored for the duration of the configured retention period. This page describes how events can be pushed.

There are several ways to send events to StackState. A large number of [integrations](../../stackpacks/integrations/) are provided out of the box that may help you get started. If there is no out of the box integration available,  you can send events to StackState using either HTTP or the [StackState `stac` CLI](/setup/cli/cli-stac.md).

## StackState Receiver API

The StackState Receiver API accepts topology, metrics, events and health data in a common JSON object. By default, the receiver API is hosted at the `<STACKSTATE_RECEIVER_API_ADDRESS>` this is constructed using the `<STACKSTATE_BASE_URL>` and <`STACKSTATE_RECEIVER_API_KEY>`.

{% tabs %}
{% tab title="Kubernetes" %}
The `<STACKSTATE_RECEIVER_API_ADDRESS>` for StackState deployed on Kubernetes or OpenShift is:

```text
https://<STACKSTATE_BASE_URL>/receiver/stsAgent/intake?api_key=<STACKSTATE_RECEIVER_API_KEY>
```

The `<STACKSTATE_BASE_URL>` and `<STACKSTATE_RECEIVER_API_KEY>` are set during StackState installation, for details see [Kubernetes install - configuration parameters](/setup/install-stackstate/kubernetes_install/install_stackstate.md#generate-values-yaml).
{% endtab %}

{% tab title="Linux" %}

The `<STACKSTATE_RECEIVER_API_ADDRESS>` for StackState deployed on Linux is:

```text
https://<STACKSTATE_BASE_URL>:<STACKSTATE_RECEIVER_PORT>/stsAgent/intake?api_key=<STACKSTATE_RECEIVER_API_KEY>
```

The `<STACKSTATE_BASE_URL>` and <STACKSTATE_RECEIVER_API_KEY>` are set during StackState installation, for details see [Linux install - configuration parameters](/setup/install-stackstate/linux_install/install_stackstate.md#configuration-options-required-during-install).
{% endtab %}
{% endtabs %}

## Common JSON object

Topology, metrics, event and health data are sent to the StackState receiver API via HTTP POST. There is a common JSON object used for all messages. One message can contain multiple metrics and multiple events.

```javascript
{
  "collection_timestamp": 1548855554, // the epoch timestamp for the collection in seconds
  "events": {}, // see the section on "events", below
  "internalHostname": "local.test", // the host that is sending this data
  "metrics": [], // see the section on "metrics", below
  "service_checks": [],
  "topologies": [], // used for sending topology data
  "health" // used for sending health data
}
```

{% hint style="info" %}
Depending on your StackState configuration, received events that are too old will be ignored.
{% endhint %}

## JSON property: "events"

Events can be sent to the StackState Receiver API using the `"events"` property of the [common JSON object](send_metrics.md#common-json-object).

All events in StackState relate to a topology element or elements. Any properties of an event can be used to define a log stream in StackState.

{% tabs %}
{% tab title="Example event JSON" %}
```javascript
"event.test": [
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
      "tag_key2:tag_value2"
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
  * **data** - Optional. A list of key/value details about the event, for example a configuration version.
  * **source\_identifier** - Optional. The original identifier of the event in the source system.
  * **source\_links** - Optional. A list of links related to the event, for example a dashboard or the event in the source system.
* **event\_type** - Describes the event being sent. This should generally end with the suffix `Event`, for example `ConfigurationChangedEvent`, `VersionChangedEvent`.
* **msg\_text** - Required. The text body of the event.
* **msg\_title** - Required. The title of the event.
* **source\_type\_name** - Optional. The source event type name.
* **tags** - Optional. A list of key/value tags to associate with the event.
* **timestamp** - The epoch timestamp for the event.

## Send events to StackState

Multiple events can be sent in one JSON message via HTTP POST. You can also send a single event to StackState using the `stac` CLI `event send` command. For example:

{% tabs %}
{% tab title="curl" %}
```bash
curl -X POST \
 'https://<STACKSTATE_RECEIVER_API_ADDRESS> \
 -H 'Content-Type: application/json' \
 -d '{
  "collection_timestamp": 1548857342,
  "internalHostname": "local.test",
  "events": {
    "event.test01": [
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
        "event_type": "event_type",
        "msg_title": "event_title",
        "msg_text": "event_text",
        "source_type_name": "source_event_type",
        "tags": [
          "tag_key1:tag_value1",
          "tag_key2:tag_value2"
        ],
        "timestamp": 1607432944
      }
    ],
    "event.test02": [ 
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
        "event_type": "event_type",
        "msg_title": "event_title",
        "msg_text": "event_text",
        "source_type_name": "source_event_type",
        "tags": [
          "tag_key1:tag_value1",
          "tag_key2:tag_value2"
        ],
        "timestamp": 1607432944
      }
    ]
  }
}'
```
{% endtab %}

{% tab title="CLI: stac" %}
```text
stac event send "event_type" \
    --title "event_title" \
    -i "element_identifier1" "element_identifier2" \
    -s "source_system" \
    -c "Changes" \
    -d '{"data_key1":"data_value1", "data_key2":"data_value2"}' \
    --links "link_title1: link_url1" "link_title2: link_url2"
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

The new `sts` CLI replaces the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="CLI: sts (new)" %}

Command not available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% endtabs %}

## See also

* [StackState identifiers](../topology/identifiers.md)
* [Events Perspective](../../use/stackstate-ui/perspectives/events_perspective.md)
* [Events tutorial](../../develop/tutorials/events_tutorial.md)

