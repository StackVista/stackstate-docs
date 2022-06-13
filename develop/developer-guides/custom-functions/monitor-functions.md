---
description: StackState Self-hosted v5.0.x
---

# Monitor functions

## Overview

Monitor Functions, much like any other type of function in StackState, are represented using the STJ file format. The following snippet represents an example Monitor Function definition:

```json
{
  "_version": "1.0.39",
  "timestamp": "2022-05-23T13:16:27.369269Z[GMT]",
  "nodes": [
    {
      "_type": "MonitorFunction",
      "name": "Metric Threshold",
      "identifier": "urn:system:default:monitor-function:metric-threshold",
      "description": "Validates the provided metric stream against the supplied threshold. Values above the threshold result in a CRITICAL health state..",
      "parameters": [
        ...
      ],
      "script": {
        "_type": "ScriptFunctionBody",
        "scriptBody": "..."
      }
    }
  ]
}
```

Much like the Monitor definition, the file contains the requisite STJ paramateres and defines a single node instance. For brevity, the specific parameter definitions & the function body have been ommited. These parts will be elaborated upon in the following sections.
The supported fields are:

- `name` - a human-readble name of the function that ideally indicates its purpose,
- `identifier` a StackState-URN-formatted values that uniquely identifies this particular function, it is used by the Monitor Definition during the invocation of this function,
- `description` - a more thorough description of the logic encapsulated by this function,
- `parameters` - a set of parameters "accepted" by this function, these allow the computation to be parameterized,
- `script` - names or lists out the concrete algorithm to use for this computation; currently, Monitors only support scripts of type `ScriptFunctionBody` written using the `Groovy` language.

#### Parameters
A Monitor Function can use any number of parameters of an array of available types. These parameter types are not unlike the ones available to the Check Functions (https://docs.stackstate.com/develop/developer-guides/custom-functions/check-functions#parameters) with the one notable exception being the `SCRIPT_METRIC_QUERY` parameter type.

`SCRIPT_METRIC_QUERY` parameter type represents a Telemetry Query and ensures that a well-formed Telemetry Query builder value is supplied to the function. Here's an example declaration of such a parameter:

```json
"parameters": [{
  "_type": "Parameter",
  "name": "metrics",
  "id": -1,
  "type": "SCRIPT_METRIC_QUERY",
  "required": true,
  "multiple": false
}]
```

The above declaration represents a single Telemetry Query accepting parameter named `metrics` that is required and allows no duplicates. Arguments of an invocation of a function using the above declaration:

```json
"arguments": [{
  "_type": "ArgumentScriptMetricQueryVal",
  "parameter": -1,
  "script": "Telemetry.query('StackState Metrics', '').groupBy('tags.pid', 'tags.createTime', 'host').metricField('cpu_systemPct').start('-1m').aggregation('mean', '15s')"
}]
```

After the invocation, the `metrics` parameter assumes the value of the following telemetry query expression which in itself indicates the specific metric values to fetch along with the aggregation method and the time window to use:

```groovy
Telemetry
  .query('StackState Metrics', '')
  .groupBy('tags.pid', 'tags.createTime', 'host')
  .metricField('cpu_systemPct')
  .start('-1m')
  .aggregation('mean', '15s')
```

A specialized telemetry query parameter type is useful as it ensures well-formedness of the above query - in case of any syntactic or type errors a suitable error will be reported and the system will prevent execution of the Monitor Function with potentially bogus values.

### Computing results
Similarily to the other kinds of functions in StackState, the Monitor Function follows an arbitrarily complex algorithm encoded as a Groovy source script. It is fairly flexible in what it can do allowing for Turing-complete computation and even communication with external services.

The Monitor Runner, which is responsible for the execution of Monitor Functions, expects every function to return a specific result type - an array of JSON-encoded `MonitorHealthState` objects. For example:

```groovy
return [
  [
    _type: "MonitorHealthState",
    id: uniqueHealthStateIdentifier,
    topologyIdentifier: topologyElementURN,
    state: healthState,
    displayTimeSeries: optionalChartConfiguration
 ],
 // More results to follow...
]
```

Each object in this array represents a single Monitor result - usually, it is a one to one mapping between a specific metrics' time series and a topology element, but in general it is possible to express many-to-one mappings as well.
The supported fields are:
- `id` - the identifier for this concrete Monitor result, it is used to deduplicate results arriving from different sources of computation,
- `topologyIdentifier` - indicates to which Topology element this result "belongs",
- `state` - indicates the resulting health state of the validation rule,
- `displayTimeSeries` - an optional configuration of chart(s) that will be displayed on the StackState interface together with the Monitor result.

The `displayTimeSeries` field can optionally be used to instrument StackState to display a helpful metric chart (or multiple charts) together with the Monitor result. It is expected to be an array of JSON-encoded objects of type `DisplayTimeSeries` of the following shape:

```groovy
[
  _type: "DisplayTimeSeries",
  name: "A descriptive name for the chart",
  query: aQueryToUseWhenFetchingMetrics,
  timeSeriesId: aSpecificTimeSeriesId
]
```

The meaning of different `DisplayTimeSeries` fields:
- `name` - a short name for the chart, it is displayed as the chart title on the StackState interface,
- `query` - a Telemetry query used to fetch the metrics data to display on the interface,
- `timeSeriesId` - an identifier of the concrete time series to use if the `query` produces multiple lines; when defined, the displayed chart will be limitted to just one line.

The computation performed by a Monitor Function is restricted in numerous ways, including by restricting its access to certain classes (sandboxing) and by resource utilization (both in execution time and memory, compute usage). Some of these limits can be lifted by changing the default StackState configuration.

### Available APIs
Monitor Functions can leverage existing StackState Script APIs, including:

- `Telemetry` - used to fetch Metric & Log data,
- `Async` - allowing for combining multiple asynchronous results in one computation,
- `View` - StackState View related operations,
- `Component` - StackState Component related operations.

Additionally, the following Script APIs are optionally available. They are considered to be experimental:

- `Topology` - used to fetch Topology data,
- `Http` - used to fetch external data via the HTTP protocol,
- `Graph` - a generic way to query the StackGraph database.

To use the above, experimental APIs please enable them explicitly in your StackState configuration file by appending the following line at the end of the `etc/application_stackstate.conf` file.

```
stackstate.featureSwitches.monitorEnableExperimentalAPIs = true
```
