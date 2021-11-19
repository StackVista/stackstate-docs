# Send health data over HTTP

{% hint style="warning" %}
**This page describes StackState version 4.4.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

StackState can synchronize health information from your own data sources either via HTTP or the [StackState CLI](../../setup/installation/cli-install.md).

## StackState Receiver API

The StackState Receiver API accepts health data next to telemetry and topology in a common JSON object. By default, the receiver API is hosted at:

{% tabs %}
{% tab title="Kubernetes" %}
```text
https://<baseUrl>/receiver/stsAgent/intake?api_key=<API_KEY>
```

Both the `baseUrl` and `API_KEY` are set during StackState installation, for details see [Kubernetes install - configuration parameters](../../setup/installation/kubernetes_install/install_stackstate.md#generate-values-yaml).
{% endtab %}

{% tab title="Linux" %}
```text
https://<baseUrl>:<receiverPort>/stsAgent/intake?api_key=<API_KEY>
```

Both the `baseUrl` and `API_KEY` are set during StackState installation, for details see [Linux install - configuration parameters](../../setup/installation/linux_install/install_stackstate.md#configuration-options-required-during-install).
{% endtab %}
{% endtabs %}

## Common JSON object

Health is sent to the receiver API via HTTP POST and has a common JSON object for all messages.

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

## JSON property: "health"

Health can be sent to the StackState Receiver API using the `"health"` property of the [common JSON object](send-health-data.md#common-json-object).

{% tabs %}
{% tab title="Example health JSON" %}
```javascript
[
    {
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
        {
          "checkStateId": "checkStateId2",
          "message": "Provisioning failed. [Learn more](https://www.any-link.com)",
          "health": "critical",
          "topologyElementIdentifier": "server-2",
          "name": "Health Monitor"
        }
      ]
    }
]
```
{% endtab %}
{% endtabs %}

Every health data payload has the following details:

* **start\_snapshot** - Optional. A start of a snapshot will be processed before processing the `check_states`. This enables StackState to diff a stream snapshot with the previously received one and delete check states that are no longer present in the snapshot. It can also carry snapshot metadata:
  * **repeat\_interval\_s** - Time in seconds. The frequency with which the external source will send health data to StackState. Max allowed value is 1800 \(30 minutes\).
  * **expiry\_interval\_s** - Time in seconds. The time to wait after the last update before an external check is deleted by StackState. Required when using sub streams.
* **stop\_snapshot** - Optional. An end of a snapshot will be processed after processing the`check_states`.
* **stream** - Object providing identification regarding which snapshots and `check_states` belong together. It contains the following fields:
  * **urn** - Data source and stream ID encoded as a StackState [URN](../identifiers.md) that matches the following convention: `urn:health:<sourceId>:<streamId>` where `<sourceId>` is the name if the external data source and `<streamId>` is a unique identifier for the health data stream.
  * **sub\_stream\_id** - Optional. Identifier for a sub set of the stream health data. When the stream data is distributed and reported by several agents, this allows snapshot lifecycles per `sub_stream_id`
* **check\_states** - A list of check states. Each check state can have the following fields:
  * **checkStateId** - Identifier for the check state in the external system
  * **message** - Optional. Message to display in StackState UI. Data will be interpreted as markdown allowing to have links to the external system check that generated the external check state.
  * **health** - One of the following StackState Health state values: `Clear`, `Deviating`, `Critical`.
  * **topologyElementIdentifier** - Used to bind the check state to a StackState topology element.
  * **name** - Name of the external check state.

## Send health to StackState

Health can be sent in one JSON message via HTTP POST or using the StackState CLI command [sts health send](../../develop/reference/cli_reference.md#sts-health-send). In the example below, a snapshot containing two check states is sent to StackState from a single external monitoring system.

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
  "health":[
  [
    {
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
        {
          "checkStateId": "checkStateId2",
          "message": "Provisioning failed. [Learn more](https://www.any-link.com)",
          "health": "critical",
          "topologyElementIdentifier": "server-2",
          "name": "Health Monitor"
        }
      ]
    }
]
}'
```
{% endtab %}

{% tab title="StackState CLI" %}
```text
sts health send start urn:health:sourceId:streamId \
  --repeat-interval-seconds 300

sts health send check-state urn:health:sourceId:streamId \
  checkStateId1 "Disk Usage" "server-1" deviating \
  --message "Deviating Server Running out of disk space"

sts health send check-state urn:health:sourceId:streamId \
  checkStateId2 "Health Monitor" "server-2" critical \
  --message "Provisioning failed. [Learn more](https://www.any-link.com)"

sts health send stop urn:health:sourceId:streamId
```
{% endtab %}
{% endtabs %}

You can also send health to StackState using the [StackState CLI `health send`](../../develop/reference/cli_reference.md#sts-health-send) command.

## See also

* [Install the StackState CLI](../../setup/installation/cli-install.md)
* [StackState CLI reference](../../develop/reference/cli_reference.md)

