# Debug topology synchronization

## Overview

This page explains several tools that can be used to debug a topology synchronization.

## Topology synchronization process

A topology synchronized using StackState Agent follows the process described below:

![Topology synchronization with StackState Agent](/.gitbook/assets/topo_sync_process.svg)

1. StackState Agent:
  - Connects to a data source to collect data.
  - Connects to the StackState receiver to push collected data to StackState (in JSON format).
2. StackState receiver:
  - Extracts topology and telemetry payloads from the received JSON.
  - Puts messages on the Kafka bus.
3. Kafka:
  - Stores received data in topics.
4. Synchronization:
  - Reads data from a topic as it becomes available on the Kafka bus.
  - Processes retrieved data.

## Troubleshooting steps

If no components appear after making changes to a synchronization, or the data is not as expected:

### StackState Agent

For integrations that run through StackState Agent, StackState Agent is a good place to start your investigation.
- The [synchronization logs](#synchronization-logs) will tell you if an integration was able to complete and errors will show up here. 
- Check the [StackState Agent log](/setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2) for hints that it has problems connecting to StackState.
- The integration can be triggered manually using the `stackstate-agent check <check_name> -l debug` command on your terminal. This command will not send any data to StackState. Instead, it will return the topology and telemetry collected to standard output along with any generated log messages.

### StackState receiver

The StackState receiver receives JSON data from the StackState Agent. 
- Check the [StackState receiver logs](#stackstate-receiver-logs) for JSON deserialization errors. 


### Kafka

Topology and telemetry are stored on Kafka, on separate topics. The StackState topology synchronization reads data from a Kafka bus once it becomes available. The Kafka topic used is defined in the Sts data source.

- Use the StackState CLI to list all topics present on Kafka `sts topology list-topics`. A topic should be present where the name has the following format; `sts_topo_<instance_type>_<instance url>` where `<instance_type>` is the recognizable name of an integration and `<instance_url>` corresponds to the Agent integration YAML, usually the URL of the data source.
- Check the messages on the Kafka topic using the StackState CLI command `sts topic show <topic_name>`. If there are recent messages on the Kafka bus, then you know that the issue is not in the data collection.
- Check if the Sts data source defined topic name matches what is returned by the `stackstate-agent check` command. Note that topic names are case-sensitive.

### Processing
   
Increasing error numbers in the StackState UI **Settings** > **Topology Synchronization** > **Synchronizations** page tell you that processing the received data resulted in an error. 
  
![Synchronization errors](/.gitbook/assets/settings_synchronizations.png)

To troubleshoot processing errors, refer to the relevant log files. The log messages will help you in resolving the issue.

- Check the `stackstate.log` or, for Kubernetes, the `stackstate-api` pod. 
  - If there is an issue with the ID extractor, an exception will be logged here on each received topology element. No topology will be synchronized, however, the synchronization’s error counter will not increase.

- Check the synchronization’s specific log file or, for Kubernetes, the `stackstate-sync` pod for log messages including the synchronization’s name.
  - Issues with a mapper function defined for a synchronization mapping will be reported here. The type is also logged to help determine which mapping to look at. The synchronization’s error counter will increase.
  - Issues with templates are also logged here. The synchronization’s error counter will increase.


### Relations

It is possible that relations reference to a source or target component that does not exist. Components are always processed before relation. If a component is not present in the synchronization’s topology, the relation will not be created, and a warning is logged to the synchronization’s specific log file or the `stackstate-sync` pod. The component external ID and relation external ID are logged to help.






-------




1. [List all topology synchronization streams](debugging_topology_synchronization.md#list-all-topology-synchronization-streams). The topology synchronization should be included in the list and have created components and relations.
2. [Check the status of the topology synchronization stream](debugging_topology_synchronization.md#show-status-of-a-stream) for the error count. 
3. [Check the logs](#synchronization-logs).

## Log files of interest

### Synchronization logs

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

Logs for the StackState receiver can be found in the StackState receiver pod.

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

Logs for the StackState receiver are stored in the directory:

`<my_install_location>/var/log/stackstate-receiver`

{% endtab %}
{% endtabs %}

### StackState receiver logs

{% tabs %}
{% tab title="Kubernetes" %}
When StackState is deployed on Kubernetes, logs for the StackState receiver can be found in the StackState receiver pod.

{% endtab %}

{% tab title="Linux" %}
When StackState is deployed on Linux, logs for the StackState receiver are stored in the directory:

`<my_install_location>/var/log/stackstate-receiver`

{% endtab %}
{% endtabs %}

## Common Issues

### No data sync

check the synchronizations page in the StackState UI. Go to **Settings** > **Topology Synchronization** > **Synchronizations** from the main menu and check if any errors have been reported.

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

Shows the data of a specific topology synchronization stream, including detalied latency of the data being processed. The `id` might be either a `node id` or the identifier of a topology synchronization. The search gives priority to the `node id`.

```javascript
# Show a topology synchronization status
sts topology show urn:stackpack:stackstate:instance:44a9ce1e-413c-4c4c-819d-2095c1229dda:sync:stackstate

        Node Id  Identifier                                                                               Status      Created Components    Deleted Components    Created Relations    Deleted Relations    Errors
---------------  ---------------------------------------------------------------------------------------  --------  --------------------  --------------------  -------------------  -------------------  --------
144667609743389  urn:stackpack:stackstate:instance:44a9ce1e-413c-4c4c-819d-2095c1229dda:sync:stackstate   Running                  13599                  5496                    0                    0       329

metric               value between now and 500 seconds ago  value between 500 and 1000 seconds ago    value between 1000 and 1500 seconds ago
-----------------  ---------------------------------------  ----------------------------------------  -----------------------------------------
latency (Seconds)                                   35.754  ---                                       ---
```
