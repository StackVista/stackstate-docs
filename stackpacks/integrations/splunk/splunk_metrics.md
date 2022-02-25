---
description: StackState core integration
---

# Splunk metrics Agent check

{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

The StackState Splunk integration collects metrics from Splunk by executing Splunk saved searches that have been specified in the StackState API-Integration Agent Splunk metrics check configuration. In order to receive Splunk metrics data in StackState, you will therefore need to add configuration to both Splunk and the StackState API-Integration Agent.

* [In Splunk](#splunk-saved-search), there should be at least one saved search that generates the metrics data you want to retrieve. Each saved search can retrieve one metric.
* [In the StackState API-Integration Agent](#agent-check), a Splunk metrics check should be configured to connect to your Splunk instance and execute the relevant Splunk saved searches.

The Splunk metrics check on the StackState API-Integration Agent will execute all configured Splunk saved searches periodically. Data will be requested from the last received metric timestamp up until now.

## Splunk saved search

### Fields used

The StackState API-Integration Agent executes the Splunk saved searches configured in the [Splunk metrics Agent check configuration file](#agent-check) and pushes retrieved data to StackState as a telemetry stream. The following fields from the results of a saved search are sent to StackState:

| Field | Type | Description |
| :--- | :--- | :--- |
| **\_time** | long | Data collection timestamp, millis since epoch. |
| **metric** | string | The name of the metric. Taken from the configured `metric_name_field`. |
| **value** | numeric | The value of the metric. Taken from the configured `metric_value_field`. |

### Example query

{% tabs %}
{% tab title="Splunk query" %}
```text
index=vms MetricId=cpu.usage.average
| table _time VMName Value    
| eval VMName = upper(VMName)
| rename VMName as metricCpuUsageAverage, Value as valueCpuUsageAverage
| eval type = "CpuUsageAverage"
```
{% endtab %}
{% tab title="Splunk metrics Agent check configuration" %}
```
...
metric_name_field: "metricCpuUsageAverage"
metric_value_field: "valueCpuUsageAverage"
...
```
{% endtab %}
{% endtabs %}

The example Splunk saved search above would result in the following metric data in StackState:

| Field | Data |
| :--- | :--- |
| **\_time** | Splunk `_time` field. |
| **metric** | Splunk `<metricCpuUsageAverage>` field. |
| **value** | Splunk `<valueCpuUsageAverage>` field. |

## Agent check

### Configure the Splunk metrics check

To enable the Splunk metrics integration and begin collecting metrics data from your Splunk instance, the Splunk metrics check must be configured on the API-Integration Agent. The check configuration provides all details required for the Agent to connect to your Splunk instance and execute a Splunk saved search.

{% hint style="info" %}
Example Splunk metrics Agent check configuration file:<br />[conf.d/splunk_metric.yaml \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_metric/conf.yaml.example)
{% endhint %}

To configure the Splunk metrics Agent check:

1. Edit the API-Integration Agent configuration file `/etc/sts-agent/conf.d/splunk_metric.yaml`.
2. Under **instances**, add details of your Splunk instance:
   * **url** - The URL of your Splunk instance.
   * **authentication** - How the Agent should authenticate with your Splunk instance. Choose either token-based (recommended) or basic authentication. For details, see [authentication configuration details](/stackpacks/integrations/splunk/splunk_stackpack.md#authentication).
   * **tags** - Optional. Can be used to apply specific tags to all reported metrics in StackState.
3. Under **saved_searches**, add details of each Splunk saved search that the check should execute. Each saved search can retrieve one metric: 
     * **name** - The name of the [Splunk saved search](#splunk-saved-search) to execute.
       * **metric_name_field** - The field in the Splunk results that will contain the metric name. Default `"metric"`.
       * **metric_value_field** - The field in the Splunk results that will contain numerical data. Default `"value"`.
       * **match:** - Regex used for selecting Splunk saved search queries. Default `metrics.*`.
       * **app** - The Splunk app in which the saved searches are located. Default `"search"`.
       * **request_timeout_seconds** - Default `10`
       * **search_max_retry_count** - Default `5`
       * **search_seconds_between_retries** - Default `1`
       * **batch_size** - Default `1000`
       * **initial_history_time_seconds** - Default `0`
       * **max_restart_history_seconds** - Default `86400`
       * **max_query_chunk_seconds** - Default `3600`
       * **unique_key_fields** - The fields to use to [uniquely identify a record](#uniquely-identify-a-record). Default `_bkt` and `_cd`.
       * **parameters** - Used in the Splunk API request. The default parameters provided make sure the Splunk saved search query refreshes. Default `force_dispatch: true` and `dispatch.now: true`.

4. Save the configuration file.
5. Restart the StackState API-Integration Agent to apply the configuration changes.
6. Once the Agent has restarted, wait for the Agent to collect data and send it to StackState.
7. Metrics retrieved from splunk are available in StackState as a metrics telemetry stream in the `stackstate-metrics` data source. This can be [mapped to associated components](/use/health-state-and-event-notifications/add-telemetry-to-element.md).

### Uniquely identify a record

To prevent sending duplicate metrics over multiple check runs, received saved search records must be uniquely identified for comparison. By default, a record is identified by the Splunk default fields `_bkt` and `_cd`. This behavior can be customized for each saved search by specifying `unique_key_fields` in the Splunk metrics Agent check configuration. Note that the specified `unique_key_fields` fields are mandatory fields for each record returned by the Splunk saved search. 

If it is not possible to uniquely identify a record by a combination of specific fields, the whole record can be used by setting `unique_key_fields: []` (an empty list).

### Disable the Agent check

To disable the Splunk metrics Agent check:

1. Remove or rename the Agent integration configuration file, for example:

   ```text
    mv conf.d/splunk_metrics.yaml conf.d/splunk_metrics.yaml.bak
   ```

2. Restart the StackState Agent to apply the configuration changes.

## Splunk metrics in StackState

Metrics retrieved from splunk are available in StackState as a metrics telemetry stream in the `stackstate-metrics` data source. This can be [mapped to associated components](/use/health-state-and-event-notifications/add-telemetry-to-element.md).

## See also

* [StackState Splunk integration details](/stackpacks/integrations/splunk/splunk_stackpack.md)
* [Map telemetry to components](/use/health-state-and-event-notifications/add-telemetry-to-element.md)
* [Example Splunk metrics configuration file - splunk\_metrics.yaml \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_metric/conf.yaml.example)
