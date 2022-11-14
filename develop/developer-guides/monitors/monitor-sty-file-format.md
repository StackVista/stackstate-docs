---
description: StackState Self-hosted v5.1.x
---

# Monitor STY file format

## Overview

Monitors can be attached to any number of elements in the StackState topology to calculate a health state based on 4T data. Each monitor consists of a monitor definition and a monitor function. Monitors are created and managed by StackPacks, you can also create custom monitors and monitor functions outside of a StackPack without having to modify any configuration.

## STY file format

Monitors in StackState are represented textually using the [STY file format](/develop/reference/st/using_st.md). The following snippet presents an example monitor file:

```yaml
_version: "1.0.39",
timestamp: "2022-05-23T13:16:27.369269Z[GMT]"
nodes: 
  - _type: "Monitor"
    name: "CPU Usage"
    description: "A simple CPU-usage monitor. If the metric is above a given threshold, the state is set to CRITICAL."
    identifier: "urn:system:default:monitor:cpu-usage"
    remediationHint: "Turn it off and on again."
    function: {{ get "urn:system:default:monitor-function:metric-above-threshold" }}
    arguments": 
      threshold: 90.0
      topologyMapping: "urn:host:/${tags.host}"
      metrics": "Telemetry\n.query('StackState Metrics', '')\n.metricField('system.cpu.system')\n.groupBy('tags.host')\n.start('-1m')\n.aggregation('mean', '15s')"
      status: "ENABLED"
      tags:
        - "demo"
      intervalSeconds: 60
```

In addition to the usual elements of an STY file, the protocol version and timestamp, the snippet defines a single node of type `Monitor`.

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
{% tab title="CLI: sts" %}[](http://not.a.link "StackState Self-Hosted only")
```
sts settings list --type MonitorFunction
```

From StackState v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.[](http://not.a.link "StackState Self-Hosted only")

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: stac (deprecated)" %}[](http://not.a.link "StackState Self-Hosted only")
`stac graph list MonitorFunction`[](http://not.a.link "StackState Self-Hosted only")

⚠️ **From StackState v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.** [](http://not.a.link "StackState Self-Hosted only")

The new `sts` CLI replaces the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:[](http://not.a.link "StackState Self-Hosted only")

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}[](http://not.a.link "StackState Self-Hosted only")

{% hint style="success" "self-hosted info" %}

You can [create custom monitor function](../custom-functions/monitor-functions.md) to customize how StackState processes 4T data.

{% endhint %}

### arguments

The arguments defined in the monitor STY definition should match the parameters defined in the monitor function STY definition.

The parameter binding syntax is common for all parameter types, and utilizes the following format:

```yaml
arguments:
  <parameter-name>: <argument-value>
}
```

* **parameter-name** - The name of a parameter within a function's parameter list.
* **value** - The value of the argument to pass to the monitor function.

During an invocation of a monitor function, the argument value is interpreted and instantiated beforehand with all of the requisite validations applied to it. Assuming it passes type and value validations, it will become available in the body of the function as a global value of the same name, with the assigned value.

{% hint style="info" %}
* Parameters marked as `required` in the monitor function STY definition must be supplied at least once. If a parameter is not `required`, then it can be optionally omitted.
* Parameters marked as `multiple` in the monitor function STY definition can be supplied more than once, meaning that they represent a set of values.
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
{% tab title="Monitor STY definition" %}
To supply a value to the `value` parameter defined in the monitor function, the monitor STY definition would look something like the following:

```yaml
...
arguments:
  criticalFrom: 23.5
...
```
{% endtab %}

{% tab title="Monitor function STY definition" %}
The declaration of a numeric value in a monitor function STY definition can look something like the following:
```yaml
...
parameters:
  - _type: "Parameter"
    type: "DOUBLE"
    name: "criticalFrom"
    required: true
    multiple: false
  ...
...
```
{% endtab %}
{% endtabs %}

#### Topology Query

Monitor functions that utilize Topology often times take a Topology Query as a parameter. An external tool can be used to allow you to easily [work with queries in YAML format and add these to a monitor file in STY format](#add-scripts-and-queries-to-sty).

{% tabs %}
{% tab title="Monitor STY definition" %}
To supply a value to the `topologyQuery` parameter defined in the monitor function, the monitor STY definition would look something like the following:

```yaml
...
arguments:
  topologyQuery: "{{ get "<identifier-of-the-function>" "Type=Parameter;Name=topologyQuery" }}"
...
```
{% endtab %}
{% tab title="Monitor function STY definition" %}
The declaration of a topology query in a monitor function STY definition can look something like the following:
```json
...
parameters: [{
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
{% tab title="Monitor STY definition" %}
To supply a value to the `telemetryQuery` parameter defined in the monitor function, the monitor STY definition would look something like the following. Note that the provided `value` must utilize the StackState Telemetry Script API and evaluate to a telemetry query, otherwise it will not pass the argument validation that is performed before the function execution begins.

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
{% tab title="Monitor function STY definition" %}
The declaration of a telemetry query can either expect a string value of a metric name, or a full-fledged Telemetry Query:
```yaml
...
parameters:
  - _type: "Parameter"
    type: "SCRIPT_METRIC_QUERY"
    name: "telemetryQuery"
    required: true
    multiple: false
  ...
...
```
{% endtab %}
{% endtabs %}

#### Topology identifier pattern
Monitor functions that don't process any topology directly still have to produce results that attach to topology elements by way of matching the topology identifier that can be found on those elements. In those cases, one can expect a function declaration to include a special parameter that represents the pattern of a topology identifier.

{% tabs %}
{% tab title="Monitor STY definition" %}
The `topologyIdentifierPattern` value supplied to the monitor function should result in a valid topology identifier once processed by the function logic. It therefore likely needs to include various escape sequences of values that will be interpolated into the resulting value by the monitor function:

```yaml
...
arguments:
  topologyIdentifierPattern: "urn:host:/${tags.host}"
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
{% tab title="Monitor function STY definition" %}
The declaration of a topology identifier pattern would look something like the following:
```yaml
...
parameters:
  - _type: "Parameter"
    type: "STRING"
    name: "topologyIdentifierPattern"
    required: true
    multiple: false
  ...
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

The monitor run interval determines how often a monitor logic will be executed. This is configured in the monitor STY file as a number of seconds using the `intervalSeconds` field. For example, an `intervalSeconds: 60` configuration means that StackState will attempt to execute the monitor function associated with the monitor every 60 seconds. If the monitor function execution takes significant time, the next scheduled run will occur 60 seconds after the previous run finishes.

## Add scripts and queries to STY

A monitor STY file and an STY monitor function definition contain the following script and queries:

* [Parameters of type `SCRIPT_METRIC_QUERY`](#arguments) in the monitor STY file define a telemetry query to be used by the monitor function.
* The property `script` of type `ScriptFunctionBody` in the monitor function definition provides a groovy script that is run by the monitor function.

For details of the `script` property, see the page [monitor functions](/develop/developer-guides/custom-functions/monitor-functions.md#monitor-function-definition "StackState Self-Hosted only").

## See also

* [Create a custom monitor](create-custom-monitors.md)
* [Monitor functions](/develop/developer-guides/custom-functions/monitor-functions.md "StackState Self-Hosted only")
* [Manage monitors](/use/checks-and-monitors/manage-monitors.md)
* [Using STY](/develop/reference/st/using_st.md)
  [STY Reference](/develop/reference/st/st_reference.md)