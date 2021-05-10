# Create a custom check function

## Overview 

Check functions are run by health checks in StackState. They can process metric data, logs or events to trigger a change in health status of a component or relation. A number of check functions are shipped together with StackState, or you can write your own check function as a groovy script. 

## Create a custom check function 

To add a custom check handler function:

1. In the StackState UI, go to **Settings** &gt; **Functions** &gt; **Check Functions**.
2. Click **ADD CHECK FUNCTION**.
3. Enter the required settings:
  * **Name** - A name to identify the check function.
  * **Description** - Optional. A description of the check function.
  * **User parameters** - These are parameters that must be entered by the user when a check is added to a component. For details, see the section on [user parameters](#user-parameters).
  * **Return** - ???. For details see [check function results](#result).  
  * **Script** - The groovy script run by the function.
  * **Identifier** - Optional. A unique identifier \(URN\) for the event handler function. For details, see [identifiers](/configure/identifiers.md#about-identifiers-in-stackstate).
4. Click **CREATE** to save the check function.
  * The new check function will be listed on the **Check Functions** page and available in the **Add check** drop-down when you [add a health check](../../../use/health-state-and-event-notifications/add-a-health-check.md#add-a-health-check-to-an-element).

![Add a custom check function](../../../.gitbook/assets/add-check-function.png)

## User parameters

Check functions can work with a number of user parameters. These parameters can be accessed by the function script, and their values are specified by the user when the check function is used in a health check.

User parameters can be any of the types listed below. **Required** parameters must always be specified by the user. **Multiple** parameters will be a list containing the specified user parameter type.

| User parameter type | Description |
|:---|:---|
| Primitive types | Can be a  `Float`, `Integer`, `String` or `Boolean`. |
| State | |
| Run state | |
| Metric stream | A `List` with a number of `MetricTelemetryPoint` metrics. Each `MetricTelemetryPoint` includes a `point` (the metric value as a double) and a `timestamp` in epoch milliseconds. | 
| Baseline metric stream \(deprecated\) | |
| Metric stream id | |
| Log stream | |
| StackState events |  |
| Anomaly direction | Used for [anomaly check functions](/develop/developer-guides/custom-functions/anomaly-check-functions.md). |

In the example below, the check function includes a Metric stream parameter (`metrics`) and an Integer parameter (`deviatingValue`). The health state DEVIATING will be returned whenever the metrics stream includes a metric value higher than the specified deviating value.

{% tabs %}
{% tab title="Example check function script" %}
```text
if (metrics[-1].point >= deviatingValue) return DEVIATING;
```
{% endtab %}
{% endtabs %}

## Result

Whenever a check function runs, it returns a result. This can be a **health state** and/or a **run state**, or a custom map containing a collection of data formatted as described below. 

* **Health state** - A `HealthStateValue`. This will be the new health state of the component (`CLEAR`, `DEVIATING`, `CRITICAL`, `DISABLED` or `UNKNOWN`). A `CheckStateExpiration` can also be returned to specify how long the health state should remain valid and what it should change to after expiration.
* **Run state** - A `RunStateValue`. This will be the new run state of the component (`UNKNOWN`, `STARTING`, `RUNNING`, `STOPPING` `STOPPED`, `DEPLOYED` or `DEPLOYING`). |
* **Custom map** - A custom map can contain a health state and/or run state as described above, as well as:
  - `detailedMessage` - Markdown formatted explanation of the reason behind a returned health state. `String`.
  - `shortMessage` - A short description of the state change. `String`.
  - `causingEvents` - The events that triggered the health state change. These are used in [anomaly check functions](/develop/developer-guides/custom-functions/anomaly-check-functions.md) to link changes to anomaly events. Provided as a map with the keys `title` (`String`), `eventId` (`String`), `eventTimestamp` (`Long`) and `eventType` (`String`).
  - `data` - Arbitrary additional data. `Map<String, Object>`.

Example custom map result:

```
[
    runState: STOPPING,
    healthState: DEVIATING,
    shortMessage: "Something bad happened",
    detailedMessage: "Something **REALLY** bad happened.",
    expiration: [
        duration: 60000,
        expireTo: UNKNOWN
    ],
    causingEvents: [
         [
                 title: event.getName(),
                 eventId: event.getIdentifier(),
                 eventTimestamp: event.getEventTimestamp(),
                 eventType: event.getType()
         ]
    ],
    data: [
        "foo": "bar"
    ]
]
```

## Logging

You can add logging statements to check function scripts for debug purposes, for example, with `log.info("message")`. Logs will appear in `stackstate.log`. Read how to [enable logging for functions](../../../configure/logging/enable-logging.md).

## See also

* [Send notifications when a health state changes](../../../use/health-state-and-event-notifications/send-event-notifications.md)
* [Anomaly check functions](/develop/developer-guides/custom-functions/anomaly-check-functions.md).