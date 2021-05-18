# Health state in StackState

## Overview

StackState has the ability to track a single health state for a given topology element (components and relations) based on the information from the different health checks that can be attached to it. A topology element can have any of the health states listed below:

* Green - `CLEAR` - There is nothing to worry about.
* Orange - `DEVIATING` - Something may require your attention.
* Red - `CRITICAL` - Attention is needed right now, because something is broken.
* Gray - `UNKNOWN` - The view does not have a view health state.

The health checks that a topology element can contain can be obtained in two different ways:

* Calculated by StackState based on telemetry or event streams defined for the topology element. See [Add a health check](../health-state-and-event-notifications/add-a-health-check.md). This path is useful when the telemetry/events data is alredy sent into StackState which opens the posibiliti to use [AAD](../health-state-and-event-notifications/anomaly-health-checks.md)  as well on top of it.
* Calculated by an external system based on its own rules and synchronized to StackState. See [Set up a health synchronization](../../configure/health/health-synchronization.md). This path is useful when the health checks are already defined and calculated externally or sending the telemetry/events and translating the check rules into StackState is not viable. 


## See also

* [Add a health check](../health-state-and-event-notifications/add-a-health-check.md)
* [Set up a health synchronization](../../configure/health/health-synchronization.md)
