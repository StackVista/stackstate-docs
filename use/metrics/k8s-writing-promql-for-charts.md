---
description: StackState Kubernetes Troubleshooting
---

# Writing PromQL queries for representative charts

## Guidelines

When StackState shows data in a chart it almost always needs to change the resolution of the stored data to make it fit into the available space for the chart. To get the most representative charts possible follow these guidelines:

* Don't query for the raw metric but always aggregate over time (using `*_over_time` or `rate` functions).
* Use the `${__interval}` parameter as the range for aggregations over time, it will automatically adjust with the resolution of the chart
* Use the `${__rate_interval}` parameter as the range for `rate` aggregations, it will also automatically adjust with the resolution of the chart but takes into account specific behaviors of `rate`.

Applying an aggregation often means that a trade-off is made to emphasize certain patterns in metrics more than others. For example, for large time windows `max_over_time` will show all peaks, but it won't show all troughs. While `min_over_time` does the exact opposite and `avg_over_time` will smooth out both peaks and troughs. To show this behavior, here is an example metric binding using the CPU usage of pods. To try it yourself, copy it to a YAML file and use the [CLI to apply it](./k8s-add-charts.md#create-or-update-the-metric-binding-in-stackstate) in your own StackState (you can remove it later).

```
nodes:
- _type: MetricBinding
  chartType: line
  enabled: true
  tags: {}
  unit: short
  name: CPU Usage (different aggregations and intervals)
  priority: HIGH
  identifier: urn:custom:metric-binding:pod-cpu-usage-a
  queries:
    - expression: sum(max_over_time(container_cpu_usage{cluster_name="${tags.cluster-name}", namespace="${tags.namespace}", pod_name="${name}"}[${__interval}])) by (cluster_name, namespace, pod_name) /1000000000
      alias: max_over_time dynamic interval
    - expression: sum(min_over_time(container_cpu_usage{cluster_name="${tags.cluster-name}", namespace="${tags.namespace}", pod_name="${name}"}[${__interval}])) by (cluster_name, namespace, pod_name) /1000000000
      alias: min_over_time dynamic interval
    - expression: sum(avg_over_time(container_cpu_usage{cluster_name="${tags.cluster-name}", namespace="${tags.namespace}", pod_name="${name}"}[${__interval}])) by (cluster_name, namespace, pod_name) /1000000000
      alias: avg_over_time dynamic interval
    - expression: sum(last_over_time(container_cpu_usage{cluster_name="${tags.cluster-name}", namespace="${tags.namespace}", pod_name="${name}"}[${__interval}])) by (cluster_name, namespace, pod_name) /1000000000
      alias: last_over_time dynamic interval
    - expression: sum(max_over_time(container_cpu_usage{cluster_name="${tags.cluster-name}", namespace="${tags.namespace}", pod_name="${name}"}[1m])) by (cluster_name, namespace, pod_name) /1000000000
      alias: max_over_time 1m interval
    - expression: sum(min_over_time(container_cpu_usage{cluster_name="${tags.cluster-name}", namespace="${tags.namespace}", pod_name="${name}"}[1m])) by (cluster_name, namespace, pod_name) /1000000000
      alias: min_over_time 1m interval
    - expression: sum(avg_over_time(container_cpu_usage{cluster_name="${tags.cluster-name}", namespace="${tags.namespace}", pod_name="${name}"}[1m])) by (cluster_name, namespace, pod_name) /1000000000
      alias: avg_over_time 1m interval
    - expression: sum(last_over_time(container_cpu_usage{cluster_name="${tags.cluster-name}", namespace="${tags.namespace}", pod_name="${name}"}[1m])) by (cluster_name, namespace, pod_name) /1000000000
      alias: last_over_time 1m interval
  scope: (label = "stackpack:kubernetes" and type = "pod")
```

After applying it, open the metrics perspective for a pod in StackState (preferably a pod with some spikes and troughs in CPU usage). Enlarge the chart using the icon in its top-right corner to get a better view. Now you can also change the time window to see what the effects are from the different aggregations (30 minutes vs 24 hours for example). 

{% hint style="warning %}
When the metric binding doesn't specify an aggregation StackState will automatically use the `last_over_time` aggregation to reduce the number of data points for a chart. See also [Why is this necessary?](./k8s-writing-promql-for-charts.md#why) for an explanation.
{% endhint %}

![The chart for this metric binding for the last 30m, there are only a few lines in the chart visible because most time series are on top of each other](../../.gitbook/assets/k8s/metric-aggregation-differences-30m.png)
![The same chart, same component and same end time, but now for the last 24h. It shows, sometimes completely, different results for the different aggregations](../../.gitbook/assets/k8s/metric-aggregation-differences-24h.png)

## Why is this necessary?

First of all, why should you use an aggregation? It doesn't make sense to retrieve more data points from the metric store than fit in the chart. Therefore StackState automatically determines the step needed between 2 data points to get a good result. For short time windows (for example a chart showing only 1 hour of data) this results in a small step (around 10 seconds). Metrics are often only collected every 30 seconds, so for 10 second steps the same value will repeat for 3 steps before changing to the next value. Zooming out to a 1 week time window, will require a much bigger step (around 1 hour, depending on the exact size of the chart on screen).

When the steps become larger than the resolution of the collected data points, a decision needs to be made on how to summarize the data points of the 1 hour time range into a single value. When an aggregation over time is already specified in the query, it will be used to do that. However, if no aggregation is specified, or when the aggregation interval is smaller than the step, the `last_over_time` aggregation is used, with the `step` size as the interval. The result is that only the last data point for each hour is used to "summarize" the all data points in that hour.

To summarize, when executing a PromQL query for a time range of 1 week with a step of 1 hour this query:

```
container_cpu_usage /1000000000
```

is automatically converted to:

```
last_over_time(container_cpu_usage[1h]) /1000000000
```

Try it for yourself on the [StackState playground](https://play.stackstate.com/#/metrics?promql=last_over_time%28container_cpu_usage%7Bnamespace%3D%22sock-shop%22%2C%20pod_name%3D~%22carts.%2A%22%7D%5B%24%7B__interval%7D%5D%29%20%2F%201000000000&timeRange=LAST_7_DAYS).

![Last over time](../../.gitbook/assets/k8s/k8s-metric-queries-for-chart-last-over-time.png)
![Max over time with fixed range](../../.gitbook/assets/k8s/k8s-metric-queries-for-chart-max-over-time-fixed-range.png)
![Max over time with automatic range](../../.gitbook/assets/k8s/k8s-metric-queries-for-chart-max-over-time-interval.png)

Often this behavior isn't intended and it's better to decide for yourself what kind of aggregation is needed. Using different aggregation functions it's possible to emphasize certain behavior (at the cost of hiding other behavior). Is it more important to see peaks, troughs, a smooth chart etc.? Then use the `${__interval}` parameter for the range as it's automatically replaced with the `step` size used for the query. The result is that all the data points in the step are used.

![A fixed range, shorter than the data resolution](../../.gitbook/assets/k8s/k8s-metric-queries-small-range.png)
![Automatic range, based on step but with a lower limit](../../.gitbook/assets/k8s/k8s-metric-queries-interval-for-range.png)

The `${__interval}` parameter prevents another issue. When the `step` size and therefore the `${__interval}` value, would shrink to a smaller size than the resolution of the stored metric data this would result in gaps in the chart. 

Therefore `${__interval}` will never shrink smaller than the 2* the default scrape interval (default scrape interval is 30 seconds) of the StackState agent.

Finally the `rate()` function requires at least 2 data points to be in the interval to calculate a rate at all. With less than 2 data points the rate won't have a value. Therefore  `${__rate_interval}` is guaranteed to always be at least 4 * the scrape interval. This guarantees no unexpected gaps or other strange behavior in rate charts, unless data is missing.

There are some excellent blog posts on the internet that explain this in more detail:

* [Step and query range](https://www.robustperception.io/step-and-query_range/)
* [What range should I use with rate()?](https://www.robustperception.io/what-range-should-i-use-with-rate/)
* [Introduction of __rate_interval in Grafana](https://grafana.com/blog/2020/09/28/new-in-grafana-7.2-__rate_interval-for-prometheus-rate-queries-that-just-work/)

## See also

Some more resources on understanding PromQL queries:

* [Anatomy of a PromQL Query](https://promlabs.com/blog/2020/06/18/the-anatomy-of-a-promql-query/)
* [Selecting Data in PromQL](https://promlabs.com/blog/2020/07/02/selecting-data-in-promql/)
* [How to join multiple metrics](https://iximiuz.com/en/posts/prometheus-vector-matching/)
* [Aggregation over time](https://iximiuz.com/en/posts/prometheus-functions-agg-over-time/)
