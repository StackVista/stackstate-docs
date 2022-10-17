---
description: StackState Self-hosted v5.1.x
---

# Monitor STJ file format

## Overview

Monitors can be attached to any number of elements in the StackState topology to calculate a health state based on 4T data. Each monitor consists of a monitor definition and a monitor function. Monitors are created and managed by StackPacks, you can also create custom monitors and monitor functions outside of a StackPack without having to modify any configuration.

## STJ file format

Monitors in StackState are represented textually using the [STJ file format](/develop/reference/stj/using_stj.md). The following snippet presents an example monitor file:

```json
{
  "_version": "1.0.39",
  "timestamp": "2022-05-23T13:16:27.369269Z[GMT]",
  "nodes": [
    {
      "_type": "Monitor",
      "name": "CPU Usage",
      "description": "A simple CPU-usage monitor. If the metric is above a given threshold, the state is set to CRITICAL.",
      "identifier": "urn:system:default:monitor:cpu-usage",
      "remediationHint": "Turn it off and on again.",
      "function": {{ get "urn:system:default:monitor-function:metric-above-threshold" }},
      "arguments": [{
        "_type": "ArgumentDoubleVal",
        "parameter": {{ get "urn:system:default:monitor-function:metric-above-threshold" "Type=Parameter;Name=threshold" }},
        "value": 90.0
      }, {
         "_type": "ArgumentStringVal",
        "parameter": {{ get "urn:system:default:monitor-function:metric-above-threshold" "Type=Parameter;Name=topologyIdentifierPattern" }},
        "value": "urn:host:/${tags.host}"
      }, {
        "_type": "ArgumentScriptMetricQueryVal",
        "parameter": {{ get "urn:system:default:monitor-function:metric-above-threshold" "Type=Parameter;Name=query" }},
        "script": "Telemetry\n.query('StackState Metrics', '')\n.metricField('system.cpu.system')\n.groupBy('tags.host')\n.start('-1m')\n.aggregation('mean', '15s')"
      }],
      "status": "ENABLED",
      "tags": ["demo"],
      "intervalSeconds": 60
    }
  ]
}
```

In addition to the usual elements of an STJ file, the protocol version and timestamp, the snippet defines a single node of type `Monitor`. 

The supported fields are:

- **name** - a human-readable name that shortly describes the operating principle of the monitor.
- **description** - a longer, more in-depth description of the monitor.
- **identifier** - a StackState-URN-formatted value that uniquely identifies this monitor definition. For more details see [identifier](#identifier).
- **remediationHint** - a short, markdown-enabled hint displayed whenever the validation rule represented by this monitor triggers and results in an unhealthy state.
- **function** - the specific monitor function to use as the basis of computation for this monitor. For more details see [function](#function).
- **arguments** - lists concrete values that are to be used for parameters in the monitor function invocation. For more details and descriptions of commonly used parameters, see [arguments](#arguments).
- **status** - either `ENABLED`|`DISABLED`. Dictates if the monitor will be running and producing health states. Optional. If not specified, the previous status will be used (`DISABLED` for newly created monitors).
- **tags** - tags associated to the monitor.
- **intervalSeconds** - dictates how often to execute this particular monitor; new executions are scheduled after the specified number of seconds, counting from the time that the last execution ended. For more details see [run interval](#intervalseconds).

## Field information

### identifier

An important field of the monitor node is the `identifier` - it is a unique value of the StackState URN format that can be used together with the monitor-specific StackState CLI commands. The identifier should be formatted as follows:

`urn : <prefix> : monitor : <unique-monitor-identification>`

* The `<prefix>` is described in more detail in [topology identifiers](../../../configure/topology/identifiers.md "StackState Self-Hosted only").
* The `<unique-monitor-identification>` is user-definable and free-form.

### function

Each monitor configured in StackState uses a monitor function to compute the health state results that are attached to the elements.

Monitor functions are scripts that accept 4T data as input, check the data based on some internal logic and output health state mappings for the affected topology elements. The function is run periodically by the monitor runner (at the configured `intervalSeconds`). The monitor function is responsible for detecting any changes in the data that can be considered to change an element's health state.

You can list the available monitor functions using the CLI command:

{% tabs %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: sts (new)" %}[](http://not.a.link "StackState Self-Hosted only")
```
sts settings list --type MonitorFunction
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.[](http://not.a.link "StackState Self-Hosted only")

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: stac" %}[](http://not.a.link "StackState Self-Hosted only")
`stac graph list MonitorFunction`[](http://not.a.link "StackState Self-Hosted only")

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`. [](http://not.a.link "StackState Self-Hosted only")

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:[](http://not.a.link "StackState Self-Hosted only")

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}[](http://not.a.link "StackState Self-Hosted only")

{% hint style="success" "self-hosted info" %}

You can [create custom monitor function](../custom-functions/monitor-functions.md) to customize how StackState processes 4T data.

{% endhint %}

### arguments

The arguments defined in the monitor STJ definition should match the parameters defined in the monitor function STJ definition. 

The parameter binding syntax is common for all parameter types, and utilizes the following format:

```json
{
  "_type": "<type-of-the-parameter",
  "parameter": {{ get "<identifier-of-the-function>" "Type=Parameter;Name=<name-of-the-parameter>" }},
  "value": "<value-of-the-parameter>"
}
```

* **_type** - The type of the parameter.
* **parameter** - A reference to the concrete instance of a parameter within a function's parameter list. The `Name` must match the name specified in the monitor function.
* **value** - the value of the parameter to pass to the monitor function. 

During an invocation of a monitor function, the parameter value is interpreted and instantiated beforehand with all of the requisite validations applied to it. Assuming it passes type and value validations, it will become available in the body of the function as a global value of the same name, with the assigned value.

{% hint style="info" %}
* Parameters marked as `required` in the monitor function STJ definition must be supplied at least once. If a parameter is not `required`, then it can be optionally omitted.
* Parameters marked as `multiple` in the monitor function STJ definition can be supplied more than once, meaning that they represent a set of values.
{% endhint %}

**Common parameters**

Descriptions of parameters that are commonly used by monitor functions can be found below:

* [Numeric values](#numeric-values) - a simple numeric value.
* [Topology query](#topology-query) - a query to return a subset of the topology.
* [Telemetry query](#telemetry-query) - a query that returns the telemetry to be passed to the monitor function.
* [Topology identifier pattern](#topology-identifier-pattern) - the pattern of the topology element identifiers to which the monitor function should assign calculated health states.

#### Numeric values
The most common and simple monitor function parameter types are numeric values. 

{% tabs %}
{% tab title="Monitor STJ definition" %}
To supply a value to the `value` parameter defined in the monitor function, the monitor STJ definition would look something like the following:

```json
...
{
  "_type": "ArgumentDoubleVal",
  "parameter": {{ get "<identifier-of-the-function>" "Type=Parameter;Name=value" }},
  "value": 23.5
}
...
```
{% endtab %}
{% tab title="Monitor function STJ definition" %}
The declaration of a numeric value in a monitor function STJ definition can look something like the following:
```json
...
"parameters": [{
  "_type": "Parameter",
  "type": "DOUBLE",
  "name": "value",
  "required": true,
  "multiple": false
  },
  ...
]
...
```
{% endtab %}
{% endtabs %}

#### Topology Query

Monitor functions that utilize Topology often times take a Topology Query as a parameter. An external tool can be used to allow you to easily [work with queries in YAML format and add these to a monitor file in STJ format](#add-scripts-and-queries-in-stj).

{% tabs %}
{% tab title="Monitor STJ definition" %}
To supply a value to the `topologyQuery` parameter defined in the monitor function, the monitor STJ definition would look something like the following:

```json
...
{
  "_type": "ArgumentStringVal",
  "parameter": {{ get "<identifier-of-the-function>" "Type=Parameter;Name=topologyQuery" }},
  "value": "type = 'database' OR type = 'database-shard'"
}
...
```
{% endtab %}
{% tab title="Monitor function STJ definition" %}
The declaration of a topology query in a monitor function STJ definition can look something like the following:
```json
...
"parameters": [{
  "_type": "Parameter",
  "type": "STRING",
  "name": "topologyQuery",
  "required": true,
  "multiple": false
  },
  ...
]
...
```
{% endtab %}
{% endtabs %}

#### Telemetry query
Monitor functions that utilize telemetry tend to be parameterized with the exact telemetry query to use for their computation. The telemetry query should be built using the StackState Telemetry Script API. The following fields are particularly useful in telemetry queries that are passed to monitor functions:

* `groupBy(fields)` - when a monitor will produce a health state for multiple components, use the `groupBy` field to produce multiple time series as a set of unique values for the defined `fields`.
* `aggregation(type, interval)` - aggregates each time series by the defined `type`. Each aggregated value is constructed out of a data span the size of the defined `interval`.

➡️ [Learn more about the Telemetry script API](/develop/reference/scripting/script-apis/telemetry.md "StackState Self-Hosted only")

{% tabs %}
{% tab title="Monitor STJ definition" %}
To supply a value to the `telemetryQuery` parameter defined in the monitor function, the monitor STJ definition would look something like the following. Note that the provided `value` must utilize the StackState Telemetry Script API and evaluate to a telemetry query, otherwise it will not pass the argument validation that is performed before the function execution begins. 

```json
...
{
  "_type": "ArgumentScriptMetricQueryVal",
  "parameter": {{ get "<identifier-of-the-function>" "Type=Parameter;Name=telemetryQuery" }},
  "value": "Telemetry.query('StackState Metrics', '').metricField('system.cpu.iowait').groupBy('tags.host').start('-10m').aggregation('mean', '1m')"
}
...
```
{% endtab %}
{% tab title="Monitor function STJ definition" %}
The declaration of a telemetry query can either expect a string value of a metric name, or a full-fledged Telemetry Query:
```json
...
"parameters": [{
  "_type": "Parameter",
  "type": "SCRIPT_METRIC_QUERY",
  "name": "telemetryQuery",
  "required": true,
  "multiple": false
},
  ...
]
...
```
{% endtab %}
{% endtabs %}

#### Topology identifier pattern
Monitor functions that don't process any topology directly still have to produce results that attach to topology elements by way of matching the topology identifier that can be found on those elements. In those cases, one can expect a function declaration to include a special parameter that represents the pattern of a topology identifier.

{% tabs %}
{% tab title="Monitor STJ definition" %}
The `topologyIdentifierPattern` value supplied to the monitor function should result in a valid topology identifier once processed by the function logic. It therefore likely needs to include various escape sequences of values that will be interpolated into the resulting value by the monitor function:

```json
...
{
  "_type": "ArgumentStringVal",
  "parameter": {{ get "<identifier-of-the-function>" "Type=Parameter;Name=topologyIdentifierPattern" }},
  "value": "urn:host:/${tags.host}"
}
...
```

The exact `value` to use for this parameter depends on the topology available in StackState (or more precisely on its identifier scheme), and on the values supplied by the monitor function for interpolation (or more precisely the type of data processed by the function). In the most common case, a topology identifier pattern parameter is used in conjunction with a [telemetry query parameter](#telemetry-query) - in this case, the fields used for the telemetry query grouping (listed in its `.groupBy()` step) will also be available for the interpolation of topology identifier values. For example, consider the following query:

```groovy
Telemetry
  .query('StackState Metrics', '')
  .metricField('system.cpu.iowait')
  .groupBy('host', 'region')
  .start('-10m')
  .aggregation('mean', '1m')
```

The telemetry query above groups its results by two fields: `host` and `region`. Both of these values will be available for value interpolation of an exact topology identifier to use, and each different `host` and `region` pair can be used either individually or together to form a unique topology identifier.
If the common topology identifier scheme utilized by the topology looks as follows, then the different parts of the identifier can be replaced by references to `host` or `region`:

```groovy
# Example identifier as found on a topology element:
'urn:host:/eu-west-1/i-244e275aef2a83dd'

# Topology identifier pattern that matches the above example identifier:
'urn:host:/${region}/${host}'
```
{% endtab %}
{% tab title="Monitor function STJ definition" %}
The declaration of a topology identifier pattern would look something like the following:
```json
...
"parameters": [{
  "_type": "Parameter",
  "type": "STRING",
  "name": "topologyIdentifierPattern",
  "required": true,
  "multiple": false
  },
  ...
]
...
```
{% endtab %}
{% endtabs %}

### status

A monitor with an `ENABLED` status will be automatically executed and its results will be persisted. A `DISABLED` monitor is still available for a `dry-run` in order to inspect its results and execution (helpful for debugging a monitor). When a monitor is initially created it will start with a `DISABLED` status, unless the `status` field is present in the payload. When a monitor is updated, it will keep its own `status`, unless the `status` is specified. If the `status` field is included in the payload, the monitor will assume the specified `status`.

{% hint style="info" %}
When a monitor is disabled, all health states associated with the monitor will be removed, and they will no longer be visible in the StackState UI. Disabling a monitor is quite useful to debug and fix execution errors without having the monitor produce health states or errors. A disabled monitor can still be used to do a `dry-run`.
{% endhint %}

### intervalSeconds

The monitor run interval determines how often a monitor logic will be executed. This is configured in the monitor STJ file as a number of seconds using the `intervalSeconds` field. For example, an `intervalSeconds: 60` configuration means that StackState will attempt to execute the monitor function associated with the monitor every 60 seconds. If the monitor function execution takes significant time, the next scheduled run will occur 60 seconds after the previous run finishes.

## Add scripts and queries in STJ

A monitor STJ file contains the following script and queries:

* [Argument of type `ArgumentScriptMetricQueryVal`](#arguments) - define a telemetry query to be used by the monitor function.
* [The property `script` of type `ScriptFunctionBody`](/develop/developer-guides/custom-functions/monitor-functions.md#monitor-function-definition) - defines a groovy script that is run by the monitor function.

It can be challenging to add scripts and queries to the STJ format. An external tool, such as [yq \(github.com\)](https://github.com/mikefarah/yq), can be used to get a more friendly formatting of the script or query to work with and update as required.

For example:

{% tabs %}
{% tab title="Add a query to `ArgumentScriptMetricQueryVal`" %}

Update a query defined in `ArgumentScriptMetricQueryVal` for a monitor using the external tool [yq \(github.com\)](https://github.com/mikefarah/yq) to get a more friendly formatting:
```text
yq -P ./monitor.stj > monitor.yaml
```

Obtains something like the following:

```yaml
_version: 1.0.39
timestamp: 2022-05-23T13:16:27.369269Z[GMT]
nodes:
  - _type: Monitor
    name: CPU Usage
    description: A simple CPU-usage monitor. If the metric is above a given threshold, the state is set to CRITICAL.
    identifier: urn:system:default:monitor:cpu-usage
    remediationHint: Turn it off and on again.
    function:? get "urn:system:default:monitor-function:metric-above-threshold"::
    arguments:
      - _type: ArgumentDoubleVal
        parameter:? get "urn:system:default:monitor-function:metric-above-threshold" "Type=Parameter;Name=threshold"::
        value: 90.0
      - _type: ArgumentStringVal
        parameter:? get "urn:system:default:monitor-function:metric-above-threshold" "Type=Parameter;Name=topologyIdentifierPattern"::
        value: urn:host:/${tags.host}
      - _type: ArgumentScriptMetricQueryVal
        parameter:? get "urn:system:default:monitor-function:metric-above-threshold" "Type=Parameter;Name=metrics"::
        script: |-
          Telemetry
          .query("StackState Metrics", "")
          .metricField("system.cpu.system")
          .groupBy("tags.host")
          .start("-1m")
          .aggregation("mean", "15s")
    intervalSeconds: 60
```

Here the `ArgumentScriptMetricQueryVal` script (query) is readable and more easily editable in a YAML representation of the monitor. 

After the `script`, or any other field, has been edited in the YAML representation, you can go back to the STJ representation using:

```text
yq -o=json '.' monitor.yaml
```


{% endtab %}
{% tab title="Add a script to `ScriptFunctionBody`" %}

To update the monitor function example shown on the page [monitor functions](/develop/developer-guides/custom-functions/monitor-functions.md#upload-to-stackstate), we could use the external tool [yq \(github.com\)](https://github.com/mikefarah/yq) to get a more friendly formatting:

```text
yq -P ./monitorFunction.stj > monitorFunction.yaml
```

This will obtain:

```yaml
_version: 1.0.39
timestamp: 2022-06-23T23:23:23.269369Z[GMT]
nodes:
  - _type: MonitorFunction
    name: Metric above threshold
    description: Validates that a metric value stays below a given threshold, reports a CRITICAL state otherwise.
    parameters:
      - _type: Parameter
        name: threshold
        type: DOUBLE
        required: true
        multiple: false
      - _type: Parameter
        name: topologyIdentifierPattern
        type: STRING
        required: true
        multiple: false
      - _type: Parameter
        name: metrics
        type: SCRIPT_METRIC_QUERY
        required: true
        multiple: false
    identifier: urn:system:default:monitor-function:metric-above-threshold
    script:
      _type: ScriptFunctionBody
      scriptBody: |-
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
            topologyIdentifier: StringTemplate.runForTimeSeriesId(topologyIdentifierPattern, result.timeSeries.id)
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

The script is now readable and easier to edit. After editing the `script`, or any other field, of our monitor function in the YAML representation, we could go back to the STJ representation using:

```text
yq -o=json '.' monitorFunction.yaml
```

This can then be added back to the property `script` of type `ScriptFunctionBody`.

{% endtab %}
{% endtabs %}


## See also

* [Create a custom monitor](create-custom-monitors.md)
* [Monitor functions](/develop/developer-guides/custom-functions/monitor-functions.md "StackState Self-Hosted only")
* [Manage monitors](/use/checks-and-monitors/manage-monitors.md)
* [STJ reference](/develop/reference/stj/using_stj.md)