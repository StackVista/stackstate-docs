---
title: Analytical queries
kind: Documentation
listorder: 9
---

<h2 id="intro">Intro</h2>
StackState's 4T (Topology, Telemetry, Traces and Time) can be queried via it's analytical function executor. Analytical functions can be written in Groovy and have support for STQL and <a href="http://tinkerpop.apache.org/docs/current/reference/">Gremlin</a> queries.
StackState analytical functions can be tested via the analytical playground which can be found at: `<stackstate_url:7070>/#/analytics`.

<h3 id="intro">STQL Examples:</h3>

Get all components which are related to a specific component.

{{< highlight python >}}
//Define a name for the component where we start the search.
def selectedComponent = "Invoicing"

Topology.query("name = '" + selectedComponent + "'")
{{< /highlight >}}

List all components which depend on a specific component and have the state CRITICAL

{{< highlight python >}}
//Define a name for the component where we start the search.
def selectedComponent = "srv02"

Topology.query("withNeighborsOf(direction = 'down', levels = '15', components = (name = '" + selectedComponent + "')) and healthState = 'CRITICAL'")
{{< /highlight >}}

List a service with components it is depending on down to N levels of depth

{{< highlight python >}}
//Define a name for the component where we start the search.
def selectedComponent = "Payment_Service"

//Define a search depth  
def N = 3

Topology.query("withNeighborsOf(direction = 'down', components = (name = '" + selectedComponent + "'), levels = '" + N + "') ")
{{< /highlight >}}

List a service with components depending on it up to N levels of depth

{{< highlight python >}}
//Define a name for the component where we start the search.
def selectedComponent = "Payment_Service"

//Define a search depth  
def N = 3

Topology.query("withNeighborsOf(direction = 'up', components = (name = '" + selectedComponent + "'), levels = '" + N + "') ")

{{< /highlight >}}

Give a list of databases.

{{< highlight python >}}

Topology.query("Type = 'database'")

{{< /highlight >}}


<h3 id="intro">Gremlin Examples:</h3>

Get component by name.

{{< highlight python >}}
//Define a name for the component where we start the search.
def selectedComponent = "Invoicing"

//Open the graph
return Graph.query { it.V()

  //Filter on components with a specific name
  .hasLabel("Component")

  .has("name", selectedComponent)
}
{{< /highlight >}}

List all components which depend on a specific component and have the state CRITICAL

{{< highlight python >}}
//Define a name for the component where we start the search.
def selectedComponent = "srv02"

//Open the graph
return Graph.query { it.V()

  .hasLabel("Component")

  //Filter on component name
  .has("name", selectedComponent)

  //Hold a reference to the sub result
  .as("components")

  //Follow the component till the is no dependend component anymore
  .until(__.inE("HAS_SOURCE").count().is(0))

  //Repeat this step for all Component->HAS_SOURCE->Relation->HAS_TARGET->Component relations.
  .repeat(__.in("HAS_SOURCE").in("HAS_TARGET").simplePath().as("components"))

  //Select all "components"
  .select("components")

  //Unfold the arrays in arrays from the result
  .unfold()

  //Remove duplicates
  .dedup()

  //Filter on components with the healthState attribute "CRITICAL"
  .where(__.out("HAS_HEALTH_STATE").has("healthState", "CRITICAL"))
}
{{< /highlight >}}

List the value of a particular Vertex in the graph.

{{< highlight python >}}
return Graph.query { it.V()
  //Select all Vertexes with the label Component (=Class Component)
  .hasLabel("Component")

  //Get 1 sample
  .sample(1)

  //Show the values
  .valueMap()
}
{{< /highlight >}}

List the outgoing edges in the graph.

{{< highlight python >}}
return Graph.query { it.V()
  //Select all Vertexes with the label Component (=Class Component)
  .hasLabel('Component')

  //Outgoing edges
  .outE()

  //Group and count them
  .groupCount()

  //By EDGE label
  .by(label)
}
{{< /highlight >}}

List a job with it's upstream jobs upto N levels of dependencies

{{< highlight python >}}
//NOTE: Upstream/downstream is the information-flow direction which for batch jobs is opposite to the
// dependency direction that is modeled in StackState.
def jobNames = ["sl2-INTACC"];
def maxDepth = 1;

// Dependencies / upstream dataflow:
return Graph.query { it.V()
  .hasLabel("Component")
  .has("name", within(jobNames))
  .where(__.out("HAS_LABEL").has("name", "autosys"))
  .as("elements")
  .until(__.outE("HAS_TARGET").count().is(0).or().loops().is(gt(maxDepth-1)))
  .repeat(__.out("HAS_TARGET").as("elements").out("HAS_SOURCE").simplePath().as("elements"))
  .select("elements").unfold().dedup()
}
{{< /highlight >}}

List a job with it's upstream jobs upto N levels of dependencies
Optionally project only name + states + streamIds
Optionally filter the subgraph on some properties like: name, having a run state or having some streams

{{< highlight python >}}
//NOTE: Upstream/downstream is the information-flow direction which for batch jobs is opposite to the
// dependency direction that is modeled in StackState.
def jobNames = ["sl2-INTACC"];
def maxDepth = 1;

// Dependents / downstream dataflow:
return Graph.query { it.V()
  .hasLabel("Component")
  .has("name", within(jobNames))
  .where(__.out("HAS_LABEL").has("name", "autosys"))
  .as("elements")
  .until(__.inE("HAS_SOURCE").count().is(0).or().loops().is(gt(maxDepth-1)))
  .repeat(__.in("HAS_SOURCE").as("elements").in("HAS_TARGET").simplePath().as("elements"))
  .select("elements").unfold().dedup()
}

// To project only name + states + streamIds append this projection:
.project("runState", "healthState", "name", "streams")
  .by(__.out("HAS_RUN_STATE").values("runState"))
  .by(__.out("HAS_HEALTH_STATE").values("healthState"))
  .by(__.values("name"))
  .by(__.out("HAS_DATA_STREAM").project("id", "name").by(__.id()).by(__.values("name")).fold());

// Use match instead of project to add additional filtering, example for only elements with streams:
.match(
      __.as("element").values("name").as("name"),
      __.as("element").out("HAS_DATA_STREAM"),
      __.as("element").out("HAS_RUN_STATE").values("runState").as("runState")
      )
  .select("name", "runState")

{{< /highlight >}}

Give a disjoint graph listing all DBs (filtered by some basic parameters - only Sybase, only DB2 etc..) and their basic health information and telemetry

{{< highlight python >}}
return Graph.query { it.V()
  .hasLabel("Component")
  .where(__.out("HAS_LABEL").has("name", "database"))
}
//Add other where steps for other filters on labels and related nodes
{{< /highlight >}}
