---
description: StackState Self-hosted v5.0.x
---

# Scaling the Autonomous Anomaly Detector

Anomaly detection is a CPU bound process and typically there are many more metric streams than can be handled in (near) real-time.  The AAD uses prioritization to most effectively allocate the allotted resources to the most important streams.  But how many resources must be given to the AAD is dependent on the number of metric streams that are present and the way anomalies are used to investigate problems.

This document explains how to allocate resources for the AAD and provides guidance on how to use metrics to determine if an installation is performing well.

## Setting the number of workers

The AAD consists of two types of pods, a (singleton) manager pod and a configurable number of worker pods.  The manager handles all non-cpu-intensive tasks, such as maintaining the work queue and persisting model state.  Workers run model selection, training and (near) real-time anomaly detection.  They fetch their data from stackstate and report back any found anomalies (or their absence).

The number of workers and their individual resource requirements can be configured in the deployment `values.yaml`.  The snippet below contains the default values; adjust these to scale out (`replicas`) or up (`cpu.limit`, `cpu.request`).

{% tabs %}
{% tab title="values.yaml" %}
```text
# number of worker replicas
replicas: 1
cpu:
  # cpu.limit -- CPU resource limit
  limit: 4
  # cpu.request -- CPU resource request
  request: 4
```
{% endtab %}
{% endtabs %}

## Evaluating effective use of resources

One of the most important uses of anomalies in the StackState product is in [anomaly health checks](../../use/health-state/anomaly-health-checks.md).  To determine if the AAD is putting the resources to good use, we will use the following metrics:

* **Streams with anomaly checks** - the number of metric streams that have an anomaly health check defined on them
* **Checked streams** - the number of metric streams that have their latest data points checked

The streams with an anomaly check have the highest priority in the AAD.  All anomaly health checks are updated on time when the number of **Checked streams** is higher than the number of **Streams with anomaly checks**.

We can get these metrics from StackState using the CLI:

```text
sts metric get <multi_metrics_id> -t stackstate.spotlight_streams_with_anomaly_check -f anomaly_health_checks.csv
sts metric get <multi_metrics_id> -t stackstate.spotlight_streams_checked -f checked.csv
```

Here `<multi_metrics_id>` is the ID for the "StackState Multi Metrics" datasource (`sts datasource list`).

Both files contain a timeseries with 1024 data points by default, which can e.g. be used to compute the ratio of the number of checked streams and the number of health checks:

```text
CHECKED=$(awk -F"," 'NR!=1 {Total=Total+$2} END{print Total}' < checked.csv)
HEALTH_CHECKS=$(awk -F"," 'NR!=1 {Total=Total+$2} END{print Total}' < anomaly_health_checks.csv)
RATIO=$(echo "$CHECKED / $HEALTH_CHECKS" | bc -l)
printf "%.3f\n" $RATIO
```

When this ratio is larger than 1, the anomaly health checks are updated in near real-time.
