---
description: StackState Self-hosted v5.1.x 
---

# View - script API

## Function: `getAll`

Returns a list of all views.

### Args

None

### Return type

`AsyncScriptResult[List[QueryViewResponse]]`

Fields:

* `QueryViewResponse.view` - the `QueryView` object
* `QueryViewResponse.viewInfo` - \(optional\) `ViewInfo` structure holding extra information that can be requested using builder methods

The `QueryView` type has the following fields:

* `QueryView.name` - the name of the view
* `QueryView.description` - the description of the view
* `QueryView.state` - View state object, holding view state
* `QueryView.query` - STQL query which can be used subsequently in getting topology using [Topology Script Api](topology.md)

The `ViewInfo` type has the following fields:

* `ViewInfo.stars.count` - the number of times a star was given by any user to the view

**Builder methods**

`withStarCount` - adds the number of times a star was given by any user to the view info of each view.

If this flag is set the query response will contain the `viewInfo` holding star count. The stars count is available on this path `viewResponse.viewInfo.stars.count`

### Examples

The following example collects the names of all components in all views.

```text
View.getAll()
    .thenInject([]) { componentNames, view ->
      Topology.query(view.view.query)
              .components()
              .then {
                components -> componentNames + components.collect { it.name }                  
              }
    }
    .then {
      it.unique()
    }
```

## Function: `withId(viewId).problems()`

Returns a list of all problems in a view.

### Args

* `viewId` - the ID of the view to query for problems.

### Return type

`AsyncScriptResult[List[ProblemWithDetails]]`

### Fields

* `contributingProblems` - list of all contributing problems with details: 
  * `contributingProblems.causeId` - the ID of the topology element contributing to this problem.
  * `contributingProblems.causeName` - the name of the topology element contributing to this problem.
  * `contributingProblems.causeType` - the type of the topology element contributing to this problem.
  * `contributingProblems.failingCheckNames` - the names of the checks that are failing at the moment of fetching this problem contributor.
  * `contributingProblems.healthState` - the current health state of the contributor, either `DEVIATING` or `CRITICAL`.
  * `contributingProblems.propagatedHealthState` - the propagated health state of the contributor, either `DEVIATING` or `CRITICAL`.
* `problemId` - the ID of the problem
* `rootCause` - the root cause component for the queried problem:
    * `rootCause.causeId` - the ID of the root cause topology component, the bottom-most component in the problem cluster.
    * `rootCause.causeName` - the name of the root cause topology component.
    * `rootCause.causeType` - the type of the root cause component.
    * `rootCause.failingCheckNames` - the names of the checks that are failing at the moment of fetching the root cause component .
    * `rootCause.healthState` - the current health state of the root cause component, either `DEVIATING` or `CRITICAL`.
    * `rootCause.propagatedHealthState` - the propagated health state of the root cause component, either `DEVIATING` or `CRITICAL`.
* `viewId` - the ID of the queried view.

### Builder methods

None.

### Examples

The example below returns the name of the root cause component of the first problem in the view `230470072729670`, together with the names of any failing checks on that component

```yaml
View
    .withId(230470072729670)  
    .problems()
        .then{ problems ->       
        problems.isEmpty()? null : 
            problems[0].rootCause.causeName + " - failed check(s): " +
            problems[0].rootCause.failingCheckNames
    }
```

## Function: 'withId(viewId).problem(problemId)'

### Args

* `viewId` - the ID of the view containing the problem.
* `problemId` - the ID of a problem to return details for.

### Return type

`AsyncScriptResult[ProblemWithDetails]`

### Fields

* contributingProblems - list of all contributing problems with details: 
    * `contributingProblems.causeId`
    * `contributingProblems.causeName`
    * `contributingProblems.causeType`
    * `contributingProblems.failingCheckNames`
    * `contributingProblems.healthState`
    * `contributingProblems.propagatedHealthState`
* `problemId` - the ID of the problem
* rootCause - the root cause component for the queried problem:
    * `rootCause.causeId`
    * `rootCause.causeName`
    * `rootCause.causeType`
    * `rootCause.failingCheckNames`
    * `rootCause.healthState`
    * `rootCause.propagatedHealthState`
* `viewId` - the ID of the queried view.

### Builder methods

None.

### Examples

The example below returns the names of all checks failing for the problem with ID `65706558771339` in the view with ID `105520781477197`

```yaml
View
    .withId(105520781477197)  
    .problem(65706558771339)  
        .then{ problem ->       
        problem.contributingProblems.failingCheckNames.unique()
    }
```

In an event handler, we can get the view ID and problem ID automatically from the configuration of the [event handler function](/develop/developer-guides/custom-functions/event-handler-functions.md):

```yaml
View
  .withId(view)
  .problem(event.problemId)
    .then {  problem ->       
        problem.contributingProblems.failingCheckNames.unique()
  }
```
