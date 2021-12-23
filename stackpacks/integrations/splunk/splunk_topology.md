---
description: StackState Self-hosted v4.5.x
---





# Splunk topology V1

{% hint style="info" %}
This page describes the Splunk topology V1 integration with StackState Agent V1.

**If you are running StackState Agent V2:** See the instructions on how to configure a [Splunk topology V2](splunk_topology_v2.md) check. You can also [upgrade](splunk_topology_upgrade_v1_to_v2.md) an existing Splunk topology V1 integration to use StackState Agent V2.
{% endhint %}

## Overview

The StackState Splunk topology V1 integration collects topology from Splunk by executing Splunk saved searches from [StackState Agent V1](../../../setup/agent/agent-v1.md). In order to receive Splunk topology data in StackState, configuration needs to be added to both Splunk and StackState Agent V1:

* [In Splunk](splunk_topology.md#splunk-saved-search), there should be at least one saved search that generates the topology data you want to retrieve.
* [In StackState Agent V1](splunk_topology.md#agent-check), a Splunk topology check should be configured to connect to your Splunk instance and execute the relevant Splunk saved searches.

The Splunk topology check on StackState Agent V1 will execute all configured Splunk saved searches periodically to retrieve a snapshot of the topology at the current time.

## Splunk saved search

In the Splunk Topology V1 integration, StackState Agent V1 executes the Splunk saved searches configured in the [Splunk topology Agent check configuration file](splunk_topology.md#agent-check) and pushes retrieved data to StackState components and relations. The fields from the results of a saved search that are sent to StackState for topology components and relations are listed in the table below.

### Topology components

The following fields from the results of a saved search are sent to StackState for topology components:

| Field | Type | Required? | Description |
| :--- | :--- | :--- | :--- |
| **id** | string | ✅ | The unique identifier for the component. |
| **name** | string | ✅ | The value will be used as the component name. |
| **type** | string | ✅ | The type of component or relation. |
| **labels** | multivalue field or comma separated string | - | The values will be added as labels on the component. |
| **identifiers** | multivalue field or comma separated string | - | The values will be included as identifiers of the component. |
| All other fields | - | - | [Splunk default fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields) other than `_time` will be filtered out of the result. Any other fields present in the result will be available in StackState in the `data` field of the component properties `source` tab. |

#### Example query for components

{% tabs %}
{% tab title="Splunk query for components" %}
```text
| datamodel uberAgent60m System_MachineInventory search 
| dedup host 
| eval id = upper(host) | strcat "urn:host:/" id identifier
| eval name = 'id'
| eval type="host" 
| eval domain="uberAgent" 
| eval layer="Machines" 
| eval labels=split("uberAgent", ",") 
| eval identifiers=mvappend(identifier, id)
| table id type name domain layer labels identifiers
```
{% endtab %}
{% endtabs %}

The example Splunk saved search above would result in the following topology component data in StackState:

| Field | Data |
| :--- | :--- |
| **id** | Splunk `id` field. |
| **name** | Splunk `name` field. |
| **type** | Splunk `type` field. |
| **labels** | Splunk `labels` field |
| **identifiers** | Splunk `identifiers` field. |
| **data** | Splunk fields `domain` and `layer`. |

### Topology relations

The following fields from the results of a saved search are sent to StackState for topology relations:

| Field |  | Type | Required? | Description |
| :--- | :--- | :--- | :--- | :--- |
| **type** | string | ✅ | The type of component or relation. |  |
| **sourceId** | string | ✅ | The ID of the component that is the source of the relation. |  |
| **targetId** | string | ✅ | The ID of the component that is the target of the relation. |  |

#### Example query for relations

{% tabs %}
{% tab title="Splunk query for relations" %}
```text
| datamodel uberAgent60m Application_ApplicationInventory search 
| rename Application_ApplicationInventory.DisplayName as appname 
| table host appname | uniq 
| eval host_id = upper(host) | strcat "urn:host:/" host_id targetId 
| eval app_id = upper(appname) | rex mode=sed field=app_id "s/ /_/g" 
| strcat "urn:application:/" app_id sourceId 
| eval type="runs_on" 
| table type sourceId targetId | dedup sourceId targetId
```
{% endtab %}
{% endtabs %}

The example Splunk saved search above would result in the following topology relation data in StackState:

| Field | Data |
| :--- | :--- |
| **type** | Splunk `type` field. |
| **sourceId** | Splunk `sourceId` field. |
| **targetId** | Splunk `targetId` field. |

## Agent check

### Configure the Splunk topology V1 check

To enable the Splunk topology integration and begin collecting component and relation data from your Splunk instance, the Splunk topology check must be configured on StackState Agent V1. The check configuration provides all details required for the Agent to connect to your Splunk instance and execute a Splunk saved search.

{% hint style="info" %}
Example Splunk topology Agent check configuration file:  
[splunk\_topology/conf.yaml.example \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_topology/conf.yaml.example)
{% endhint %}

To configure the Splunk topology Agent check:

1. Edit the StackState Agent V1 configuration file `/etc/sts-agent/conf.d/splunk_topology.yaml`.
2. Under **instances**, add details of your Splunk instance:
   * **url** - The URL of your Splunk instance.
   * **authentication** - How the Agent should authenticate with your Splunk instance. Choose either token-based \(recommended\) or basic authentication. For details, see [authentication configuration details](splunk_stackpack.md#authentication).
   * **ignore\_saved\_search\_errors** - Set to `false` to return an error if one of the configured saved searches does not exist. Default `true`.
   * **tags** - Optional. Can be used to apply specific tags to all reported topology in StackState.
   * **collection_interval** - The interval at which the check is scheduled to run.
3. Under **component\_saved\_searches**, add details of each Splunk saved search that the check should execute to retrieve components: 
   * **name** - The name of the [Splunk saved search](splunk_topology.md#splunk-saved-search) to execute.
     * **match** - Regex used for selecting Splunk saved search queries. Default `"comp.*"` for component queries and `"relation*"` for relation queries.
     * **app** - The Splunk app in which the saved searches are located. Default `"search"`.
     * **request\_timeout\_seconds** - Default `10`.
     * **search\_max\_retry\_count** - Default `5`.
     * **search\_seconds\_between\_retries** - Default `1`.
     * **batch\_size** - Default `1000`.
     * **parameters** - Used in the Splunk API request. The default parameters provided make sure the Splunk saved search query refreshes. Default `force_dispatch: true` and `dispatch.now: true`.
4. Under **relation\_saved\_searches**, add details of each Splunk saved search that the check should execute to retrieve relations.
5. More advanced options can be found in the [example configuration \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_topology/conf.yaml.example). 
6. Save the configuration file.
7. Restart StackState Agent V1 to apply the configuration changes.
8. Once the Agent has restarted, wait for the Agent to collect data and send it to StackState.

### Disable the Agent check

To disable the Splunk topology Agent check:

1. Remove or rename the Agent integration configuration file, for example:

   ```text
    mv conf.d/splunk_topology.yaml conf.d/splunk_topology.yaml.bak
   ```

2. Restart the StackState Agent to apply the configuration changes.

## See also

* [StackState Splunk integration details](splunk_stackpack.md)
* [Upgrade to the Splunk topology V2 integration](splunk_topology_upgrade_v1_to_v2.md)  
* [Example Splunk topology V1 configuration file - splunk\_topology/conf.yaml.example \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_topology/conf.yaml.example)
* [Splunk default fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields) 

