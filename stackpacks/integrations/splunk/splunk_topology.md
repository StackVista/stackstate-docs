---
description: StackState Self-hosted v5.1.x 
---

# Splunk Topology

## Overview

{% hint style="info" %}
This page describes the Splunk Topology check running on StackState Agent V2. 

If you are currently running the Splunk Topology check on Agent V1 (legacy), it's advised that you migrate to Agent V2.

* [Migrate to Agent V2](/setup/agent/migrate-agent-v1-to-v2/)
* [Documentation for the Splunk Topology check running on Agent V1 \(legacy\)](https://docs.stackstate.com/v/5.0/stackpacks/integrations/splunk/splunk_topology)
{% endhint %}

When the [Splunk StackPack](splunk_stackpack.md) is installed in StackState, you can configure the Splunk Topology check on StackState Agent V2 to begin collecting Splunk topology data.

The StackState Splunk Topology integration collects topology from Splunk by executing Splunk saved searches from [StackState Agent V2](../../../setup/agent/about-stackstate-agent.md). In order to receive Splunk topology data in StackState, configuration needs to be added to both Splunk and StackState Agent V2:

* [Splunk saved search](splunk_topology.md#splunk-saved-search) - there should be at least one saved search that generates the topology data you want to retrieve.
* [StackState Agent V2 Splunk Topology check](splunk_topology.md#agent-check) - a Splunk Topology check should be configured to connect to your Splunk instance and execute the relevant Splunk saved searches.

The Splunk Topology check on StackState Agent V2 will execute all configured Splunk saved searches periodically to retrieve a snapshot of the topology at the current time.

## Prerequisites

To run the Splunk Topology Agent check, you need to have:

* A running Splunk instance.
* The [Splunk StackPack](splunk_stackpack.md) installed on your StackState instance.
* [StackState Agent v2.18 or later](/setup/agent/about-stackstate-agent.md) must be installed on a single machine which can connect to Splunk and StackState.

## Splunk saved search

In the Splunk Topology integration, StackState Agent V2 executes the Splunk saved searches configured in the [Splunk Topology Agent check](splunk_topology.md#agent-check) and pushes retrieved data to StackState as components and relations. The fields from the results of a saved search that are sent to StackState are described below.

### Topology components

The following fields from the results of a saved search are sent to StackState for topology components:

| Field                                                        | Description                                             |
|:-------------------------------------------------------------|:--------------------------------------------------------|
| **id** (string)                                              | Required. The unique identifier for the component.      |
| **name** (string)                                            | Required. The value will be used as the component name. |
| **type** (string)                                            | Required. The type of component or relation.            |
| **labels** (multivalue field or comma separated string)      | The values will be added as labels on the component. |
| **identifiers** (multivalue field or comma separated string) | The values will be included as identifiers of the component. |
| All other fields     | [Splunk default fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/9.0.1/Data/Aboutdefaultfields) other than `_time` will be filtered out of the result. Any other fields present in the result will be available in StackState in the `data` field of the properties `source` tab for a component. |

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

| Field                 | Description                                                            |
|:----------------------|:-----------------------------------------------------------------------|
| **type** (string)     | Required. The type of component or relation.                           |
| **sourceId** (string) | Reqruired. The ID of the component that is the source of the relation. |
| **targetId** (string) | Required. The ID of the component that is the target of the relation.  |

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

### Configure the Splunk Topology check

To enable the Splunk Topology integration and begin collecting component and relation data from your Splunk instance, the Splunk Topology check must be configured on StackState Agent V2. The check configuration provides all details required for the Agent to connect to your Splunk instance and execute a Splunk saved search.

{% hint style="info" %}
Example Agent V2 Splunk Topology check configuration file:  
[splunk\_topology/conf.yaml.example \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/splunk_topology/stackstate_checks/splunk_topology/data/conf.yaml.example)
{% endhint %}

To configure the Splunk Topology Agent check:

1. Edit the StackState Agent V2 check configuration file: `/etc/stackstate-agent/conf.d/splunk_topology.d/conf.yaml`
2. Under **instances**, add details of your Splunk instance:
   * **url** - The URL of your Splunk instance.
   * **authentication** - How the Agent should authenticate with your Splunk instance. Choose either token-based \(recommended\) or basic authentication. For details, see [authentication configuration details](splunk_stackpack.md#authentication).
   * **ignore\_saved\_search\_errors** - Set to `false` to return an error if one of the configured saved searches doesn't exist. Default `true`.
   * **tags** - Optional. Can be used to apply specific tags to all reported topology in StackState.
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
5. More advanced options can be found in the [example configuration \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/splunk_topology/stackstate_checks/splunk_topology/data/conf.yaml.example). 
6. Save the configuration file.
7. Restart StackState Agent V2 to apply the configuration changes.
8. Once the Agent has restarted, wait for the Agent to collect data and send it to StackState.

### Disable the Agent check

To disable the Splunk Topology Agent check:

1. Remove or rename the Agent integration configuration file, for example:

   ```text
    mv /etc/stackstate-agent/conf.d/splunk_topology.d/conf.yaml /etc/stackstate-agent/conf.d/splunk_topology.d/conf.yaml.bak
   ```

2. Restart StackState Agent V2 to apply the configuration changes.

## See also

* [StackState Agent V2](../../../setup/agent/about-stackstate-agent.md)
* [StackState Splunk integration details](splunk_stackpack.md)
* [Example Splunk Topology configuration file - splunk\_topology/conf.yaml.example \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/splunk_topology/stackstate_checks/splunk_topology/data/conf.yaml.example)
* [Splunk default fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/9.0.1/Data/Aboutdefaultfields)

