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

- [Monitors](#monitors)
  - [Overview](#overview)
  - [Example - CPU metric monitor](#example---cpu-metric-monitor)
    - [Create a new STY import file](#create-a-new-sty-import-file)
    - [Populate the monitor node](#populate-the-monitor-node)
    - [Populate the parameters of the monitor function invocation](#populate-the-parameters-of-the-monitor-function-invocation)
    - [Apply the newly created monitor in StackState](#apply-the-newly-created-monitor-in-stackstate)
    - [Verify that your newly created monitor is working correctly](#verify-that-your-newly-created-monitor-is-working-correctly)
  - [See also](#see-also)

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

A node of type `Monitor` needs to be added to the STY import file. This type of node is supported in API version 1.0.39 and above. In the example below, the invocation of the [`get` helper function](/develop/reference/stackstate-templating/template_functions.md#get) will automatically resolve to the ID of the desired monitor function during import time.

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

* **name** - A name to identify the monitor.
* **description** -  A description of the monitor.
* **identifier** - A value that uniquely identifies this specific monitor definition.
* **remediationHint** - Optional. A Markdown-encoded instruction of what to do if this monitor produces an unhealthy health state. It is displayed on the interface together with the monitor result panel.
* **function** - The [monitor function](/develop/developer-guides/custom-functions/monitor-functions.md) that the monitor should run. This is best configured using the [`get` helper function](/develop/reference/stackstate-templating/template_functions.md#get) and the `identifier` of the monitor function itself. In this example, the function has the identifier `urn:system:default:monitor-function:metric-above-threshold`.
* **arguments** - Values for any [`arguments`](/develop/developer-guides/monitors/monitor-sty-file-format.md#arguments) required by the monitor function.
* **intervalSeconds** - How often the monitor will run.

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
          .promql("avg by (tags.host) (system.cpu.system)")
          .start("-1m")
          .step("15s")
    intervalSeconds: 60
```

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

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:[](http://not.a.link "StackState Self-Hosted only")

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

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:[](http://not.a.link "StackState Self-Hosted only")

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

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:[](http://not.a.link "StackState Self-Hosted only")

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}

## See also

* [Monitor functions](/develop/developer-guides/custom-functions/monitor-functions.md "StackState Self-Hosted only")
* [StackState `sts` CLI](/setup/cli/cli-sts.md)
* [StackState templating \(STY\)](/develop/reference/stackstate-templating/README.md)
* [Develop your own StackPacks](/stackpacks/sdk.md "StackState Self-Hosted only")
* [Integrations](/stackpacks/integrations/README.md)
