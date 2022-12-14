---
description: StackState Self-hosted v5.1.x
---

# Scale the AAD up and down

## Overview

Anomaly detection is a CPU bound process and typically there are many more metric streams than can be handled in (near) real-time. The AAD uses prioritization to most effectively allocate the allotted resources to the most important streams. But how many resources must be given to the AAD is dependent on the number of metric streams that are present and the way anomalies are used to investigate problems.

This page explains how to allocate resources for the AAD and determine if an installation is performing well. In particular, we show how to use metrics on anomaly health checks to do this.

## Set the number of workers

The AAD consists of two types of pods:

* A (singleton) manager pod that handles all non-CPU-intensive tasks, such as maintaining the work queue and persisting model state.
* A configurable number of worker pods that run model selection, training and (near) real-time anomaly detection. Workers fetch their data from StackState and report back any found anomalies (or their absence).

The number of workers and their individual resource requirements can be configured in the deployment `values.yaml`. The snippet below includes the default values, adjust these to scale out (`replicas`) or to up (`cpu.limit`, `cpu.request`).

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

For most cases, this snippet should be added to the `values.yaml` file used to deploy [StackState](/setup/install-stackstate/kubernetes_openshift/kubernetes_install.md).

## Evaluate use of resources

One of the most important uses of anomalies in the StackState product is in [anomaly health checks](../../use/checks-and-monitors/anomaly-health-checks.md). The following metrics can be used to determine if the AAD is putting the available resources to good use:

* **Checked streams** - the number of metric streams that have their latest data points checked.
* **Streams with anomaly checks** - the number of metric streams that have an anomaly health check defined on them.

As streams with an anomaly check have the highest priority in the AAD, these metrics can be retrieved and compared to determine whether sufficient resources have been allocated to the AAD:

1. In the StackState UI, open the main menu on the left and go to the [Analytics environment](/use/stackstate-ui/analytics.md).

2. Use this query to plot the number of streams checked over the last 6 hours:

    ```java
    Telemetry
      .query("StackState Metrics", "")
      .metricField("stackstate.spotlight_streams_checked")
      .start("-6h")
    ```

3. Use this query to plot the number of streams with an anomaly health check defined:

    ```java
    Telemetry
      .query("StackState Metrics", "")
      .metricField("stackstate.spotlight_streams_with_anomaly_check")
      .start("-6h")
    ```

4. Compare the number of checked streams and the number of streams with anomaly health checks defined:
   * When the number of checked streams is **HIGHER** than the number of streams with an anomaly health check defined, sufficient resources have been allocated. All anomaly health checks are updating on time.
   * When the number of checked streams is **LOWER** than the number of streams with an anomaly health check defined, [more resources should be allocated to the AAD](#set-the-number-of-workers).
