---
description: StackState Self-hosted v5.1.x
---

## Overview

This page describes the exact JSON messages that can be sent for the health synchronization Transactional Increments consistency model.

## JSON property: "health"

Health can be sent to the StackState Receiver API using the `"health"` property of the [common JSON object](send-health-data.md#common-json-object).

{% tabs %}
{% tab title="Example health `transactional_increments` JSON" %}
```javascript
   "apiKey":"your api key",
   "collection_timestamp":1585818978,
   "internalHostname":"lnx-343242.srv.stackstate.com",
   "events":{},
   "metrics":[],
   "service_checks":[],
   "health":[
      {
        "consistency_model": "TRANSACTIONAL_INCREMENTS",
        "increment": {
              "checkpoint": {
                  "offset": 5,
                  "batch_index": 102
              },
              "previous_checkpoint": {
                  "offset": 5,
                  "batch_index": 100
              }
        },
        "stream": {
          "urn": "urn:health:sourceId:streamId"
          //"sub_stream_id": "subStreamId" Optional
        },
        "check_states": [
          {
            "checkStateId": "checkStateId1",
            "message": "Server Running out of disk space",
            "health": "Deviating",
            "topologyElementIdentifier": "server-1",
            "name": "Disk Usage"
          },
          {
            "checkStateId": "checkStateId2",
            "message": "Provisioning failed. [Learn more](https://www.any-link.com)",
            "health": "critical",
            "topologyElementIdentifier": "server-2",
            "name": "Health monitor"
          },
          {
            "checkStateId": "checkStateId3",
            "delete": true
          }
        ]
      }
   ],
   "topologies":[]
```
{% endtab %}
{% endtabs %}

Every health Transactional Increments data payload has the following details:

* **increment** - An increment objects needs to be present on every message. This enables StackState to track the complete chain of messages and be able to detect when a retransmission of data, or an unexpected gap in the data is occurring. It carries the following fields as increment metadata:
  * **checkpoint** - Object providing the checkpoint that belongs the `check_states` present in the message, it contains two fields:
    * **offset** - The offset asigned to the messages by the streaming pipeline. For example, Kafka offset.
    * **batch_index** - Optional. When using a single message to accumulate several `check_states` the batch index represents the latest index that's present in the message, allowing to send big batches in separate api calls.
  * **previous_checkpoint** - Optional. Represents the previously communicated checkpoint, can be empty on the very first transmission on the substream. It allows StackState to keep track if there could be any data missing from upstream.
* **stream** - Object providing identification regarding which snapshots and `check_states` belong together. It contains the following fields:
  * **urn** - Data source and stream ID encoded as a StackState [URN](/configure/topology/identifiers.md) that matches the following convention: `urn:health:<sourceId>:<streamId>` where `<sourceId>` is the name if the external data source and `<streamId>` is a unique identifier for the health data stream.
  * **sub_stream_id** - Optional. Identifier for a subset of the stream health data. When the stream data is distributed and reported by several agents, this allows snapshot lifecycles per `sub_stream_id`
* **check_states** - A list of check states. Each check state can have the following fields:
  * **checkStateId** - Identifier for the check state in the external system
  * **message** - Optional. Message to display in StackState UI. Data will be interpreted as markdown allowing to have links to the external system check that generated the external check state.
  * **health** - One of the following StackState Health state values: `Clear`, `Deviating`, `Critical`.
  * **topologyElementIdentifier** - Used to bind the check state to a StackState topology element.
  * **name** - Name of the external check state.
  * **delete** - Flag that's interpreted as a delete request for the related `checkStateId`. Even if the rest of the fields for the create are present, for example, `name, health, ...` the delete will take precedence.


## Send health to StackState

Health can be sent in one JSON message via HTTP POST. In the example below, a snapshot containing two check states is sent to StackState from a single external monitoring system.

{% tabs %}
{% tab title="curl" %}
```bash
curl -X POST \
 '<STACKSTATE_RECEIVER_API_ADDRESS>' \
 -H 'Content-Type: application/json' \
 -d '{
  "collection_timestamp": 1548857167,
  "internalHostname": "local.test",
  "health": [
    {
      "consistency_model": "TRANSACTIONAL_INCREMENTS",
      "increment": {
            "checkpoint": {
                "offset": 5,
                "batch_index": 102
            },
            "previous_checkpoint": {
                "offset": 5,
                "batch_index": 100
            }
      },
      "stream": {
        "urn": "urn:health:sourceId:streamId"
      },
      "check_states": [
        {
          "checkStateId": "checkStateId1",
          "message": "Server Running out of disk space",
          "health": "Deviating",
          "topologyElementIdentifier": "server-1",
          "name": "Disk Usage"
        },
        {
          "checkStateId": "checkStateId2",
          "message": "Provisioning failed. [Learn more](https://www.any-link.com)",
          "health": "critical",
          "topologyElementIdentifier": "server-2",
          "name": "Health monitor"
        },
        {
          "checkStateId": "checkStateId3",
          "delete": true
        }
      ]
    }
  ]
}'
```
{% endtab %}
{% tab title="CLI: stac (deprecated)" %}
{% hint style="warning" %}
**From StackState v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")
{% endhint %}

Sending of Transactional increments check_states isn't available in the CLI, but all the debugging and introspection features can still be used.

{% endtab %}
{% tab title="CLI: sts" %}

Sending of Transactional increments check_states isn't available in the `sts` CLI.
{% endtab %}

{% endtabs %}
