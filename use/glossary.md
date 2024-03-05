---
description: StackState SaaS
---

# Glossary

Below you can find a short dictionary that can help you get a better grasp on the context of the terms used in our documentation.

* **4T data model -** Stands for Topology, Telemetry, Traces and Time. These four dimensions are the key concepts of the StackSate data model.
* **Agent** - Software that runs on hosts. Collects events and metrics from hosts and sends them to StackState.
* **baseline** - Information used as a starting point by which to compare other information. In StackState it's used for comparison with the metric stream. It learns from the historical data and calculates the baseline on the current data.
* **check** - Defines the status of the component/relation and therefore represents the graphic presentation of the health status in the StackState view. It's responsible for determining the health status of the component based on the telemetry streams.
* **check function** - Logic to determine health and run state based on the input \(for example, metric stream\).
* **component** - The smallest unit of a topology; represents a real-life component in the IT landscape like a server, a service or an application. Each component belongs to one layer and one domain only.
* **component action** - Performs an action based on a component when the user triggers the action on the quick action menu of the component.
* **component health state** - Determined by all defined checks on the component. The most severe one always determines the state of the component.
* **component type** - Defines the granularity level of components in the IT environment.
* **data source** - Defines how StackState recognizes components of specified type during the topology creation process.
* **domain** - Used to logically group components, for example, business units, teams, application.
* **element** - Component or relation in the topology.
* **environment** - Used to divide the IT landscape into smaller logical units according to their intended purpose. For example, creating DTAP \(Develop, Test, Acceptance, Production\) environments. One component can belong to multiple environments.
* **event** - StackState records every change detected in the IT environment as an event. Events are always bound to one or more topology elements.
* **event handler** - Performs an action defined for a specific type of event occurrence.
* **gremlin** - A graph traversal language. Find out more on Gremlin [here](https://tinkerpop.apache.org/gremlin.html).
* **groovy** - A multi-faceted language for the Java platform. Find out more about Groovy [here](https://groovy-lang.org/).
* **health state** - Representation of the health status of components and relations in the IT landscape.
* **integration** - A link between an external data source and StackState as defined in a StackPack.
* **layer** - Represents a hierarchy that determines the relations and dependencies in your stack - typically top to bottom.
* **log stream** - A telemetry stream with log or event data coming from an external system.
* **mapping** - In the synchronization process it specifies the transformation of external system topological data into StackState based on component/relation type.
* **mapping function** - Allows the user to transform data before applying a template during the synchronization process.
* **metric stream** - A telemetry stream with metric data coming from an external system.
* **monitor** - A declarative definition of a validation rule that uses available 4T data to compute health states and attach them to the StackState Topology.
* **monitor function** - Defines the underlying algorithm used to compute the health states produced by a monitor.
* **monitor runner** - A subsystem of StackState responsible for execution of the logic of a monitor in a timely manner.
* **permission** - Defines access to specific actions for users.
* **prefix** - STQL query that's specific to a role. It's added as a query prefix to every query executed by users in that role.
* **propagation** - Defines how a component affects its health state based on dependencies and relations. Health state propagates in the opposite direction of the dependency. For example, a virtual machine crash will influence applications running on it.
* **propagation function** - Allows users to alter the propagation logic for a specific component.
* **relation** - Models a dependency between components.
* **relation health state** - Determined by all checks defined on the relation. The most severe one always determines the state of the relation.
* **role** - Combination of a configured subject and a set of permissions.
* **run state** - Defines the operational status of a component.
* **scope** - Determines limitations for queries that user can execute. See prefix for more information.
* **selection** - Filtering down the IT landscape from the full view to a more specific one. Selection can be saved as a view.
* **stack element** - See element.
* **StackPack** - A package that's prepared for integration with an external data source.
* **StackPack instance** - Single StackPack integration to one instance of the specific type of data source.
* **state** - See Health State.
* **STQL \(StackState Query Language\)** - A built-in query language used to create advanced filters. It's a typed language, which means that each supported type of data is predefined as a part of STQL.
* **STJ \(StackState Templated JSON\)** - A JSON file with StackState specific template placeholders.
* **STY \(StackState Templated YAML\)** - A YAML file with StackState specific template placeholders.
* **subject** - A user or a group with a scope.
* **synchronization** - Consolidation of topology information from a data source.
* **sync** - See synchronization.
* **telemetry -** Defined as either logs, metrics or events.
* **telemetry data source** - A real-time stream of metric or event data coming from an external system.
* **telemetry stream** - Component or relation specific data collected and sent over to StackState.
* **template** - Creates components/relations based on data from the topology data source.
* **topology** - The set of relationships and dependencies between discrete components in an environment (for example, business services, microservices, load balancers, containers and databases).
* **topology data source** - Used to provide data from an external system during the synchronization process.
* **traces** - A single request that follows a certain path through the 4T data model.
* **view** - A partial visualization of the 4T data model that can be tailored to show only the cut of an IT landscape that's needed.
* **view health state** - Shows the health state of the entire view.
* **view state function** - Allows users to modify the behavior of the view health state.
