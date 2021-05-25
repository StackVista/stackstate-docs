# Health state in StackState

## Overview

StackState will track a single health state for a given topology element (components and relations) based on information available from the different health checks attached to it. Health checks can be calculated by either [StackState](#stackstate-health-checks) or an [external monitoring system](#external-monitoring-system).

## Health state

A topology element in StackState can have any of the health states listed below:

* Green - `CLEAR` - There is nothing to worry about.
* Orange - `DEVIATING` - Something may require your attention.
* Red - `CRITICAL` - Attention is needed right now, because something is broken.
* Gray - `UNKNOWN` - No health state available.

![Health states](/.gitbook/assets/health-states.svg)

## Health Checks

Health checks attached to an element can be calculated by StackState or by an external monitoring system.

### StackState health checks

StackState can calculate health check based on telemetry or log streams defined for a topology element. This approach is useful if the telemetry or events data is available in StackState as it opens up the possibility to use the Autonomous Anomaly Detector \(AAD\). See how to [add a health check](../health-state-and-event-notifications/add-a-health-check.md) and how to set up [anomaly health checks](../health-state-and-event-notifications/anomaly-health-checks.md).

### External monitoring system

Health checks calculated by an external monitoring solution based on its own rules can be synchronized to StackState. This approach is useful if you have existing health checks defined and calculated externally, or if it is not viable to send telemetry or events data to StackState and translate the check rules. See how to [set up a health synchronization](../../configure/health/health-synchronization.md).


## See also

* [Add a health check](../health-state-and-event-notifications/add-a-health-check.md)
* [Set up a health synchronization](../../configure/health/health-synchronization.md)
