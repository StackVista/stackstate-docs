---
description: StackState Self-hosted v5.0.x
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
        "script": "Telemetry\n.query(\"StackState Metrics\", \"\")\n.metricField(\"system.cpu.system\")\n.groupBy(\"tags.host\")\n.start(\"-1m\")\n.aggregation(\"mean\", \"15s\")"
      }],
      "intervalSeconds": 60
    }
  ]
}
```

In addition to the usual elements of an STJ file, the protocol version and timestamp, the snippet defines a single node of type `Monitor`. 

The supported fields are:

- **name** - a human-readable name that shortly describes the operating principle of the monitor.
- **description** - a longer, more in-depth description of the monitor.
- **identifier** - a StackState-URN-formatted value that uniquely identifies this monitor definition. For more details, see [identifier](#identifier).
- **remediationHint** - a short, markdown-enabled hint displayed whenever the validation rule represented by this monitor triggers and results in an unhealthy state.
- **function** - the specific monitor function to use as the basis of computation for this monitor. For more details. see [monitor function](#monitor-function).
- **arguments** - lists concrete values that are to be used as arguments to the monitor function invocation.
- **intervalSeconds** - dictates how often to execute this particular monitor; new executions are scheduled after the specified number of seconds, counting from the time that the last execution ended. For more details, see [run interval](#run-interval).

## Field information

### Identifier

An important field of the monitor node is the `identifier` - it is a unique value of the StackState URN format that can be used together with the monitor-specific StackState CLI commands. The identifier should be formatted as follows:

`urn : <prefix> : monitor : <unique-monitor-identification>`

* The `<prefix>` is described in more detail in [topology identifiers](../../../configure/topology/identifiers.md).
* The `<unique-monitor-identification>` is user-definable and free-form.

### Monitor function

Each monitor configured in StackState uses a monitor function to compute the health state results that are attached to the elements.

Monitor functions are scripts that accept 4T data as input, check the data based on some internal logic and output health state mappings for the affected topology elements. The function is run periodically by the monitor runner (at the configured `intervalSeconds`). The monitor function is responsible for detecting any changes in the data that can be considered to change an element's health state.

You can list the available monitor functions using the CLI command:

{% tabs %}
{% tab title="CLI: sts (new)" %}
```
sts settings list --type MonitorFunction
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endtab %}
{% tab title="CLI: stac" %}
```
stac graph list MonitorFunction
```

**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
{% endtab %}
{% endtabs %}

{% hint style="success" "self-hosted info" %}

You can [screate custom monitor function](../custom-functions/monitor-functions.md) to customize how StackState processes 4T data.

{% endhint %}

### Run interval

The monitor run interval determines how often a monitor logic will be executed. This is configured in the monitor STJ file as a number of seconds using the `intervalSeconds` field. For example, an `intervalSeconds: 60` configuration means that StackState will attempt to execute the monitor function associated with the monitor every 60 seconds. If the monitor function execution takes significant time, the next scheduled run will occur 60 seconds after the previous run finishes.

## See also

* [Create a custom monitor](create-custom-monitors.md)
* [Monitor functions](/develop/developer-guides/custom-functions/monitor-functions.md)
* [Manage monitors](/use/checks-and-monitors/manage-monitors.md)
* [STJ file format](/develop/reference/stj/using_stj.md)