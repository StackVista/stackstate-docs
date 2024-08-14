---
description: Rancher Observability 
---

# Send health data over HTTP

## Overview

Rancher Observability can synchronize health information from your own data sources either via HTTP or the [Rancher Observability CLI](../../../setup/cli/cli-sts.md).

## Rancher Observability Receiver API

The Rancher Observability Receiver API accepts topology, metrics, events and health data in a common JSON object. The default location for the receiver API is the `<STACKSTATE_RECEIVER_API_ADDRESS>`, constructed using the `<STACKSTATE_BASE_URL>` and <`STACKSTATE_RECEIVER_API_KEY>`.

The `<STACKSTATE_RECEIVER_API_ADDRESS>` for Rancher Observability deployed on Kubernetes or OpenShift is:

```text
https://<STACKSTATE_BASE_URL>/receiver/stsAgent/intake?api_key=<STACKSTATE_RECEIVER_API_KEY>
```

The `<STACKSTATE_BASE_URL>` and `<STACKSTATE_RECEIVER_API_KEY>` are set during Rancher Observability installation, for details see [Kubernetes install - configuration parameters](/setup/install-stackstate/kubernetes_openshift/kubernetes_install.md#generate-values-yaml).

## JSON 

### Common JSON object

Topology, telemetry and health data are sent to the receiver API via HTTP POST. There is a common JSON object used for all messages.

```javascript
{
  "collection_timestamp": 1548855554, // the epoch timestamp for the collection
  "events": {}, // used to send events data
  "internalHostname": "localdocker.test", // the host sending this data
  "metrics": [], // used to send metrics data
  "service_checks": [],
  "topologies": [], // used to send topology data
  "health": // used for sending health data
}
```

### JSON health payload

Rancher Observability accepts health data based on a chosen [consistency model](/configure/health/health-synchronization.md#consistency-models). The message that can be sent for each model are described on the pages below:

* [Repeat Snapshots JSON](/configure/health/send-health-data/repeat_snapshots.md)
* [Repeat States JSON](/configure/health/send-health-data/repeat_states.md)
* [Transactional Increments JSON](/configure/health/send-health-data/transactional_increments.md)

## See also

* [Install the Rancher Observability CLI](../../../setup/cli/cli-sts.md)

