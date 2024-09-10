---
description: SUSE Observability
---

# Health synchronization

This section describes the advanced topic of synchronizing custom health data from different monitoring systems to SUSE Observability.
This topic is mostly interesting for engineers who want to make a custom integration with an existing monitoring system.
For out of the box monitors you can look [here](/use/alerting/kubernetes-monitors.md).

## Overview

Health synchronization adds existing health checks from external monitoring systems to SUSE Observability topology elements. Health data is calculated in the external monitoring system using its own data and rules, then automatically synchronized and attached to the associated topology elements in SUSE Observability.

## Set up health synchronization

The SUSE Observability Receiver API will automatically receive and process all incoming health data. SUSE Observability doesn't require additional configuration to enable health synchronization, however, the health data received should match the expected JSON format.

Details on how to ingest health data can be found on the following pages:

* [Ingest health data through the SUSE Observability Receiver API](send-health-data/send-health-data.md)


## Health synchronization pipeline

The health synchronization framework works as follows:

* Health data is sent to SUSE Observability and ingested via the Receiver API.
* SUSE Observability topology elements related to the ingested health checks are identified and bound based on:
  * the topology identifiers obtained during topology synchronization.
  * the `topologyElementIdentifier` from the ingested [health payload](send-health-data/send-health-data.md#json-health-payload).
* SUSE Observability keeps track of changes to both topology elements and health checks to maintain up-to-date information.

![Health synchronization pipeline](../../.gitbook/assets/health-sync-pipeline.svg)

### Consistency models
SUSE Observability health synchronization relies on different consistency models to guarantee that the data sent from an external monitoring system matches with what SUSE Observability ingests and shows. The consistency model is specified in the `"health"` property of the [common JSON object](/configure/health/send-health-data/send-health-data.md#common-json-object) or as an argument in the SUSE Observability CLI when health data is sent to SUSE Observability. The supported models are: `REPEAT_SNAPSHOTS`, `REPEAT_STATES` and `TRANSACTIONAL_INCREMENTS`. 
{% tabs %}
{% tab title="Repeat snapshots model" %}
The `REPEAT_SNAPSHOTS` consistency model works with periodic, full snapshots of all checks in an external monitoring system. SUSE Observability keeps track of the checks in each received snapshot and decides if associated external check states need to be created, updated or deleted in SUSE Observability. For example, if a check state is no longer present in a snapshot. This model offers full control over which external checks will be deleted as all decisions are inferred from the received snapshots. There is no ambiguity over the external checks that will be present in SUSE Observability.

**Use this model when:** The external monitoring system is capable of keeping the state of which elements are present in a determined time window and therefore can communicate how the full snapshot looks like. 

**JSON payload:** The [Repeat Snapshots health payload](/configure/health/send-health-data/repeat_snapshots.md) accepts specific properties to specify when a snapshot starts or stops.
{% endtab %}

{% tab title="Repeat States model" %}
The `REPEAT_STATES` consistency model works with periodic checks received from an external monitoring system. SUSE Observability keeps track of the checks and decides if associated external checks need to be created or updated in SUSE Observability. A configurable expiry mechanism is used to delete external checks that aren't observed anymore. This model offers less control over data than the `REPEAT_SNAPSHOTS` model. As an expiry configuration is used to delete external checks, it might happen that elements are deleted due to barely missing the expiry timeout. This would reflect as external checks disappearing and reappearing in SUSE Observability.

**Use this model when:** The external monitoring system isn't capable of collecting all checks in a determined time window. The best effort is just to send the external checks as they're obtained.

**JSON payload:** The [Repeat States health payload](/configure/health/send-health-data/repeat_states.md) accepts specific properties to specify the expiry configuration.
{% endtab %}

{% tab title="Transactional Increments model" %}
The `TRANSACTIONAL_INCREMENTS` consistency model is designed to be used on streaming systems where only incremental changes are communicated to SUSE Observability. As there is no repetition of data, data consistency is upheld by ensuring that at-least-once delivery is guaranteed across the entire pipeline. To detect whether any data is missing, SUSE Observability requires that both a checkpoint and the previous checkpoint are communicated together with the `check_states`. This model requires strict control across the whole pipeline to guarantee no data loss.

**Use this model when:** The external monitoring system doesn't have access to the total external checks state, but only works on an event based approach. 

**JSON payload:** The metadata `repeat_interval` and `expire_interval` aren't relevant for the [Transactional Increments health payload](/configure/health/send-health-data/transactional_increments.md) as there is no predefined periodicity on the data.

{% endtab %}
{% endtabs %}

### Health stream and substream

External monitoring systems send health data to the SUSE Observability Receiver in a health stream. Each health stream has at least one substream with health checks.

#### Health stream

The Health stream uniquely identifies the health synchronization and defines the boundaries within which the health check states should be processed together.

#### Substream

Sub streams contain the health check data that are processed by SUSE Observability. When working with health data from a distributed external monitoring system, multiple sub streams can be configured, each containing health snapshots from a single location. The data in each substream is semi-independent, but contributes to the health check states of the complete health stream. If a single location is responsible for reporting the health check states of the health stream, you can omit the `sub_stream_id` from the [health payload](/configure/health/send-health-data/send-health-data.md#json-health-payload). SUSE Observability will assume that all the external health checks belong to a single, default substream. 


### Repeat Interval

Health synchronization processes the ingested health data per substream. The repeat interval specified in the [health payload](/configure/health/send-health-data/send-health-data.md#json-health-payload) is the commitment from the external monitoring system to send complete snapshots over and over to keep the data up to date on SUSE Observability. This is helpful for SUSE Observability to be able to inform the user how up to date the health synchronization is running.

### Expire Interval

The expire interval can be used to configure sub streams in the health synchronization to delete data that isn't sent by the external system anymore. This is helpful in case the source for a substream could be decommissioned and SUSE Observability would not hear from it again. Without an expire interval, the previously synchronized data would be left permanently hanging.

### Check State

The health check state is calculated by an external monitoring system and includes all information required to attach it to a topology element. In order to be able to materialize and attach it to a component it requires to attribute the health state to a particular monitor in this case an [ExternalMonitor](#external-monitor).

Once attached to a topology element, the health check state contributes to the element's own health state. 

### External Monitor

An external monitor allows to attach the health states to components and to show a remediationHint on the SUSE Observability highlight pages. This resource needs to be created via the [SUSE Observability CLI](../../setup/cli/cli-sts.md) or as part of a stackpack. Here is an example of an externa monitor:

```
    {
      "_type": "ExternalMonitor",
      "healthStreamUrn": "urn:health:kubernetes:external-health",
      "description": "Monitored by external tool.",
      "identifier": "urn:custom:external-monitor:heartbeat",
      "name": "External Monitor Heartbeat",
      "remediationHint": "",
      "tags": [
        "heartbeat"
      ]
    }
```
Every `ExternalMonitor` payload has the following details:

* `_type`: SUSE Observability needs to know this is a monitor so, value always needs to be `ExternalMonitor`
* `healthStreamUrn`: This field needs to match the `urn` that is sent as part of the [Health Payload](/configure/health/send-health-data/repeat_snapshots.md#json-property-health).
* `description`: A description of the external monitor.
* `identifier`: An identifier of the form `urn:custom:external-monitor:....` which uniquely identifies the external monitor when updating its configuration.
* `name`: The name of the external monitor
* `remediationHint`: A description of what the user can do when the monitor fails. The format is markdown. 
* `tags`: Add tags to the monitor to help organize them in the monitors overview of your SUSE Observability instance, http://your-SUSE Observability-instance/#/monitors

Here is an example of how to create an `External Monitor` using the [SUSE Observability CLI](../../setup/cli/cli-sts.md)
* Create a new YAML file called `externalMonitor.yaml` and add this YAML template to it to create your own external monitor.
```
nodes:
- _type: ExternalMonitor
  healthStreamUrn: urn:health:sourceId:streamId
  description: Monitored by external tool.
  identifier: urn:custom:external-monitor:heartbeat
  name: External Monitor Heartbeat
  remediationHint: |-
    To remedy this issue with the deployment {{ labels.deployment }}, consider taking the following steps:
    
    1. Look at the logs of the pods created by the deployment
  tags:
    - heartbeat
```
* Use the cli to create the external monitor
```bash
sts settings apply -f externalMonitor.yaml 
✅ Applied 1 setting node(s).                                                                                                                                                                                                               

TYPE            | ID              | IDENTIFIER                            | NAME                      
ExternalMonitor | 150031117290020 | urn:custom:external-monitor:heartbeat | External Monitor Heartbeat
```

## See also

* [JSON health payload](/configure/health/send-health-data/send-health-data.md#json-health-payload)

