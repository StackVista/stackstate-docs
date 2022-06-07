---
description: StackState Self-hosted v5.0.x
---

# About checks and monitors

## Checks

**Checks** is a feature of StackState that provides health state information bound to the topology elements based on the telemetry & log streams and a set of customizable validation rules expressed in the form of **Check Functions**.

StackState can calculate health checks based on telemetry or log streams defined for a topology element. When telemetry or events data is available in StackState, this approach opens up the possibility to use the Autonomous Anomaly Detector \(AAD\) for anomaly health checks.

See how to [add a health check](./add-a-health-check.md) and how to [set up anomaly health checks](./anomaly-health-checks.md).

Checks are defined on a per-topology element basis and rely on the telemetry streams present on said topology elements. In this sense, each instance of a Check is directly connected to the specific topology element for which it will produce health state information. This means that in order to provide health state information for a large swath of the available topology, multiple instances of Checks, one per each topology element to be covered by monitoring, need to be created.

This can be conveniently done by extending the [component templates](../../develop/developer-guides/custom-functions/template-functions.md) in a StackPack definition. See how to [develop a StackPack](../../develop/developer-guides/stackpack/README.md)

## Monitors
**Monitors** are a new feature of StackState, introduced in version 5.0, that allows definition of complex validation rules within StackState. Monitors allow novel ways of combining 4T data to improve rule expressiveness and monitoring coverage.

Monitors, similarily to Checks, use the 4T data collected by StackState to compute health state information and attach it to the topology elements observed by the system. Unlike Checks, Monitors do not directly relate to the topology and do not require any changes to the topology synchronization templates in order to operate. Monitors inform the topology by leveraging the Health Synchronization and can be managed independantly via a dedicated set of CLI commands.

Monitors are a flexible way to define a custom set of monitoring rules. They can created manually, packaged as part of a StackPack, or integrated into any modern software development practice that leverages automation (for instance, GitOps).

See how to [add a new monitor](./add-a-monitor.md).

### Monitor format
Monitors in StackState are represented textually using the STJ file format. The following snippet presents an example monitor file:

```json
{
  "_version": "1.0.39",
  "timestamp": "2022-05-23T13:16:27.369269Z[GMT]",
  "nodes": [
    {
      "_type": "Monitor",
      "name": "CPU Usage",
      "description": "",
      "identifier": "urn:system:default:monitor:cpu-usage",
      "remediationHint": "Turn it off and on again.",
      "function": {{ get "urn:system:default:monitor-function:metric-threshold" }},
      "arguments": [{
        "_type": "ArgumentDoubleVal",
        "parameter": {{ get "urn:system:default:monitor-function:metric-threshold" "Type=Parameter;Name=threshold" }},
        "value": 90.0
      }, {
        "_type": "ArgumentScriptMetricQueryVal",
        "parameter": {{ get "urn:system:default:monitor-function:metric-threshold" "Type=Parameter;Name=query" }},
        "script": "Telemetry\n.query(\"StackState Metrics\", \"\")\n.metricField(\"cpu-usage\")\n.groupBy(\"tags.name\")\n.start(\"-1m\")\n.aggregation(\"mean\", \"15s\")"
      }],
      "intervalSeconds": 60
    }
  ]
}
```

In addition to the usual elements of an STJ file, the protocol version and timestamp, the snippet defines a single note of type `Monitor`. Here is a breakdown of the various fields supported by this definition:
- `name` - a human readable name that shortly describes the operating principle of the Monitor,
- `identifier` - a StackState-URN-formatted value that uniquely identifies this Monitor definition,
- `description` - a longer, more in-depth description of the Monitor,
- `remediationHint` - a short, markdown-enabled hint displayed whenever the validation rule represented by this Monitor triggers and results in an unhealthy state.
- `function` - refers a specific Monitor Function to use as the basis of computation for this Monitor,
- `arguments` - lists concrete values that are to be used as arguments to the Monitor Function invocation,
- `intervalSeconds` - dictates how often to execute this particular Monitor; new executions are scheduled after `intervalSeconds`, counting from the time th last execution ended.

### Monitor Function
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

#### Computing results
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

#### Available APIs
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

### Monitor execution
Monitors are run by a dedicated subsystem of StackState called the Monitor runner. The main task of the Monitor runner is to schedule the execution of all existing monitors in such a way as to ensure that all of them produce viable results in a timely manner.
For that purpose, the Monitor runner uses an interval parameter configured on a per-monitor basis - the `intervalSeconds`. The runner will attempt to schedule a Monitor execution every `intervalSeconds`, counting from the end of the previous execution cycle, in parallel to the other existing Monitors (subject to resource limits). For example, setting `intervalSeconds` of a Monitor definition to the value `600` will cause the Monitor runner to attempt to schedule the execution of this Monitor every ten minutes, assuming that the execution time itself is negligible.

The runner is maintenance free - it starts whenever StackState starts and picks up any newly applied Monitor definitions automatically whenever they are created, changed or removed. Any changes to the Monitors are reflected with the next execution cycle and any execution issues are logged to the global StackState log file. Any such error logs are obtainable (in addition to being stored in the StackState log file) via a dedicated CLI command:

```
sts monitor status <identifier-of-the-monitor-definition>
```

The output of this command indicates the specific errors that occured along with the counts of how many times they happend in addition to health stream statistics associated with this monitor.

The Monitor runner subsystem can be disabled via the configuration file by appending the following line at the end of the `etc/application_stackstate.conf` file:

```
stackstate.featureSwitches.monitorRunner = false
```

## See also
* [Health Synchronization](../../configure/health/health-synchronization)
* [StackState Template JSON \(STJ\)](../../develop/reference/stj/README.md)
* [StackState Query Language \(STQL\)](../../develop/reference/stql_reference.md)
* [StackState CLI](../../setup/cli-install.md)
* [StackPacks](../../stackpacks/about-stackpacks.md)
* [Identifiers](../../configure/topology/identifiers.md)
