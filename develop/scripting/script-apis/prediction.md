---
title: Working with Predictions
kind: Documentation
description: Functions for predicting data available in StackState.
---

# Script API: Prediction


{% hint style="warning" %}
**This page describes StackState version 4.x.**

The StackState 4.0 version range is End of Life (EOL) and **no longer supported**. We encourage customers still running the 4.0 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Function: `predictMetrics`

Predict metrics for any metric query coming from any data source.

**Args:**

* `predictorName` - name of prediction preset. Current available predictors: `linear`, `hmn` and `fft`.
* `horizon` - how much future to predict. The horizon is specified in the [duration format](https://github.com/StackVista/stackstate-docs/tree/e2f9fce29a1e9eddeb4327ce7f8f25a8ab5ce870/develop/scripting/script-apis/scripting/script-apis/time.md).
* `query` - what metrics to use for the prediction. The query can be created using the `Telemetry.query()` function followed by `.compileQuery()`. The telemetry query has to return metrics.

**Builder methods:**

* `predictionPoints(points: Int)` - the number of points to the horizon.
* `includeHistory(start?: Instant, end?: Instant)` - call this builder method to include the result of the `query` in the return value. Optionally a start and end can be added to limit the included history using the [instant format](https://github.com/StackVista/stackstate-docs/tree/e2f9fce29a1e9eddeb4327ce7f8f25a8ab5ce870/develop/scripting/script-apis/scripting/script-apis/time.md). When not specifying the start and end the whole history will be included.

**Return type:**

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

