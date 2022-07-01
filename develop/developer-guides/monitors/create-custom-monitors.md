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

{% tabs %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: sts (new)" %}[](http://not.a.link "StackState Self-Hosted only")
```
sts monitor apply -f path/to/the/file.stj
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: stac" %}[](http://not.a.link "StackState Self-Hosted only")
`stac monitor apply < path/to/the/file.stj`[](http://not.a.link "StackState Self-Hosted only")

**Not running the `stac` CLI yet?**[](http://not.a.link "StackState Self-Hosted only")

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}[](http://not.a.link "StackState Self-Hosted only")

An alternative way is to include the newly created monitor in a custom StackPack and installing it.

## Verify that your newly created monitor is working correctly

You can check if your monitor is working correctly by invoking the CLI command:

{% tabs %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: sts (new)" %}[](http://not.a.link "StackState Self-Hosted only")
```
# By ID
sts monitor status --id <id-of-a-monitor>
# By Identifier
sts monitor status --identifier <identifier-of-a-monitor>
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: stac" %}[](http://not.a.link "StackState Self-Hosted only")
`stac monitor status <id-or-identifier-of-a-monitor>`[](http://not.a.link "StackState Self-Hosted only")

**Not running the `stac` CLI yet?**[](http://not.a.link "StackState Self-Hosted only")

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}[](http://not.a.link "StackState Self-Hosted only")

You can also preview the results it generates by invoking the CLI command:

{% tabs %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: sts (new)" %}[](http://not.a.link "StackState Self-Hosted only")
```
# By ID
sts monitor run --id <id-of-a-monitor>
# By Identifier
sts monitor run --identifier <identifier-of-a-monitor>
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: stac" %}[](http://not.a.link "StackState Self-Hosted only")
`stac monitor preview <id-or-identifier-of-a-monitor>`[](http://not.a.link "StackState Self-Hosted only")

**Not running the `stac` CLI yet?**[](http://not.a.link "StackState Self-Hosted only")

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}[](http://not.a.link "StackState Self-Hosted only")

## See also

* [Custom monitor functions](/develop/developer-guides/custom-functions/monitor-functions.md "StackState Self-Hosted only")
* [StackState CLI](/setup/cli/README.md)
* [StackState Template JSON \(STJ\)](/develop/reference/stj/README.md)
* [Develop your own StackPacks](/stackpacks/sdk.md "StackState Self-Hosted only")
* [Integrations](/stackpacks/integrations/README.md)
