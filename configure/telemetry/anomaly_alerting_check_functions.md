---
title: Anomaly Alerting Check Functions
kind: documentation
---

## Overview

Anomaly alerting check function is a function that gives a possibility to configure a health check that triggers DEVIATING health state if anomaly is found for a MetricStream.

The function body is specified as groovy script. Below is an example of an anomaly alerting check function with `metricStream` input parameter name that indicates metric stream id from anomaly event.
The function checks if the incoming event is anomaly event and if the id of the metricStream from the event matches metricStream argument.
This check will trigger DEVIATING state if such anomaly event is received and hold it for 1 minute (60000 milliseconds) and then switched back to UNKNOWN.

  ```text
  if (event.getType() == "Metric Stream Anomaly" && event.getData().getStreamId() == metricStream) {
     return [
         healthState: DEVIATING,
         expiration: [
             duration: 60000
         ]
     ];
  }
  ```

## Anomaly Alerting Check Function parameters

### StackState events

The parameters specifies what type of topology events check function should receive. The anomaly events are selected by specifying `Anomaly Events` when check is configured.

The anomaly event is a topology event with the following fields available:

#### Generic Topology Event fields

* event.getIdentifier() - event identifier
* event.getElementIdentifiers() - the identifiers of topology component
* event.getCategory() - event category, e.g. "Anomalies"
* event.getType() - the type of event, e.g. "Metric Stream Anomaly"
* event.getName() - the event summary, e.g. "Sudden Rise Detected"
* event.getDescription() - detailed description of event
* event.getEventTimestamp() - the time when event has been generated
* event.getObservedTimestamp() - the time when even has been processed by StackState
* event.getTags() - an array of event tags, e.g. anomalyDirection:RISE, severity:HIGH
* event.getData() - an event specific data, e.g. Metric Anomaly Event Data

#### Metric Anomaly Event data fields

* event.getData().getStreamId() - id of the MetricStream where anomaly has been found

### Anomaly Direction

The parameter specifies the direction of deviation of metric telemetry - RISE, DROP or ANY (RISE or DROP). The parameter gives fine-grained control over alerting on anomaly events. For example, for latency one may be interested only on anomalies with RISE, and for request count - DROP.

The code snippet below shows how the anomaly direction can be matched with parameters of incoming anomaly event. The incoming event has tags list containing anomaly direction tags in the format "anomalyDirection:RISE" or "anomalyDirection:DROP".

  ```text
    def tags = event.getTags()
    def anomalyDirectionMatch = tags.contains("anomalyDirection:" + anomalyDirection.toString())
  ```

### Metric Stream Id

The identifier of the Metric Stream for which anomaly detection and anomaly alerting is executed. The alerting check function should match this is with id of the metric stream from anomaly event. See example below

  ```text
    def metricStreamIdMatch = event.getData().getStreamId() == metricStream
  ```

## See also

* [Autonomous Anomaly Detector](../../stackpacks/add-ons/aad.md)
* [Checks and telemetry streams](checks_and_streams.md)
