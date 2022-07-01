---
description: StackState Self-hosted v5.0.x
---

# Monitors

## Overview

Monitors can be attached to any number of elements in the StackState topology to calculate a health state based on 4T data. Each monitor consists of a monitor definition and a monitor function. Monitors are created and managed by StackPacks, you can also create custom monitors and monitor functions outside of a StackPack without having to modify any configuration.

The following example creates a CPU metric monitor using an example monitor function. 

To create a custom monitor in StackState:

1. [Create a new STJ import file.](#create-a-new-stj-import-file)
2. [Populate the monitor node.](#populate-the-monitor-node)
3. [Populate the parameters of the monitor function invocation.](#populate-the-parameters-of-the-monitor-function-invocation)
4. [Apply the newly created monitor in StackState.](#apply-the-newly-created-monitor-in-stackstate)
5. [Verify that your newly created monitor is working correctly.](#verify-that-your-newly-created-monitor-is-working-correctly)

## Create a new STJ import file

```json
{
  "_version": "1.0.39",
  "timestamp": "2022-05-23T13:16:27.369269Z[GMT]",
  "nodes": [
    ...
  ]
}
```

You can place multiple monitors on the same STJ file. You can also add other node types on the same import file.

## Populate the monitor node

A monitor node of type `Monitor` needs to be added to the import file. This type of node is supported in API version 1.0.39 and above. The required fields are the `name`, `identifier` and `description`. The `identifier` should be a value that uniquely identifies this specific monitor definition. `intervalSeconds`, `function` and `arguments` determine what validation rule and how often it is run. An optional parameter of `remediationHint` can be specified - it is a Markdown-encoded instruction of what to do if this monitor produces an unhealthy health state. It is displayed on the interface together with the monitor result panel.

Configuring the monitor function is best done by utilizing the [`get` helper function](/develop/reference/stj/stj_reference.md#get) paired with the `identifier` of the function itself. In this example the function is named `Metric above threshold` and its identifier is `urn:system:default:monitor-function:metric-above-threshold`.

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
      "arguments": [
        ...
      ],
      "intervalSeconds": 60
    }
  ]
}
```

The invocation of the `get` helper function will automatically resolve to the ID of the desired function during import time.

### Common parameters

Parameter binding syntax is common for all parameter types, and utilizes the following format:

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

The parameters defined in the monitor STJ definition should match those defined in the monitor function STJ definition. Descriptions of parameters that are commonly used my monitor functions can be found below:

* [Numeric values](#numeric-values) - a simple numeric value.
* [Topology query](#topology-query) - a query to return a subset of the topology.
* [Telemetry query](#telemetry-query) - a query that collects the telemetry to be passed to the monitor function.
* [Topology identifier pattern](#topology-identifier-pattern) - the pattern of the topology element identifiers to which the monitor function should assign the calculated health states.

### Numeric values
The most common and simple monitor function parameter types are numeric values. They are declared the following way with a function definition:

```json
{
  "_type": "Parameter",
  "type": "DOUBLE",
  "name": "value",
  "required": true,
  "multiple": false
}
```

Once declared this way, they can be supplied by:

```json
{
  "_type": "ArgumentDoubleVal",
  "parameter": {{ get "<identifier-of-the-function>" "Type=Parameter;Name=value" }},
  "value": 23.5
}
```

Parameters marked as `multiple` can be supplied more than once, meaning they represent a set of values. Parameters marked as `required` have to be supplied at least once. If a parameter is not `required`, then it can be optionally omitted.

### Topology Query
Monitor functions that utilize Topology often take a Topology Query as a parameter. The declaration can look something like the following:

```json
{
  "_type": "Parameter",
  "type": "STRING",
  "name": "topologyQuery",
  "required": true,
  "multiple": false
}
```

To supply a value of a topology query to a Monitor function when defining a Monitor:

```json
{
  "_type": "ArgumentStringVal",
  "parameter": {{ get "<identifier-of-the-function>" "Type=Parameter;Name=topologyQuery" }},
  "value": "type = 'database' OR type = 'database-shard'"
}
```

### Telemetry Query
Monitor functions that utilize Telemetry tend to be parameterized with the exact telemetry query to use for their computation. The declaration can either expect a string value of a metric name, or a full-fledged Telemetry Query:

```json
{
  "_type": "Parameter",
  "type": "SCRIPT_METRIC_QUERY",
  "name": "telemetryQuery",
  "required": true,
  "multiple": false
}
```

To supply a value of the Telemetry Query one must utilize the Telemetry Script API available in StackState:

```json
{
  "_type": "ArgumentScriptMetricQueryVal",
  "parameter": {{ get "<identifier-of-the-function>" "Type=Parameter;Name=telemetryQuery" }},
  "value": "Telemetry.query('StackState Metrics', '').metricField('system.cpu.iowait').groupBy('tags.host').start('-10m').aggregation('mean', '1m')"
}
```

The query value must evaluate to a telemetry query, otherwise it won't pass the argument validation that is performed before the function execution begins.

### Topology Identifier Pattern
Monitor functions that don't process any topology directly still have to produce results that attach to topology elements by way of matching the topology identifier that can be found on those elements. In those cases, one can expect a function declaration to include a special parameter that represents the pattern of a topology identifier:

```json
{
  "_type": "Parameter",
  "type": "STRING",
  "name": "topologyIdentifierPattern",
  "required": true,
  "multiple": false
}
```

The value supplied to that function once processed by the function logic should result in a valid topology identifier to be produced. It therefore likely needs to include various escape sequences of values that will be interpolated into the resulting value by the Monitor function:

```json
{
  "_type": "ArgumentStringVal",
  "parameter": {{ get "<identifier-of-the-function>" "Type=Parameter;Name=topologyIdentifierPattern" }},
  "value": "urn:host:/${tags.host}"
}
```

The exact value to use for this parameter depends on the topology avaliable in StackState (or more precisely on its identifier scheme), and on the values supplied by the Monitor function for interpolation (or more precisely the type of data processed by the function). In the most common case, a topology identifier pattern parameter is used in conjunction with a Telemetry query parameter - then the fields used for the query grouping (listed in its `.groupBy()` step) will also be available for the interpolation of topology identifier values. For example, consider the following query:

```groovy
Telemetry
  .query('StackState Metrics', '')
  .metricField('system.cpu.iowait')
  .groupBy('host', 'region')
  .start('-10m')
  .aggregation('mean', '1m')
```

This query groups its results by two fields: `host` and `region`. Both of these values will be available for value interpolation of an exact topology identifier to use and each different `host` and `region` pair can be used either individually or together to form a unique topology identifier.
If the common topology identifier scheme utilized by the topology looks as follows, then the different parts of the identifier can be replaced by references to `host` or `region`:

```groovy
# An example identifier as found on the topology elements:
'urn:host:/eu-west-1/i-244e275aef2a83dd'

# A topology identifier pattern that'll match the example identifier one applied to the above query results:
'urn:host:/${region}/${host}'
```

## Populate the parameters of the monitor function invocation

The parameters are different for each monitor function. In the case of `Metric above threshold` we need to populate `thershold`, `metrics` and `topologyIdentifierPattern`:

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
        "script": "Telemetry\n.query(\"StackState Metrics\", \"\")\n.metricField(\"system.cpu.system\")\n.groupBy(\"tags.host\")\n.start(\"-1m\")\n.aggregation(\"mean\", \"15s\")"
      }],
      "intervalSeconds": 60
    }
  ]
}
```

Similar to the `function`, parameters can be referred to by utilizing the `get` helper function.

## Apply the newly created monitor in StackState

This can be achieved by using the dedicated StackState CLI command:

{% tabs %}
{% tab title="CLI: sts (new)" %}
```
sts monitor apply -f path/to/the/file.stj
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endtab %}
{% tab title="CLI: stac" %}
```
stac monitor apply < path/to/the/file.stj
```

**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
{% endtab %}
{% endtabs %}

An alternative way is to include the newly created monitor in a custom StackPack and installing it.

## Verify that your newly created monitor is working correctly

You can check if your monitor is working correctly by invoking the CLI command:

{% tabs %}
{% tab title="CLI: sts (new)" %}
```
# By ID
sts monitor status --id <id-of-a-monitor>
# By Identifier
sts monitor status --identifier <identifier-of-a-monitor>
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endtab %}
{% tab title="CLI: stac" %}
```
stac monitor status <id-or-identifier-of-a-monitor>
```

**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
{% endtab %}
{% endtabs %}

You can also preview the results it generates by invoking the CLI command:

{% tabs %}
{% tab title="CLI: sts (new)" %}
```
sts monitor preview <id-or-identifier-of-a-monitor>
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endtab %}
{% tab title="CLI: stac" %}
```
stac monitor preview <id-or-identifier-of-a-monitor>
```

**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
{% endtab %}
{% endtabs %}

## See also

* [Custom monitor functions](/develop/developer-guides/custom-functions/monitor-functions.md "StackState Self-Hosted only")
* [StackState CLI](/setup/cli/README.md)
* [StackState Template JSON \(STJ\)](/develop/reference/stj/README.md)
* [Develop your own StackPacks](/stackpacks/sdk.md "StackState Self-Hosted only")
* [Integrations](/stackpacks/integrations/README.md)
