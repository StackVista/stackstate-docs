---
description: Track changes in your IT landscape.
---

# Events Perspective

{% hint style="warning" %}
**TODO**
- description of categories
- when are tags applied to events?
{% endhint %}

The Events Perspective shows events and changes for the elements in the current [view](/use/views/README.md) or filtered topology. 

![The Events Perspective](/.gitbook/assets/event-perspective.png)

## Events

StackState records changes in your landscape as **events**. Events help you make sense of the changes that impact your IT landscape and are a great asset when troubleshooting problems.

The StackState Events Perspective lists events generated internally by StackState and can also include events retrieved from external systems. Event data received in StackState through a configured events telemetry stream will not be listed here. This can, however, be monitored by a check, which can in turn trigger an internally generated state change event for the associated element. The internally generated state change event will appear on the Events Perspective page.

### Event categories

All events displayed in the Events Perspective have a category. The category is assigned based on the event type and the source system. Events retrieved from external systems should already have a category attached to them. If no category is included in a retrieved event, it will be assigned the category **Others**. 

| Category | Internal event types | Description |
|:---|:---|:---|
| Activities | Run state changes | |
| Alerts | Health state changes | |
| Anomalies | Anomaly | | 
| Changes | Element created<br />Element deleted<br />Element updated<br />Version changed | |
| Others | - | All external events that do not specify a category. |

## Filter displayed events

Events displayed in the Events Perspective can be filtered in two ways: 

- Topology filters define the elements (components and relations) for which events will be displayed.
- Event filters refine the type and area of events that should be displayed. 

### Topology Filters

The elements (components and relations) included in a view are defined by the topology filters in the **View Filters** > **Topology Filters** pane on the left side of the screen. Only events relating to these elements or the view itself will be visible in the Events Perspective. You can [change the topology filters](/use/views/filters.md) at any time to show events for a different set of elements. 

### Event filters

The events displayed in the Events Perspective can be filtered in the **View Filters** > **Filter Events** pane on the left side of the screen. Two filters are available to help you quickly locate relevant changes:

| Filter | Description |
|:---|:---|
| **Event Types** | Click on the **Event Types** filter box to open a list of all event types currently included in the Events Perspective. You can select one or more event types to refine the events displayed. |
| **Tags** | Relevant event properties will be added as tags when an event is retrieved from an external system. For example `status:open` or `status:production`. This can help identify the events relevant to a specific problem in your IT infrastructure.  |



## Time travel

When opening the Events Perspective, the events shown are based on the currently selected time window in the timeline control. Shrink the time window to display less events. Place the playhead on the timeline to restrict the events to the time indicated by the playhead.

## Event handlers

The Events Perspective allows the creation of [event handlers](/use/alerting.md) to act on events in the view.

