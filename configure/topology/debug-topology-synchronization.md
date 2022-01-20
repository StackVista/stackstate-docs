---
description: StackState SaaS
---

# Debug topology synchronization

## Overview

This page explains several tools that can be used to troubleshoot a topology synchronization.

## Topology synchronization process

A topology synchronized using StackState Agent follows the process described below:

![Topology synchronization with StackState Agent](/.gitbook/assets/topo_sync_process.svg)

1. StackState Agent:
   * Connects to a data source to collect data.
   * Connects to the StackState receiver to push collected data to StackState (in JSON format).
   * Read the [troubleshooting steps for StackState Agent](#stackstate-agent).
2. StackState receiver:
   * Extracts topology and telemetry payloads from the received JSON. 
   * Puts messages on the Kafka bus. 
   * Read the [troubleshooting steps for StackState receiver](#stackstate-receiver).
3. Kafka:
   * Stores received data in topics.
   * Read the [troubleshooting steps for Kafka](#kafka).
4. Synchronization:
   * Reads data from a topic as it becomes available on the Kafka bus. 
   * Processes retrieved data. 
   * Read the [troubleshooting steps for syncrhonization](#synchronization).

## Troubleshooting steps

1. Confirm that a custom synchronization is running: 
   - Use the StackState CLI to [list all topology synchronization streams](debug-topology-synchronization.md#list-all-topology-synchronization-streams). 
   - The synchronization should be included in the list and have created components/relations. 
   - If a custom synchronization is not listed, you will need to [recreate the synchronization](/configure/topology/sync.md).
2. If no components appear after making changes to a synchronization, or the data is not as expected, follow the steps described in the sections below to check each step in the [topology synchronization process](#topology-synchronization-process). 
3. If relations are missing from the topology, read the note on [troubleshooting synchronization of relations](#relations).

### StackState Agent

For integrations that run through StackState Agent, StackState Agent is a good place to start an investigation.
- Check the [StackState Agent log](/setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2) for hints that it has problems connecting to StackState.
- The integration can be triggered manually using the `stackstate-agent check <check_name> -l debug` command on your terminal. This command will not send any data to StackState. Instead, it will return the topology and telemetry collected to standard output along with any generated log messages.

### StackState receiver

The StackState receiver receives JSON data from the StackState Agent. 
 
- Check the StackState receiver logs for JSON deserialization errors. 

### Kafka

Topology and telemetry are stored on Kafka on separate topics. The StackState topology synchronization reads data from a Kafka bus once it becomes available.

- Use the StackState CLI to list all topics present on Kafka `sts topology list-topics`. A topic should be present where the name has the format `sts_topo_<instance_type>_<instance url>` where `<instance_type>` is the recognizable name of an integration and `<instance_url>` corresponds to the StackState Agent integration YAML, this is usually the URL of the data source.
- Check the messages on the Kafka topic using the StackState CLI command `sts topic show <topic_name>`. If there are recent messages on the Kafka bus, then you know that the issue is not in the data collection.

### Synchronization

The StackState topology synchronization reads messages from a topic on the Kafka data bus. The Kafka topic used by a synchronization is defined in the Sts data source.

- Check if the topic name defined in the Sts data source matches what is returned by the `stackstate-agent check` command. Note that topic names are case-sensitive.
- Check the error counter for the synchronization on the StackState UI page **Settings** > **Topology Synchronization** > **Synchronizations**. Increasing numbers tell you that there was an error while processing received data. 
  
![Synchronization errors](/.gitbook/assets/settings_synchronizations.png)

To troubleshoot processing errors, refer to the relevant StackState log files. The provided log messages will help you to resolve the issue. For details on working with the StackState log files on Kubernetes and Linux see the page [Configure > Logging > StackState log files](/configure/logging/stackstate-log-files.md).

- Check the `stackstate.log` or, for Kubernetes, the `stackstate-api` pod. 
  - If there is an issue with the ID extractor, an exception will be logged here on each received topology element. No topology will be synchronized, however, the synchronization’s error counter will **not** increase.

- Check the synchronization’s specific log file or, for Kubernetes, the `stackstate-sync` pod for log messages that include the synchronization’s name.
  - Issues with a mapper function defined for a synchronization mapping will be reported here. The type is also logged to help determine which mapping to look at. The synchronization’s error counter will increase.
  - Issues with templates are also logged here. The synchronization’s error counter will increase.

### Relations

It is possible that a relation references a source or target component that does not exist. Components are always processed before relations. If a component referenced by a relation is not present in the synchronization’s topology, the relation will not be created. When this happens, a warning is logged to the synchronization’s specific log file or the `stackstate-sync` pod. The component external ID and relation external ID are logged to help.

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
  * StackPacks.

{% hint style="info" %}
For details on working with the StackState log files on Kubernetes, see the page [Configure > Logging > StackState log files](/configure/logging/stackstate-log-files.md#kubernetes).
{% endhint %}

{% endtab %}

{% tab title="Linux" %}
When StackState is deployed on Linux, logs about synchronization are stored in the directory:

`<my_install_location>/var/log/sync/`

There are two log files for each synchronization:

* `exttopo.<DataSource_name>.log` contains information about ID extraction and the building of an external topology. Here you will find details of:
  * ID extractor errors.
  * Relations connected to a non-existing component.
  * Messages that have been discarded due to a slow synchronization.

* `sync.<Synchronization_name>.log` contains information about mapping, templates and merging. Here you will find details of:
  * Template/mapping function errors.
  * Component types that do not have a mapping.

Logs about StackPacks are stored in the directory:

`<my_install_location>/var/log/stackpacks/`

There is a log file for each StackPack. The name of the log file is set to the StackPack’s internal name. Information about the StackPack lifecycle can be found here.

{% hint style="info" %}
For details on working with the StackState log files on Linux, see the page [Configure > Logging > StackState log files](/configure/logging/stackstate-log-files.md#linux).
{% endhint %}

{% endtab %}
{% endtabs %}

## Useful CLI commands

### List all topology synchronization streams

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

## See also

* [Working with StackState log files](/configure/logging/stackstate-log-files.md)
* [Configure topology synchronizations](/configure/topology/sync.md)
