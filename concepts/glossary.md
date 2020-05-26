---
title: Glossary
kind: Documentation
---


Below you can find a short dictionary that can help you get a better grasp on the context of the terms used in our documentation.


* __agent__ - software that runs on hosts. Collects events and metrics from hosts and sends them to StackState.

* __baseline__ - information that is used as a starting point by which to compare other information. In StackState it is used for comparison with the metric stream. It learns from the historical data and calculates the baseline on the current data.

* __check__ - it defines the status of the component/relation and therefore represents the graphic presentation of the health status in the StackState view. It is responsible for determining the health status of the component based on the telemetry streams.

* __check function__ - logic to determine health and/or run state based on the input (e.g., metric stream).  

* __component__ - the smallest unit of a topology; represents a real-life component in the IT landscape like a server, a service or an application. Each component belongs to one layer and one domain only.

* __component health state__ - determined by all defined checks on the component. The most severe one always determines the state of the component.  

* __component type__ - defines the granularity level of components in the IT environment.

* __data source__ - defines how StackState recognizes components of specified type during the topology creation process.

* __domain__ - used to logically group components, e.g., business units, teams, application.

* __element__ - component or relation in the topology.

* __environment__ - used to divide the IT landscape into smaller logical units according to their intended purpose.  e.g., creating DTAP (Develop, Test, Acceptance, Production) environments. One component can belong to multiple environments.

* __event__ - StackState records every change detected in the IT environment as an event.

* __event stream__ - shows all events defined for the active view.

* __event stream__ (II) - event data that is coming from an external system.

* __event handler__ - performs an action defined for a specific type of event occurrence.

* __Gremlin__ - is the graph traversal language. Find out more on Gremlin [here](https://tinkerpop.apache.org/gremlin.html).

* __Groovy__ - is a multi-faceted language for the Java platform. Find out more about Groovy [here](https://groovy-lang.org/).

* __health state__ -  representation of the health status of components and relations in the IT landscape.

* __integration__ - a link between an external data source and StackState as defined in a StackPack.

* __layer__ - represents a hierarchy that determines the relations and dependencies in your stack - typically top to bottom.

* __mapping__ - in the synchronization process it specifies the transformation of external system topological data into StackState based on component/relation type.

* __mapping function__ - allows the user to transform data before applying a template during the synchronization process.

* __metric stream__ - metric data that is coming from an external system; Allows for baseline checks.

* __permission__ - defines an access to specific actions for users.

* __prefix__ - STQL query that is specific to a role. It is added as a query prefix to every query executed by users in that role.

* __propagation__ - defines how a component affects its health state based on dependencies and relations. Health state propagates in the opposite direction of the dependency, e.g., a virtual machine crash will influence applications running on it.

* __propagation function__ - allows users to alter the propagation logic for a specific component.

* __relation__ - models a dependency between components.

* __relation health state__ - determined by all checks defined on the relation. The most severe one always determines the state of the relation.

* __role__ - combination of a configured subject and a set of permissions.

* __run state__ - defines the working status of a component.

* __scope__ - determines limitations for queries that user can execute. See prefix for more information.  

* __selection__ - filtering down the IT landscape from the full view to a more specific one. Selection can be saved as a view.

* __stack element__ - see the element.

* __StackPack__ - a package that is prepared for integration with an external data source.

* __StackPack instance__ - single StackPack integration to one instance of the specific type of data source.

* __state__ - same as Health State.

* __STQL (StackState Query Language)__ - a built-in query language used to create advanced filters. It is a typed language, which means that each supported type of data is predefined as a part of STQL.

* __STJ (StackState Templated JSON)__ - a JSON file with StackState specific placeholders.

* __subject__ - a user or a group with a scope.

* __synchronization__ - consolidation of topology information from a data source.

* __sync__ - same as synchronization.

* __telemetry data source__ - a real-time stream of metric or event data coming from an external system.

* __telemetry stream__ - component or relation specific data collected and sent over to StackState.

* __template__ - creates components/relations based on data from the topology data source.

* __topology__ - consists of components and relations between those components.

* __topology data source__ - used to provide data from an external system during the synchronization process.

* __view__ - a partial visualization of the topological landscape that can be tailored to show only the cut of an IT landscape that is needed.

* __view health state__ - shows the health state of the entire view.

* __view state function__ - allows users to modify the behavior of the view health state.
