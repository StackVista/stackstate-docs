---
description: StackState Self-hosted v4.6.x
---

# Set telemetry stream priority

## Overview

Telemetry streams in the right-hand component pane of the StackState UI are displayed in order of telemetry stream priority. There are four levels of priority: `High`, `Medium`, `Low`, and `None`. Streams that have a higher priority level are presented at the top of the Telemetry stream section. The the most recent metric received from the top three telemetry streams in this list will be displayed in the component context menu under [top metrics](/use/metrics-and-events/top-metrics.md) when you hover over a component in the Topology Perspective.

By default, all streams have priority set to `none`. To change the priority of a specific stream, follow the instruction below:

## Set the telemetry stream priority

### 1. Open the Component Details pane

Locate the component that you want to edit Telemetry streams for. Click on the component to open the Component Details pane on the right of the screen - see the screenshot below:

![Component Details](../../.gitbook/assets/v46_component_details.png)

This displays the details of the component, such as Properties, Health status, and Telemetry.

### 2. Choose the telemetry streams to prioritize

Components can have multiple Telemetry streams. They are presented in a column, so not all of them are visible at first. Let's say that instead of `BytesReceivedRate`, you want to see `PacketsReceivedRate` right after the `basic_health` stream. Click on the triple dots menu in the top-right corner of the `basic_health` stream and choose **Edit**:

![Edit telemetry stream](../../.gitbook/assets/v46_telstream_edit.png)

### 3. Set stream priority

In the `basic_health` stream edit screen, set the Priority field to `High`, as this stream should be presented at the top of the list. Click **Save** and confirm the change:

![Edit basic\_health](../../.gitbook/assets/v46_edit_basic_health.png)

Now navigate to the `PacketsReceivedRate` stream and open the stream editing screen. Set the Priority field here to `Medium`:

![Edit packetsReceiveRate](../../.gitbook/assets/v46_edit_medium.png)

All streams have their priority set to `None` by default, so the `PacketsReceivedRate` stream is presented above them and below the `basic_health` stream, which has its priority set to `High`.

