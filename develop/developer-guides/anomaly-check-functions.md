---
description: How to create your own health checks using anomaly events.
---

## Overview

Anomaly check functions makes it possible to configure a health check that triggers the `DEVIATING` health status if an anomaly with certain parameters is found for a metric stream.

The function body is specified as a groovy script. Below is an example of an anomaly check function with `metricStream` input parameter name that indicates metric stream id from an anomaly event. The function checks if the incoming `event` is the anomaly event and if the metric stream id from the event matches `metricStream` argument. If there is a match the function will trigger DEVIATING state when the anomaly event is received and hold it for 1 minute (60000 milliseconds) and then switch the state to UNKNOWN. Additionally, the return value `causingEvents` returns the event reference which indicates the cause of the state change.

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

## Anomaly Check Function parameters

The possible (relevant) parameters for anomaly check function are:
* StackState Events
* Anomaly Direction
* Metric Stream Id

### StackState events

The parameter specifies what type of topology events the check function should receive. The anomaly events are selected by specifying `Anomaly Events` when check is configured.

The anomaly event is a topology event with the following fields:

#### Generic Topology Event fields

| Field Name | Type | Description |
| :--- | :--- | :--- |
| event.getIdentifier() | String | The event identifier. |
| event.getElementIdentifiers() | an array of String | The identifiers of topology component related to the event. |
| event.getCategory() | String | The event category, e.g. "Anomalies" |
| event.getType() | String | The type of event. For anomaly events it is "Metric Stream Anomaly". |
| event.getName() | String | The event summary, e.g. "Sudden Rise Detected" |
| event.getDescription() | Optional of String | The detailed description of event |
| event.getEventTimestamp() | Long | The time when event has been generated, e.g. anomaly start time |
| event.getObservedTimestamp() | Long | The time when even has been processed by StackState |
| event.getTags() | An array of String | An array of event tags, for anomaly events available tags are - `anomalyDirection:RISE`, `anomalyDirection:DROP`, `severity:HIGH`, `severity:MEDIUM`, `severity:LOW` |
| event.getData() | TopologyEventData | The type specific event data, e.g. *Metric Stream Anomaly Data* |

#### Metric Stream Anomaly Data fields

| Field Name | Type | Description |
| :--- | :--- | :--- |
| event.getData().getStreamId() | Long | The id of the MetricStream where anomaly has been found. |

### Anomaly Direction

The parameter specifies the direction of deviation of metric telemetry - RISE, DROP or ANY (RISE or DROP). The parameter gives fine-grained control over alerting on anomaly events. For example, for latency one may be interested only in anomalies with RISE direction, and for request count - DROP.

The code snippet below shows how the anomaly direction can be matched with parameters of incoming anomaly event. The incoming event has tags list containing anomaly direction tags in the format "anomalyDirection:RISE" or "anomalyDirection:DROP".

  ```text
    def tags = event.getTags()
    def anomalyDirectionMatch = tags.contains("anomalyDirection:" + anomalyDirection.toString())
  ```

### Metric Stream Id

The identifier of the Metric Stream for which anomaly check is executed. The anomaly check function should match this is with id of the metric stream from anomaly event. See example below

  ```text
    def metricStreamIdMatch = event.getData().getStreamId() == metricStream
  ```

## See also

* [Autonomous Anomaly Detector](../../stackpacks/add-ons/aad.md)
* [Checks and telemetry streams](checks_and_streams.md)
