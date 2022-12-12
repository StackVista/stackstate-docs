---
description: StackState Self-hosted v5.1.x
---

## Overview

This page describes the exact JSON messages that can be sent for the health synchronization Repeat Snapshots consistency model.

## JSON property: "health"

Health can be sent to the StackState Receiver API using the `"health"` property of the [common JSON object](send-health-data.md#common-json-object).

{% tabs %}
{% tab title="Example health `repeat_snapshots` JSON" %}
```javascript
{
   "apiKey":"<STACKSTATE_RECEIVER_API_KEY>",
   "collection_timestamp":1585818978,
   "internalHostname":"lnx-343242.srv.stackstate.com",
   "health":[
      {
        "consistency_model": "REPEAT_SNAPSHOTS",
        "start_snapshot": {
          "repeat_interval_s": 50
          //"expiry_interval_s": 200 Optional
        },
        "stop_snapshot": {},
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
          }
        ]
      }
   ]
}
```
{% endtab %}
{% endtabs %}

Every health Repeat Snapshots data payload has the following details:

* **start_snapshot** - Optional. A start of a snapshot needs to be processed before processing `check_states`. This enables StackState to diff a stream snapshot with the previously received one and delete check states that are no longer present in the snapshot. It carries the following fields as snapshot metadata:
  * **repeat_interval_s** - Time in seconds. The frequency with which the external source will send health data to StackState. Max allowed value is 1800 (30 minutes).
  * **expiry_interval_s** - Time in seconds. The time to wait after the last update before an external check is deleted by StackState. Required when using sub streams.
* **stop_snapshot** - Optional. An end of a snapshot will be processed after processing the`check_states`.
* **stream** - Object providing identification regarding which snapshots and `check_states` belong together. It contains the following fields:
  * **urn** - Data source and stream ID encoded as a StackState [URN](/configure/topology/identifiers.md) that matches the following convention: `urn:health:<sourceId>:<streamId>` where `<sourceId>` is the name if the external data source and `<streamId>` is a unique identifier for the health data stream.
  * **sub_stream_id** - Optional. Identifier for a subset of the stream health data. When the stream data is distributed and reported by several Agents, this allows snapshot lifecycles per `sub_stream_id`
* **check_states** - A list of check states. Each check state can have the following fields:
  * **checkStateId** - Identifier for the check state in the external system
  * **message** - Optional. Message to display in StackState UI. Data will be interpreted as markdown allowing to have links to the external system check that generated the external check state.
  * **health** - One of the following StackState Health state values: `Clear`, `Deviating`, `Critical`.
  * **topologyElementIdentifier** - Used to bind the check state to a StackState topology element.
  * **name** - Name of the external check state.


## Send health to StackState

Health can be sent in one JSON message via HTTP POST or using the `stac` CLI command `stac health send`. In the example below, a snapshot containing two check states is sent to StackState from a single external monitoring system.

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
      "consistency_model": "REPEAT_SNAPSHOTS",
      "start_snapshot": {
        "repeat_interval_s": 300
      },
      "stop_snapshot": {},
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

```
stac health send start urn:health:sourceId:streamId \
  --repeat-interval-seconds 300

stac health send check-state urn:health:sourceId:streamId \
  checkStateId1 "Disk Usage" "server-1" deviating \
  --message "Deviating Server Running out of disk space" --consistency-model="REPEAT_SNAPSHOTS"

stac health send check-state urn:health:sourceId:streamId \
  checkStateId2 "Health monitor" "server-2" critical \
  --message "Provisioning failed. [Learn more](https://www.any-link.com)" --consistency-model="REPEAT_SNAPSHOTS"

stac health send stop urn:health:sourceId:streamId
```

{% endtab %}
{% tab title="CLI: sts" %}

The new `sts` CLI does not support sending health states. This will only be supported by directly reaching out to the receiver API.
{% endtab %}
{% endtabs %}
