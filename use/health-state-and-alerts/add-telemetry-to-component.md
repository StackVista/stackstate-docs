---
description: 
---

# Add a custom telemetry stream to a component

{% hint style="warning" %}
**QUESTIONS:**
- Where does telemetry come from? (what are the data sources)
- How to be sure that data in a stream relates to the component you are attaching it to?
- Why does it need to be manually added to a component(s) - is this always required or will it sometimes be added automatically when the component is created in sts?
- What if there isn't any telemetry available?
- How to know if telemetry is available?
- What is the difference between a telemetry stream and a metric stream?
- priority - this is used for the order of the lista dn also the AAD right?
{% endhint %}

## Overview

Components in StackState can also include telemetry \(metrics\). This provides additional insight into your topology and is required, for example, to [monitor the health of a component](/use/health-state-and-alerts/create-a-health-check.md).

If a telemetry stream has not automatically been assigned to a component, you can do this manually from the StackState UI.

## Add a telemetry stream to a component or relation

You can add a telemetry stream to a component or relation in the StackState Topology Perspective.

![Add a telemetry stream to a component or relation](/.gitbook/assets/v41_add_telemetry_stream.png)

1. Select the component or relation that you want to.
2. Click **+ ADD** next to **Telemetry streams** on the right of the screen.
3. Provide the following details:
    - **Name** - 
    - **Data source** - 
4. Click **NEXT**
5. Provide the following details:
    - **Time window** - 
    - **Filters** - 
    - **Select** - 
    - **Priority** - Optionally [set a priority for the telemetry stream](/configure/telemetry/how_to_use_the_priority_field_for_components.md). This will affect 
6. The stream preview on the right will update to show the incoming metric values based on the details you provide.
7. Click **SAVE** to add the stream to the component.
    - You will receive a notification that the stream has been successfully completed. 

## See also

- [Set a priority for the telemetry stream](/configure/telemetry/how_to_use_the_priority_field_for_components.md)
- [Automomous Anomaly Detector](/stackpacks/add-ons/aad.md)
- [Monitor the health of a component](/use/health-state-and-alerts/create-a-health-check.md)