# Debug telemetry synchronization

## Overview

This page explains several tools that can be used to debug telemetry synchronization.

## Telemetry synchronization process

There are two types of integrations that deliver telemetry data to StackState:

- [Pull-based integrations](#pull-based-integrations) (AWS, Azure, Prometheus mirror and Splunk). 
- [Push-based integrations](#push-based-integrations) (all other integrations). 
 
The telemetry synchronization process for each type of integration is described below.

### Pull-based integrations

In pull-based integrations, a StackState plugin pulls telemetry data directly into ElasticSearch. This method is used by the StackState integrations with AWS, Azure and Splunk, and the Prometheus mirror. 

![Pull-based telemetry synchronization process](/.gitbook/assets/pull-based-telemetry.svg)

The process too synchronize telemetry using a pull-based integration is described below:

1. StackState plugin:
   * Pulls telemetry data from the external source system on demand.
2. Elasticsearch:
   * Stores telemetry data retrieved by the StackState plugins (pull-based integrations).
   * Telemetry data from push-based integrations is also stored here (retrieved from the Kafka topic `sts_multi_metrics`).
   * Read the [troubleshooting steps for Elasticsearch](#elasticsearch).
3. Element telemetry stream configuration:
   * Queries Elasticsearch and attaches retrieved telemetry data to the element in StackState.
   * Read the [troubleshooting steps for element telemetry stream configuration](#element-telemetry-stream-configuration).

### Push-based integrations

In push-based integrations, StackState Agent retrieves telemetry data from an external system and pushes it to the StackState receiver. 

![Push-based telemetry synchronization process](/.gitbook/assets/push-based-telemetry.svg)

The process too synchronize telemetry using a push-based integration is described below:

1. StackState Agent:
   * Connects to a data source to collect data.
   * Connects to the StackState receiver to push collected data to StackState (in JSON format).
   * Read the [troubleshooting steps for StackState Agent](#stackstate-agent).
2. StackState receiver:
   * Extracts topology and telemetry payloads from the received JSON. 
   * Puts messages on the Kafka bus. 
   * Read the [troubleshooting steps for StackState receiver](#stackstate-receiver).
3. Kafka:
   * Stores all telemetry data that arrives in the StackState receiver in the topic `sts_multi_metrics`.
   * Read the [troubleshooting steps for Kafka](#kafka).
4. Elasticsearch:
   * Stores telemetry data from the Kafka topic `sts_multi_metrics`.
   * Telemetry data from pull-based integrations is also stored here.
   * Read the [troubleshooting steps for Elasticsearch](#elasticsearch).
5. Element telemetry stream configuration:
   * Queries Elasticsearch and attaches retrieved telemetry data to the element in StackState.
   * Read the [troubleshooting steps for element telemetry stream configuration](#element-telemetry-stream-configuration).

## Troubleshooting steps

1. Identify the scale of impact - are all metrics missing or specific metrics from a single integration?
   * ???
2. If the problem relates to a single integration:
   * Check [Kafka](#kafka) to confirm that data has arrived in StackState. If not, check [StackState Agent](#stackstate-agent) for details.
   * Check [Elasticsearch](#elasticsearch) to confirm that data has arrived in Elasticsearch. If not, checked the applied limits in ???.
   * Check the filters placed on the telemetry stream in [StackState](#stackstate). These should match the data received from the external source.
3. If all metrics are missing from StackState, ???

### Kafka

Telemetry data from push-based integrations is stored on Kafka on the topic `sts_multi_metrics`. When data becomes available on the Kafka bus,`kafkaToES` reads data and stores it in an Elasticsearch index.

- Check the messages on the Kafka topic using the StackState CLI command `sts topic show sts_multi_metrics`. If there are recent messages on the Kafka bus, then you know that metrics have been retrieved and the issue is not in the data collection.

### Elasticsearch

Telemetry data from push-based and pull-based integrations are stored in Elasticsearch indexes. The naming of indexes and the fields within them are entirely based on the data retrieved from the external source system.

- ???

### StackState Agent

For integrations that run through StackState Agent, StackState Agent is a good place to start an investigation.
- Check the [StackState Agent log](/setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2) for hints that it has problems connecting to StackState.
- The integration can be triggered manually using the `stackstate-agent check <check_name> -l debug` command on your terminal. This command will not send any data to StackState. Instead, it will return the topology and telemetry collected to standard output along with any generated log messages.

Note that for the Kubernetes and OpenShift integrations, different Agents types supply different sets of metrics. 

- **StackState Agents (node Agents):** Supply metrics from the node on which it is deployed. If cluster checks are not enabled, the Agent will also report metrics from `kube-state-metrics` if it is deployed on the same node.
- **Cluster Agent:** ???
- **ClusterCheck Agent:** Deployed only when cluster checks are enabled, supplies metrics from `kube-state-metrics`.

### StackState receiver

The StackState receiver receives JSON data from the StackState Agent (for push-based integrations). 

- Check the StackState receiver logs for JSON deserialization errors. 

### Element telemetry stream configuration

To add telemetry to an element, Elasticsearch is queried using the filters specified for each telemetry stream attached to the element. In the StackState UI, [browse a telemetry stream](/use/metrics-and-events/browse-telemetry.md) to see details  of the applied filters.

- Check that the filters match the data received from the external data source. For example, an update to an external system may result in a change to the name applied to metrics in Elasticsearch.
- Use auto-complete to fill the filters. This ensures that the correct names are entered.

## Synchronization logs

???

## Useful CLI commands

### Show Kafka topic data

For all push-based integrations, telemetry data is stored in the Kafka topic `sts_multi_metrics`. Use the StackState CLI command below to show all data from this topic.

```
sts topic show sts_multi_metrics
```

## See also

* [Working with StackState log files](/configure/logging/stackstate-log-files.md)
* [Browse telemetry](/use/metrics-and-events/browse-telemetry.md)
* [Add a telemetry stream to an element](/use/metrics-and-events/add-telemetry-to-element.md)
