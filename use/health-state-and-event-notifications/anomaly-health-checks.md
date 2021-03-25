---
description: How to setup alerting based on anomalies coming from the Autonomous Anomaly Detector.
---

## Overview

{% hint style="info" %}
To use anomaly health checks the [Autonomous Anomaly Detector](../../stackpacks/add-ons/aad.md) StackPack must be installed.
{% endhint %}

The [Autonomous Anomaly Detector (AAD)](../../stackpacks/add-ons/aad.md) looks for deviations in metric streams. It annotates the metric streams with anomalies and emits corresponding anomaly events. The anomaly events can be viewed in the [event perspective](../../use/views/events_perspective.md) and also serve as an input for anomaly health checks. Anomaly health checks react to anomaly events and set the component to the `DEVIATING` (orange) health status. Without an anomaly check a component will never change its health status based on found anomalies.

Anomaly health checks are either automatically placed on components by the StackPacks or can be manually created. After manual creation you can of course automate the creation of such checks, like any other checks, using the [component templates](../../configure/telemetry/telemetry_synchronized_topology.md).

## Manually placing an anomaly check on a component

To create an anomaly check first select a component in a view. To add a check click on the the **+ ADD** button under the health section in the right hand side component details panel. Select the **Autonomous metric stream anomaly detection** as a `Check function`.

![Autonomous metric stream anomaly detection check](../../.gitbook/assets/v43_autonomous_metric_stream_anomaly_detection_check.png)

Select the following arguments:

| Argument Name | Description |
| :--- | :--- |
| anomalyDirection | The direction the found anomaly must have for the check to go to the `DEVIATING` health status.  You can choose from `Rise`, `Drop` or `Any`. Choose `Rise` when you want to detect peaks, for example in a latency metric stream. Choose `Drop` when you want to detect sudden drops, for example in the number of threads free in a thread pool. Choose `Any` to detect both rises and drops, for example when detecting both hot and cold deviations in data center temperature. |
| metricStream | Select a metric stream that is available on the component to detect the anomalies on. |
| event | The event argument will be an instance of an anomaly event that the check will react to. Leave unchanged. |

Then click on the **CREATE** button. The check will now become active. 

## Behavior of the "Autonomous metric stream anomaly detection" check function

 * The `Autonomous metric stream anomaly detection` check will remain in an `UNKNOWN` (gray) health status unless there is a an anomaly found. In that case the check will go to the `DEVIATING` (orange) health status. 
 * Only `HIGH` severity anomalies change the health status of the check to `DEVIATING`.
 * It can take between 5 to 25 minutes before an anomaly is detected depending on the granularity of the metric stream and the size of the anomaly. Only anomalies of several minutes long are considered `HIGH` severity anomalies. 
 * Once an anomaly is found, the `DEVIATING` health status will remain for at least 8 minutes. 
 
## Custom anomaly check functions

Optionally, advanced users of StackState can create their own custom anomaly check functions. More information on custom anomaly check functions, parameters and available fields can be found in the [anomaly check functions](../../develop/developer-guides/anomaly-check-functions.md) section. Note, that you have to adjust an identifier of custom anomaly check function such that it is recognized by Autonomous Anomaly Detector. If you would you like to know more, contact [StackState support](https://support.stackstate.com).

## See also

* [Autonomous Anomaly Detector StackPack](../../stackpacks/add-ons/aad.md)
* [Anomaly check functions](../../develop/developer-guides/anomaly-check-functions.md)
* [Add a health check](add-a-health-check.md)