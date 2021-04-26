# Splunk topology Agent check

## Overview

The StackState Splunk integration collects topology from Splunk by executing Splunk saved searches that have been specified in the StackState Agent V1 Splunk topology check configuration. This means that, in order to receive Splunk topology data in StackState, you will need to add configuration to both Splunk and the StackState Agent V1.

* [In Splunk](#splunk-saved-search), there should be at least one saved search that generates the topology data you want to retrieve.
* [In StackState Agent V1](#agent-check), a Splunk topology check should be configured to connect to your Splunk instance and execute relevant Splunk saved searches.

The Splunk topology check on StackState Agent V1 will execute all configured Splunk saved searches periodically to retrieve a snapshot of the topology at the current time.

## Splunk saved search

### Fields used

StackState Agent V1 executes the Splunk saved searches configured in the [Splunk topology Agent check configuration file](#agent-check) and pushes retrieved data to StackState components and relations. The fields from the results of a saved search that are sent to StackState for topology components and relations are listed in the table below.

| Field | Components | Relations | Type | Description |
| :--- | :--- | :--- | :--- | :--- |
| **type** | ✅ | ✅ | string | The type of component or relation.  |
| **id** | ✅ | - | string | The unique identifier for the component.  |
| **identifier.\<identifier_name\>** | ✅ | - | string |  |
| **label.\<label_name\>** | ✅ | - | string | The value will be added as a label on the component in the format `label_name:value` |
| **name** | ✅ | - | string | The value will be used as the component name. |
| **sourceId** | - | ✅ | string | The ID of the component that is the source of the relation. |
| **targetId** | - | ✅ | string | The ID of the component that is the target of the relation.  |

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
| **identifier.\<identifier_name\>** | - |
| **label.\<label_name\>** | - |
| **name** | - |
| **sourceId** | - |
| **targetId** | - |

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
| **id** | - |
| **identifier.\<identifier_name\>** | - |
| **label.\<label_name\>** | - |
| **name** | - |
| **sourceId** | `<sourceId>` |
| **targetId** | `<targetId>` |

## Agent check

### Configure the Splunk topology check


## See also

* [StackState Splunk integration details](/stackpacks/integrations/new_splunk/splunk_stackpack.md)