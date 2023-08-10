---
description: StackState Kubernetes Troubleshooting
---

# Explore metrics

Execute any PromQL query using the metrics explorer. The query result is shown in a chart for the selected time range and in table form showing the last value for each time serie.

<TODO add screenshot>

## PromQL queries

The query input field has auto-suggestions for metric names, label names and values, and supported PromQL functions. See the Prometheus documentation for a complete [PromQL guide and reference](https://prometheus.io/docs/prometheus/latest/querying/basics/). StackState also adds 2 default parameters that can be used in any query: `${__interval}` and `${__rate_interval}`. They can be used to scale the aggregation interval automatically with the chart resolution ([more details](/use/metrics/k8s-writing-promql-for-charts.md)).

## See also

* [Writing PromQL queries for representative charts](/use/metrics/k8s-writing-promql-for-charts.md)
* [PromQL documentation](https://prometheus.io/docs/prometheus/latest/querying/basics/)
* [PromQL operators](https://prometheus.io/docs/prometheus/latest/querying/operators/)
* [PromQL functions](https://prometheus.io/docs/prometheus/latest/querying/functions/)