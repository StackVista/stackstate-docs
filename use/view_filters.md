# View filters

## Overview

The **View Filters** pane on the left side of the StackState UI allows you to filter the components (topology), events and traces displayed in each perspective. Applied filters can be saved as a view to open directly in the future, views also allow you to generate a combined health state for the included elements and send event notifications. Read more about [StackState views](/use/views.md).

## Topology filters

Topology Filters can be used to select a sub-set of topology components to be shown in any one of the available perspectives. You can browse your topology using basic filters or use the StackState in-built query language \(STQL\) to build an advanced topology filter that zooms in on a specific area of your topology. Read more about:

* [Basic filters](view_filters.md#basic-topology-filters)
* [Advanced filters](view_filters.md#advanced-topology-filters)
* [Topology filtering limits](view_filters.md#topology-filtering-limits)

### Basic topology filters

The main way of filtering the topology is by using the basic filters. When you set a filter, the open perspective will update to show only the visualization or data for the subset of your topology that matches the filter. Setting multiple filters will narrow down your search further. You can set more than one value for each filter to expand your search

| Filter | Description |
| :--- | :--- |
| Layers, Domains, Environments and Types | Filter by the component details included when components are imported or created. |
| Health | Only include components with the named health state as reported by the associated [health check](/use/health-state-and-event-notifications/add-a-health-check.md). |
| Labels | Only include components with a [custom label](/configure/topology/tagging.md) or a default integration label, for example the [Dynatrace integration](/stackpacks/integrations/dynatrace.md#dynatrace-filters-for-stackstate-views). |
| Components | The Components filter behaves differently to other filters. Components named here will be included in the topology **in addition to** the components returned from other filters. |

The example below uses basic filters to return components that match the following conditions:

* In the **Domain** `security check`
* AND has a **Health** state of `Clear` OR `Deviating`
* OR is the **Component** with the name `bambDB`

![Filtering example](/.gitbook/assets/v42_basic_filter_example.png)

This could also be written as an advanced filter, see [advanced topology filters](view_filters.md#advanced-topology-filters).

### Advanced topology filters

You can use the in-built [StackState Query Language \(STQL\)](/develop/reference/stql_reference.md) to build an advanced topology filter that zooms in on a specific area of your topology.

The example below uses an advanced filter to return components that match the following conditions:

* In the domain `security check`
* AND has a health state of `CLEAR` OR `DEVIATING`
* OR has the name `bambDB`

![Filtering \(advanced filter\)](/.gitbook/assets/v42_advanced_filter_example.png)

This could also be done using basic filters, see [basic topology filters](view_filters.md#basic-topology-filters).

### Topology filtering limits

To optimize performance, a configurable limit is placed on the amount of elements that can be loaded to produce a topology visualization. The filtering limit has a default value of 10000 elements, this can be manually configured in `etc/application_stackstate.conf` using the parameter `stackstate.topologyQueryService.maxStackElementsPerQuery`.

If a [basic filter](view_filters.md#basic-topology-filters) or [advanced filter query](view_filters.md#advanced-topology-filters) exceeds the configured filtering limit, you will be presented with an error on screen and no topology visualization will be displayed.

Note that the filtering limit is applied to the total amount of elements that need to be loaded and not the amount of elements that will be displayed.

In the example below, we first LOAD all neighbors of every component in our topology and then SHOW only the ones that belong to the `applications` layer. This would likely fail with a filtering limit error, as it requires all components to be loaded.

```text
withNeighborsOf(direction = "both", components = (name = "*"), levels = "15")
   AND layer = "applications"
```

To successfully produce this topology visualization, we would need to either re-write the query to keep the number of components loaded below the configured filtering limit, or increase the filtering limit.

## Event filters

You can use the View Filters pane to filter the events shown in the [Events Perspective](/use/perspectives/events_perspective.md) and in the **Event** list in the view details pane on the right of the StackState UI while in the Topology Perspective. 

The following event filters are available:

| Filter | Description |
| :--- | :--- |
| **Category** | Show only events from one or more [categories](/use/perspectives/events_perspective.md#event-category). |
| **Type** | Click on the **Type** filter box to open a list of all event types that have been generated for the currently filtered components in the current time window. You can select one or more event types to refine the events displayed. |
| **Source** | Events can be generated by StackState or retrieved from an external source system, such as Kubernetes or ServiceNow, by an integration. Click on the **Source** filter box to open a list of all source systems for events that have been generated for the currently filtered components in the current time window. Select one or more source systems to see only those events.  |
| **Tags** | Relevant event properties will be added as tags when an event is retrieved from an external system. For example `status:open` or `status:production`. This can help to identify events relevant to a specific problem or environment. |

## Trace filters

The traces shown in the Traces Perspective can be filtered by **Tags** or **Span Types**. Read more about [filtering traces in the Traces Perspective](/use/perspectives/traces-perspective.md#trace-filters)

