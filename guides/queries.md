---
title: Analytical queries
kind: Documentation
listorder: 9
---

# queries

Intro StackState's 4T \(Topology, Telemetry, Traces and Time\) can be queried via it's analytical function executor. Analytical functions can be written in Groovy and have support for STQL and [Gremlin](http://tinkerpop.apache.org/docs/current/reference/) queries. StackState analytical functions can be tested via the analytical playground which can be found at: `<stackstate_url:7070>/#/analytics`.

## STQL Examples: <a id="intro"></a>

Get all components which are related to a specific component.

 //Define a name for the component where we start the search. def selectedComponent = "Invoicing"

Topology.query\("name = '" + selectedComponent + "'"\) 

List all components which depend on a specific component and have the state CRITICAL

 //Define a name for the component where we start the search. def selectedComponent = "srv02"

Topology.query\("withNeighborsOf\(direction = 'down', levels = '15', components = \(name = '" + selectedComponent + "'\)\) and healthState = 'CRITICAL'"\) 

List a service with components it is depending on down to N levels of depth

 //Define a name for the component where we start the search. def selectedComponent = "Payment\_Service"

//Define a search depth  
def N = 3

Topology.query\("withNeighborsOf\(direction = 'down', components = \(name = '" + selectedComponent + "'\), levels = '" + N + "'\) "\) 

List a service with components depending on it up to N levels of depth

 //Define a name for the component where we start the search. def selectedComponent = "Payment\_Service"

//Define a search depth  
def N = 3

Topology.query\("withNeighborsOf\(direction = 'up', components = \(name = '" + selectedComponent + "'\), levels = '" + N + "'\) "\)

Give a list of databases.

Topology.query\("Type = 'database'"\)

## Gremlin Examples: <a id="intro"></a>

Get component by name.

 //Define a name for the component where we start the search. def selectedComponent = "Invoicing"

//Open the graph return Graph.query { it.V\(\)

//Filter on components with a specific name .hasLabel\("Component"\)

.has\("name", selectedComponent\) } 

List all components which depend on a specific component and have the state CRITICAL

 //Define a name for the component where we start the search. def selectedComponent = "srv02"

//Open the graph return Graph.query { it.V\(\)

.hasLabel\("Component"\)

//Filter on component name .has\("name", selectedComponent\)

//Hold a reference to the sub result .as\("components"\)

//Follow the component till the is no dependend component anymore .until\(\_\_.inE\("HAS\_SOURCE"\).count\(\).is\(0\)\)

//Repeat this step for all Component-&gt;HAS_SOURCE-&gt;Relation-&gt;HASTARGET-&gt;Component relations. .repeat\(_.in\("HAS\_SOURCE"\).in\("HAS\_TARGET"\).simplePath\(\).as\("components"\)\)

//Select all "components" .select\("components"\)

//Unfold the arrays in arrays from the result .unfold\(\)

//Remove duplicates .dedup\(\)

//Filter on components with the healthState attribute "CRITICAL" .where\(\_\_.out\("HAS\_HEALTH\_STATE"\).has\("healthState", "CRITICAL"\)\) } 

List the value of a particular Vertex in the graph.

 return Graph.query { it.V\(\) //Select all Vertexes with the label Component \(=Class Component\) .hasLabel\("Component"\)

//Get 1 sample .sample\(1\)

//Show the values .valueMap\(\) } 

List the outgoing edges in the graph.

 return Graph.query { it.V\(\) //Select all Vertexes with the label Component \(=Class Component\) .hasLabel\('Component'\)

//Outgoing edges .outE\(\)

//Group and count them .groupCount\(\)

//By EDGE label .by\(label\) } 

List a job with it's upstream jobs upto N levels of dependencies

 //NOTE: Upstream/downstream is the information-flow direction which for batch jobs is opposite to the // dependency direction that is modeled in StackState. def jobNames = \["sl2-INTACC"\]; def maxDepth = 1;

// Dependencies / upstream dataflow: return Graph.query { it.V\(\) .hasLabel\("Component"\) .has\("name", within\(jobNames\)\) .where\(**.out\("HAS\_LABEL"\).has\("name", "autosys"\)\) .as\("elements"\) .until\(**.outE\("HAS_TARGET"\).count\(\).is\(0\).or\(\).loops\(\).is\(gt\(maxDepth-1\)\)\) .repeat\(\__.out\("HAS\_TARGET"\).as\("elements"\).out\("HAS\_SOURCE"\).simplePath\(\).as\("elements"\)\) .select\("elements"\).unfold\(\).dedup\(\) } 

List a job with it's upstream jobs upto N levels of dependencies Optionally project only name + states + streamIds Optionally filter the subgraph on some properties like: name, having a run state or having some streams

 //NOTE: Upstream/downstream is the information-flow direction which for batch jobs is opposite to the // dependency direction that is modeled in StackState. def jobNames = \["sl2-INTACC"\]; def maxDepth = 1;

// Dependents / downstream dataflow: return Graph.query { it.V\(\) .hasLabel\("Component"\) .has\("name", within\(jobNames\)\) .where\(**.out\("HAS\_LABEL"\).has\("name", "autosys"\)\) .as\("elements"\) .until\(**.inE\("HAS_SOURCE"\).count\(\).is\(0\).or\(\).loops\(\).is\(gt\(maxDepth-1\)\)\) .repeat\(\__.in\("HAS\_SOURCE"\).as\("elements"\).in\("HAS\_TARGET"\).simplePath\(\).as\("elements"\)\) .select\("elements"\).unfold\(\).dedup\(\) }

// To project only name + states + streamIds append this projection: .project\("runState", "healthState", "name", "streams"\) .by\(**.out\("HAS\_RUN\_STATE"\).values\("runState"\)\) .by\(**.out\("HAS_HEALTHSTATE"\).values\("healthState"\)\) .by\(**.values\("name"\)\) .by\(**.out\("HASDATASTREAM"\).project\("id", "name"\).by\(.id\(\)\).by\(_.values\("name"\)\).fold\(\)\);

// Use match instead of project to add additional filtering, example for only elements with streams: .match\( **.as\("element"\).values\("name"\).as\("name"\),** .as\("element"\).out\("HAS_DATASTREAM"\),_ .as\("element"\).out\("HAS\_RUN\_STATE"\).values\("runState"\).as\("runState"\) \) .select\("name", "runState"\)

Give a disjoint graph listing all DBs \(filtered by some basic parameters - only Sybase, only DB2 etc..\) and their basic health information and telemetry

 return Graph.query { it.V\(\) .hasLabel\("Component"\) .where\(\_\_.out\("HAS\_LABEL"\).has\("name", "database"\)\) } //Add other where steps for other filters on labels and related nodes 

