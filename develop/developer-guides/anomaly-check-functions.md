---
description: How to create your own health checks using anomaly events
---

## Overview

Anomaly check functions make it possible to configure a health check that triggers the DEVIATING health status if an anomaly with certain parameters is found for a specified metric stream.

An anomaly check function body is a groovy script. The example below shows an anomaly check function with a `metricStream` user input parameter that specifies the metric stream ID that the check will run on. The function checks if an incoming `event` is a `Metric Stream Anomaly` event and if the metric stream ID from the event matches that provided in the `metricStream` argument. If there is a match, the function will trigger a DEVIATING health state, hold it for 1 minute (60000 milliseconds) and then switch the health state to UNKNOWN. Additionally, the return value `causingEvents` will return details of the event that caused the state change.

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

## Anomaly check function parameters

The relevant **User Parameters** to provide for an anomaly check function are:
* [StackState events](#stackstate-events)
* [Anomaly direction](#anomaly-direction)
* [Metric stream id](#metric-stream-id)

### StackState events

The StackState events user parameter specifies the type of topology events that the check function should receive. Anomaly events are selected by specifying `Anomaly Events` when the check is configured.

The following properties return details of a received anomaly event:

| Property | Type | Description |
| :--- | :--- | :--- |
| `event.getIdentifier()` | String | The event identifier. |
| `event.getElementIdentifiers()` | an array of String | The identifiers of topology component related to the event. |
| `event.getCategory()` | String | The event category. For example, "Anomalies" |
| `event.getType()` | String | The type of event.<br />For anomaly events, the type is "Metric Stream Anomaly". |
| `event.getName()` | String | The event summary. For example, "Sudden Rise Detected". |
| `event.getDescription()` | Optional of String | The detailed description of event. |
| `event.getEventTimestamp()` | Long | The time when event has been generated. For example, anomaly start time. |
| `event.getObservedTimestamp()` | Long | The time when even has been processed by StackState. |
| `event.getTags() | An array of String | An array of event tags.<br />For anomaly events, available tags are `anomalyDirection:RISE`, `anomalyDirection:DROP`, `severity:HIGH`, `severity:MEDIUM`, `severity:LOW`. |
| `event.getData()` | TopologyEventData | The type specific event data. For example, *Metric Stream Anomaly Data*. |
| `event.getData().getStreamId()` | Long | The id of the MetricStream where anomaly has been found. |

### Anomaly direction

The Anomaly direction parameter specifies the direction of deviation of metric telemetry. It can be set as `RISE`, `DROP` or `ANY` (either RISE or DROP). The parameter gives fine-grained control over alerting on anomaly events. For example, the direction `RISE` may be interesting to track latency, while `DROP` might be useful to track request count.

The code snippet below shows how the anomaly direction can be matched with parameters of an incoming anomaly event. The incoming event has a tags list containing an anomaly direction tag in the format `anomalyDirection:RISE` or `anomalyDirection:DROP`.

  ```text
    def tags = event.getTags()
    def anomalyDirectionMatch = tags.contains("anomalyDirection:" + anomalyDirection.toString())
  ```

### Metric stream id

The Metric stream id parameter specifies the identifier of the Metric Stream for which the anomaly check is executed. The anomaly check function should match this with the id of the metric stream from an incoming anomaly event. See the example below:

  ```text
    def metricStreamIdMatch = event.getData().getStreamId() == metricStream
  ```

## See also

* [Autonomous Anomaly Detector](../../stackpacks/add-ons/aad.md)
* [Checks and telemetry streams](/configure/telemetry/checks_and_streams.md)
