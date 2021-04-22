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
| **metric** | string | Name of the metric. This is taken from the `metric_name_field` configured in the [Agent splunk metrics check](#agent-splunk-metrics-check). |
| **value** | numeric | The value of the metric. This is taken from the `metric_value_field` configured in the [Agent splunk metrics check](#agent-splunk-metrics-check). |

{% tabs %}
{% tab title="Example Splunk query" %}
```text
index=vms MetricId=cpu.usage.average
| table _time VMName Value    
| eval VMName = upper(VMName)
| rename VMName as metricCpuUsageAverage, Value as valueCpuUsageAverage
| eval type = "CpuUsageAverage"
```
{% endtab %}
{% endtabs %}

With Agent check configuration:

* `metric_name_field: "metricCpuUsageAverage"`
* `metric_value_field: "valueCpuUsageAverage"`

The example Splunk saved search above would result in the following metric data in StackState:

| Field | Data |
| :--- | :--- |
| **\_time** | Splunk `_time` field. |
| **metric** | Splunk `<metricCpuUsageAverage>` field. |
| **value** | Splunk `<valueCpuUsageAverage>` field. |

## Agent Splunk metrics check



### Uniquely identify a record

To prevent sending duplicate metrics over multiple check runs, received saved search records must be uniquely identified for comparison. By default, a record is identified of the Splunk default fields `_bkt` and `_cd`. This behavior can be customized for each saved search by specifying `unique_key_fields` in the Splunk metrics Agent check configuration. Note that the specified `unique_key_fields` fields are mandatory fields for each record returned by the Splunk saved search. 

If it is not possible to uniquely identify a record by a combination of specific fields, the whole record can be used by setting `unique_key_fields: []` (an empty list).


## See also

* [StackState Splunk integration details](/stackpacks/integrations/new_splunk/splunk.md)
* [Example Splunk metrics configuration file - splunk\_metrics.yaml \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_metrics/conf.yaml.example)