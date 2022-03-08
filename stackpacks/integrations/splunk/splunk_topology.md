---
description: StackState core integration
---

# Splunk topology Agent check

{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

The StackState Splunk integration collects topology from Splunk by executing Splunk saved searches that have been specified in the StackState API-Integration Agent Splunk topology check configuration. In order to receive Splunk topology data in StackState, you will therefore need to add configuration to both Splunk and the StackState API-Integration Agent.

* [In Splunk](#splunk-saved-search), there should be at least one saved search that generates the topology data you want to retrieve.
* [In the StackState API-Integration Agent](#agent-check), a Splunk topology check should be configured to connect to your Splunk instance and execute the relevant Splunk saved searches.

The Splunk topology check on the StackState API-Integration Agent will execute all configured Splunk saved searches periodically to retrieve a snapshot of the topology at the current time.

## Splunk saved search

### Fields used

The StackState API-Integration Agent executes the Splunk saved searches configured in the [Splunk topology Agent check configuration file](#agent-check) and pushes retrieved data to StackState components and relations. The fields from the results of a saved search that are sent to StackState for topology components and relations are listed in the table below.

| Field | Components | Relations | Type | Description |
| :--- | :--- | :--- | :--- | :--- |
| **type** | ✅ | ✅ | string | Required, The type of component or relation.  |
| **id** | ✅ | - | string | Required. The unique identifier for the component.  |
| **identifier.&lt;identifier\_name&gt;**  | ✅ | - | string | Optional. The value will be included as identifier of the component. |
| **label.&lt;label\_name&gt;** | ✅ | - | string | Optional. The value will be added as a label on the component in the format `label_name:value` |
| **name** | ✅ | - | string | Required. The value will be used as the component name. |
| All other fields | ✅ | - | - | [Splunk default fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields) other than `_time` will be filtered out of the result.<br />Any other fields present in the result will be available in StackState in the `data` field of the component properties `source` tab. |
| **sourceId** | - | ✅ | string | Required. The ID of the component that is the source of the relation. |
| **targetId** | - | ✅ | string | Required. The ID of the component that is the target of the relation.  |

### Example queries

{% tabs %}
{% tab title="Splunk query for components" %}
```text
| loadjob savedsearch=:servers
| search OrganizationPart="*" OrgGrp="*" company="*"
| table name | dedup name
| eval name = upper(name)
| eval id = 'name', type="vm"
| table id type name
```
{% endtab %}
{% endtabs %}

The example Splunk saved search above would result in the following topology component data in StackState:

| Field | Data |
| :--- | :--- |
| **type** | Splunk `type` field.  |
| **id** | Splunk `id` field. |
| **identifier.&lt;identifier\_name&gt;** | - |
| **label.&lt;label\_name&gt;** | - |
| **name** | Splunk `name` field.|

{% tabs %}
{% tab title="Splunk query for relations" %}
```text
index=cmdb_icarus source=cmdb_ci_rel earliest=-3d
| eval VMName=lower(VMName)
| rename Application as sourceId, VMName as targetId
| eval type="is-hosted-on"
| table sourceId targetId type
```
{% endtab %}
{% endtabs %}

The example Splunk saved search above would result in the following topology relation data in StackState:

| Field | Data |
| :--- | :--- |
| **type** | Splunk `type` field.  |
| **sourceId** | `<sourceId>` (renamed from `Application`) |
| **targetId** | `<targetId>` (renamed from `VMName`) |

## Agent check

### Configure the Splunk topology check

To enable the Splunk topology integration and begin collecting component and relation data from your Splunk instance, the Splunk topology check must be configured on the API-Integration Agent. The check configuration provides all details required for the Agent to connect to your Splunk instance and execute a Splunk saved search.

{% hint style="info" %}
Example Splunk events Agent check configuration file:<br />[conf.d/splunk_topology.yaml \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_topology/conf.yaml.example)
{% endhint %}

To configure the Splunk events Agent check:

1. Edit the API-Integration Agent configuration file `/etc/sts-agent/conf.d/splunk_topology.yaml`.
2. Under **instances**, add details of your Splunk instance:
   * **url** - The URL of your Splunk instance.
   * **authentication** - How the Agent should authenticate with your Splunk instance. Choose either token-based (recommended) or basic authentication. For details, see [authentication configuration details](/stackpacks/integrations/splunk/splunk_stackpack.md#authentication).
   * **ignore_saved_search_errors** - Set to `false` to return an error if one of the configured saved searches does not exist. Default `true`.
   * **tags** - Optional. Can be used to apply specific tags to all reported topology in StackState.
3. Under **component_saved_searches**, add details of each Splunk saved search that the check should execute to retrieve components: 
     * **name** - The name of the [Splunk saved search](#splunk-saved-search) to execute.
       * **match** - Regex used for selecting Splunk saved search queries. Default `"comp.*"` for component queries and `"relation*"` for relation queries.
       * **app** - The Splunk app in which the saved searches are located. Default `"search"`.
       * **request_timeout_seconds** - Default `10`.
       * **search_max_retry_count** - Default `5`.
       * **search_seconds_between_retries** - Default `1`.
       * **batch_size** - Default `1000`.
       * **parameters** - Used in the Splunk API request. The default parameters provided make sure the Splunk saved search query refreshes. Default `force_dispatch: true` and `dispatch.now: true`.
4. Under **relation_saved_searches**, add details of each Splunk saved search that the check should execute to retrieve relations.
5. Save the configuration file.
6. Restart the StackState API-Integration Agent to apply the configuration changes.
7. Once the Agent has restarted, wait for the Agent to collect data and send it to StackState.

### Disable the Agent check

To disable the Splunk topology Agent check:

1. Remove or rename the Agent integration configuration file, for example:

   ```text
    mv conf.d/splunk_topology.yaml conf.d/splunk_topology.yaml.bak
   ```

2. Restart the StackState Agent to apply the configuration changes.

## See also

* [StackState Splunk integration details](/stackpacks/integrations/splunk/splunk_stackpack.md)
* [Example Splunk topology configuration file - splunk_topology.yaml \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_topology/conf.yaml.example)
* [Splunk default fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields) 
