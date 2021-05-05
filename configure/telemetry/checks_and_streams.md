# Understanding checks and streams

## Overview

Checks are the mechanisms through which elements \(components and relations\) get a health state. The state of an element is determined from data in the associated telemetry streams.

* Read more about [checks](checks_and_streams.md#checks)
* Read more about [telemetry streams](checks_and_streams.md#telemetry-streams)

## Checks

Checks determine the health state of an element by monitoring one or more telemetry streams. Each telemetry stream supplies either metrics \(time-series\) or logs \(logs and events\) data.

### Check Functions

StackState checks are based on check functions - reusable, user defined scripts that specify when a health state should be returned. This makes checks particularly powerful, allowing StackState to monitor any number of available telemetry streams. For example, you could write a check function to monitor:

* Are we seeing a normal amount of hourly traffic?
* Have there been any fatal exceptions logged?
* What state did other systems report?

A check function receives parameter inputs and returns an output health state. Each time a check function is executed, it updates the health state of the checks it ran for. If a check function does not return a health state, the health state of the check remains unchanged.

## Telemetry streams

A telemetry stream is a real-time stream of either metric or log data coming from an external monitoring system.

| Data | Description |
| :--- | :--- |
| **Metrics** | Metric, or time-series, data are numeric values over time. A metric can represent any kind of measurement, like a count or a percentage. |
| **Logs** | A log entry is a \(JSON style\) data object with some properties. Each log entry may represent an event or even some state information coming from an external system. StackState is able to synchronize the checks of external systems, such as OpsView or Nagios. These systems report check changes to StackState in a log stream. These log entries are then checked for their data by a check, which in turn can translate into an element state change in StackState. |

### Telemetry stream providers

Telemetry streams are supplied via plugins. Different plugins provide one or multiple types of telemetry streams. For example, the Graphite plugin provides StackState with a metrics telemetry stream, while the Elasticsearch plugin provides metric and log telemetry streams.

### Add telemetry streams

In StackState, telemetry streams need to be linked to elements \(components or relations\). Once a telemetry stream has been linked to an element it can be used as an input for the element's checks. Telemetry streams can also be defined in templates and attached automatically to elements when they are imported by a synchronization.

Read how to [add a telemetry stream to an element](../../use/health-state-and-event-notifications/add-telemetry-to-element.md) or how to [add telemetry during topology synchronization](telemetry_synchronized_topology.md).

### Baselines

A baseline can be attached to a metric stream. The baseline consists of an average, a lowerDeviation and a higherDeviation for batches of metric data. Checks can use the baseline values on a metric stream to trigger a health state change if a batch of metrics deviates from the baseline.

Read more about [anomaly detection with baselines](../../use/health-state-and-event-notifications/anomaly-detection-with-baselines.md) and [baseline functions](baseline-functions.md).

## Create a custom check function

Check functions make it possible to configure a health check that triggers the DEVIATING health status.  They do this by processing metric data, logs or events. You can write your own check function as a groovy script. To add a custom event handler function:

1. Go to **Settings** &gt; **Functions** &gt; **Check Functions**.
2. Click **ADD CHECK FUNCTION**.
3. Enter the required settings:
  * **Name** - A name to identify the event handler function.
  * **Description** - Optional. A description of the event handler function.
  * **User parameters** - Parameters that must be entered by the user when a check is added to a component. For details, see the section on [parameters](checks_and_streams.md#parameters) below.
  * **Return** - Whether the function returns a Health state, a Run state or both.
  * **Script** - The script run by the function.
  * **Identifier** - Optional. A unique identifier \(URN\) for the event handler function.
4. Click **CREATE** to save the check function.
  * The new check function will be listed on the **Check Functions** page and available in the **Add check** drop-down when you [add a health check](../../use/health-state-and-event-notifications/add-a-health-check.md#add-a-health-check-to-an-element).

![Add a custom check function](../../.gitbook/assets/add-check-function.png)

## Parameters

Check functions are allowed a variety of parameters, but the most important one is the "Metric stream".  A metric stream (say, with argument name `metrics`) gets a `List` of `MetricTelemetryPoint`s.

A `MetricTelemetryPoint` has the properties
* `point` - the metric value as a `Double`
* `timestamp` - the time \(epoch in ms\) at which the value was measured

{% tabs %}
{% tab title="Example check function script" %}
```text
if (metrics[-1].point >= deviatingValue) return DEVIATING;
```
{% endtab %}
{% endtabs %}

## Check Result

When a check function runs, it returns a check result.  This result can be either one of
* **health state** a `HealthStateValue`, the new health state of the component.  One of `CLEAR`, `DEVIATING`, `CRITICAL`, `DISABLED` or `UNKNOWN`
* **run state** a `RunStateValue`, the new run state of the component.  One of `UNKNOWN`, `STARTING`, `RUNNING`, `STOPPING` `STOPPED`, `DEPLOYED` or `DEPLOYING`
* **acknowledgement**, a `CheckAcknowledgementResult`
* **expiration**, a `CheckStateExpiration` that specifies how long the health state remains valid and what it should expire to
* a combination of the above and/or additional state in a `Map<String, Object>`.  See below for more details.

The keys of the combined map are:

| Key | Type | Description |
| :--- | :--- | :--- |
|`runState` |`RunStateValue`|see above|
|`healthState` |`HealthStateValue`|see above|
|`healthAcknowledgement` |`CheckAcknowledgementResult`|see above|
|`expiration` |`CheckStateExpiration`|see above|
|`detailedMessage` |`String`|detailed explanation of the reason behind the health status|
|`shortMessage` |`String`|a short description|
|`causingEvents` |`List<Map<String, Object>>`|the events that triggered the health state change|
|`data`|`Map<String, Object>`|arbitrary additional data|

The `causingEvents` allow StackState to link events together.  E.g. when an anomaly event occurs, the component that generated the metrics can become `DEVIATING`.  Including the anomaly as a causing event then allows the operator to understand why the health state change event occurred.  The causing event are provided as a `Map`, provided that the keys `title` (`String`), `eventId` (`String`), `eventTimestamp` (`Long`) and `eventType` (`String`) are all set.

In order to guarantee that `data` can be serialized and no objects can leak from the groovy sandbox, only these value types are supported:
* primitive, meaning a `Boolean`, `Short`, `Integer`, `Long`, `Float`, `Double` or `String`
* a _homogeneous_ `List` of values - all values must be of the same type
  - `Number` (any primitive except `String` or `Boolean`)
  - `String`
  - `Boolean`
  - `List`
  - `Map`
* they are a `Map` themselves, with `String` keys 

In `List` and `Map`, values must again conform to these rules.

## Logging

You can add logging statements to an event handler function for debug purposes, for example, with `log.info("message")`. Logs will appear in `stackstate.log`. Read how to [enable logging for functions](../logging/enable-logging.md).

## See also

* [Add a health check](../../use/health-state-and-event-notifications/add-a-health-check.md)
* [Add a telemetry stream to an element](../../use/health-state-and-event-notifications/add-telemetry-to-element.md)
* [Use templates to add telemetry streams to your own integrations](telemetry_synchronized_topology.md)
* [Anomaly check functions](../../develop/developer-guides/anomaly-check-functions.md)
* [Anomaly detection with baselines](../../use/health-state-and-event-notifications/anomaly-detection-with-baselines.md)
* [Baseline functions](baseline-functions.md)
* [Send notifications when a health state changes](../../use/health-state-and-event-notifications/send-event-notifications.md)

