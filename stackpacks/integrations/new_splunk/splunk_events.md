# Splunk events Agent check

## Overview

The StackState Splunk integration collects events from Splunk by executing Splunk saved searches that have been specified in the StackState Agent V1 Splunk events check configuration. This means that, in order to receive Splunk events data in StackState, you will need to add configuration to both Splunk and the StackState Agent V1.

* [In Splunk](#splunk-saved-search), there should be at least one saved search that generates the events data you want to retrieve.
* [In StackState Agent V1](#splunk-events-agent-check), a Splunk events check should be configured to connect to your Splunk instance and execute relevant Splunk saved searches.

The Splunk events check on StackState Agent V1 will execute all configured Splunk saved searches periodically. Data will be requested from the last received event timestamp up until now.

## Splunk saved search

### Fields used

StackState Agent V1 executes the Splunk saved searches configured in the [Splunk events Agent check configuration file](#splunk-events-agent-check) and pushes retrieved data to StackState as a telemetry stream. The following fields from the results of a saved search are sent to StackState:

| Field | Type | Description |
| :--- | :--- | :--- |
| **\_time** | long | Required. The data collection timestamp, in milliseconds since epoch. |
| **event\_type** | string | Event type, for example `server_created`. |
| **msg\_title** | string | Message title. |
| **msg\_text** | string | Message text. |
| **source\_type\_name** | string | Source type name. |
| All other fields | - | [Splunk default fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields) other than `_time` will be filtered out of the result.<br />Any other fields present in the result will be mapped to tags in the format `field`:`value`. |

### Example query

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

The example Splunk saved search above would result in the following event data in StackState:

| Field | Data |
| :--- | :--- |
| **\_time** | Splunk `_time` field. |
| **event\_type** | - |
| **msg\_title** | - |
| **msg\_text** | - |
| **source\_type\_name** | - |
| **tags** | `hostname:<hostname>`<br />`status:<status>`<br />`description:<description>` |

## Agent check

### Configure the Splunk events check

To enable the Splunk events integration and begin collecting events data from your Splunk instance, the Splunk events check must be configured on Agent V1. The check configuration provides all details required for the Agent to connect to your Splunk instance and execute a Splunk saved search.

{% hint style="info" %}
Example Splunk events Agent check configuration file:<br />[conf.d/splunk_event.yaml \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_event/conf.yaml.example)
{% endhint %}

To configure the Splunk events Agent check:

1. Edit the Agent V1 integration configuration file `???`.
2. Under **instances**, add details of your Splunk instance:
   * **url** - The URL of your Splunk instance.
   * **authentication** - How the Agent should authenticate with your Splunk instance. Choose either token-based (recommended) or basic authentication. For details, see [authentication configuration details](/stackpacks/integrations/new_splunk/splunk.md#authentication).
   * **tags** - 
3. Under **saved_searches**, add details of each Splunk saved search that the check should execute: 
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
       * **unique_key_fields** - The fields to use to [uniquely identify a record](#uniquely-identify-a-record). Default `_bkt` and `_cd`.
       * **parameters** - 
4. Save the configuration file.
5. Restart StackState Agent V1 to apply the configuration changes.
6. Once the Agent has restarted, wait for the Agent to collect data and send it to StackState.

### Uniquely identify a record

To prevent sending duplicate events over multiple check runs, received saved search records must be uniquely identified for comparison. By default, a record is identified of the Splunk default fields `_bkt` and `_cd`. This behavior can be customized for each saved search by specifying `unique_key_fields` in the Splunk events Agent check configuration. Note that the specified `unique_key_fields` fields are mandatory fields for each record returned by the Splunk saved search. 

If it is not possible to uniquely identify a record by a combination of specific fields, the whole record can be used by setting `unique_key_fields: []` (an empty list).

## See also

* [StackState Splunk integration details](/stackpacks/integrations/new_splunk/splunk.md)
* [Example Splunk events configuration file - splunk\_events.yaml \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_event/conf.yaml.example)
* [Splunk default fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields) 