---
description: StackState Self-hosted v4.5.x
---

{% hint style="info" %}
These are the docs for the StackState Self-hosted product. [Go to the StackState SaaS docs site](https://docs.stackstate.com/v/stackstate-saas/).
{% endhint %}

# Prediction - script API

## Function: `predictMetrics`

Predict metrics for any metric query coming from any data source.

**Args:**

* `predictorName` - the prediction preset to use: 
  * **fft** - Fast Fourier Transformation. Used for seasonal metrics with a repeatable pattern that has a cycle.
  * **linear** - Used for metrics that have a linear trend.
  * **hmn** - Harmonic Mean Normal. Used in difficult cases when metrics are not clearly seasonal or linear.
* `horizon` - How much future to predict. The horizon is specified in [duration format](time.md).
* `query` - The metrics to use for the prediction. A telemetry query that returns metrics, created using the `Telemetry.query()` function followed by `.compileQuery()`.

**Builder methods:**

* `predictionPoints(points: Int)` - the number of points to the horizon.
* `includeHistory(start?: Instant, end?: Instant)` - call this builder method to include the result of the `query` in the return value. Optionally a start and end can be added to limit the included history using the [instant format](time.md). When not specifying the start and end the whole history will be included.

**Return type:**

`AsyncScriptResult[PredictionResponse]`

A `PredictionResponse`, which contains the following fields:

Fields:

* `PredictionResponse.request` - the request made to the prediction API of type `PredictionRequest`.
* `PredictionResponse.history` - optional, the history used for prediction of type `MetricTelemetry`. Empty if `.includeHistory()` was not used.
* `PredictionResponse.prediction` - the predicted metrics.

The `PredictionRequest` type has the following fields:

* `PredictionRequest.query` - the query provided to `predictMetrics`.
* `PredictionRequest.predictor` - the name and configuration of the predictor.
* `PredictionRequest.horizon` - the prediction horizon.
* `PredictionRequest.predictionPointCount` - the number of predicted points.
* `PredictionRequest.historyResponse` - options of the history response.

The `MetricTelemetry` has the following fields:

* `MetricTelemetry.result.data` - the two dimensional array with values and time stamps.

**Examples:**

Predict 8 points of disk utilization for `myHost` for the next four hours based on the last four weeks of data:

```text
Prediction.predictMetrics("linear", "4h",
    Telemetry.query("MyDatasource", 'host="myHost" and name="diskutil"')
        .metricField("value")
        .start("-4w")
        .compileQuery()
).includeHistory().predictionPoints(8)
```

