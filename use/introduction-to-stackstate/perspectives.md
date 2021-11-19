---
description: Access data via perspectives.
---

# Perspectives

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

StackState and its [4T data model](4t_data_model.md) collect real-time data about your IT landscape. **Perspectives** allow you to look at this data from various angles and to relate different types of data to each other.

All data in StackState is organized around [topology](4t_data_model.md#topology), a representation of the components and their relations that make up your IT landscape. A subset of that topology, called a [view](../views/), that represents the application, layer or set of components that you care about, is the context that the perspectives operate in.

## Perspectives

StackState offers the following perspectives via it's user interface:

* [Topology Perspective](../views/topology-perspective.md)
* [Telemetry Perspective](../views/telemetry-perspective.md)
* [Events Perspective](../views/events_perspective.md)
* [Traces Perspective](../views/traces-perspective.md)

## Time travel

All perspectives allow for time travel by using the timeline control located at the bottom of the perspective. The timeline shows the currently selected time window and the active perspective uses this time window to show information. Switching to another perspective keeps the current time window in place so you can easily correlate different types of information. You can change the time window by using the dropdown on the top left of the timeline control. Zoom in on a particular time window using drag-zoom on the timeline control.

Inside the timeline, blue bars show the number of recorded events at a particular point in time. This makes it possible to identify moments of interest that will help when troubleshooting.

The timeline is in **live mode** by default. This means that it tracks changes as they happen and update the perspective and timeline accordingly. By clicking at a specific place in the timeline, you can stop time and time travel to that moment, updating the information shown in the active perspective. Select the **Live Mode** button in the timeline to switch to live updates again.

To the left of the current time are two arrows, one pointing left and one pointing right. These **time jumpers** move the active time window to the next interesting point in time \(either in the past or the future\) for which StackState has recorded events.

