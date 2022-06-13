---
description: StackState Self-hosted v5.0.x
---

# Add a monitor

## Overview

Monitors process 4T data, such as metrics, events and topology, to produce a health state for elements \(components and relations\). The states are calculated by a specific monitor function selected by the user.

## Monitor format

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

## Monitor functions

Each monitor configured in StackState uses a monitor function to compute the health state results attached to the elements.

Monitor functions are scripts that accept the 4T data as input, check the data based on some internal logic and output health state mappings for the affected topology elements. The function is run periodically by the monitor runner and it is responsible for detecting any changes in the data that can be considered to change an elements health state.

* You can [create a custom monitor function](../../develop/developer-guides/custom-functions/monitor-functions.md) to customize how StackState processes the 4T data.
* Details of the monitor functions provided by StackPacks can be found in [their respective documentation](../../stackpacks/integrations/README.md).

## Add a monitor

Most monitors in StackState are created as part of a StackPack installed by the user. There is, however, the possibility to install custom monitors by using the StackState CLI.

To create a custom monitor in StackState:

1. Select a suitable monitor function or [create a custom one](../../develop/developer-guides/custom-functions/check-functions.md).
  * You can list the available monitor functions via the CLI command `sts settings list --type MonitorFunction`
2. Create a new [STJ](../../develop/reference/stj/using_stj.md) import file and populate it acording to the specification above.
  * You can place multiple monitors on the same STJ file. You can also add other node types on the same import file.
3. Populate the at least the `name`, `identifier` and `intervalSeconds` parameters of the monitor definition.
  * The `identifier` should be a value that uniquely identifies this specific monitor definition.
4. Populate the `function` value using the previously selected function.
  * Configuring the monitor function is best done by utilizing the [`get` helper function](../../develop/reference/stj/stj_reference.md#\`get\`).
5. Populate the parameters of the monitor function invocation.
  * The parameters are different for each function. More details on the functions provided by StackPacks is available in their respective documentation.
4. Apply the newly created monitor in StackState using the CLI commands: `sts monitor apply < path/to/the/file.stj`.
  * An alternative way is to include the newly created monitor in a custom StackPack and installing it.
5. Verify that your newly created monitor is working correctly.
  * You can check if your monitor is working correctly by invoking the `sts monitor status` command.
  * You can also preview the results it generates by invoking the `sts monitor preview` command.

For a more thorough description of each of the above steps please follow the [step by step guide](../../develop/developer-guides/monitors/how-to-create-moniors.md).

## See also
* [StackState CLI](../../develop/reference/cli_reference.md)
* [StackState Template JSON \(STJ\)](../../develop/reference/stj/README.md)
* [Develop your own StackPacks](../../stackpacks/sdk.md)
* [Integrations](../../stackpacks/integrations/README.md)
