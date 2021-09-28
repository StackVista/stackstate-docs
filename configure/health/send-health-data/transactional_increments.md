## Overview

This page describes the exact JSON messages that can be sent for the health synchronization Transactional Increments consistency model.

## JSON property: "health"

Health can be sent to the StackState Receiver API using the `"health"` property of the [common JSON object](send-health-data.md#common-json-object).

{% tabs %}
{% tab title="Example health `transactional_increments` JSON" %}
```javascript
[
    {
      "consistency_model": "TRANSACTIONAL_INCREMENTS",
      "incrment": {
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
          "name": "Health Monitor"
        },
        {
          "checkStateId": "checkStateId3",
          "delete": true
        }
      ]
    }
]
```
{% endtab %}
{% endtabs %}

Every health Transactional Increments data payload has the following details:

* **increment** - An increment objects needs to be present on every message. This enables StackState to track the complete chain of messages and be able to detect when a retransmission of data, or an unexpected gap in the data is occurring. It carries the following fields as increment metadata:
  * **checkpoint** - Object providing the checkpoint that belongs the the `check_states` present in the message, it contains two fields:
    * **offset** - The offset asigned to the messages by the streaming pipeline (e.g. Kafka offset)
    * **batch_index** - Optional. When using a single message to accumulate several `check_states` the batch index represents the latest index that is present in the message, allowing to send big batches in separate api calls.
  * **previous_checkpoint** - Optional. Represents the previously communicated checkpoint, can be empty on the very first transmission on the substream. It allows StackState to keep track if there could be any data missing from upstream.
* **stream** - Object providing identification regarding which snapshots and `check_states` belong together. It contains the following fields:
  * **urn** - Data source and stream ID encoded as a StackState [URN](/configure/identifiers.md) that matches the following convention: `urn:health:<sourceId>:<streamId>` where `<sourceId>` is the name if the external data source and `<streamId>` is a unique identifier for the health data stream.
  * **sub_stream_id** - Optional. Identifier for a sub set of the stream health data. When the stream data is distributed and reported by several agents, this allows snapshot lifecycles per `sub_stream_id`
* **check_states** - A list of check states. Each check state can have the following fields:
  * **checkStateId** - Identifier for the check state in the external system
  * **message** - Optional. Message to display in StackState UI. Data will be interpreted as markdown allowing to have links to the external system check that generated the external check state.
  * **health** - One of the following StackState Health state values: `Clear`, `Deviating`, `Critical`.
  * **topologyElementIdentifier** - Used to bind the check state to a StackState topology element.
  * **name** - Name of the external check state.
  * **delete** - Flag that is interpreted as a delete request for the related `checkStateId`. Even if the rest of the fields for the create are present, e.g. `name, health, ...` the delete will take precedence.


## Send health to StackState

Health can be sent in one JSON message via HTTP POST or using the StackState CLI command [sts health send](/develop/reference/cli_reference.md#sts-health-send). In the example below, a snapshot containing two check states is sent to StackState from a single external monitoring system.

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
  "metrics": [],
  "service_checks": [],
  "topologies": [],
  "health": [
    {
      "consistency_model": "TRANSACTIONAL_INCREMENTS",
      "incrment": {
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
          "name": "Health Monitor"
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
{% tab title="StackState CLI" %}
```
Sending of Transactional increments check_states is not available in the CLI, 
but all the debugging and introspection features can still be used.
```

{% endtab %}
{% endtabs %}