# Health synchronization

## Overview

Health synchronization allows you to add existing health checks from external monitoring systems to StackState topology elements. The synchronized health data has is calculated in the external monitoring system using its own data and rules, then automatically synchronized and attached to the associated topology elements in StackState that were ingested via [Topology synchronization](../topology/topology_synchronization.md).


## Set up health synchronization
The StackState receiver API will automatically receive and process all incoming health data. No additional configuration is required in StackState to enable this, however, the received data should match the expected JSON format. For details, see [send health data over HTTP](/configure/health/send-health-data.md).

## Health synchronization pipeline

The health synchronization framework works as follows: 

* Health data sent to the StackState Receiver API is ingested.
* StackState topology elements related to the ingested health checks are identified based on the [topology identifiers](../topology/sync.md#id-extraction) obtained during the topology synchronization and the [topologyElementIdentifier](send-health-data.md#health-json) from the ingested health payload. 
* The ingested health checks are bound to all associated topology elements.
* StackState keeps track of changes to both topology elements and health checks to maintain up to date information.

![Health synchronization pipeiline](/.gitbook/assets/health-sync-pipeline.svg)

### Health Stream and SubStream

External monitoring systems send health data to the StackState Receiver API in a health stream. Each health stream can optionally contain multiple SubStreams.

| | |
|:---|:---|
| **Health Stream** | The Health Stream uniquely identifies the health synchronization and defines the boundaries within which the health check states should be processed together in strict order. |
| **SubStream** |  SubStreams contain the health check lifecycle snapshots which are processed by StackState. When working with health data from a distributed external monitoring system, multiple SubStreams can be configured, each containing health snapshots from a single location. The data in each SubStream is semi-independent, but contributes to the health check states of the complete Health Stream. If a single location is responsible for reporting the health check states of the Health Stream, the `sub_stream_id` can be omitted from the [health payload](/configure/health/send-health-data.md). StackState will assume that all the external health checks belong to a single default SubStream. |

### Repeat Interval
Health synchronization processes the ingested health data in a snapshots per SubStream. The repeat interval is the commitment from the external system to send complete snapshots over and over in order to keep the data up to date on StackState. This is helpful for StackState in order to inform the user how uo to date is the health synchronization running.

### Expire Interval
The expire interval is the way to configure SubStreams the health synchronization to delete data thats is not sent by the external system anymore, it's helpful when the agent of the specific SubStream could potentially be decommissioned and StackState would not here from it gaian leaving it's previosuly synchronized data hanging permanently.

{% hint style="info" %}
The health expire feature is still under development, so currently the `expiry_interval_s` value is not used at all.
{% endhint %}

### Check State
The single health check calculated by an external system which contains the relevant information to show it attached to a topology elemement and to contribute to the topology element health state.


## See also