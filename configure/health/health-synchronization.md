# Health synchronization

## Overview

Health synchronization allows you to add existing health checks from external monitoring systems to StackState topology elements. Health data is calculated in the external monitoring system using its own data and rules, then automatically synchronized and attached to the associated topology elements in StackState.

## Set up health synchronization

The StackState receiver API will automatically receive and process all incoming health data. No additional configuration is required in StackState to enable this, however, the health data received should match the expected JSON format.

Details on how to ingest health data can be found on the following pages:

* [Ingest health data through the StackState Receiver API](send-health-data.md)
* [Create an Agent check to ingest health data using the StackState Agent](../../develop/developer-guides/agent_check/how_to_develop_agent_checks.md)

## Health synchronization pipeline

The health synchronization framework works as follows:

* Health data is sent to StackState and ingested via the Receiver API.
* StackState topology elements related to the ingested health checks are identified and bound based on:
  * the [topology identifiers](../topology/sync.md#id-extraction) obtained during topology synchronization.
  * the [topologyElementIdentifier](send-health-data.md#json-property-health) from the ingested health payload.
* StackState keeps track of changes to both topology elements and health checks to maintain up to date information.

![Health synchronization pipeline](../../.gitbook/assets/health-sync-pipeline.svg)

### Health stream and sub stream

External monitoring systems send health data to the StackState Receiver API as snapshots in a health stream. Each health stream contains at least one sub stream with health check snapshots.

|  |  |
| :--- | :--- |
| **Health stream** | The Health stream uniquely identifies the health synchronization and defines the boundaries within which the health check states should be processed together. |
| **Sub stream** | Sub streams contain the health check snapshots that are processed by StackState. When working with health data from a distributed external monitoring system, multiple sub streams can be configured, each containing health snapshots from a single location. The data in each sub stream is semi-independent, but contributes to the health check states of the complete health stream. If a single location is responsible for reporting the health check states of the health stream, the `sub_stream_id` can be omitted from the [health payload](send-health-data.md#json-property-health). StackState will assume that all the external health checks belong to a single, default sub stream. |

### Repeat Interval

Health synchronization processes the ingested health data in a snapshots per sub stream. The repeat interval specified in the [health payload](send-health-data.md#json-property-health) is the commitment from the external monitoring system to send complete snapshots over and over in order to keep the data up to date on StackState. This is helpful for StackState to be able to inform the user how up to date the health synchronization is running.

### Expire Interval

The expire interval can be used to configure sub streams in the health synchronization to delete data that is not sent by the external system anymore. This is helpful in case the source for a sub stream could potentially be decommissioned and StackState would not hear from it again. Without an expire interval, the previously synchronized data would be left permanently hanging.

### Check State

The health check state calculated by an external monitoring system. This contains the relevant information to attach to a topology element and to contribute to the topology element health state.

## See also

* [Add a health check based on telemetry available in StackState](../../use/health-state/add-a-health-check.md)
* [JSON health payload](send-health-data.md#json-property-health)
* [Topology synchronization](../topology/topology_synchronization.md)

