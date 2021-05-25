# Health state in StackState

## Overview

StackState will track a single health state for a given topology element (components and relations) based on the information from the different health checks attached to it. The health state of a topology element can have any of the health states listed below:

* Green - `CLEAR` - There is nothing to worry about.
* Orange - `DEVIATING` - Something may require your attention.
* Red - `CRITICAL` - Attention is needed right now, because something is broken.
* Gray - `UNKNOWN` - The view does not have a view health state.

Health checks attached to an element can be calculated by StackState or by an existing monitoring system.

| Health check | Description |
|:--|:--|
| **Calculated by StackState** | The health check is calculated by StackState based on telemetry or log streams defined for the topology element. This is useful when the telemetry or events data is available in StackState. It also opens up the possibility to use the Autonomous Anomaly Detector \(AAD\) and [anomaly health checks](../health-state-and-event-notifications/anomaly-health-checks.md). See how to [add a health check](../health-state-and-event-notifications/add-a-health-check.md). |
| **Calculated by an existing monitoring solution**  | The health check is calculated by an external monitoring system based on its own rules and then synchronized to StackState. This is useful if you have existing health checks defined and calculated externally or if it is not viable to send telemetry or events data to StackState and translate the check rules. See how to [set up a health synchronization](../../configure/health/health-synchronization.md). |


## See also

* [Add a health check](../health-state-and-event-notifications/add-a-health-check.md)
* [Set up a health synchronization](../../configure/health/health-synchronization.md)
