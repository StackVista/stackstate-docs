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

* You can [create a custom monitor function](../../develop/developer-guides/custom-functions/check-functions.md) to customize how StackState assigns a health state to a metric stream.
* Details of the available check functions can be found in the StackState UI, go to **Settings** &gt; **Check functions**.
