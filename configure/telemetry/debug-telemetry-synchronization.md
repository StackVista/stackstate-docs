# Debug telemetry synchronization

## Overview

This page explains how to go aabout debugging issues with telemetry synchronization.

## Telemetry synchronization process

Telemetry is pushed to StackState by StackState Agent or pulled by a StackState plugin or the prometheus mirror.

![Telemetry synchronization process](/.gitbook/assets/telemetry-sync-2.svg)

1. StackState Agent:
   * Connects to a data source to collect data.
   * Connects to the StackState receiver to push collected data to StackState (in JSON format).
   * Read the [troubleshooting steps for StackState Agent](#stackstate-agent)
2. StackState receiver:
   * Extracts topology and telemetry payloads from the received JSON.
   * Read the [troubleshooting steps for StackState receiver](#stackstate-receiver).
3. Elasticsearch in StackState:
   * Stores telemetry data received via the StackState receiver. 
   * Read the [troubleshooting steps for Elasticsearch](#elasticsearch). 
4. StackState plugins:
  * Pull data from AWS, Azure, external Elasticsearch, Prometheus or Splunk on demand.
5. Element telemetry stream configuration:
   * Queries Elasticsearch and attaches retrieved telemetry data to the element in StackState.
   * Read the [troubleshooting steps for element telemetry stream configuration](#element-telemetry-stream-configuration).

## Troubleshooting steps

### General troubleshooting

1. Identify the scale of impact - are all metrics missing or specific metrics from a single integration?
   * Click through the topology in the StackState UI to check which components have telemetry available. If telemetry is only available for a single integration, this will be clear in the elements and views associated with this integration.
   * Open the [telemetry browser](/use/metrics-and-events/browse-telemetry.md) and adjust the selected metric and filters to check if any telemetry data is available. The available metrics are listed under **Select**. 
2. If the problem relates to a single integration:
   * If the integration runs through StackState Agent, start by checking [StackState Agent](#stackstate-agent).
   * Confirm that telemetry data has arrived in [Elasticsearch](#elasticsearch).
   * Check the filters in [the element telemetry stream configuration](#element-telemetry-stream-configuration). These should match the data received in Elasticsearch from the external source.
3. If no telemetry data is available in StackState:
   * Check the [StackState Agents](#stackstate-agent) for problems retrieving data from the source system or connecting to StackState.
   * Check the [StackState receiver](#stackstate-receiver) for problems decoding incoming data.

### StackState Agent

For integrations that run through StackState Agent, StackState Agent is a good place to start an investigation.
- Check the [StackState Agent log](/setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2) for hints that it has problems connecting to StackState.
- The integration can be triggered manually using the `stackstate-agent check <check_name> -l debug` command on your terminal. This command will not send any data to StackState. Instead, it will return the topology and telemetry collected to standard output along with any generated log messages.

Note that for the Kubernetes and OpenShift integrations, different Agent types supply different sets of metrics. 

- **StackState Agents (node Agents):** Supply metrics from the node on which they are deployed only. If cluster checks are not enabled, the Agent will also report metrics from kube-state-metrics if it is deployed on the same node.
- **Cluster Agent:** ???
- **ClusterCheck Agent:** Deployed only when cluster checks are enabled, supplies metrics from kube-state-metrics.

### StackState receiver

The StackState receiver receives JSON data from the StackState Agent. 

- Check the StackState receiver logs for JSON deserialization errors. 

### Elasticsearch

Telemetry data from push-based integrations is stored in Elasticsearch indexes. The naming of indexes and the fields within them are entirely based on the data retrieved from the external source system.

- ???

### Element telemetry stream configuration

To add telemetry to an element, Elasticsearch is queried using the filters specified for each telemetry stream attached to the element. In the StackState UI, [browse a telemetry stream](/use/metrics-and-events/browse-telemetry.md) to see details  of the applied filters.

- Check that the filters match the data received from the external data source. For example, an update to an external system may result in a change to the name applied to metrics in Elasticsearch.
- Use auto-complete to fill the filters. This ensures that the correct names are entered.

## Synchronization logs

???
* StackState Agent log
* Receiver log

## See also

* [Working with StackState log files](/configure/logging/stackstate-log-files.md)
* [Browse telemetry](/use/metrics-and-events/browse-telemetry.md)
* [Add a telemetry stream to an element](/use/metrics-and-events/add-telemetry-to-element.md)