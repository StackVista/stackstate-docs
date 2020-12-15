---
title: Browse telemetry
kind: Documentation
aliases:
  - /configuring/browse_telemetry/
listorder: 3
---

# Browse telemetry

{% hint style="warning" %}
This page describes StackState version 4.1.  
Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

This is an overview of the telemetry browser inside of StackState.

## Telemetry Browser

The Telemetry Browser enables users to query events and metrics inside your data sources \(monitored systems\). These queries can be saved as telemetry streams on a Component or Relation entity in the topology of the 4T model. Also the Telemetry Browser allows you to play around with different graph settings in a more ad-hoc way.

![Telemetry browser](/.gitbook/assets/telemetry_browser.png)

## How to access the telemetry browser

There are two primary ways to open the Telemetry Browser in StackState.

#### 1. Open an existing stream.

By default, the browser is available on all telemetry \(event and metrics\) streams in the component / relation details pane. By clicking on the chart or selecting the 'Inspect stream' option from the context menu on a stream the telemetry browser will be opened.

#### 2. Create a new stream.

New streams can be added from the Component / Relation details pane \(under the Telemetry streams heading\) '+ Add' button. From there it will guide you through the necessary steps to create a new telemetry stream.

Currently we don't support the creation of new streams on synced components because they will conflict with the next synchronisation with external topology sources. This may will change in the future.

### Choosing a name and selecting the data source

The first step would ask the user about a new name for the telemetry stream and the source where it originates it's data from. Only the source is mandatory at this moment, you can leave the name empty if you're not yet sure what to fill in.

### Selecting your telemetry stream type

In the second step you have to select the output type of the telemetry stream. This either can be 'Metric' or 'Event'. The main differences are in the way how StackState visualizes the stream and how they are processed.

Event telemetry streams are meant to be used for streams which contains 'Logs' and 'event's' which can be viewed from the User Interface and are visualized as a bar chart.

Metric streams are used to display 'metrics' and have some aggregation methods available and will be visualized as a timeseries line chart.
