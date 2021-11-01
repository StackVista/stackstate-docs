# Filters

## Overview

The **View Filters** pane on the left-hand side of the StackState UI allows you to filter the components \(topology\), events and traces displayed in each perspective. Applied filters can be [saved as a view](filters.md#save-filters-as-a-view) to open directly in the future.

## Filter Topology

Topology filters can be used to select a sub-set of topology components to be shown in any one of the available perspectives. You can browse your topology using basic filters or build an advanced topology filter that zooms in on a specific area of your topology using the StackState in-built query language \(STQL\). Read more about:

* [Basic topology filters](filters.md#basic-topology-filters)
* [Advanced topology filters](filters.md#advanced-topology-filters)
* [Topology filtering limits](filters.md#topology-filtering-limits)

### Basic topology filters

The main way to filter topology is using the available basic filters. When you set a filter, the open perspective will update to show only the visualization or data for the subset of your topology that matches the filter. Setting multiple filters will narrow down your search further. You can set more than one value for each filter to expand your search

| Filter | Description |
| :--- | :--- |
| Layers, Domains, Environments and Component types | Filter by the component details included when components are imported or created. |
| Component health | Only include components with the named [health state](../health-state/health-state-in-stackstate.md) as reported by the associated health check. |
| Component labels | Only include components with a specific label. |
| Include components | Components named here will be included in the topology **in addition to** the components returned from other filters. |

{% hint style="success" %}
**StackState Self-Hosted**

Extra information for the StackState Self-Hosted product:

You can define [custom labels](../../configure/topology/tagging.md) to make searching for information easier.
{% endhint %}

To filter the topology using basic filters, click on the **View Filters** button on the left of the screen and select **Basic** under **Filter Topology**. 

The example below uses basic filters to return components that match the following conditions:

* In the **Domain** `mydomain`
* AND has a **Health** state of `Clear` OR `Deviating`
* OR is the **Component** with the name `agent-centos`

![Filtering example](../../.gitbook/assets/v45_basic_filter_example.png)

This same filter could also be written as an advanced topology filter using STQL.

### Advanced topology filters

You can use the in-built [StackState Query Language \(STQL\)](../../develop/reference/stql_reference.md) to build an advanced topology filter that zooms in on a specific area of your topology.

To filter the topology using an STQL query, click on the **View Filters** button on the left of the screen and select **Advanced** under **Filter Topology**. 

The STQL query example below will return components that match the following conditions:

* In the **Domain** `mydomain`
* AND has a **Health** state of `CLEAR` OR `DEVIATING`
* OR is the **Component** with the name `agent-centos`

```yaml
(domain IN ("mydomain") AND healthstate IN ("CLEAR", "DEVIATING")) OR name IN ("agent-centos")
```

![Filtering \(advanced filter\)](../../.gitbook/assets/v45_advanced_filter_example.png)

This same filter result could also be returned with basic filters, see [basic topology filters](filters.md#basic-topology-filters).

### Compatibility of basic and advanced filters

You can switch between basic and advanced filtering by selecting **Basic** or **Advanced** under **Filter Topology** in the **View Filters** pane.

It is always possible to switch from Basic to Advanced filtering. The selected basic filters will be converted directly to an STQL query. For simple queries it is also possible to switch from Advanced to Basic filtering, however, some advanced queries are not compatible with basic filters. 

* Basic filters cannot contain an inequality.
* Basic filters use AND/OR in a specific way:
    - All items in each basic filter box are joined with an **OR**: `layer IN ("business service", "applications", "databases")`
    - The different basic filter boxes are chained together with an **AND**: `layer IN ("business service") AND domain IN ("online banking”)`
    - The **Include components** basic filter box (name) is the exception - this is chained to the other filter boxes with an OR: `layer IN ("business service") AND domain IN ("online banking") OR name IN ("DLL_DB”)`
    - The advanced filtering options **withNeighborsOf** function and **identifier** are only compatible with basic filtering if they are joined to other filters with an **OR**: `layer in ("Processes") OR identifier IN ("urn:test:component")`
  
If you try to switch from an Advanced filter to a Basic filter and the query is not compatible, StackState will let you know and ask for confirmation to continue as you will lose some of the set filters. Alternatively, you can choose to stay in advanced filtering.

### Other filters

Some advanced filtering options are compatible with basic filtering, but cannot be set or adjusted as a basic filter. When these advanced filters are set in a way that is compatible with basic filtering, the box **Other filters** will be shown in the View Filters pane with details of the affected components:

* **withNeighborsOf** - when an advanced filter contains the function [withNeighborsOf](/develop/reference/stql_reference.md#withneighborsof), the number of components whose neighbors are queried for is shown in the **Other filters** box. To be compatible with basic filtering, a `withNeighborsOf` function must be joined to other filters using an `OR` operator.
* **identifier** - when an advanced filter filters components by [identifier](/develop/reference/stql_reference.md#filters), the number of component identifiers queried is reported in the **Other filters** box. To be compatible with basic filtering, an `identifier` filter must be specified and joined to other filters using the operator `OR identifier IN (...)`.

{% hint style="info" %}
The **Other filters** box will only contain details of advanced filters that have been set and are compatible with basic filtering.
{% endhint %}

### Topology filtering limits

To optimize performance, a limit is placed on the amount of elements that can be loaded to produce a topology visualization. The filtering limit has a default value of 10000 elements. If a [basic filter](filters.md#basic-topology-filters) or [advanced filter query](filters.md#advanced-topology-filters) exceeds the filtering limit, a message will be shown on screen and no topology visualization will be displayed.

Note that the filtering limit is applied to the total amount of elements that need to be **loaded** and not the amount of elements that will ultimately be displayed.

In the example below, we first LOAD all neighbors of every component in our topology and then DISPLAY only the ones that belong to the `applications` layer. This would likely fail with a filtering limit error as it requires all components in the topology to be loaded.

```text
withNeighborsOf(direction = "both", components = (name = "*"), levels = "15")
   AND layer = "applications"
```

To successfully produce this topology visualization, we would need to either re-write the query to keep the number of components loaded below the configured filtering limit, or increase the filtering limit. By fitering for only components in the `applications` layer, we will DISPLAY the same components as the query above, without first needing to LOAD all components. This query is therefore less likely to result in a filtering limit error.

```yaml
layer = "applications"
```

{% hint style="success" %}
**StackState Self-Hosted**

Extra information for the StackState Self-Hosted product:

If required, you can [manually configure the topology filtering limit](/configure/topology/topology-filtering-limits.md). 
{% endhint %}

## Filter Events

The **View Filters** pane on the left-hand side of the StackState UI can be used to filter the events shown in the [Events Perspective](perspectives/events_perspective.md) and in the **Event** list in the View Details pane on the right of the StackState UI.

The following event filters are available:

| Filter | Description |
| :--- | :--- |
| **Category** | Show only events from one or more [categories](perspectives/events_perspective.md#event-category). |
| **Type** | Click on the **Type** filter box to open a list of all event types that have been generated for the currently filtered components in the current time window. You can select one or more event types to refine the events displayed. |
| **Source** | Events can be generated by StackState or retrieved from an external source system, such as Kubernetes or ServiceNow, by an integration. Click on the **Source** filter box to open a list of all source systems for events that have been generated for the currently filtered components in the current time window. Select one or more source systems to see only those events. |
| **Tags** | Relevant event properties will be added as tags when an event is retrieved from an external system. For example `status:open` or `status:production`. This can help to identify events relevant to a specific problem or environment. |

## Filter Traces

Traces shown in the [Traces Perspective](perspectives/traces-perspective.md) can be filtered based on two properties of the spans they contain:

* Span types
* Span tags

For example, if you filter the trace list for all spans of type `database`, this will return all traces that have at least one span whose type is `database`.

## Save filters as a view

To update the existing view with the currently applied filters, click **Save view** at the top of the screen. To save the current filters as a new view, click **Save view as**. 

➡️ [Learn more about StackState views](views/about_views.md).

## Clear applied filters

To clear any filters you have added and return to the saved view filters or initial clean state, click on the view name at the top of the screen. Alternatively, you can select **Reset view** from the **Save view** dropdown menu at the top of the screen, or **Reset** from the **...** menu in the View details pane on the right of the screen.
