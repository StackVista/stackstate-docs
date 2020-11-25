---
description: Track changes in your IT landscape.
---

# Events Perspective

{% hint style="warning" %}
**TODO**
- description of categories
{% endhint %}

The Events Perspective shows events and changes for the components in your [view](/use/views/README.md). 

![The Events Perspective](/.gitbook/assets/event-perspective.png)

## Events

StackState records changes in your landscape as **events**. Events help you make sense of the changes that impact your IT landscape and are a great asset when troubleshooting problems.

The StackState Events Perspective lists events generated internally by StackState and can also include events retrieved from external systems for some integrations. Event data received in StackState through a configured events telemetry stream will not be listed here, however, they can be monitored by a check, which can in turn trigger an internally generated state change event for the associated element. The internally generated state change event will appear on the Events Perspective page.

All events displayed in the Events Perspective have a category, which is assigned according to their type and source system. Events from external systems should already 

| Category | Internal event types | Description |
|:---|:---|:---|
| Activities | Run state changes | |
| Alerts | Health state changes | |
| Anomalies | Anomaly | | 
| Changes | element created, deleted or updated, version changed. | |
| Others | - | All external events that do not include a category. |




* Version changed

## Filtering

### Topology Filters

The View Filters pane on the left side of the screen in any View allows you to filter the sub-set of topology for which events are displayed. Read more about [Topology Filters](filters.md#topology-filters)

### Filter Events

The Events Perspective supports filtering of events by **Event Types**.

## Time travel

When opening the Events Perspective, the events shown are based on the currently selected time window in the timeline control. Shrink the time window to display less events. Place the playhead on the timeline to restrict the events to the time indicated by the playhead.

## Event handlers

The Events Perspective allows the creation of [event handlers](/use/alerting.md) to act on events in the view.

