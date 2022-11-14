---
description: StackState Self-hosted v5.1.x
---

# Monitors

## Overview

Monitors can be attached to any number of elements in the StackState topology to calculate a health state based on 4T data. Each monitor consists of a monitor definition and a monitor function. Monitors are created and managed by StackPacks, you can also create custom monitors and monitor functions outside of a StackPack without having to modify any configuration.

The example on this page creates a CPU metric monitor using an example monitor function.

➡️ [Learn more about the STY file format used for monitor definitions](monitor-sty-file-format.md)

## Example - CPU metric monitor

To create the example CPU metric custom monitor in StackState we will:

1. [Create a new STY import file.](#create-a-new-sty-import-file)
2. [Populate the monitor node.](#populate-the-monitor-node)
3. [Populate the parameters of the monitor function invocation.](#populate-the-parameters-of-the-monitor-function-invocation)
4. [Apply the newly created monitor in StackState.](#apply-the-newly-created-monitor-in-stackstate)
5. [Verify that your newly created monitor is working correctly.](#verify-that-your-newly-created-monitor-is-working-correctly)

### Create a new STY import file

```yaml
_version: "1.0.39"
timestamp: "2022-05-23T13:16:27.369269Z[GMT]"
nodes:
  -
  ...
```

You can place multiple monitors on the same STY file. You can also add other node types on the same import file.

➡️ [Learn more about the STY file format used for monitor definitions](monitor-sty-file-format.md)

### Populate the monitor node

A monitor node of type `Monitor` needs to be added to the import file. This type of node is supported in API version 1.0.39 and above. The required fields are the `name`, `identifier` and `description`. The `identifier` should be a value that uniquely identifies this specific monitor definition. `intervalSeconds`, `function` and [`arguments`](/develop/developer-guides/monitors/monitor-sty-file-format.md#arguments) determine what validation rule and how often it is run. An optional parameter of `remediationHint` can be specified - it is a Markdown-encoded instruction of what to do if this monitor produces an unhealthy health state. It is displayed on the interface together with the monitor result panel.

Configuring the monitor function is best done by utilizing the [`get` helper function](/develop/reference/st/st_reference.md#get) paired with the `identifier` of the function itself. In this example the function is named `Metric above threshold` and its identifier is `urn:system:default:monitor-function:metric-above-threshold`.

```yaml
_version: "1.0.39"
timestamp: "2022-05-23T13:16:27.369269Z[GMT]"
nodes:
  - _type: "Monitor"
    name": "CPU Usage"
    description: "A simple CPU-usage monitor. If the metric is above a given threshold, the state is set to CRITICAL."
    identifier: "urn:system:default:monitor:cpu-usage"
    remediationHint: "Turn it off and on again."
    function: {{ get "urn:system:default:monitor-function:metric-above-threshold" }}
    arguments:
      ...
    intervalSeconds: 60
```

The invocation of the `get` helper function will automatically resolve to the ID of the desired function during import time.

➡️ [Learn more about the STY file format used for monitor definitions](monitor-sty-file-format.md)

### Populate the parameters of the monitor function invocation

The parameters are different for each monitor function. In the case of `Metric above threshold` we need to populate `threshold`, `metrics` and `topologyIdentifierPattern`:

```yaml
_version: 1.0.39
timestamp: 2022-05-23T13:16:27.369269Z[GMT]
nodes:
  - _type: Monitor
    name: CPU Usage
    description: A simple CPU-usage monitor. If the metric is above a given threshold, the state is set to CRITICAL.
    identifier: urn:system:default:monitor:cpu-usage
    remediationHint: Turn it off and on again.
    function: {{ get "urn:system:default:monitor-function:metric-above-threshold" }}
    arguments:
      threshold: 90.0
      topolopgyIdentifierPattern: "urn:host:/${tags.host}"
      metrics: |-
          Telemetry
          .query("StackState Metrics", "")
          .metricField("system.cpu.system")
          .groupBy("tags.host")
          .start("-1m")
          .aggregation("mean", "15s")
    intervalSeconds: 60
```

Similar to the `function`, parameters can be referred to by utilizing the `get` helper function.

For further details of defining arguments in the monitor definition and how to work with commonly used parameters such as a metrics query or topology identifier, see [monitor sty file format > Arguments](/develop/developer-guides/monitors/monitor-sty-file-format.md#arguments).

### Apply the newly created monitor in StackState

This can be achieved by using the dedicated StackState CLI command:

{% tabs %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: sts" %}[](http://not.a.link "StackState Self-Hosted only")
```
sts monitor apply -f path/to/the/file.sty
```

From StackState v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: stac (deprecated)" %}[](http://not.a.link "StackState Self-Hosted only")
`stac monitor apply < path/to/the/file.sty`[](http://not.a.link "StackState Self-Hosted only")

⚠️ **From StackState v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:[](http://not.a.link "StackState Self-Hosted only")

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}[](http://not.a.link "StackState Self-Hosted only")

An alternative way is to include the newly created monitor in a custom StackPack and installing it.

### Verify that your newly created monitor is working correctly

You can check if your monitor is working correctly by invoking the CLI command:

{% tabs %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: sts" %}[](http://not.a.link "StackState Self-Hosted only")
```
# By ID
sts monitor status --id <id-of-a-monitor>
# By Identifier
sts monitor status --identifier <identifier-of-a-monitor>
```

From StackState v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: stac (deprecated)" %}[](http://not.a.link "StackState Self-Hosted only")
`stac monitor status <id-or-identifier-of-a-monitor>`[](http://not.a.link "StackState Self-Hosted only")


⚠️ **From StackState v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:[](http://not.a.link "StackState Self-Hosted only")

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}[](http://not.a.link "StackState Self-Hosted only")

You can also preview the results it generates by invoking the CLI command:

{% tabs %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: sts" %}[](http://not.a.link "StackState Self-Hosted only")
```
# By ID
sts monitor run --id <id-of-a-monitor>
# By Identifier
sts monitor run --identifier <identifier-of-a-monitor>
```

From StackState v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: stac (deprecated)" %}[](http://not.a.link "StackState Self-Hosted only")
`stac monitor preview <id-or-identifier-of-a-monitor>`[](http://not.a.link "StackState Self-Hosted only")


⚠️ **From StackState v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:[](http://not.a.link "StackState Self-Hosted only")

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}

## See also

* [Custom monitor functions](/develop/developer-guides/custom-functions/monitor-functions.md "StackState Self-Hosted only")
* [StackState `sts` CLI](/setup/cli/cli-sts.md)
* [StackState Template JSON \(STY\)](/develop/reference/st/README.md)
* [Develop your own StackPacks](/stackpacks/sdk.md "StackState Self-Hosted only")
* [Integrations](/stackpacks/integrations/README.md)
