# Splunk metrics Agent check

## Overview

The StackState Splunk integration collects metrics from Splunk by executing Splunk saved searches that have been specified in the StackState Agent V1 Splunk metrics check configuration. This means that, in order to receive Splunk metrics data in StackState, you will need to add configuration to both Splunk and the StackState Agent V1.

* [In Splunk](#splunk-saved-search), there should be at least one saved search that generates the metrics data you want to retrieve.
* [In StackState Agent V1](#splunk-metrics-agent-check), a Splunk metrics check should be configured to connect to your Splunk instance and execute relevant Splunk saved searches.

The Splunk metrics check on StackState Agent V1 will execute all configured Splunk saved searches periodically. Data will be requested from the last received metric timestamp up until now.

## Splunk saved search

StackState Agent V1 executes the Splunk saved searches configured in the [Splunk metrics Agent check configuration file](#splunk-metrics-agent-check) and pushes retrieved data to StackState as a telemetry stream. The following fields from the results of a saved search are sent to StackState:

| Field | Type | Description |
| :--- | :--- | :--- |
| **\_time** | long | Data collection timestamp, millis since epoch. |
| `metric_name_field` | string | Name of the metric.<br />Taken from the field `metric_name_field`, configured in the [Agent splunk metrics check](#agent-splunk-metrics-check). |
| `metric_value_field` | numeric | The value of the metric.<br />Taken from the `metric_value_field`, configured in the [Agent splunk metrics check](#agent-splunk-metrics-check). |

### Example

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

## Splunk metrics Agent check

To enable the Splunk metrics check and begin collecting metrics data from your Splunk instance, a Splunk metrics check on Agent V1 must be configured to connect to your Splunk instance and execute at least one Splunk saved search. Follow the instructions below to configure the Splunk metrics Agent check. An example Splunk metrics configuration file is available on GitHub - [conf.d/splunk_metric.yaml \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_metric/conf.yaml.example).

1. Edit the Agent V1 integration configuration file `???` to include details of your Splunk instance under **instances**:
   * **url** - The URL of your Splunk instance.
   * **authentication** - How the Agent should authenticate with your Splunk instance. Choose either token-based (recommended) or basic authentication. For details see [authentication configuration details](/stackpacks/integrations/new_splunk/splunk.md#authentication).
   * **tags** - 
2. In the same the Agent V1 integration configuration file under **saved_searches**, add details of each [Splunk saved search](#splunk-saved-search) that the check should execute: 
     * **name** - The name of the [Splunk saved search](#splunk-saved-search) to execute.
       * **metric_name_field** - The field in the Splunk results that will contain the metric name. Default - `"metric"`.
       * **metric_value_field** - The field in the Splunk results that will contain numerical data. Default `value`.
       * **match:** - Default `metrics.*`.
       * **app** - Default `"search"
       * **request_timeout_seconds** - Default `10`
       * **search_max_retry_count** - Default `5`
       * **search_seconds_between_retries** - Default `1`
       * **batch_size** - Default `1000`
       * **initial_history_time_seconds** - Default `0`
       * **max_restart_history_seconds** - Default `86400`
       * **max_query_chunk_seconds** - Default `3600`
       * **unique_key_fields** - The fields to use to [uniquely identify a record](#uniquely-identify-a-record). Default `_bkt` and `_cd`.
       * **parameters** -

3. Restart StackState Agent V1 to apply the configuration changes.
4. Once the Agent has restarted, wait for the Agent to collect data and send it to StackState.

### Uniquely identify a record

To prevent sending duplicate metrics over multiple check runs, received saved search records must be uniquely identified for comparison. By default, a record is identified of the Splunk default fields `_bkt` and `_cd`. This behavior can be customized for each saved search by specifying `unique_key_fields` in the Splunk metrics Agent check configuration. Note that the specified `unique_key_fields` fields are mandatory fields for each record returned by the Splunk saved search. 

If it is not possible to uniquely identify a record by a combination of specific fields, the whole record can be used by setting `unique_key_fields: []` (an empty list).

## See also

* [StackState Splunk integration details](/stackpacks/integrations/new_splunk/splunk.md)
* [Example Splunk metrics configuration file - splunk\_metrics.yaml \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_metric/conf.yaml.example)