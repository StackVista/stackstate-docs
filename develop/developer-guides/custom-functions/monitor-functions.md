---
description: StackState Self-hosted v5.1.x
---

# Monitor functions

## Overview

Monitor functions are run by [monitors](/use/checks-and-monitors/monitors.md) in StackState. They can process 4T data to trigger a change in health status of a component or relation. A number of monitor functions are shipped together with StackState, or you can write your own monitor function as a groovy script.

## Create a custom monitor function

To add a custom monitor function:

1. In the StackState UI, go to **Settings** >  **Functions** > **Monitor Functions**.
2. Click **ADD MONITOR FUNCTION**.
3. Enter the required settings:
   * **Name** - A name to identify the monitor function.
   * **Description** - Optional. A description of the check function.
   * **User parameters** - These are parameters that must be specified in the monitor definition that runs the monitor function. For more details see the section [parameters](#parameters).
   * **Script** - The groovy script run by the function. Currently, monitors only support scripts of type `ScriptFunctionBody`.
   * **Identifier** - a StackState-URN-formatted value that uniquely identifies the monitor function. The identifier is used by the monitor definition during the invocation of this function.
4. Click **CREATE** to save the monitor function.
   * The monitor function will be listed in the StackState UI page **Settings** >  **Functions** > **Monitor Functions**. It can be exported from here to use in a monitor or add to a template that is included in a custom StackPack.

![Add a custom monitor function](../../../.gitbook/assets/v51_add-monitor-function.png)

## Parameters

Any number of user parameters can be defined in a monitor function. The values of the parameters must be passed to the monitor function by the monitor definition that runs it. Values and properties of the parameters can then be accessed by the monitor function script.

When defining parameters in the monitor function, these can optionally be set as:

- **Required** - parameters that must always be specified by the monitor definition.
- **Multiple** - parameters will be a list of the specified parameter type.

### Parameter types

The following parameter types are available for use in monitor functions:

* All parameter types available for [check functions](/develop/developer-guides/custom-functions/check-functions.md#parameter-types).
* **Telemetry query** - Unique to monitor functions. A telemetry query that supplies telemetry data to the function. For details, see the section [telemetry query](#telemetry-query).

### Telemetry query

A user parameter of type **Telemetry query** can be added to a monitor function. The monitor that invokes the monitor function can then specify a telemetry query expression as a value to the function. The query indicates the specific metric values to fetch, along with the aggregation method and the time window to use.

The telemetry query parameter type will ensure that the provided query is well-formed - in case of any syntactic or type errors, a suitable error will be reported. This will prevent execution of the monitor function with potentially bogus values.

➡️ [Learn how to specify a telemetry query in a monitor definition file](/develop/developer-guides/monitors/monitor-stj-file-format.md#telemetry-query)

### Values

Values for the defined user parameters are passed to the monitor function from the monitor. In the monitor definition that invokes a monitor function, `arguments` must be defined to provide a value for each user parameter in the monitor function.

For example:

A monitor function with one user parameter named `latest_metrics` that is of type **Telemetry query** would require the following to be included in the  `arguments` block of the monitor definition that invokes it. The `value` defines the telemetry query that will be run to provide telemetry to the monitor function:

```json
"arguments": [{
  "_type": "ArgumentScriptMetricQueryVal",
  "parameter": {{ get "<identifier-of-the-function>" "Type=Parameter;Name=latest_metrics" }},
  "value": "Telemetry.query('StackState Metrics', '').groupBy('tags.pid', 'tags.createTime', 'host').metricField('cpu_systemPct').start('-1m').aggregation('mean', '15s')"
}]
```

➡️ [Learn more about parameter values in a monitor definition file](/develop/developer-guides/monitors/monitor-stj-file-format.md#arguments)

## Available APIs

Monitor functions can leverage existing StackState Script APIs, including:

- [**Telemetry**](/develop/reference/scripting/script-apis/telemetry.md) - used to fetch Metric and Log data,
- [**Async**](/develop/reference/scripting/script-apis/async.md) - allowing for combining multiple asynchronous results in one computation,
- [**View**](/develop/reference/scripting/script-apis/view.md) - StackState View related operations,
- [**Component**](/develop/reference/scripting/script-apis/component.md) - StackState Component related operations.

Additionally, the following Script APIs are optionally available. They are considered to be experimental:

- [**Topology**](/develop/reference/scripting/script-apis/topology.md) - used to fetch Topology data,
- [**Http**](/develop/reference/scripting/script-apis/http.md) - used to fetch external data via the HTTP protocol,

{% hint style="success" "self-hosted info" %}

To use the above, experimental APIs,  they must be explicitly named in your StackState configuration file by appending the following line at the end of the `etc/application_stackstate.conf` file.

`stackstate.featureSwitches.monitorEnableExperimentalAPIs = true`

{% endhint %}

## See also 

TODO
