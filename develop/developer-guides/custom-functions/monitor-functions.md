---
description: StackState Self-hosted v5.1.x
---

# Monitor functions

## Overview

Monitor functions, much like any other type of function in StackState, are represented using the STJ file format. 

## Monitor function definition

### STJ file format

The following snippet represents an example monitor function definition:

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

Much like the monitor definition, the file contains the requisite STJ paramateres and defines a single node instance. For brevity, the specific parameter definitions and the function body have been ommited. These parts will be elaborated upon in the following sections.

The supported fields are:

- **name** - a human-readable name of the function that ideally indicates its purpose.
- **identifier** a StackState-URN-formatted values that uniquely identifies this particular function, it is used by the monitor Definition during the invocation of this function.
- **description** - a more thorough description of the logic encapsulated by this function.
- **parameters** - a set of parameters "accepted" by this function, these allow the computation to be parameterized.
- **script** - names or lists out the concrete algorithm to use for this computation; currently, monitors only support scripts of type `ScriptFunctionBody` written using the Groovy scripting language.

### Parameters

A monitor function can use any number of parameters of an array of available types. These parameter types are not unlike the ones available to the [Check functions](check-functions.md) with the one notable exception being the `SCRIPT_METRIC_QUERY` parameter type.

`SCRIPT_METRIC_QUERY` parameter type represents a Telemetry Query and ensures that a well-formed Telemetry Query builder value is supplied to the function. Here's an example declaration of such a parameter:

```json
"parameters": [{
  "_type": "Parameter",
  "name": "metrics",
  "type": "SCRIPT_METRIC_QUERY",
  "required": true,
  "multiple": false
}]
```

The above declaration represents a single Telemetry Query accepting parameter named `metrics` that is required and allows no duplicates. Arguments of an invocation of a function using the above declaration:

```json
"arguments": [{
  "_type": "ArgumentScriptMetricQueryVal",
  "parameter": {{ get "<identifier-of-the-function>" "Type=Parameter;Name=metrics" }},
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

A specialized telemetry query parameter type is useful as it ensures well-formedness of the above query - in case of any syntactic or type errors a suitable error will be reported and the system will prevent execution of the monitor function with potentially bogus values.

### Computing results

Similar to other kinds of functions in StackState, the monitor function follows an arbitrarily complex algorithm encoded as a Groovy source script. It is fairly flexible in what it can do allowing for Turing-complete computation and even communication with external services.

The monitor runner, which is responsible for the execution of monitor functions, expects every function to return a specific result type - an array of JSON-encoded `MonitorHealthState` objects. For example:

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

Each object in this array represents a single monitor result - usually, it is a one to one mapping between a specific metrics' time series and a topology element, but in general it is possible to express many-to-one mappings as well.
The supported fields are:
- **id** - the identifier for this concrete monitor result, it is used to deduplicate results arriving from different sources of computation,
- **topologyIdentifier** - indicates to which Topology element this result "belongs",
- **state** - indicates the resulting health state of the validation rule,
- **displayTimeSeries** - an optional configuration of chart(s) that will be displayed on the StackState interface together with the monitor result.

The `displayTimeSeries` field can optionally be used to instrument StackState to display a helpful metric chart (or multiple charts) together with the monitor result. It is expected to be an array of JSON-encoded objects of type `DisplayTimeSeries` of the following shape:

```groovy
[
  _type: "DisplayTimeSeries",
  name: "A descriptive name for the chart",
  query: aQueryToUseWhenFetchingMetrics,
  timeSeriesId: aSpecificTimeSeriesId
]
```

The meaning of different `DisplayTimeSeries` fields:
- **name** - a short name for the chart, it is displayed as the chart title on the StackState interface,
- **query** - a Telemetry query used to fetch the metrics data to display on the interface,
- **timeSeriesId** - an identifier of the concrete time series to use if the `query` produces multiple lines; when defined, the displayed chart will be limitted to just one line.

The computation performed by a monitor function is restricted in numerous ways, including by restricting its access to certain classes (sandboxing) and by resource utilization (both in execution time and memory, compute usage). Some of these limits can be lifted by changing the default StackState configuration.

### Available APIs
Monitor functions can leverage existing StackState Script APIs, including:

- **Telemetry** - used to fetch Metric and Log data,
- **Async** - allowing for combining multiple asynchronous results in one computation,
- **View** - StackState View related operations,
- **Component** - StackState Component related operations.

Additionally, the following Script APIs are optionally available. They are considered to be experimental:

- **Topology** - used to fetch Topology data,
- **Http** - used to fetch external data via the HTTP protocol,
- **Graph** - a generic way to query the StackGraph database.

{% hint style="success" "self-hosted info" %}

To use the above, experimental APIs they must be explicitly named in your StackState configuration file by appending the following line at the end of the `etc/application_stackstate.conf` file.

`stackstate.featureSwitches.monitorEnableExperimentalAPIs = true`

{% endhint %}


## Create a custom monitor function

The following example describes a step-by-step process of creating a monitor function. In this case, a metric thereshold rule is introduced parameterized with the exact metrics query to use and the threshold itself.

1. [Create an STJ file.](#create-an-stj-file)
2. [Populate the monitor function node.](#populate-the-monitor-function-node)
3. [Populate the monitor function body.](#populate-the-monitor-function-body)
4. [Formalize the function parameters.](#formalize-the-function-parameters)
5. [Upload to StackState.](#upload-to-stackstate)

### Create an STJ file

The first step is to create an STJ import file following the usual format and file organization:

```json
{
  "_version": "1.0.39",
  "timestamp": "2022-06-23T23:23:23.269369Z[GMT]",
  "nodes": [
    ...
  ]
}
```

StackState expects a `_version` property to be present in each and every export file. monitor functions are supported in versions `1.0.39` and up. Each export file can contain multiple monitor function nodes and also nodes of other types.

### Populate the monitor function node

The next step is the function node itself.

```json
{
  "_type": "MonitorFunction",
  "name": "The name of the monitor function",
  "description": "A longer, meaningful description of a monitor function",
  "identifier": "urn:system:default:monitor-function:a-name-of-the-monitor-function",
  "parameters": [
    ...
  ],
  "script": {
    "_type": "ScriptFunctionBody",
    "scriptBody": ...
  }
}
```

Here you can define the basic information about the function such as its name and description to help you distinguish different monitor functions.
An important field is the `identifier` - it is a unique value of the StackState URN format that can be used to refer to this objects in various other places, such as an invocation of a monitor function. The identifier should be formatted as follows:

`urn : <prefix> : monitor-function : <unique-function-identification>`

The `prefix` is described in more detail in [topology identifiers](../../../configure/topology/identifiers.md), while the `unique-function-identification` is user-definable and free-form.

### Populate the monitor function body

The most important fields of the monitor function node are its `scriptBody` and `parameters`. In this step, we will focus on the body of the function and we'll determine the required parameters next.

As described above, the function we're creating will check a given metric against a given threshold and based on that produce health states for the affected topology. To make things concrete, let's start with a simple CPU usage metric:

```groovy
def metrics =
  Telemetry.query("StackState Metrics", "cluster='cluster-a.example.com'")
    .metricField("system.cpu.system")
    .groupBy("tags.host")
    .start("-10m")
    .aggregation("mean", "30s")
```

The above snippet queries `StackState Metrics` datasource for a CPU usage, grouped per each hostname of a `cluster-a.example.com` Kubernetes cluster, starting at 10 minutes in the past, averaged every 30 seconds. The results are grouped per hostname and represent the CPU usage of that host averaged across 10 minutes.
Next we need to check the returned values against a threshold of 90%:

```groovy
def metrics = /* Same as above. */

def threshold = 90.0

def checkThreshold(timeSeries, threshold) {
  timeSeries.points.any { point -> point.last() > threshold }
}

metrics.map { result ->
  def state = "CLEAR"
  if (checkThreshold(result.timeSeries, threshold)) {
    state = "CRITICAL";
  }

  return state
}
```

For each hostname, we check the resulting values to see if any of them are above the threshold of 90%, and if so we indicate a `CRITICAL` health state, otherwise a `CLEAR` one is reported.
To make these results conform to the required format, we need to include a few more mandatory fields. The most important one is the `topologyIdentifier` which determines to which topology element a given monitor result belongs. We also give each monitor result a uniqe `id` (derived from the metrics that were used to create it), so that the system can match and replace successively supplied results accross time:

```groovy
def metrics = /* Same as above. */
def threshold = /* Same as above. */

def topologyIdentifierPattern = "urn:host:/${tags.host}"

def checkThreshold = /* Same as above. */

metrics.map { result ->
  def state = "CLEAR"
  if (checkThreshold(result.timeSeries, threshold)) {
    state = "CRITICAL";
  }

  return [
    _type: "MonitorHealthState",
    id: result.timeSeries.id.toIdentifierString(),
    state: state,
    topologyIdentifier: StringTemplate.runForTimeSeriesId(topologyIdentifierPattern, result.timeSeries.id)
  ]
}
```

With the above change, each timeseries is now validated against the threshold and reported as a monitor health state. Each such result is uniquely identified by the metrics that were used to compute it, so any future changes based on the same metrics will result in health state updates instead of new states being created. Furthermore, we used the same metrics to extract the `tags.host` grouping from it and turned it into a specific topology identifier of a hostname represented in StackState. This topology identifier reconstruction, called topology mapping, is performed for all the groupped metric timeseries meaning it automatically applies to all the hosts in the topology that have CPU metrics associated with them.
An improvement to the above definition can be made by introducing a result chart with each result. This is done by populating the optional `displayTimeseries` property of the monitor health state:

```groovy
def metrics = /* Same as above. */
def threshold = /* Same as above. */
def topologyIdentifierPattern = /* Same as above. */
def checkThreshold = /* Same as above. */

metrics.map { result ->
  def state = "CLEAR"
  if (checkThreshold(result.timeSeries, threshold)) {
    state = "CRITICAL";
  }

  return [
    _type: "MonitorHealthState",
    id: result.timeSeries.id.toIdentifierString(),
    state: state,
    topologyIdentifier: StringTemplate.runForTimeSeriesId(topologyIdentifierPattern, result.timeSeries.id),
    displayTimeSeries: [
      [
        _type: "DisplayTimeSeries",
        name: "The resulting metric values",
        query: result.query,
        timeSeriesId: result.timeSeries.id
      ]
    ]
  ]
}
```

Each chart configuration supplied this way will be shown together with the monitor result on the StackState UI. In the above case, the specific timeseries that resulted in the monitor health state being computed will be displayed for host affected by this monitor.

The full function body created so far:

```groovy
def metrics =
  Telemetry.query("StackState Metrics", "cluster='cluster-a.example.com'")
    .metricField("system.cpu.system")
    .groupBy("tags.host")
    .start("-10m")
    .aggregation("mean", "30s")

def threshold = 90.0

def topologyIdentifierPattern = "urn:host:/${tags.host}"

def checkThreshold(timeSeries, threshold) {
  timeSeries.points.any { point -> point.last() > threshold }
}

metrics.map { result ->
  def state = "CLEAR"
  if (checkThreshold(result.timeSeries, threshold)) {
    state = "CRITICAL";
  }

  return [
    _type: "MonitorHealthState",
    id: result.timeSeries.id.toIdentifierString(),
    state: state,
    topologyIdentifier: StringTemplate.runForTimeSeriesId(topologyIdentifierPattern, result.timeSeries.id),
    displayTimeSeries: [
      [
        _type: "DisplayTimeSeries",
        name: "The resulting metric values",
        query: result.query,
        timeSeriesId: result.timeSeries.id
      ]
    ]
  ]
}
```

To parameterize this function and make it reusable for different metrics and thresholds, we can extract the `metrics`, `threshold` and `topologyIdentifierPattern` into StackState functions parameters. Furthermore, in order to use this function as part of an STJ import file it needs to be encoded as a JSON string property:

```json
{
  "_type": "ScriptFunctionBody",
  "scriptBody": "def checkThreshold(timeSeries, threshold) {\n  timeSeries.points.any { point -> point.last() > threshold }\n}\n\nmetrics.map { result ->\n  def state = \"CLEAR\"\n  if (checkThreshold(result.timeSeries, threshold)) {\n    state = \"CRITICAL\";\n  }\n\n  return [\n    _type: \"MonitorHealthState\",\n    id: result.timeSeries.id.toIdentifierString(),\n    state: state,\n    topologyIdentifier: StringTemplate.runForTimeSeriesId(topologyIdentifierPattern, result.timeSeries.id)\n    displayTimeSeries: [\n      [\n        _type: \"DisplayTimeSeries\",\n        name: \"The resulting metric values\",\n        query: result.query,\n        timeSeriesId: result.timeSeries.id\n      ]\n    ]\n  ]\n}"
}
```

### Formalize the function parameters

In the previous steps, we created a monitor function and implemented the validation rule for CPU usage metrics, we determined that in order to make the function reusable, we need to extract three parameters - `metrics`, `threshold` and the `topologyIdentifierPattern`.

The `threshold` and `topologyIdentifierPattern` are simple basic types, a floating point value and a string respectively. For the `metrics` parameter, we can utilize the aforementioned `SCRIPT_METRIC_QUERY` parameter type, which ensures well-formedness of the metrics query supplied as the value of this parameter:

```json
{
  "_type": "Parameter",
  "name": "threshold",
  "type": "DOUBLE",
  "required": true,
  "multiple": false
},
{
  "_type": "Parameter",
  "name": "topologyIdentifierPattern",
  "type": "STRING",
  "required": true,
  "multiple": false
},
{
  "_type": "Parameter",
  "name": "metrics",
  "type": "SCRIPT_METRIC_QUERY",
  "required": true,
  "multiple": false
},
```

The above specification ensures that each function invocation is passed all the requisite parameters (all marked as `required`) and that their types will be safe to use in the context of the body of the function. Any type mismatches will be reported during the importing of this function definition.

### Upload to StackState

The final step is giving the function a descriptive name and uploading it to StackState by importing the file containing the function definition. The following snippet contains the full function created so far:

```json
{
  "_version": "1.0.39",
  "timestamp": "2022-06-23T23:23:23.269369Z[GMT]",
  "nodes": [
    {
      "_type": "MonitorFunction",
      "name": "Metric above threshold",
      "description": "Validates that a metric value stays below a given threshold, reports a CRITICAL state otherwise.",
      "parameters": [
        {
          "_type": "Parameter",
          "name": "threshold",
          "type": "DOUBLE",
          "required": true,
          "multiple": false
        },
        {
          "_type": "Parameter",
          "name": "topologyIdentifierPattern",
          "type": "STRING",
          "required": true,
          "multiple": false
        },
        {
          "_type": "Parameter",
          "name": "metrics",
          "type": "SCRIPT_METRIC_QUERY",
          "required": true,
          "multiple": false
        }
      ],
      "identifier": "urn:system:default:monitor-function:metric-above-threshold",
      "script": {
        "_type": "ScriptFunctionBody",
        "scriptBody": "def checkThreshold(timeSeries, threshold) {\n  timeSeries.points.any { point -> point.last() > threshold }\n}\n\nmetrics.map { result ->\n  def state = \"CLEAR\"\n  if (checkThreshold(result.timeSeries, threshold)) {\n    state = \"CRITICAL\";\n  }\n\n  return [\n    _type: \"MonitorHealthState\",\n    id: result.timeSeries.id.toIdentifierString(),\n    state: state,\n    topologyIdentifier: StringTemplate.runForTimeSeriesId(topologyIdentifierPattern, result.timeSeries.id)\n    displayTimeSeries: [\n      [\n        _type: \"DisplayTimeSeries\",\n        name: \"The resulting metric values\",\n        query: result.query,\n        timeSeriesId: result.timeSeries.id\n      ]\n    ]\n  ]\n}"
      }
    }
  ]
}
```

The function can be uploaded to StackState in one of three ways:

- Make the function [part of a StackPack](../../../stackpacks/about-stackpacks.md) and install the StackPack.
- Use the Import/Export facility under StackState settings.
- Use the [StackState CLI](../../../setup/cli/README.md):

{% tabs %}
{% tab title="CLI: sts (new)" %}
```
sts settings import < path/to/file.stj
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)

{% endtab %}
{% tab title="CLI: stac" %}
```
stac graph import < path/to/file.stj
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

The new `sts` CLI replaces the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% endtabs %}

After the function has been uploaded, it will be generally available for any monitor definition to invoke it.

➡️ [Learn how to create a custom monitor that utilizes an existing monitor function](../monitors/create-custom-monitors.md)

## See also

* [Monitor STJ format](/develop/developer-guides/monitors/monitor-stj-file-format.md)
* [StackState CLI](../../../setup/cli/README.md)
* [StackState Template JSON \(STJ\)](../../reference/stj/README.md)
* [Develop your own StackPacks](../../../stackpacks/sdk.md)
* [Integrations](../../../stackpacks/integrations/README.md)
