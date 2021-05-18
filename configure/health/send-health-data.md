# Send health data over HTTP

## Overview

StackState can synchronize health information from your own data sources either via HTTP or the [StackState CLI](../../setup/installation/cli-install.md).


## Send telemetry over HTTP
The Stackstate receiver API accepts health data next to telemetry and topology, the receiver API is hosted at:

```text
https://<baseUrl>:<receiverPort>/stsAgent/intake?api_key=<API_KEY>
```

Both the `baseUrl` and `API_KEY` are set during StackState installation, for details see:

* [Kubernetes install - configuration parameters](../../setup/installation/kubernetes_install/install_stackstate.md#generate-valuesyaml) 
* [Linux install - configuration parameters](../../setup/installation/linux_install/install_stackstate.md#configuration-options-required-during-install) 

Health is sent to the receiver API via HTTP POST and has a common JSON object for all messages. One message can contain multiple metrics and multiple events.

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

### Health JSON

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
          "message": "Unable to provision the device. [Click to see details](https://www.external-data-source.com)",
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
* **start_snapshot** - Optional, when the object is present it signals that before processing hte `check_states` a start of a snapshot will be processed as well, this enables StackState to diff stream snapshots with the previous one in order to delete any checks states that are no longer present in the snapshot. It's other purpose is to carry snapshot metadata information as:
  * **repeat_interval_s** - Time in seconds, frequency of the external source on sending health data to StackState. Max allowed value is 30 minutes
  * **expiry_interval_s** - Optional time in seconds, time to wait before StackState proceed to delete external checks that haven't been received again. This feature is under development.
* **stop_snapshot** - Optional, when the object is present it signals that an after processing the`check_states` and end of a snapshot will be processed as well.
* **stream** - Object providing identification regarding which snapshots and `check_states` belong together. It the following fields:
  * **urn** - Data source and stream id encoded as an [URN](../../configure/identifiers.md) that matches the following convention: `urn:health:<sourceId>:<streamId>` where `<sourceId>` is the name if the external data source and `<streamId>` is a unique identifier for the particular stream of health data.
  * **sub_stream_id** - Optional, identifier for a sub set of the stream health data. Helpful when the stream data is distributed and reported by several agents, facilitating to have snapshot lifecycles per `sub_stream_id`
* **check_states** - List of check states. Per check state you have the following fields:
  * **checkStateId** - Identifier for the check state in the external system
  * **message** - Optional, message to display in StackState UI. Data will be interpreted as markdown allowing to have links to the external system check that generated the external check state.
  * **health** - One of the following StackState Health state values: `Clear`, `Deviating`, `Critical`
  * **topologyElementIdentifier** - Identifier to associate the external check state to a StackState topology element.
  * **name** - Name of the external check state.

{% hint style="info" %}
The health expire feature is still under development, so currently the `expiry_interval_s` value is not used at all.
{% endhint %}

### Send health to StackState

Health can be sent in one JSON message via HTTP POST. For example:

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
          "message": "Unable to provision the device. [Click to see details](https://www.external-data-source.com)",
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
{% endtabs %}

You can also send health to StackState using the [StackState CLI `metric send`](../../develop/reference/cli_reference.md#sts-health-send) command.


## See also