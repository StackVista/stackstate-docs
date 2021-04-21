# Splunk events Agent check

## Overview

The StackState Splunk integration collects events from Splunk by executing Splunk saved searches that have been specified in the StackState Agent V1 Splunk events check configuration. This means that in order to receive Splunk events data in StackState, you will need to add configuration to both Splunk and the StackState Agent V1.

* [In Splunk](#splunk-saved-search), there should be a saved search that generates the events data you want to retrieve.
* [In StackState Agent V1](#agent-splunk-events-check-configuration), a Splunk events check should be configured to execute the relevant Splunk saved search and filter data as required.

The StackState Agent V1 Splunk events check will execute the saved searches periodically, retrieving data from the last received event timestamp up until now. 

## Splunk saved search

StackState Agent V1 executes all Splunk saved searches configured in the [Agent Splunk events check configuration file](#agent-splunk-events-check-configuration) and pushes retrieved data to StackState as a telemetry stream. The following fields from the results of a saved search are sent to StackState:

| Field | Type | Description |
| :--- | :--- | :--- |
| **\_time** | long | Required. The data collection timestamp, in milliseconds since epoch. |
| **event\_type** | string | Event type, for example `server_created`. |
| **msg\_title** | string | Message title. |
| **msg\_text** | string | Message text. |
| **source\_type\_name** | string | Source type name. |
| All other fields | - | [Splunk default fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields) other than `_time` will be filtered out of the result.<br />Any other fields present in the result will be mapped to tags in the format `field`:`value`. |

The example Splunk saved search below would result in an event in StackState with the following data:
* **\_time**: `_time`
* **tags**: 
    * `hostname:<hostname>`
    * `status:[CRITICAL|ERROR|WARNING|OK]`
    * `description:<description>` 

{% tabs %}
{% tab title="Example Splunk query" %}
```text
index=monitor alias_hostname=*
| eval status = upper(status)
| search status=CRITICAL OR status=error OR status=warning OR status=OK
| table _time hostname status description
```
{% endtab %}
{% endtabs %}

## Agent Splunk events check configuration

To enable the Splunk events check and begin collecting events data from your Splunk instance:

1. Edit the Agent V1 integration configuration file `???` to include details of your Splunk instance and Splunk saved searches:
   * **url** - The URL of your Splunk instance.
   * **authentication** - How the Agent should authenticate with your Splunk instance. Choose either token-based (recommended) or basic authentication. For details see [authentication configuration details](/stackpacks/integrations/new_splunk/splunk.md#authentication).
   * **saved_searches** - The Splunk saved search or searches that the check will execute. For each, provide the following details:
     * **name** - The name of the [Splunk saved search](#splunk-saved-search) to execute.
     * **match** - 
     * **app** -
     * **request_timeout_seconds** - Default 10.
     * **search_max_retry_count** - Default 5.
     * **search_seconds_between_retries** - Default 1.
     * **batch_size** - Default 1000.
     * **initial_history_time_seconds** - Default 0.
     * **max_restart_history_seconds** - Default 86400.
     * **max_query_chunk_seconds** - Default 3600.
     * **unique_key_fields** - The fields to use to [uniquely identify a record](#uniquely-identify-a-saved-search-record). Default `_bkt` and `_cd`.
     * **parameters** - 
     * **tags** - 

3. Restart StackState Agent V1 to apply the configuration changes.
4. Once the Agent has restarted, wait for the Agent to collect data and send it to StackState.

### Uniquely identify a saved search record

To prevent sending duplicate events over multiple check runs, received saved search records must be uniquely identified for comparison. By default, a record's identity is composed of the Splunk default fields `_bkt` and `_cd`. The default behavior can be changed for each saved search using the parameter `unique_key_fields` in the check configuration. The specified `unique_key_fields` fields become mandatory for each record. If it is not possible to uniquely identify a record by a combination of fields, the whole record can be used by setting `unique_key_fields` to `[]`, i.e. empty list.


## See also

* [StackState Splunk integration details](/stackpacks/integrations/new_splunk/splunk.md)
* [Example Splunk events configuration file - splunk\_events.yaml \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_event/conf.yaml.example)
* [Splunk default fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields) 