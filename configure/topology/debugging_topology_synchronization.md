# Debug topology synchronization

## Overview

This page explains several tools that can be used to debug a custom topology synchronization. For more information on individual synchronization concepts, read about [topology synchronization in StackState](topology_synchronization.md).

## Topology synchronization process

A topology synchronized using StackState Agent follows the process described below:

![Topology synchronization with StackState Agent](/.gitbook/assets/topo_sync_process.svg)

* StackState Agent:
  - Connects to a data source to collect data.
  - Connects to the StackState receiver to push collected data to StackState (in JSON format).
* StackState receiver:
  - Extracts topology and telemetry payloads from the received JSON.
  - Puts messages on the Kafka bus.
* Kafka:
  - Stores received data in topics.
* StackState topology synchronization:
  - Reads data from a topic as it becomes available on the Kafka bus.
  - Processes retrieved data.

## General troubleshooting steps

To verify issues follow these common steps:

1. [List all topology synchronization streams](debugging_topology_synchronization.md#list-all-topology-synchronization-streams). The topology synchronization should be included in the list and have created components and relations.
2. [Check the status of the topology synchronization stream](debugging_topology_synchronization.md#show-status-of-a-stream) for the error count. 
3. [Check the logs](#synchronization-logs).

## Synchronization logs

{% tabs %}
{% tab title="Kubernetes" %}
When StackState is deployed on Kubernetes, logs about synchronization can be found in the `stackstate-sync` pod and the `stackstate-api` pod. The name of the synchronization is shown in the log entries.

* The `stackstate-sync` pod contains details of:
  * Template/mapping function errors.
  * Component types that do not have a mapping.
  * Relations connected to a non-existing component.
  * Messages that have been discarded due to a slow synchronization.

* The `stackstate-api` pod contains details of:
  * ID extractor errors.

{% endtab %}

{% tab title="Linux" %}
When StackState is deployed on Linux, logs about synchronization are stored in the directory:

`<my_install_location>/var/log/sync/`

There are two log files for each synchronization:

1. `exttopo.<DataSource_name>.log` contains information about ID extraction and the building of an external topology. Here you will find details of:
  * ID extractor errors.
  * Relations connected to a non-existing component.
  * Messages that have been discarded due to a slow synchronization.

2. `sync.<Synchronization_name>.log` contains information about mapping, templates and merging. Here you will find details of:
  * Template/mapping function errors.
  * Component types that do not have a mapping.

{% endtab %}
{% endtabs %}

## Common Issues

### Components/relations not synchronized

If no components appear after making changes to a synchronization, or the data is not as expected, check the synchronizations page in the StackState UI. Go to **Settings** > **Topology Synchronization** > **Synchronizations** from the main menu and check if any errors have been reported.

![Synchronization errors](/.gitbook/assets/settings_synchronizations.png)

If there are errors reported:
* [Check the synchronization logs](#synchronization-logs) for details.

If there are no errors, check the following:
* Did you restart the synchronization and send new data after making changes? StackState will not retroactively apply changes.
* Do the components/relations to be synchronized have their type mapped in the synchronization configuration?
* Is data arriving in StackState? You can use the [StackState CLI](/setup/installation/cli-install.md) to see what data ends up on the synchronization topic:

```
# Show all Kafka topics that are present for Synchronizations to use
sts topology list-topics

# Look for a topic named: sts_topo_<instance_type>_<instance url> where:
#   <instance_type> is the name of the integration 
#   <instance_url> corresponds to the StackState Agent integration YAML (usually the URL of the data source)

# Inspect the topology messages in the Kafka topic
sts topic show <topic_name>
```
  

## Useful CLI commands

### List all Topology Synchronization streams

Returns a list of all current topology synchronization streams.

```javascript
# List streams
sts topology list

        Node Id  Identifier                                                                               Status      Created Components    Deleted Components    Created Relations    Deleted Relations    Errors
---------------  ---------------------------------------------------------------------------------------  --------  --------------------  --------------------  -------------------  -------------------  --------
245676427469735                                                                                           Running                      0                     0                    0                    0         0
154190823099122  urn:stackpack:stackstate-agent-v2:shared:sync:agent                                      Running                 761818                763870              1517959              1519490         0
144667609743389  urn:stackpack:stackstate:instance:44a9ce1e-413c-4c4c-819d-2095c1229dda:sync:stackstate   Running                  13599                  5496                    0                    0       329
```

### Show status of a stream 

Shows the data of a specific topology synchronization stream. The `id` might be either a `node id` or the identifier of a topology synchronization. The search gives priority to the `node id`.

```javascript
# Show a topology synchronization status
sts topology show urn:stackpack:stackstate:instance:44a9ce1e-413c-4c4c-819d-2095c1229dda:sync:stackstate

        Node Id  Identifier                                                                               Status      Created Components    Deleted Components    Created Relations    Deleted Relations    Errors
---------------  ---------------------------------------------------------------------------------------  --------  --------------------  --------------------  -------------------  -------------------  --------
144667609743389  urn:stackpack:stackstate:instance:44a9ce1e-413c-4c4c-819d-2095c1229dda:sync:stackstate   Running                  13599                  5496                    0                    0       329
```
