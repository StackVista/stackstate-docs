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

![Add a custom check function](/.gitbook/assets/add-check-function.png)

## User parameters

Check functions can work with a number of user parameters. These parameters can be accessed by the function script, and their values are specified by the user when the check function is used in a health check.

User parameters can be any of the types listed below. **Required** parameters must always be specified by the user. **Multiple** parameters will be a list containing the specified user parameter type.

### Primitive types

Can be a `Float`, `Integer`, `String` or `Boolean`.

### State

A health state. Can take the values `CLEAR`, `DEVIATING`, `CRITICAL`, `DISABLED` or `UNKNOWN`.

### Run state

Run state.  One of `UNKNOWN`, `STARTING`, `RUNNING`, `STOPPING` `STOPPED`, `DEPLOYED` or `DEPLOYING`.

### Metric stream

A metric stream provides data to a check function to derive a health state from.  The check function is invoked periodically with a list of recent telemetry metric points.

In the example below, the check function includes a Metric stream parameter (`metrics`) and an Integer parameter (`deviatingValue`). The health state DEVIATING will be returned whenever the metrics stream includes a metric value higher than the specified deviating value.

{% tabs %}
{% tab title="Example check function script" %}
```text
if (metrics[-1].point >= deviatingValue) return DEVIATING;
```
{% endtab %}
{% endtabs %}

A telemetry metric point (obtained as `metrics[-1]` in the example), has these properties:

| Property | Type | Returns |
| :--- | :--- | :--- |
| `metric.timestamp` | Long | Milliseconds since epoch. |
| `metric.point` | Double | The metric value. |

### Log stream

Log streams provide structured events to check functions.

In the example below, the check function has a Log stream parameter (`events`). The health state DEVIATING will be returned whenever the stream includes an event with value `bar` for the key `foo`:

{% tabs %}
{% tab title="Example check function script" %}
```text
if (events[0].point.getString("foo") == "bar") return DEVIATING;
```
{% endtab %}
{% endtabs %}

An event (obtained as `events[0]` in the example), has these properties:

| Property | Type | Returns |
| :--- | :--- | :--- |
| `event.timestamp` | Long | Milliseconds since epoch. |
| `event.point` | StructType | The metric value. |

### StackState events

The StackState events user parameter specifies the type of topology events that the check function should receive. Anomaly events are selected by specifying `Anomaly Events` when the check is configured.  Other events are e.g. received as [receiver API events](/configure/telemetry/send_telemetry.md#events).

The following properties return details of a received event:

| Property | Type | Returns |
| :--- | :--- | :--- |
| `event.identifier` | String | The event identifier. |
| `event.elementIdentifiers` | An array of String | The identifiers of topology components related to the event. |
| `event.category` | String | The event category. For example, "Anomalies" |
| `event.type` | String | The type of event.<br />For anomaly events, the type is "Metric Stream Anomaly". |
| `event.name` | String | The event summary. For example, "Sudden Rise Detected". |
| `event.description` | Optional of String | The detailed description of the event. |
| `event.eventTimestamp` | Long | The time that the event was generated. For example, anomaly start time. |
| `event.observedTimestamp` | Long | The time that the even was processed by StackState. |
| `event.tags` | An array of String | An array of event tags. For anomaly events, available tags are `anomalyDirection:RISE`, `anomalyDirection:DROP`, `severity:HIGH`, `severity:MEDIUM`, `severity:LOW`. |
| `event.data` | TopologyEventData | The type specific event data. See [Metric Stream Anomaly Data](#metric-stream-anomaly-data), [Metric Stream No Anomaly Data](#metric-stream-no-anomaly-data) and [Generic Topology Event Data](#generic-topology-event-data). |

#### Metric Stream Anomaly Data

An anomaly event contains details on the anomaly that was detected in the metric stream.

| Property | Type | Returns |
| :--- | :--- | :--- |
| `data.severity` | String | Severity of the anomaly.  Either one of `LOW`, `MEDIUM` or `HIGH`. |
| `data.severityScore` | Double | Score of the anomaly.  Between `0` and `1`, a higher score means a stronger deviation. |
| `data.explanation` | String | Human readable summary of the anomaly. |
| `data.checkedInterval` | TimeRange | Time range that was checked by the anomaly detector.  Properties `startTimestamp` and `endTimestamp`.|
| `data.eventTimeInterval` | TimeRange | Interval of the anomaly. |
| `data.streamName` | String | Name of the stream on which the anomaly was found. |
| `data.elementName` | String | Element to which the stream is attached. |
| `data.streamId` | Long | The ID of the MetricStream where the anomaly has been found. |

#### Metric Stream No Anomaly Data

When the anomaly detector has checked a time range on a metrics stream and did not find an anomaly, a topology event with `event.type` equal to "Metric Stream No Anomaly" is emitted.

| Property | Type | Returns |
| :--- | :--- | :--- |
| `data.explanation` | String | Human readable summary of the anomaly. |
| `data.checkedInterval` | TimeRange | Time range that was checked by the anomaly detector.  Properties `startTimestamp` and `endTimestamp`.|
| `data.streamName` | String | Name of the stream on which the anomaly was found. |
| `data.elementName` | String | Element to which the stream is attached. |
| `data.streamId` | Long | The ID of the MetricStream where the anomaly has been found. |

#### Generic topology event data

Other topology event types do not have a structured type associated with them, but can have additional (unstructured) data.

| Property | Type | Returns |
| :--- | :--- | :--- |
| `data.data` | StructType | Unstructured |

### Anomaly direction

The Anomaly direction parameter specifies the direction of deviation of metric telemetry. It can be set as `RISE`, `DROP` or `ANY` \(either RISE or DROP\). The parameter gives fine-grained control over alerting on anomaly events. For example, the direction `RISE` may be interesting to track latency, while `DROP` might be useful to track request count.

The code snippet below shows how the anomaly direction can be matched with parameters of an incoming anomaly event. The incoming event has a tags list containing an anomaly direction tag in the format `anomalyDirection:RISE` or `anomalyDirection:DROP`.

```text
    def tags = event.getTags()
    def anomalyDirectionMatch = tags.contains("anomalyDirection:" + anomalyDirection.toString())
```

### Metric stream id

The Metric stream ID parameter specifies the identifier of the Metric Stream for which the anomaly check is executed. The anomaly check function should match this with the ID of the metric stream from an incoming anomaly event. See the example below:

```text
    def metricStreamIdMatch = event.getData().getStreamId() == metricStream
```


## Result

Whenever a check function runs, it returns a result. This can be a **health state** and/or a **run state**, or a custom map containing a collection of data formatted as described below. 

* **Health state** - A `HealthStateValue`. This will be the new health state of the component (`CLEAR`, `DEVIATING`, `CRITICAL`, `DISABLED` or `UNKNOWN`). A `CheckStateExpiration` can also be returned to specify how long the health state should remain valid and what it should change to after expiration.
* **Run state** - A `RunStateValue`. This will be the new run state of the component (`UNKNOWN`, `STARTING`, `RUNNING`, `STOPPING` `STOPPED`, `DEPLOYED` or `DEPLOYING`). |
* **Custom map** - A custom map can contain a health state and/or run state as described above, as well as:
  - `detailedMessage` - Markdown formatted explanation of the reason behind a returned health state. `String`.
  - `shortMessage` - A short description of the state change. `String`.
  - `causingEvents` - The events that triggered the health state change. These are used in [anomaly check functions](#anomaly-check-functions) to link changes to anomaly events. Provided as a map with the keys `title` (`String`), `eventId` (`String`), `eventTimestamp` (`Long`) and `eventType` (`String`).
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

## Anomaly check functions

Anomaly check functions make it possible to configure a health check that triggers the DEVIATING health status if an anomaly with certain parameters is found for a specified metric stream.

The relevant **User Parameters** to provide for an anomaly check function are:

* [StackState events](#stackstate-events)
* [Anomaly direction](#anomaly-direction)
* [Metric stream id](#metric-stream-id)

The example below shows an anomaly check function with a `metricStream` user input parameter that specifies the metric stream ID that the check will run on. The function checks if an incoming `event` is a `Metric Stream Anomaly` event and if the metric stream ID from the event matches that provided in the `metricStream` argument. If there is a match, the function will trigger a DEVIATING health state, hold it for 1 minute \(60000 milliseconds\) and then switch the health state to UNKNOWN. Additionally, the return value `causingEvents` will return details of the event that caused the state change.

{% tabs %}
{% tab title="Example anomaly check function script" %}
```text
  if (event.getType() == "Metric Stream Anomaly" && event.getData().getStreamId() == metricStream) {
     return [
         healthState: DEVIATING,
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
         ]
     ];
  }
```
{% endtab %}
{% endtabs %}

## See also

* [Send notifications when a health state changes](../../../use/health-state-and-event-notifications/send-event-notifications.md)
* [Checks and telemetry streams](../../../configure/telemetry/checks_and_streams.md)
* [Autonomous Anomaly Detector](../../../stackpacks/add-ons/aad.md)

