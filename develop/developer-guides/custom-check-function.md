# Create a custom check function

## Overview 

Check functions are run by health checks in StackState. They process metric data, logs or events to trigger a change in health status of a component or relation. A number of check functions are shipped together with StackState or you can write your own check function as a groovy script. 

## Create a custom check function 

To add a custom check handler function:

1. In the StackState UI, go to **Settings** &gt; **Functions** &gt; **Check Functions**.
2. Click **ADD CHECK FUNCTION**.
3. Enter the required settings:
  * **Name** - A name to identify the check function.
  * **Description** - Optional. A description of the check function.
  * **User parameters** - These are parameters that must be entered by the user when a check is added to a component. For details, see the section on [parameters](#parameters).
  * **Script** - The script run by the function. See the section on [check function script](#check-function-script).
  * **Identifier** - Optional. A unique identifier \(URN\) for the event handler function.
4. Click **CREATE** to save the check function.
  * The new check function will be listed on the **Check Functions** page and available in the **Add check** drop-down when you [add a health check](../../use/health-state-and-event-notifications/add-a-health-check.md#add-a-health-check-to-an-element).

![Add a custom check function](../../.gitbook/assets/add-check-function.png)

## Check function script

### Parameters

Check functions are allowed a variety of parameters, but the most important one is the "Metric stream".  A metric stream (say, with argument name `metrics`) gets a `List` of `MetricTelemetryPoint`s.

A `MetricTelemetryPoint` has the properties
* `point` - the metric value as a `Double`
* `timestamp` - the time \(epoch in ms\) at which the value was measured

{% tabs %}
{% tab title="Example anomaly check function script" %}
```text
if (metrics[-1].point >= deviatingValue) return DEVIATING;
```
{% endtab %}
{% endtabs %}

### Check Result

When a check function runs, it returns a check result. The check result can return a **health state** and/or a **run state**. In addition to this, an acknowledgement and expiration are returned for the check and check result.

| Check result | Description |
|:---|:---|
| **health state** | A `HealthStateValue` is returned if the check function is configured to return a health state. This is the new health state of the component (`CLEAR`, `DEVIATING`, `CRITICAL`, `FLAPPING`, `DISABLED` or `UNKNOWN`). |
| **run state** | A `RunStateValue` is returned if the check function is configured to return a run state. This is the new run state of the component (`UNKNOWN`, `STARTING`, `RUNNING`, `STOPPING` `STOPPED`, `DEPLOYED` or `DEPLOYING`). | 
| **acknowledgement** | A `CheckAcknowledgementResult` is ??? |
| **expiration** | A `CheckStateExpiration` that specifies how long the health state remains valid and what it should change to after expiration.
| **custom** | A `Map<String, Object>` a combination of the above and/or additional state is ???.  |

When a **custom** map is returned, the keys of this map are:

| Key | Type | Description |
| :--- | :--- | :--- |
|`runState` |`RunStateValue`|see above|
|`healthState` |`HealthStateValue`|see above|
|`healthAcknowledgement` |`CheckAcknowledgementResult`|see above|
|`expiration` |`CheckStateExpiration`|see above|
|`detailedMessage` |`String`|detailed explanation of the reason behind the health status|
|`shortMessage` |`String`|a short description|
|`causingEvents` |`List<EventRef>` or `List<Map<String, Object>>`|the events that triggered the health state change|
|`data`|`Map<String, Object>`|arbitrary additional data|

The `causingEvents` allow StackState to link events together.  E.g. when an anomaly event occurs, the component that generated the metrics can become `DEVIATING`.  Including the anomaly as a causing event then allows the operator to understand why the health state change event occurred.  The causing event can also be provided as a `Map`, provided that the keys `title` (`String`), `eventId` (`String`), `eventTimestamp` (`Long`) and `eventType` (`String`) are all set.

To guarantee that `data` can be serialized and that no objects can leak from the groovy sandbox, the following value types are supported:
* a primitive:
  - `Boolean`
  - `Double`
  - `Float`    
  - `Integer`
  - `Long`
  - `Short`
  - `String`
* a _homogeneous_ `List` of values. All values must be of the same type, that can be:
  - `Boolean`
  - `List`
  - `Map`    
  - `Number` (any primitive except `String` or `Boolean`)
  - `String`
* a `Map` with `String` keys 

Note that in `List` and `Map`, values must also conform to these rules.

### Logging

You can add logging statements to an event handler function for debug purposes, for example, with `log.info("message")`. Logs will appear in `stackstate.log`. Read how to [enable logging for functions](../../configure/logging/enable-logging.md).

## See also

* [Send notifications when a health state changes](../../use/health-state-and-event-notifications/send-event-notifications.md)