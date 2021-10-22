---
description: See traces for the components in your IT landscape.
---

# Traces Perspective

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

The Traces Perspective shows a list of traces and their spans for the components in your view. This allows you to monitor the performance of the applications in your IT infrastructure directly in StackState.

![The Traces Perspective](../../.gitbook/assets/v42_traces-perspective.png)

To find out more about how you can add traces to StackState, please read the [guide to setting up traces](../../configure/traces/how_to_setup_traces.md).

## Inspecting Traces

### Trace Inspection

The Traces Perspective shows a list of the slowest traces for the components in your selected view. Click on any trace in the list to see the spans that belong to it

![Inspecting a trace](../../.gitbook/assets/v42_trace-inspection.png)

Span types are colored differently according to the information on the right. For example, the orange spans in this trace correspond to Postgres calls that are made when completing the request.

### Span Details

When inspecting a trace and seeing the list of its spans, you can click on any span to see further details. The image below illustrates this action.

![Inspecting a span](../../.gitbook/assets/v42_span-details.png)

## Filtering

Traces and components are tightly related. The traces visible in the Traces Perspective can be filtered in two ways: using topology filters or trace filters.

### Topology Filters

The View Filters pane on the left side of the screen in any View allows you to filter the sub-set of topology for which traces are displayed. Read more about [Topology Filters](filters.md#topology-filters)

### Trace Filters

A trace can be filtered based on two properties of its spans: **span types** and **span tags**. The image below shows the filters menu where you see filters for topology, events and traces:

![The Traces Perspective and its filters](../../.gitbook/assets/v42_trace-filters.png)

For example, if you filter the trace list for all spans of type **database**, this will return all traces that have at least one span whose type is **database**.

## Traces and Topology

In StackState, a [view](./) shows you a sub-selection of your IT infrastructure in terms of components and relations. A number of our supported integrations send traces to StackState via [our agent](../../configure/traces/how_to_setup_traces.md). These traces are used in the Traces Perspective and also in the [Topology Perspective](topology-perspective.md) to create the topology of your view.

For example, let's imagine that among your IT infrastructure the following components exist:

1. An HTTP service
2. A Java Application
3. A SQL Database

By installing our agent and its integrations to gather traces from these technologies, StackState will receive traces that traverse these components. At ingestion time, StackState stores both the spans for each component in the list above and the topology that can be extracted from these traces \(components and relations\).

* Each component relates to a span
* Each trace relates to a list of spans \(or components\) that are traversed to complete the requests executed in your IT infrastructure.

![The spans \(components\) of a trace](../../.gitbook/assets/v42_trace-inspection.png)

![The topology for which you fetch traces](../../.gitbook/assets/topology-traces.png)

The two images above illustrate these concepts by showing a library application whose main responsibility is to fetch a list of books. You can see an example of a trace and its spans for a request to fetch the list of books and the resulting topology that is created out of it.

When ingesting traces, StackState attaches service identifiers to the components that are created. These identifiers are also included as part of the **service** property of the spans in a trace. All topology created out of a trace will have a tag **has\_traces**, this allows you to easily identify components for which you have traces.

## Sorting and Limiting

Traces are sorted by latency \(descending\). This is the only sorting criteria available in this version. The trace list is not limited by size, you can scroll infinitely to see all traces that are available for your component, filter and time selections. Finally, on top of the list of traces, StackState displays an approximation of the total amount of traces that are returned from the filters you have selected.

## Time Traveling Considerations

When using the Traces Perspective, just like in other perspectives, you can either be in live mode or in the past. In live mode, StackState is constantly polling for new traces. When time traveling to the past, all views in all perspectives come with a timeline for which you can make two selections:

1. A specific moment in time for which you want the snapshot of your IT infrastructure to be fetched \(i.e. topology\).
2. The time range for which you want to see traces \(e.g the last 24 hours\).

Let's imagine a concrete scenario:

* You received an event notification saying that your payment processing application is not able to process any payments right now and your customers aren't being served.
* In StackState, you can go to the moment in time when the components that make up the critical path of payment processing turned to a `CRITICAL` state. That moment corresponds to the point in time for which you fetch the snapshot of your IT infrastructure \(point **1** above\).
* You can then select to see the hours that preceded that moment in order to fetch the traces that will hopefully point you to the root cause of your problem \(point **2** above\).

### Inspection, scrolling and its impact on time selection.

When using the Traces Perspective in live mode, you are constantly polling for the slowest traces in your time range selection. However, in a large IT infrastructure with constant requests being traced, your slowest traces right now might not be your slowest traces in a matter of seconds, changing their position the list. These constant updates to the order of the list could become frustrating, for example, if you are inspecting a trace/span, or scrolling through the list to look for a specific trace or pattern.

To avoid this, time will effectively be "paused" when you inspect a trace/span or scroll through the list of traces in live mode. This allows you to browse through a stable snapshot of your data. Note that pausing time means that you are now in the past, click the blue ribbon on top or in the timeline itself to resume live mode:

![Pausing time when inspecting a trace](../../.gitbook/assets/v42_trace-inspection.png)

