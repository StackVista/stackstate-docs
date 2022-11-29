---
description: StackState Self-hosted v5.1.x 
---

# Debug telemetry synchronization

## Overview

This page explains the [telemetry synchronization process](#synchronization-process) and how to go about troubleshooting issues with telemetry synchronization.

## Troubleshooting  steps

If telemetry data isn't available in StackState, follow the steps below to pinpoint the issue.

**Identify the scale of impact**

The first step in troubleshooting a telemetry issue is to identify if all metrics are missing or just specific metrics from a single integration. To do this: 

1. Click through the topology in the StackState UI to check which components have telemetry available. If telemetry is missing for a single integration only, this will be clear in the elements and views associated with this integration. 
2. Open the [telemetry inspector](/use/metrics/browse-telemetry.md) and adjust the selected metric and filters to check if any telemetry data is available.
   * Metrics from all integrations that run through StackState Agent (push-based) can be found in the data source **StackState Metrics**. 
   * Metrics from integrations that run through StackState plugins or the Prometheus mirror (pull-based) can be found in the associated data source that has been configured in the StackState Settings. 

**If the problem relates to a single integration:**

* If the affected integration runs through StackState Agent (push-based):
  1. Start by checking [StackState Agent](#stackstate-agent).
  2. Confirm that telemetry data has arrived in [Elasticsearch](#elasticsearch).
* Check the filters in [the element telemetry stream configuration](#telemetry-stream-configuration). These should match the data received from the external source.

**If the problem affects all integrations:**

* Check the [StackState Agents](#stackstate-agent) for connecting to the external source system or StackState.
* Check the [StackState Receiver](#stackstate-receiver) for problems decoding incoming data.

## How telemetry is synchronized

### Synchronization process

Telemetry is either pushed to StackState by a StackState Agent, or pulled from an external data source by a StackState plugin or the Prometheus mirror.

![Telemetry synchronization process](/.gitbook/assets/telemetry-sync.svg)

1. StackState Agent:
   * Connects to a data source to collect data.
   * Connects to the StackState Receiver to push collected data to StackState (in JSON format).
   * Read the [troubleshooting steps for StackState Agent](#stackstate-agent)
2. StackState Receiver:
   * Extracts topology and telemetry payloads from the received JSON.
   * Read the [troubleshooting steps for StackState Receiver](#stackstate-receiver).
3. Elasticsearch in StackState:
   * Stores telemetry data received via the StackState Receiver. 
   * Read the [troubleshooting steps for Elasticsearch](#elasticsearch). 
4. StackState plugins:
   * Pull data from AWS, Azure, external Elasticsearch, Prometheus or Splunk at the `Minimum live stream polling interval (seconds)` configured for the data source.
5. Telemetry stream configuration:
   * Specifies the telemetry data that should be included in the stream.
   * For push-based synchronizations, Elasticsearch is queried to retrieve telemetry data.
   * For pull-based integrations, telemetry data is requested from an external source system by a StackState plugin or the prometheus mirror.
   * Attaches retrieved telemetry data to the element in StackState.
   * Read the [troubleshooting steps for element telemetry stream configuration](#telemetry-stream-configuration).

### StackState Agent

For integrations that run through StackState Agent, StackState Agent is a good place to start an investigation.
- Check the [StackState Agent log](#stackstate-agent) for hints that it has problems connecting to StackState.
- The integration can be triggered manually using the `stackstate-agent check <check_name> -l debug` command on your terminal. This command won't send any data to StackState. Instead, it will return the topology and telemetry collected to standard output along with any generated log messages.

Note that for the Kubernetes and OpenShift integrations, different Agent types supply different sets of metrics. 

- **StackState Agents (node Agents):** Supplies metrics from the node on which they're deployed on. If the Checks Agent is disabled, the node agent will collect metrics from kube-state-metrics instead of the Checks Agent.
- **Checks Agent:** Supplies metrics from kube-state-metrics.

### StackState Receiver

The StackState Receiver receives JSON data from StackState Agent V2. 

- Check the [StackState Receiver logs](#stackstate) for JSON deserialization errors..

### Elasticsearch

Telemetry data from push-based integrations is stored in an Elasticsearch index. The naming of the fields within the index is entirely based on the data retrieved from the external source system.

- Use the [telemetry inspector](/use/metrics/browse-telemetry.md) to check which data is available in Elasticsearch by selecting the data source `StackState Multi Metrics`. CLick in the **Select** box to list all metrics available in the selected data source. Note that if no data is available for a telemetry stream, the telemetry inspector can still be opened by selecting **inspect** from the context menu (the triple dots menu in the top-right corner of the telemetry stream). 
- If the expected data isn't in Elasticsearch, check the [KafkaToES log](#stackstate) for errors.

### Telemetry stream configuration

To add telemetry to an element, the filters specified for each telemetry stream attached to an element are used to build a query. For push-based synchronizations, Elasticsearch is queried to retrieve the associated telemetry data. For pull-based synchronizations, the associated StackState plugin queries the external data source directly. 

In the StackState UI, [open the telemetry inspector](/use/metrics/browse-telemetry.md) to see details of the applied filters:

- Check that data is available for the selected filters. An update to an external system may result in a change to the name applied to metrics in Elasticsearch or no results being returned when the external data source is queried.
- Use auto-complete to select the filters. This ensures that the correct names are entered.

## Log files

### StackState

{% tabs %}
{% tab title="Kubernetes" %}
When StackState is deployed on Kubernetes, there are pods with descriptive names and logging is output to standard out.

The following logs may be useful when debugging telemetry synchronization:

* There is a pod for the StackState Receiver.
* There is a pod for each Kafka-to-Elasticsearch process. These processes are responsible for getting telemetry data to Elasticsearch. Note that there are processes for metrics, events, and traces. For example, the pod `stackstate-mm2es` is responsible for metrics.

➡️ [Learn more about StackState logs on Kubernetes](/configure/logging/kubernetes-logs.md)
{% endtab %}
{% tab title="Linux" %}
When deployed on Linux, StackState log files are located in the directory:

```yaml
/opt/stackstate/var/log
```

The following log files may be useful when debugging telemetry synchronization:

* **StackState Receiver:** `/opt/stackstate/var/log/stackstate-receiver`
* **kafkaToEs:** `/opt/stackstate/var/log/kafka-to-es` - contains logs for the processes that are responsible for getting telemetry data to Elasticsearch. Note that there are separate processes for metrics, events, and traces.
* **ElasticSearch:** `/opt/stackstate/var/log/elasticsearch7`

➡️ [Learn more about the StackState log files](/configure/logging/linux-logs.md)
{% endtab %}
{% endtabs %}

### StackState Agent

For details of StackState Agent V2 log files, see the platform-specific Agent pages:

* [StackState Agent V2 on Docker](/setup/agent/docker.md#log-files)
* [StackState Agent V2 on Kubernetes](/setup/agent/kubernetes-openshift.md#log-files)
* [StackState Agent V2 on Linux](/setup/agent/linux.md#log-files)
* [StackState Agent V2 on Windows](/setup/agent/windows.md#log-files)

## See also

* [Working with StackState log files](/configure/logging/README.md)
* [Browse telemetry](/use/metrics/browse-telemetry.md)
* [Add a telemetry stream to an element](/use/metrics/add-telemetry-to-element.md)
