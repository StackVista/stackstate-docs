# Filtering

The View Filters panel on the left side of the StackState UI allows you to filter the components and other information displayed in each perspective.

##Topology Filters

Topology Filters can be used to select a sub-set of topology components to be shown in any one of the available perspectives. You can browse your topology using basic filters or use the StackState in-built query language (STQL) to build an advanced topology filter that zooms in on a specific area of your topology. Read more about:

* [Basic topology filters](#basic-topology-filters)
* [Advanced topology filters with STQL](../../configure/topology_selection_advanced.md)
* [Topology filtering limits](#topology-filtering-limits)

### Basic topology filters

The main way of filtering the topology is by using the basic filters. When you set a filter, the open perspective will update to show only the visualization or data for the subset of your topology that matches the filter. Setting multiple filters will narrow down your search further. You can set more than one value for each filter to expand your search

| Basic filter | Description |
|:---|:---|
| Layers<br />Domains<br />Environments | Topology organization |
| Types | Component type |
| Health | Health state |
| Labels | Component labels |
| Components | Always include the named component(s) |


### Basic filtering example

Here is an example of using a basic filter to search for components by **Domains**.

![Filtering example](../../.gitbook/assets/v410/basic_filtering.png)

### Advanced topology filters

You can use the StackState in-built query language (STQL) to build an advanced topology filter that zooms in on a specific area of your topology. Read more about [Advanced topology filters with STQL](../../configure/topology_selection_advanced.md).

![Filtering\(advanced filter\)](../../.gitbook/assets/v410/advanced_filtering.png)

### Topology filtering limits

To optimize performance, a configurable limit is placed on the amount of elements that can be loaded to produce a topology visualization. The filtering limit has a default value of 10000 elements, this can be manually configured in `etc/application_stackstate.conf` using the parameter `stackstate.topologyQueryService.maxStackElementsPerQuery`.

If a [basic filter](#basic-topology-filters) or [advanced filter query](/configure/topology_selection_advanced.md) exceeds the configured filtering limit, you will be presented with an error on screen and no topology visualization will be displayed.

Note that the filtering limit is applied to the total amount of elements that need to be loaded and not the amount of elements that will be displayed.

In the example below, we first LOAD all neighbors of every component in our topology and then SHOW only the ones that belong to the `applications` layer. This would likely fail with a filtering limit error, as it requires all components to be loaded.
```text
withNeighborsOf(direction = "both", components = (name = "*"), levels = "15")
   AND layer = "applications"
```

To successfully produce this topology visualization, we would need to either re-write the query to keep the number of components loaded below the configured filtering limit, or increase the filtering limit.

## Filter Events

You can use the View Filters panel to filter the type of events shown in the [Events Perspective](event-perspective.md).

## Filter Traces

The traces shown in the Traces Perspective can be filtered by **Tags** or **Span Types**. Read more about [FIlter Traces](trace-perspective.md#trace-filters)
