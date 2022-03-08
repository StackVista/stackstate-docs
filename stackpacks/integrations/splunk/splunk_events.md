---
description: StackState core integration
---

# Splunk events Agent check

{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

The StackState Splunk integration collects events from Splunk by executing Splunk saved searches that have been specified in the StackState API-Integration Agent Splunk events check configuration. In order to receive Splunk events data in StackState, you will therefore need to add configuration to both Splunk and the StackState API-Integration Agent.

* [In Splunk](#splunk-saved-search), there should be at least one saved search that generates the events data you want to retrieve.
* [In the StackState API-Integration Agent](#agent-check), a Splunk events check should be configured to connect to your Splunk instance and execute the relevant Splunk saved searches.

The Splunk events check on the StackState API-Integration Agent will execute all configured Splunk saved searches periodically. Data will be requested from the last received event timestamp up until now. 

## Splunk saved search

### Fields used

The StackState API-Integration Agent executes the Splunk saved searches configured in the [Splunk events Agent check configuration file](#agent-check) and pushes retrieved data to StackState as a telemetry stream. The following fields from the results of a saved search are sent to StackState:

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

To enable the Splunk events integration and begin collecting events data from your Splunk instance, the Splunk events check must be configured on the API-Integration Agent. The check configuration provides all details required for the Agent to connect to your Splunk instance and execute a Splunk saved search.

{% hint style="info" %}
Example Splunk events Agent check configuration file:<br />[conf.d/splunk_event.yaml \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_event/conf.yaml.example)
{% endhint %}

To configure the Splunk events Agent check:

1. Edit the API-Integration Agent configuration file `/etc/sts-agent/conf.d/splunk_events.yaml`.
2. Under **instances**, add details of your Splunk instance:
   * **url** - The URL of your Splunk instance.
   * **authentication** - How the Agent should authenticate with your Splunk instance. Choose either token-based (recommended) or basic authentication. For details, see [authentication configuration details](/stackpacks/integrations/splunk/splunk_stackpack.md#authentication).
   * **tags** - Optional. Can be used to apply specific tags to all reported events in StackState.
3. Under **saved_searches**, add details of each Splunk saved search that the check should execute: 
     * **name** - The name of the [Splunk saved search](#splunk-saved-search) to execute.
       * **match** - Regex used for selecting Splunk saved search queries. Default `"events.*"`.
       * **app** - The Splunk app in which the saved searches are located. Default `"search"`.
       * **request_timeout_seconds** - Default `10`.
       * **search_max_retry_count** - Default `5`.
       * **search_seconds_between_retries** - Default `1`.
       * **batch_size** - Default `1000`.
       * **initial_history_time_seconds** - Default `0`.
       * **max_restart_history_seconds** - Default `86400`.
       * **max_query_chunk_seconds** - Default `3600`.
       * **unique_key_fields** - The fields to use to [uniquely identify a record](#uniquely-identify-a-record). Default `_bkt` and `_cd`.
       * **parameters** - Used in the Splunk API request. The default parameters provided make sure the Splunk saved search query refreshes. Default `force_dispatch: true` and `dispatch.now: true`.
4. Save the configuration file.
5. Restart the StackState API-Integration Agent to apply the configuration changes.
6. Once the Agent has restarted, wait for the Agent to collect data and send it to StackState.
7. Events retrieved from splunk are available in StackState as a log telemetry stream in the `stackstate-generic-events` data source. This can be [mapped to associated components](/use/health-state-and-event-notifications/add-telemetry-to-element.md).

### Uniquely identify a record

To prevent sending duplicate events over multiple check runs, received saved search records must be uniquely identified for comparison. By default, a record is identified by the Splunk default fields `_bkt` and `_cd`. This behavior can be customized for each saved search by specifying `unique_key_fields` in the Splunk events Agent check configuration. Note that the specified `unique_key_fields` fields are mandatory fields for each record returned by the Splunk saved search. 

If it is not possible to uniquely identify a record by a combination of specific fields, the whole record can be used by setting `unique_key_fields: []` (an empty list).

### Disable the Agent check

To disable the Splunk events Agent check:

1. Remove or rename the Agent integration configuration file, for example:

   ```text
    mv conf.d/splunk_event.yaml conf.d/splunk_event.yaml.bak
   ```

2. Restart the StackState Agent\(s\) to apply the configuration changes.


## Splunk events in StackState

Events retrieved from splunk are available in StackState as a log telemetry stream in the `stackstate-generic-events` data source. This can be [mapped to associated components](/use/health-state-and-event-notifications/add-telemetry-to-element.md).

## See also

* [StackState Splunk integration details](/stackpacks/integrations/splunk/splunk_stackpack.md)
* [Map telemetry to components](/use/health-state-and-event-notifications/add-telemetry-to-element.md)
* [Example Splunk events configuration file - splunk\_events.yaml \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_event/conf.yaml.example)
* [Splunk default fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields) 
