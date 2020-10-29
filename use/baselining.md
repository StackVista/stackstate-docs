---
description: How to configure anomaly detection with baselines.
---

# Anomaly Detection with Baselines

Baselines are a way to detect anomalies in metric streams. Generally speaking, an anomaly is detected when a metric stream exceeds its baseline boundaries. A baseline consists of a lower and upper boundary. It forms a band that the metric, under normal conditions, is expected to remain inside of. Baselines are initially derived from historical data, but continuously update as new data flows in. Thus when an anomaly occurs, the baseline gradually updates to take the anomaly into account.

![Baseline example](/.gitbook/assets/baseline_example.png)

## How baselining works

The process for detecting anomalies using baselines consists out of two steps:

1. A `baseline` enriches a metric stream with a baseline. The metric stream is transformed into a `baseline metric stream`. Baselines are continuously calculated by baseline functions based on given the batch size.
2. A `check` determines the health state of a component or relation based on the metrics in the metric stream and its baseline. Once a metric stream is a baseline metric stream, check functions that support such baseline metric streams are available for selection.

## Configuring a baseline for a metric stream

To configure a baseline for a metric stream go to the metric stream on a component or relation and select "add baseline" from the metric stream context menu \(accessed through the triple dots next to the name of the metric stream\).

## Baseline dialog

In the baseline dialog fill in the following values:

| Field name | Description |
| :--- | :--- |
| Name | Give a name for later reference to the baseline. |
| Description | \(Optional\) Any description for the baseline. |
| Aggregation | Determines the way metrics are aggregated before being fed to the baseline function for determining the baseline. This can only be modified through modifying the metric stream itself. |
| Batch size | Determines how often the metrics are aggregated before being fed to the baseline function. |
| Baseline function | Choose any of the provided baseline functions for different types of baseline calculation. Read below about the pros and cons of each baseline function. |
| Arguments | These values are specific to the baseline function. The arguments are listed per baseline function below |

### Preview

Below the horizontal line you can run a preview of the baseline, so you may tune it to your liking. Select a time range for the preview and press the preview button.

## Baseline functions

Baseline functions are configurable in StackState and can be coded in the [StackState Scripting Language](/develop/scripting/). By default the following baseline functions are supplied:

### Function: Stationary Auto-Tuned Baseline

{% hint style="info" %}
This is always a good default choice; it works well for stationary as well as seasonal metrics.
{% endhint %}

This baseline functions works well for stationary metrics \(e.g. data center temperature, average response time, error count\). Under the hood it uses the Exponential Weighted Moving Average \(EWMA\) algorithm, but auto-tunes that algorithm itself.

**Pros:**

* Works reasonably well for stationary as well as seasonal metrics given any distribution of the metric stream.
* Requires no knowledge of the underlying algorithm.

**Cons:**

* Does not assume seasonality. It does not assume yesterday looks similar to today or that any such seasonal patterns should occur.
* Very little control.

**Arguments**:

| Argument Name | Type | Description |
| :--- | :--- | :--- |
| sensitivity | Integer between 0 and 100 | Sensitivity controls the smoothing of the EWMA algorithm. High sensitivity \(max 100\) means the baseline will quickly change shape when new metrics flow in, thus resulting in fewer anomalies. Low sensitivity means the baseline will be slower in changing shape, thus resulting in more anomalies. |
| history | Duration | The amount of time needed for the baseline function to learn an initial baseline. 1 day typically is enough. The choice for a different fundamental period does not affect the algorithm, only the amount of initial data needed for calculating the baseline. |

### Function: Median Absolute Deviation

This baseline functions work well for seasonal metrics \(e.g. logged in user count, online orders placed per minute\). It assumes that the metrics of the last days or last weeks \(fundamental period\) are similar to those of today or this week.

**When to choose?**

When dealing with metric streams which are seasonal either by day or week. It also works reasonably well for stationary metrics, but it is not the recommended baseline function for stationary metrics.

**Pros:**

* Works reasonably well for seasonal as well as stationary metric streams.

**Cons:**

* Assumes daily or weekly patterns. If such patterns are not there this algorithm will not produce good results.
* Assumes the data is normally distributed.
* You have to specify the fundamental period yourself instead of that being auto detected.
* For weekly patterns requires a lot of data.

**Arguments**:

| Argument Name | Type | Description |
| :--- | :--- | :--- |
| Fundamental period | Day / Week | Whether the baseline function should assume self-similarity in terms of days or weeks. Set to days if each day looks similar to every other day. Set to weeks if every weekday looks similar to the every other weekday \(every Monday looks similar to next Monday, every Tuesday looks similar to next Tuesday, etc.\) |
| Training window | Duration | The amount of fundamental periods to learn from. Four or more is recommended. |

### Function: Stationary Customizable Baseline based on EWMA

This baseline functions works well for stationary metrics \(e.g. data center temperature, average reponse time, error count\). It uses the Exponential Weighted Moving Average \(EWMA\) algorithm. It is the same as the `Stationary Auto-Tuned Baseline`, but leaves the tuning up to you.

**Pros:**

* Works well for seasonal as well as stationary metric streams given any distribution of the metric stream.
* Provide a lot of controls for tuning.

**Cons:**

* Tuning requires knowledge of both the algorithm as well as domain knowledge about the metrics stream.
* Does not assume seasonality. It does not assume yesterday looks similar to today or that any such seasonal patterns should occur.

**Arguments**:

| Argument Name | Type | Description |
| :--- | :--- | :--- |
| history | Duration | The amount of time needed for the baseline function to learn an initial baseline. 1 day typically is enough. The choice for a different fundamental period does not affect the algorithm, only the amount of initial data needed for calculating the baseline. |
| historyLimit | Integer | \(Optional\) The size of the moving history. Default is `64`. |
| lowerControlLimit | Float | \(Optional\) a multiple of the standard deviation that establishes the lower boundary. Default is `3.0`. |
| upperControlLimit | Float | \(Optional\) a multiple of the standard deviation that establishes the upper boundary. Default is `3.0`. |
| lowerSlack | Float | \(Optional\) a value that is always subtracted from the lower boundary. Default is `0.0`. |
| upperSlack | Float | \(Optional\) a value that is always added to the upper boundary. Default is `0.0`. |
| smoothing | Float - value between 0.0 and 1.0 | \(Optional\) Discount rate of ewma. Determines how fast the baseline reacts to changes in the metrics. Default is `0.3`. |

## Checking for anomalies on a baseline metric stream

Once you've added a baseline to a metric stream and you see the baseline bounds drawn on top the metric stream chart you can now configure a check to alert on anomalies.

1. On the component/relation details pane with the baseline metric stream on it, click on the "add" button next to "health", so as to create a new health check.
2. Select the `Detect anomaly by checking if the metric values are within upper and lower deviation bounds` check function.
3. Select the baseline metric stream you want to check for anomalies.
4. Select a critical and deviating value. The values are floating point values that indicate with what factor how far the metric stream may exceed the baseline. For example:
   * `deviatingValue = 1.0` - if the metric exceeds the baseline that the check will go to the `DEVIATING` health state. 
   * `criticalValue = 1.25` - if the metric exceeds the baseline by 125% that the check will go to the `CRITICAL` health state.
5. Click `create` to add the check.

{% hint style="info" %}
Once you've added the check function it may take 5 or more minutes \(dependent on the baseline batch size\) before the check changes health state.
{% endhint %}

Alerting on checks based on baseline metric streams works exactly the same as with other checks.

