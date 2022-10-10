---
description: StackState Self-hosted v5.1.x 
---

# Splunk Events

## Overview

{% hint style="info" %}
This page describes the Splunk Events check running on StackState Agent V2. If you are currently running the Splunk Events check on Agent V1 (legacy), it is advised that you migrate to Agent V2.

* [Migrate to Agent V2](TODO_LINK_TO_AGENT_MIGRATION_DOCS)
* [Documentation for the Splunk Events check running on Agent V1 \(legacy\)](https://docs.stackstate.com/v/5.0/stackpacks/integrations/splunk/splunk_events)
{% endhint %}

When the [Splunk StackPack](splunk_stackpack.md) is installed in StackState, you can configure the Splunk Events check on StackState Agent V2 to begin collecting Splunk events data.

Events are collected from Splunk by executing Splunk saved searches that are configured in the StackState Agent V2 Splunk Events check. In order to receive Splunk events data in StackState, you will therefore need to add configuration to both Splunk and StackState Agent V2:

* [Splunk saved search](splunk_events.md#splunk-saved-search) - there should be at least one saved search that generates the events data you want to retrieve.
* [StackState Agent V2 Splunk Events check](splunk_events.md#agent-check) - a Splunk Events check should be configured to connect to your Splunk instance and execute the relevant Splunk saved searches.

The Splunk Events check on StackState Agent V2 will execute all configured Splunk saved searches periodically. Data will be requested from the last received event timestamp up until now.

## Prerequisites

To run the Splunk Events Agent check, you need to have:

* A running Splunk instance.
* The [Splunk StackPack](splunk_stackpack.md) installed on your StackState instance.
* [StackState Agent V2 v2.18 or later](/setup/agent/about-stackstate-agent.md) must be installed on a single machine which can connect to Splunk and StackState.

## Splunk saved search

### Fields used

StackState Agent V2 executes the Splunk saved searches configured in the [Splunk Events Agent check configuration file](splunk_events.md#agent-check) and pushes retrieved data to StackState as a telemetry stream. The following fields from the results of a saved search are sent to StackState:

| Field | Description |
| :--- | :--- | 
| **\_time** (long ) | Required. The data collection timestamp, in milliseconds since epoch. |
| **event\_type** (string) |Event type, for example `server_created`. |
| **msg\_title** (string) | Message title. |
| **msg\_text** (string) | Message text. |
| **source\_type\_name** (string) | Source type name. |
| All other fields | [Splunk default fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields) other than `_time` will be filtered out of the result. Any other fields present in the result will be mapped to tags in the format `field`:`value`. |

### Example Splunk query

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
| **tags** | `hostname:<hostname>` `status:<status>` `description:<description>` |

## Agent check

### Configure the Splunk Events check

To enable the Splunk Events integration and begin collecting events data from your Splunk instance, the Splunk Events check must be configured on StackState Agent V1. The check configuration provides all details required for the Agent to connect to your Splunk instance and execute a Splunk saved search.

{% hint style="info" %}
Example Splunk Events Agent check configuration file:  
[splunk\_event/conf.yaml.example \(github.com\)](https://l.stackstate.com/ui-splunk-events-v2-check-example)
{% endhint %}

To configure the Splunk Events Agent check:

1. Edit the StackState Agent V2 configuration file `/etc/stackstate-agent/conf.d/splunk_event.d/conf.yaml`.
2. Under **instances**, add details of your Splunk instance:
   * **url** - The URL of your Splunk instance.
   * **authentication** - How the Agent should authenticate with your Splunk instance. Choose either token-based \(recommended\) or basic authentication. For details, see [authentication configuration details](splunk_stackpack.md#authentication).
   * **tags** - Optional. Can be used to apply specific tags to all reported events in StackState.
3. Under **saved\_searches**, add details of each Splunk saved search that the check should execute: 
   * **name** - The name of the [Splunk saved search](splunk_events.md#splunk-saved-search) to execute.
     * **match** - Regex used for selecting Splunk saved search queries. Default `"events.*"`.
     * **app** - The Splunk app in which the saved searches are located. Default `"search"`.
     * **request\_timeout\_seconds** - Default `10`.
     * **search\_max\_retry\_count** - Default `5`.
     * **search\_seconds\_between\_retries** - Default `1`.
     * **batch\_size** - Default `1000`.
     * **initial\_history\_time\_seconds** - Default `0`.
     * **max\_restart\_history\_seconds** - Default `86400`.
     * **max\_query\_chunk\_seconds** - Default `3600`.
     * **unique\_key\_fields** - The fields to use to [uniquely identify a record](splunk_events.md#uniquely-identify-a-record). Default `_bkt` and `_cd`.
     * **parameters** - Used in the Splunk API request. The default parameters provided make sure the Splunk saved search query refreshes. Default `force_dispatch: true` and `dispatch.now: true`.
4. More advanced options can be found in the [example configuration \(github.com\)](https://l.stackstate.com/ui-splunk-events-v2-check-example). 
5. Save the configuration file.
6. Restart StackState Agent V2 to apply the configuration changes.
7. Once the Agent has restarted, wait for the Agent to collect data and send it to StackState.
8. Events retrieved from splunk are available in StackState as a log telemetry stream in the `stackstate-generic-events` data source. This can be [mapped to associated components](../../../use/metrics/add-telemetry-to-element.md).

### Uniquely identify a record

To prevent sending duplicate events over multiple check runs, received saved search records must be uniquely identified for comparison. By default, a record is identified by the Splunk default fields `_bkt` and `_cd`. This behavior can be customized for each saved search by specifying `unique_key_fields` in the Splunk Events Agent check configuration. Note that the specified `unique_key_fields` fields are mandatory fields for each record returned by the Splunk saved search.

If it is not possible to uniquely identify a record by a combination of specific fields, the whole record can be used by setting `unique_key_fields: []` \(an empty list\).

### Disable the Agent check

To disable the Splunk Events Agent check:

1. Remove or rename the Agent integration configuration file, for example:

   ```text
    mv /etc/stackstate-agent/conf.d/splunk_event.d/conf.yaml /etc/stackstate-agent/conf.d/splunk_event.d/conf.yaml.bak
   ```

2. Restart the StackState Agent\(s\) to apply the configuration changes.

## Splunk Events in StackState

Events retrieved from splunk are available in StackState as a log telemetry stream in the `stackstate-generic-events` data source. This can be [mapped to associated components](../../../use/metrics/add-telemetry-to-element.md).

## See also

* [StackState Splunk integration details](splunk_stackpack.md)
* [Map telemetry to components](../../../use/metrics/add-telemetry-to-element.md)
* [Example Splunk Events configuration file - splunk\_event/conf.yaml.example \(github.com\)](https://l.stackstate.com/ui-splunk-events-v2-check-example)
* [Splunk default fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields)