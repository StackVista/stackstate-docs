---
description: StackState Self-hosted v5.0.x
---

# Send health data over HTTP

## Overview

StackState can synchronize health information from your own data sources either via HTTP or the [StackState CLI](/setup/cli-install.md).

## StackState Receiver API

The StackState Receiver API accepts topology, telemetry and health data in a common JSON object. By default, the receiver API is hosted at:

{% tabs %}
{% tab title="Kubernetes" %}
```text
https://<baseUrl>/receiver/stsAgent/intake?api_key=<API_KEY>
```

Both the `baseUrl` and `API_KEY` are set during StackState installation, for details see [Kubernetes install - configuration parameters](/setup/install-stackstate/kubernetes_install/install_stackstate.md#generate-values-yaml).
{% endtab %}

{% tab title="Linux" %}
```text
https://<baseUrl>:<receiverPort>/stsAgent/intake?api_key=<API_KEY>
```

Both the `baseUrl` and `API_KEY` are set during StackState installation, for details see [Linux install - configuration parameters](/setup/install-stackstate/linux_install/install_stackstate.md#configuration-options-required-during-install).
{% endtab %}
{% endtabs %}

## JSON 

### Common JSON object

Topology, telemetry and health data are sent to the receiver API via HTTP POST. There is a common JSON object used for all messages.

```javascript
{
  "collection_timestamp": 1548855554, // the epoch timestamp for the collection
  "events": {}, // used to send events data
  "internalHostname": "localdocker.test", // the host that is sending this data
  "metrics": [], // used to send metrics data
  "service_checks": [],
  "topologies": [], // used to send topology data
  "health" // used for sending health data
}
```

### JSON health payload

StackState accepts health data based on a chosen [consistency model](/configure/health/health-synchronization.md#consistency-models). The message that can be sent for each model are described on the pages below:

* [Repeat Snapshots JSON](/configure/health/send-health-data/repeat_snapshots.md)
* [Repeat States JSON](/configure/health/send-health-data/repeat_states.md)
* [Transactional Increments JSON](/configure/health/send-health-data/transactional_increments.md)

## See also

* [Install the StackState CLI](/setup/cli)
* [Send topology data over HTTP](/configure/topology/send-topology-data.md)
* [Send telemetry data over HTTP](/configure/telemetry/send_telemetry.md)

