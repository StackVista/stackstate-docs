---
description: StackState SaaS
---

# About events

## Overview

StackState records every change detected in the IT environment as an event. Events are always bound to one or more topology elements. Events can be generated internally by StackState or retrieved from external systems by an integration. Events help you make sense of changes that impact your IT landscape and are a great asset when troubleshooting problems. 

* Events related to the elements in a view are listed in the [Events perspective](/use/stackstate-ui/perspectives/events_perspective.md). They're also included in the **Event** list in the right panel **View summary** tab and the details tabs - **Component details** and **Direct relation details**.
* [Event handlers](/use/events/event-notifications.md) can be configured to trigger notifications in response to different event types, such as sending a message to Slack or a notification email.
* In some cases, events sent to StackState aren't bound to an element in the topology. Incoming data of this kind will be treated as a log entry and made available in a [telemetry stream](/use/metrics/telemetry_streams.md) (a log stream). 

## Event source

StackState generates events internally and also receives events from integrations with external systems, note that not all events are available in the Events Perspective.

{% hint style="success" "self-hosted info" %}

**StackState Self-Hosted**

Extra information for the [StackState Self-Hosted product](https://docs.stackstate.com/):

    
You can also use the StackState CLI or an HTTP POST to send events to StackState.
{% endhint %}

### Internally generated events

StackState generates events for every change in the topology. For example, events will be generated when a component/relation is created, an anomaly is detected by the AAD, or when the properties of an element changed. These events will be listed in the [Events perspective](/use/stackstate-ui/perspectives/events_perspective.md). They're also included in the **Event** list in the right panel **View summary** tab and the details tabs - **Component details** and **Direct relation details**.

### Events from external sources

Many StackState integrations retrieve events from external systems. All events retrieved from external systems will be listed in the Events Perspective. They're also included in the **Event** list in the right panel **View summary** tab and the details tabs - **Component details** and **Direct relation details**, unless otherwise stated in the [integration documentation](/stackpacks/integrations/).

### Log streams

Event data that isn't bound to an element is made available in a log [telemetry stream](/use/metrics/telemetry_streams.md#log-streams). Events in these streams won't be listed in the Events Perspective, however, they're available to be used by a check or monitor. This can then trigger a health state change event, which would be listed in the Events Perspective as an internally generated event.

## Event category

All events in StackState have a category assigned based on the event type and source system. The available categories are **Activities**, **Alerts**, **Anomalies**, **Changes** and **Others**. Events received from external systems will have a category attached to them when they arrive in StackState. If no valid category is included in an event, it will be grouped under the category **Others**.

## Event properties

Select an event to display detailed information about it in the right panel **Event details** tab. Events from external systems will also include links through to relevant information in the source system here:

* **Elements** - The components or relations involved in the event.
* **Event type** - A description of the event type.
* **Event time** - The time at which the event occurred. For events from an external system, this will be the timestamp from the external system. Click the timestamp to [time travel](/use/stackstate-ui/perspectives/events_perspective.md#time-travel) to the topology at the moment that the event occurred.
* **Processed time** - For external events, this is the time that the event was received by StackState. For internally generated events that affect the graph database, this is the time data was stored in the graph database. Click the timestamp to [time travel](/use/stackstate-ui/perspectives/events_perspective.md#time-travel) to the topology at the moment that the event was processed by StackState.
* **Links** - Direct links to an external source of an event. For example, a ServiceNow change request or JIRA ticket.
* **Description** - Additional information about the event. For example, the context of the event or its importance.
* **SHOW ALL PROPERTIES** - Click to access all data included in the event.

![Properties of an event](/.gitbook/assets/v51_event-properties.png)

## See also

* [Events perspective](/use/stackstate-ui/perspectives/events_perspective.md)
* [Use events to trigger event notifications and actions](/use/events/manage-event-handlers.md)