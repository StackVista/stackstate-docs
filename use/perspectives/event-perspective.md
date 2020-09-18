---
description: Track changes in your IT landscape.
---

# Event Perspective

{% hint style="warning" %}
This page describes StackState version 4.0.<br />Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

The Event Perspective shows events and changes for the components in your [view](../views.md).

## Events

StackState records changes in your landscape as **events**. Events help you make sense of the changes that impact your IT landscape and are a great asset when troubleshooting problems.

The following events are currently recorded:

* component / relation created
* component / relation deleted
* component / relation updated
* health state changed
* version changed

## Filtering

The Event Perspective supports filtering of the events by type.

## Time travel

When opening the Event Perspective, the events shown are based on the currently selected time window in the timeline control. Shrink the time window to display less events. Place the playhead on the timeline to restrict the events to the time indicated by the playhead.

## Event handlers

The Event Perspective allows the creation of [event handlers](../alerting.md) to act on events in the view.

