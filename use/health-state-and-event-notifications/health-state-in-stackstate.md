# Health state in StackState

## Overview

StackState will track a single health state for a given topology element (components and relations) based on information available from the different health checks attached to it. Health checks can be calculated by either [StackState](#stackstate-health-checks) or an [external monitoring system](#external-monitoring-system).

## Health state

A topology element in StackState can have any of the health states listed below:

* Green - `CLEAR` - There is nothing to worry about.
* Orange - `DEVIATING` - Something may require your attention.
* Red - `CRITICAL` - Attention is needed right now, because something is broken.
* Gray - `UNKNOWN` - No health state available.

The element health state is calculated as the most severe state reported by a health check attached to it.

![Health states](/.gitbook/assets/health-states.svg)

## Health Checks

Health checks attached to an element can be calculated internally by StackState or by an external monitoring system. The health state of an element is calculated as the most severe state reported by a health check attached to it.

### StackState health checks

StackState can calculate health checks based on telemetry or log streams defined for a topology element. When telemetry or events data is available in StackState, this approach opens up the possibility to use the Autonomous Anomaly Detector \(AAD\) for anomaly health checks. 

See how to [add a health check](../health-state-and-event-notifications/add-a-health-check.md) and how to [set up anomaly health checks](../health-state-and-event-notifications/anomaly-health-checks.md).

### External monitoring system

Health data from external monitoring systems can be synchronized to StackState as health checks. In this case, health checks are calculated by the external systems based on their own rules and then synchronized with StackState and bound to associated topology elements. This approach is useful if you have existing health checks defined externally, or if it is not viable to send telemetry or events data to StackState and translate the check rules. 

Existing StackPacks will provide health synchronization out of the box. Advanced users can also [set up a custom health synchronization](../../configure/health/health-synchronization.md).


## See also

* [Add a health check based on telemetry streams available in StackState](../health-state-and-event-notifications/add-a-health-check.md)
* Add [Static Health from CSV](/stackpacks/integrations/static_health.md)
* [Set up a health synchronization](../../configure/health/health-synchronization.md)
