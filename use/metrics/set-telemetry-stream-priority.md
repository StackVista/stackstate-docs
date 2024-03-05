---
description: StackState SaaS
---

# Set telemetry stream priority

## Overview

The telemetry streams associated with an element are displayed in the right panel details tab when an element is selected to show its detailed information - **Component details** or **Direct relation details** depending on the element type that you selected. Telemetry streams are displayed in order of telemetry stream priority. There are four levels of priority: `High`, `Medium`, `Low`, and `None`. By default, all streams have priority set to `None`. 

Stream priority is used in StackState to help determine the following:

* The order in which streams are displayed in the details tab **Telemetry** list. Streams are ordered first by priority (highest at the top) and then alphabetically.
* The streams that are shown as [Top metrics](/use/metrics/top-metrics.md) in the component context menu - this is the pop-up displayed when you hover the mouse pointer over a component in the Topology Perspective. The most recent metric received from the first three metric streams in the **Telemetry** list will be displayed.
* The order in which streams are displayed in the [Metrics Perspective](/use/stackstate-ui/perspectives/metrics-perspective.md).
* The [streams selected for monitoring by the Autonomous Anomaly Detector](/stackpacks/add-ons/aad.md#how-are-metric-streams-selected).

## Set the telemetry stream priority

To change the priority of a specific stream, follow the instructions below.

### 1. Select a component to display detailed information

Locate the component that you want to edit Telemetry streams for. Select the component to open detailed information about it in the right panel details tab - **Component details**. See the screenshot below:

![Detailed component information](../../.gitbook/assets/v51_component_details.png)

### 2. Choose the telemetry streams to prioritize

Components can have multiple Telemetry streams. They're presented in a list, so not all of them are visible at first. Let's say that instead of `BytesReceivedRate`, you want to see `PacketsReceivedRate` right after the `basic_health` stream. Click the **...** menu in the top-right corner of the `basic_health` stream and choose **Edit**:

![Edit telemetry stream](../../.gitbook/assets/v51_telstream_edit.png)

### 3. Set stream priority

In the `basic_health` stream edit screen, set the Priority field to `High`, as this stream should be presented at the top of the list. Click **Save** and confirm the change:

![Edit basic\_health](../../.gitbook/assets/v51_edit_basic_health.png)

Now navigate to the `PacketsReceivedRate` stream and open the stream editing screen. Set the Priority field here to `Medium`:

![Edit packetsReceiveRate](../../.gitbook/assets/v51_edit_medium.png)

All streams have their priority set to `None` by default, so the `PacketsReceivedRate` stream will now be displayed above them and below the `basic_health` stream, which has its priority set to `High`.

