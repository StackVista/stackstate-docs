# Health synchronization

## Overview

One of the ways to get health checks into StackState topology elements is by synchronizing the data from an existing monitoring solution that has already calculated them with it's on data and rules. StackState allows you to automatically synchronize the health state from your existing monitoring solution into StackState and to relate it to your topology elements ingested via [Topology synchronization](../topology/topology_synchronization.md)

## Set up health synchronization
The StackState receiver API will receive and process all health data sent to it by an existing monitoring solution. No additional configuration is required in StackState to enable this, however, the received data should match the expected JSON format. For details, see [send health data over HTTP](/configure/health/send-health-data.md).


## Synchronization pipeline
The health synchronization framework works by first ingesting the health data sent to the Receiver API and in a second step trying to find topology elements related to the just ingested health checks, the binding is created based on the topology [identifiers](../topology/sync.md#id-extraction) obtained during the topology synchronization and the [topologyElementIdentifier](send-health-data.md#health-json) part of the health payload. StackState keeps track of both topology element changes as well as health check changes to keep up to date the information on StackState topology.

![Health synchronization pipeiline](/.gitbook/assets/health-sync-pipeline.svg)

### Stream and SubStream
The stream uniquely indentifies the health synchronization and defines the boundaries of which check states should be processed together in strict order, within the stream we have the SubStream in which the snapshot lifecyles are applied. The SubStream is the way StackState offers to model when the agents to report health for a single stream are distributed in different locations and which data is semi independent form each other as well as their own snapshots but in the end they all contribute to the check states for a stream. It's possible to model a health synchronization without defining a SubStream, for example when a single agent is responsible of reporting the check states for a stream, in that case the `sub_stream_id` can be omitted and StackState will assume all the external checks belong to a single default SubStream.

### Repeat Interval
As previously mentioned StackState health synchronization process the checks data in a snapshots per SubStream, the repeat interval is the commitment from the external system to send complete snapshots over and over in order to keep the data up to date on StackState. This is helpful for StackState in order to inform the user how uo to date is the health synchronization running.

### Expire Interval
The expire interval is the way to configure SubStreams the health synchronization to delete data thats is not sent by the external system anymore, it's helpful when the agent of the specific SubStream could potentially be decommissioned and StackState would not here from it gaian leaving it's previosuly synchronized data hanging permanently.

{% hint style="info" %}
The health expire feature is still under development, so currently the `expiry_interval_s` value is not used at all.
{% endhint %}

### Check State
The single health check calculated by an external system which contains the relevant information to show it attached to a topology elemement and to contribute to the topology element health state.


## See also