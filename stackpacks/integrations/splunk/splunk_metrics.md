---
description: StackState Self-hosted v5.0.x 
---

# Splunk Metrics

## Overview

When the [Splunk StackPack](splunk_stackpack.md) has been installed in StackState, you can configure the Splunk Metrics check on StackState Agent V1 to begin collecting Splunk metrics data.

Metrics are collected from Splunk by executing Splunk saved searches that have been specified in the StackState Agent V1 Splunk Metrics check configuration. In order to receive Splunk metrics data in StackState, you will therefore need to add configuration to both Splunk and StackState Agent V1.

* [In Splunk](splunk_metrics.md#splunk-saved-search), there should be at least one saved search that generates the metrics data you want to retrieve. Each saved search can retrieve one metric.
* [In StackState Agent V1](splunk_metrics.md#agent-check), a Splunk Metrics check should be configured to connect to your Splunk instance and execute the relevant Splunk saved searches.

The Splunk Metrics check on StackState Agent V1 will execute all configured Splunk saved searches periodically. Data will be requested from the last received metric timestamp up until now.

## Splunk saved search

### Fields used

StackState Agent V1 executes the Splunk saved searches configured in the [Splunk Metrics Agent check configuration file](splunk_metrics.md#agent-check) and pushes retrieved data to StackState as a telemetry stream. The following fields from the results of a saved search are sent to StackState:

| Field | Type | Required? | Description |
| :--- | :--- | :--- | :--- |
| **\_time** | long | - | Data collection timestamp, millis since epoch. |
| **metric** | string | - | The name of the metric. Taken from the configured `metric_name_field`. |
| **value** | numeric | - | The value of the metric. Taken from the configured `metric_value_field`. |

### Example Splunk query

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

{% tab title="Splunk Metrics Agent check configuration" %}
```text
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

### Configure the Splunk Metrics check

To enable the Splunk Metrics integration and begin collecting metrics data from your Splunk instance, the Splunk Metrics check must be configured on StackState Agent V1. The check configuration provides all details required for the Agent to connect to your Splunk instance and execute a Splunk saved search.

{% hint style="info" %}
Example Splunk Metrics Agent check configuration file:  
[splunk\_metric/conf.yaml.example \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_metric/conf.yaml.example)
{% endhint %}

To configure the Splunk Metrics Agent check:

1. Edit the StackState Agent V1 configuration file `/etc/sts-agent/conf.d/splunk_metric.yaml`.
2. Under **instances**, add details of your Splunk instance:
   * **url** - The URL of your Splunk instance.
   * **authentication** - How the Agent should authenticate with your Splunk instance. Choose either token-based \(recommended\) or basic authentication. For details, see [authentication configuration details](splunk_stackpack.md#authentication).
   * **tags** - Optional. Can be used to apply specific tags to all reported metrics in StackState.
3. Under **saved\_searches**, add details of each Splunk saved search that the check should execute. Each saved search can retrieve one metric: 
   * **name** - The name of the [Splunk saved search](splunk_metrics.md#splunk-saved-search) to execute.
     * **metric\_name\_field** - The field in the Splunk results that will contain the metric name. Default `"metric"`.
     * **metric\_value\_field** - The field in the Splunk results that will contain numerical data. Default `"value"`.
     * **match:** - Regex used for selecting Splunk saved search queries. Default `metrics.*`.
     * **app** - The Splunk app in which the saved searches are located. Default `"search"`.
     * **request\_timeout\_seconds** - Default `10`
     * **search\_max\_retry\_count** - Default `5`
     * **search\_seconds\_between\_retries** - Default `1`
     * **batch\_size** - Default `1000`
     * **initial\_history\_time\_seconds** - Default `0`
     * **max\_restart\_history\_seconds** - Default `86400`
     * **max\_query\_chunk\_seconds** - Default `3600`
     * **unique\_key\_fields** - The fields to use to [uniquely identify a record](splunk_metrics.md#uniquely-identify-a-record). Default `_bkt` and `_cd`.
     * **parameters** - Used in the Splunk API request. The default parameters provided make sure the Splunk saved search query refreshes. Default `force_dispatch: true` and `dispatch.now: true`.
4. More advanced options can be found in the [example configuration \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_metric/conf.yaml.example). 
5. Save the configuration file.
6. Restart StackState Agent V1 to apply the configuration changes.
7. Once the Agent has restarted, wait for the Agent to collect data and send it to StackState.
8. Metrics retrieved from splunk are available in StackState as a metrics telemetry stream in the `stackstate-metrics` data source. This can be [mapped to associated components](../../../use/metrics-and-events/add-telemetry-to-element.md).

### Uniquely identify a record

To prevent sending duplicate metrics over multiple check runs, received saved search records must be uniquely identified for comparison. By default, a record is identified by the Splunk default fields `_bkt` and `_cd`. This behavior can be customized for each saved search by specifying `unique_key_fields` in the Splunk Metrics Agent check configuration. Note that the specified `unique_key_fields` fields are mandatory fields for each record returned by the Splunk saved search.

If it is not possible to uniquely identify a record by a combination of specific fields, the whole record can be used by setting `unique_key_fields: []` \(an empty list\).

### Disable the Agent check

To disable the Splunk Metrics Agent check:

1. Remove or rename the Agent integration configuration file, for example:

   ```text
    mv conf.d/splunk_metrics.yaml conf.d/splunk_metrics.yaml.bak
   ```

2. Restart the StackState Agent to apply the configuration changes.

## Splunk metrics in StackState

Metrics retrieved from splunk are available in StackState as a metrics telemetry stream in the `stackstate-metrics` data source. This can be [mapped to associated components](../../../use/metrics-and-events/add-telemetry-to-element.md).

## See also

* [StackState Splunk integration details](splunk_stackpack.md)
* [Map telemetry to components](../../../use/metrics-and-events/add-telemetry-to-element.md)
* [Example Splunk Metrics configuration file - splunk\_metric/conf.yaml.example \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_metric/conf.yaml.example)

