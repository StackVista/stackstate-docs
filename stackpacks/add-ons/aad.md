---
description: StackState Self-hosted v4.6.x
---

# Autonomous Anomaly Detector

## Overview

Anomaly detection identifies abnormal behavior in your fast-changing IT environment. This helps direct the attention of IT operators to the root cause of problems or can provide an early warning. The Autonomous Anomaly Detector (AAD) requires zero configuration. It is fully autonomous in selecting both the metric streams it will apply anomaly detection to, and the appropriate machine learning algorithms to use for each metric stream.

{% hint style="info" %}
Note that a [training period](aad.md#training-period) is required before the AAD can begin to report anomalies.
{% endhint %}

### The anomaly detection process

The Autonomous Anomaly Detector (AAD) is enabled as soon as the [AAD StackPack has been installed](aad.md#install-the-aad-stackpack) in StackState. When the AAD has been enabled, metric streams are identified and analyzed in search of any anomalous behavior based on their past. After the initial training period, detected anomalies will be reported in the following way:

* The identified anomaly is given a [severity](aad.md#anomaly-severity) (HIGH, MEDIUM or LOW).
* The anomaly and time period during which anomalous behaviour was detected are shown on the associated metric stream chart. The color indicates the anomaly severity.
* If the anomaly is considered to have a severity level of HIGH, an [anomaly event](aad.md#anomaly-events) is generated.

### Anomaly severity

Each identified anomaly is given a severity. This can be HIGH, MEDIUM or LOW. The severity shows how far a metric point has deviated from the expected model and the length of time for which anomalous data has been observed.

| Severity | Description |
| :--- | :--- |
| 🟥 **HIGH** (red) | Reported only when data points with a low probability of occurrence are observed for at least 3 minutes. The least frequently reported severity. [Generates an anomaly event](aad.md#anomaly-events). |
| 🟧 **MEDIUM** (orange) | Reported for anomalous data observed for a short period of time or slightly anomalous data observed for a longer period of time. Reported less frequently than LOW severity and more frequently than HIGH severity anomalies. Useful for root cause analysis and can offer additional insight into HIGH severity anomalies reported on the stream. |
| 🟨 **LOW** (yellow) | Reported when slightly anomalous data is observed. The most frequently reported anomaly severity. Less frequent occurrences of LOW severity anomalies indicates a higher reliability of anomaly reports from the AAD. |

![HIGH, MEDIUM and LOW severity anomalies](/.gitbook/assets/v46_anomaly_severity_inspector.png)

### Anomaly events

When a HIGH severity anomaly is detected on a metric stream, a `Metric Stream Anomaly` event is generated. Anomaly events are listed on the Events Perspective and will also be reported as one of the [Probable Causes for any associated problem](../../use/problem-analysis/problem_investigation.md#probable-causes). Clicking on the event will open the Event Details pane on the right-hand side of the screen.

![Metric stream anomaly event details pane](../../.gitbook/assets/v46_event_metric_stream_anomaly.png)

* **Metric Stream** - The name of the metric stream on which the anomaly was detected.
* **Severity** - The [anomaly severity](#anomaly-severity). Anomaly events are only generated for HIGH severity anomalies.
* **Metric chart** - A chart with an extract from the metric stream centered around the detected anomaly.
* **Anomaly interval** - The time period during which anomalous behaviour was detected. This is also shaded on the metric chart.
* **Description** - A description of the observed anomaly.
* **Elements** - The name of the element (or elements) on which the metric stream is attached

## Anomaly feedback

The Autonomous Anomaly Detector selects and optimizes a model for each metric stream.  How well the model describes the stream determines to a large extent the quality of the reported anomalies.  Streams with a high false positive rate need better models.  To develop new models and optimize the hyperparameters for selection and (online) training, StackState uses representative datasets.  You can (dis)like anomalies in the [telemetry inspector](../../use/metrics-and-events/browse-telemetry) and export the feedback using the CLI (see below).  The data you selected in this way becomes part of the datasets and will be better supported in the next release, when you send it to StackState.

The feedback sent to StackState consists of:
* **Thumbs-up, Thumbs-down** votes - Each user can cast one vote
* **Comments** - Free-form text entered by users
* **Anomaly details** - The description, interval, severity (score), model information, metric query and element, stream names
* **Metric data** - Data from the metric stream leading up to the anomaly.

### Exporting feedback

An export of the feedback on anomalies can be made with the CLI:

```text
# Export feedback on anomalies in the last 7 days,
# with 1 day worth of metric data for each anomaly
sts anomaly feedback --start-time=-7d > feedback.json

# Export feedback on anomalies from 10 to 2 days ago,
# with 3 days worth of metric data for each anomaly
sts anomaly feedback --start-time=-10d --end-time=-2d --history=3d > feedback.json
```

{% hint style="warning" %}
User comments are included in the exported feedback.  These are very useful, but should not contain any sensitive information.
{% endhint %}

## Installation
    
### Prerequisites[](http://not.a.link "StackState Self-Hosted only")

* The AAD StackPack can only be installed within a [Kubernetes setup](../../setup/install-stackstate/kubernetes_install/ "StackState Self-Hosted only"). Please make sure that this is supported by your StackState installation.
* It is also possible to [install the AAD standalone](../../setup/install-stackstate/kubernetes_install/aad_standalone.md "StackState Self-Hosted only") within Kubernetes.
* If you are not sure that you have a Kubernetes setup or would you like to know more, contact [StackState support](https://support.stackstate.com/hc/en-us "StackState Self-Hosted only").

### Install the AAD StackPack

To install the AAD StackPack, simply press the INSTALL button. No other actions need to be taken. A [training period](aad.md#training-period) is required before AAD can begin to report anomalies.

### Training period

The AAD will need to train on your data before it can begin reporting anomalies. With data collected in 1 minute buckets, the AAD requires a 2 hour training period. If historic data exists for relevant metric streams, this will also be used for training the AAD. In this case, the first results can be expected within an hour.  Up to a day of data is used for training.  After the initial training, the AAD will continuously refine its model and adapt to changes in the data.

## Frequently Asked Questions

### How are metric streams selected?

The AAD scales to large environments by autonomously prioritizing metric streams based on its knowledge of the 4T data model and user feedback. The metric stream selection algorithm ranks metric streams based on the criteria below:

* The top ranking is given to metric streams with [anomaly health checks](../../use/health-state/anomaly-health-checks.md).
* Components in views that have the most stars by the most users are ranked highest.
* From those components, the metric streams with the highest priorities are ranked highest. See [how to set the priority for a stream](../../use/metrics-and-events/set-telemetry-stream-priority.md).
* Anomaly detection will be disabled on streams if more than 20% of their time is flagged as anomalous.

You cannot directly control the stream selected, but you can steer the metric stream selection of the AAD by manipulating the above-mentioned factors.

{% hint style="success" "self-hosted info" %}

Know what the AAD is working on. [The status UI of the AAD](/setup/install-stackstate/kubernetes_install/aad_standalone.md#troubleshooting) provides various metrics and indicators, including details of what the AAD is currently doing.
{% endhint %}

### How fast are anomalies detected?

After an initial [training period](aad.md#training-period), the AAD ensures that prioritized metric streams are checked for anomalies in a timely fashion. Anomalies occurring in the highest prioritized metric streams are detected within about 5 minutes.

### Can anomalies trigger alerts?

Yes. The AAD itself does not alert on anomalies found, but [anomaly health checks](../../use/health-state/anomaly-health-checks.md) can be added to components to automatically change the health status of the component to `DEVIATING`. This health state change event can then trigger notifications by [adding an event handler](../../use/stackstate-ui/views/manage-event-handlers.md) to a view.

## Uninstall

To uninstall the AAD StackPack, simply press the UNINSTALL button. No other actions need to be taken.

## Release Notes

**Autonomous Anomaly Detector StackPack v0.9.2 (02-04-2021)**

* Common version bumped from 2.4.3 to 3.0.0
* StackState min version bumped to 4.3.0

## See also

* [Anomaly detection](../../use/concepts/anomaly-detection.md)
* [Anomaly health checks](../../use/health-state/anomaly-health-checks.md)
