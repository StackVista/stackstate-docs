---
description: Track changes in your IT landscape.
---

# Events Perspective

The Events Perspective shows events and changes for the components in your [view](/use/views/README.md).

![The Events Perspective](/.gitbook/assets/event-perspective.png)

## Events

StackState records changes in your landscape as **events**. Events help you make sense of the changes that impact your IT landscape and are a great asset when troubleshooting problems.

The following events are currently recorded:

* Anomaly
* Component / relation created
* Component / relation deleted
* Component / relation updated
* Health state changed
* Version changed

## Filtering

### Topology Filters

The View Filters pane on the left side of the screen in any View allows you to filter the sub-set of topology for which events are displayed. Read more about [Topology Filters](filters.md#topology-filters)

### Filter Events

The Events Perspective supports filtering of events by **Event Types**.

## Time travel

When opening the Events Perspective, the events shown are based on the currently selected time window in the timeline control. Shrink the time window to display less events. Place the playhead on the timeline to restrict the events to the time indicated by the playhead.

## Event handlers

The Events Perspective allows the creation of event handlers to act on events in the view and [trigger alerts and actions](/use/health-state-and-alerts/add-an-alert.md).

## See also

- [Trigger alerts and actions](/use/health-state-and-alerts/add-an-alert.md)
- [Filtering data](/use/views/filters.md)
- [Working with StackState views](/use/views/README.md)
