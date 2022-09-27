---
description: StackState Self-hosted v5.1.x 
---

# Events

## Overview

StackState defines an event as a timestamped record of an activity or change that an observer of the platform should be aware of. Events can be generated internally by StackState, retrieved from external systems by an integration or received in a telemetry stream (a log stream). Events help you make sense of changes that impact your IT landscape and are a great asset when troubleshooting problems. 

* Events related to the elements in a view are listed in the right panel details tabs and in the [Events perspective](/use/stackstate-ui/perspectives/events_perspective.md). 
* [Event handlers](/use/metrics-and-events/event-notifications.md) can be configured to trigger notifications in response to different event types, such as sending a message to Slack or a notification email.

## Event source

StackState works with three different kinds of events, note that not all of these are available in the Events Perspective.

{% hint style="success" "self-hosted info" %}

You can also use the StackState CLI or an HTTP POST to [send events to StackState](/configure/telemetry/send_telemetry.md#events).
{% endhint %}

### Internally generated events

The following event types are generated internally by StackState. They will be listed in the [Events perspective](/use/stackstate-ui/perspectives/events_perspective.md) and in the right panel details tabs: Anomaly, Component/relation created, Component/relation deleted, Component/relation updated, Health state changed, Version changed.

### Events from external sources

Many StackState integrations can retrieve events from external systems. All events retrieved from external systems will be listed in the Events Perspective and the right panel details tabs.

### Events from telemetry streams

Event data can be received in a log [telemetry stream](/use/metrics-and-events/telemetry_streams.md#log-streams). Events from these streams will not be listed in the Events Perspective, however, they are available to be used by a check or monitor. This can then trigger a health state change event, which would be listed in the Events Perspective as an internally generated event.

## Event category

All events in StackState have a category assigned based on the event type and source system. The available categories are **Activities**, **Alerts**, **Anomalies**, **Changes** and **Others**. Events received from external systems will have a category attached to them when they arrive in StackState. If no valid category is included in an event, it will be grouped under the category **Others**.
tab
## Event properties

Select an event to display detailed information about it in the right panel **Event details** tab. Events from external systems will also include links through to relevant information in the source system here:

* **Elements** - The components and/or relations involved in the event.
* **Event type** - A description of the event type.
* **Event time** - The time at which the event occurred. For events from an external system, this will be the timestamp from the external system. Click the timestamp to [time travel](/use/stackstate-ui/perspectives/events_perspective.md#time-travel) to the topology at the moment that the event occurred.
* **Processed time** - For external events, this is the time that the event was received by StackState. For internally generated events that affect the graph database, this is the time data was stored in the graph database. Click the timestamp to [time travel](/use/stackstate-ui/perspectives/events_perspective.md#time-travel) to the topology at the moment that the event was processed by StackState.
* **Links** - Direct links to an external source of an event. For example, a ServiceNow change request or JIRA ticket.
* **Description** - Additional information about the event. For example, the context of the event or its importance.
* **SHOW ALL PROPERTIES** - Click to access all data included in the event.

![Properties of an event](/.gitbook/assets/v51_event-properties.png)

## See also

* [Events perspective](/use/stackstate-ui/perspectives/events_perspective.md)
* [Use events to trigger event notifications and actions](/use/stackstate-ui/views/manage-event-handlers.md)