# Health state in StackState

## Overview

StackState will track a single health state for a given topology element (components and relations) based on information available from the different health checks attached to it. Health checks can be calculated by either [StackState](#stackstate-health-checks) or an [external monitoring system](#external-monitoring-system).

## Element health state

A topology element in StackState can have any of the health states listed below:

* Green - `CLEAR` - There is nothing to worry about.
* Orange - `DEVIATING` - Something may require your attention.
* Red - `CRITICAL` - Attention is needed right now, because something is broken.
* Gray - `UNKNOWN` - No health state available.

The element health state is calculated as the most severe state reported by a health check attached to it.

![Health states](/.gitbook/assets/health-states.svg)

## Element health checks

Health checks attached to an element can be calculated internally by StackState or by an external monitoring system. The health state of an element is calculated as the most severe state reported by a health check attached to it.

### StackState health checks

StackState can calculate health checks based on telemetry or log streams defined for a topology element. When telemetry or events data is available in StackState, this approach opens up the possibility to use the Autonomous Anomaly Detector \(AAD\) for anomaly health checks. 

See how to [add a health check](../health-state-and-event-notifications/add-a-health-check.md) and how to [set up anomaly health checks](../health-state-and-event-notifications/anomaly-health-checks.md).

### External monitoring system

Health data from external monitoring systems can be synchronized to StackState as health checks. In this case, health checks are calculated by the external systems based on their own rules and then synchronized with StackState and bound to associated topology elements. This approach is useful if you have existing health checks defined externally, or if it is not viable to send telemetry or events data to StackState and translate the check rules. 

Existing StackPacks will provide health synchronization out of the box. Advanced users can also [set up a custom health synchronization](../../configure/health/health-synchronization.md).

## View health state

A view can also report a health state as one of the same four colours:

* Green - `CLEAR` - There is nothing to worry about.
* Orange - `DEVIATING` - Something may require your attention.
* Red - `CRITICAL` - Attention is needed right now, because something is broken.
* Gray - `UNKNOWN` - View health state reporting is disabled.

The view health state is calculated based on the health of components and relations within in the view. Find out how to [configure view health state reporting](/use/health-state-and-event-notifications/configure-view-health.md).

![Health states](/.gitbook/assets/view-health-states.svg)

You can check the view health state in the following places in the StackState UI:

* **Health state of all views**: The view overview screen lists all views together with their health state.
* **Health state of starred views**: The main menu lists all starred views together with their health state.
* **Health state of the current view**: The health state of the current view is visible in the top bar and also next to the view name in the View Details pane on the right of the screen. Historical health state information for the current view can be seen in the timeline **Health** line at the bottom of the screen.

![View health state in main menu](/.gitbook/assets/v43_view_health_main_menu.png)

## See also

* [Add a health check based on telemetry streams available in StackState](../health-state-and-event-notifications/add-a-health-check.md)
* Add [Static Health from CSV](/stackpacks/integrations/static_health.md)
* [Set up a health synchronization](../../configure/health/health-synchronization.md)
