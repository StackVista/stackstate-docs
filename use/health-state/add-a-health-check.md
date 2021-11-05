---
description: Report the health state for an element.
---

# Add a health check

## Overview

Health checks report a health state for elements \(components and relations\). The health state can either be calculated internally by StackState based on data from telemetry streams or synchronized with an external monitoring system.

The combined check states attached to an element are used to calculate its overall health status. When the status of an element changes, a state change event is generated. These events can be used to [trigger event notifications and actions](../metrics-and-events/send-event-notifications.md).

## Add a health check

Most elements in the StackState topology will have a relevant health check added when the are created. If required, you can also add custom health checks that calculate a health state in StackState based on available telemetry streams or [synchronize health data from an external monitoring system](add-a-health-check.md#synchronize-external-health-data).

To add a health check calculated in StackState:

1. Select the element that you want to assign a health check to.
   * If no telemetry stream is available on the selected element, you will need to [add a telemetry stream](../metrics-and-events/add-telemetry-to-element.md).
2. Click **+ ADD** next to **Health** on the right of the screen.
   * An **Add check** dialog box appears.
3. Provide the following details:
   * **Name** - The health check name. Will be displayed in the StackState UI **Health** pane.
   * **Description** - Optional, can be used to explain the check in greater detail.
   * **Remediation hint** - Optional, will be automatically displayed on the element when this check goes to a non clear state, for example `critical` or `deviating`.
   * **Check function** - The check function to use to monitor the element's telemetry stream\(s\). See [Check functions](add-a-health-check.md#check-functions) below.
4. Provide the required check function arguments, these will vary according to the check function selected, but will include:
   * At least one telemetry stream. Some checks will require multiple streams.
   * For metrics check functions, a [windowing method](add-a-health-check.md#windowing-method) and window size.
5. Click **CREATE** to create the health check.
   * The check is now active and visible under the **Health** section on the right-hand side of the screen.
   * The check will remain gray until enough telemetry data has been received to determine a health state.

![Add a health check to an element](../../.gitbook/assets/v45_add_health_check.png)

### Check functions

Each health check caluclated in StackState uses a check function to monitor the telemetry stream attached to the element.

Check functions are scripts that take streaming telemetry as an input, check the data based on its logic and on the supplied arguments and output a health state. The telemetry changes a check function responds to determine the way in which the health check reports element health state, for example by monitoring a metric stream for thresholds and spikes, or checking the generated events. A number of check functions are included out of the box with StackState.

{% hint style="success" "self-hosted info" %}

* You can [create a custom check function](../../develop/developer-guides/custom-functions/check-functions.md) to customize how StackState assigns a health state to a metric stream.

* Details of the available check functions can be found in the StackState UI, go to **Settings** &gt; **Check functions**.
{% endhint %}

#### Windowing method

For metrics check functions, a windowing method and window size must be provided. This determines how often the check function will run based on the incoming metrics. There are two possible windowing methods, batching and sliding.

| Method | Description |
| :--- | :--- |
| **Batching** | The batching windowing method groups metric data into strictly separate windows of the configured window time, with consistent start and end times. For example, with window size set to 60 seconds, a batching check will run every minute with metrics from the previous minute. |
| **Sliding** | The sliding windowing method groups metric data into overlapping windows. For example, with `window size` set to 60 seconds, a sliding check will run whenever the data flows in after 60 seconds of metrics have been collected. Note that runs of the check will adhere to the `Minimum live stream polling interval` configured for the data source. |

#### Check function: Autonomous metric stream anomaly detection

The `Autonomous metric stream anomaly detection` health check reacts to anomaly events and sets the component health state to the `DEVIATING` \(orange\). 

➡️ [Learn more about how to use anomaly health checks](anomaly-health-checks.md).


## Synchronize external health data

{% hint style="success" "self-hosted info" %}

[Synchronize existing health checks](../../configure/health/health-synchronization.md) from an external monitoring system and add them to StackState topology elements.
{% endhint %}

## See also

* [Anomaly health checks](anomaly-health-checks.md)
* [Add a telemetry stream to an element](../metrics-and-events/add-telemetry-to-element.md)
* [Add an event notification](../metrics-and-events/send-event-notifications.md)
* [Custom check functions](../../develop/developer-guides/custom-functions/check-functions.md "StackState Self-Hosted only")
* [Synchronize external health data](../../configure/health/health-synchronization.md "StackState Self-Hosted only")
