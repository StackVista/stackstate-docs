---
title: Splunk Metric Integration
kind: documentation
---

## Overview

The StackState Agent can be configured to execute Splunk saved searches and provide the results as metrics to the StackState receiver API. It will dispatch the saved searches periodically, specifying last metric timestamp to start with up until now.

The StackState Agent expects the results of the saved searches to contain certain fields, as described below in the Metric Query Format.
If there are other fields present in the result, they will be mapped to tags, where the column name is the key, and the content the value.
The Agent will filter out Splunk default fields (except `_time`), like e.g. `_raw`, see the [Splunk documentation](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields) for more information about default fields.

The agent check prevents sending duplicate metrics over multiple check runs.  The received saved search records have to be uniquely identified for comparison.
By default, a record's identity is composed of Splunk's default fields `_bkt` and `_cd`.
The default behavior can be changed for each saved search by setting the `unique_key_fields` in the check's configuration.
Please note that the specified `unique_key_fields` fields become mandatory for each record.
In case the records can not be uniquely identified by a combination of fields then the whole record can be used by setting `unique_key_fields` to `[]`, i.e. empty list.

### Metric Query Format

All these fields are required.

<table class="table">
<tr><td><strong>_time</strong></td><td>long</td><td>Data collection timestamp, millis since epoch</td></tr>
<tr><td><strong>metric%</strong></td><td>string</td><td>Name of the metric</td></tr>
<tr><td><strong>value%</strong></td><td>numeric</td><td>The value of the metric</td></tr>
</table>

\% The name of the field is configurable in the configuration file

### Example

Example Splunk query:

```
index=vms MetricId=cpu.usage.average
| table _time VMName Value    
| eval VMName = upper(VMName)
| rename VMName as metricCpuUsageAverage, Value as valueCpuUsageAverage
| eval type = "CpuUsageAverage"
```

## Configuration

1.  Edit your conf.d/splunk_metric.yaml file.
2.  Restart the agent

{{< insert-example-links >}}
