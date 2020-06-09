---
title: Script API - View
kind: Documentation
description: Fetch a list of views.
---

# Script API: View

## Function `getAll`

Returns query view responses. The query view response contains
* `view` - the actual query view definition
* `viewInfo` - (optional) structure holding extra information that can be requested using builder methods

The query view definition contains the following fields

```text
id
name
description
groupedByDomains
groupedByLayers
groupedByRelations
showIndirectRelations
showCause
state
viewHealthStateConfiguration
groupingEnabled
minimumGroupSize
query
```

The fields that may be of the most interest are:
* query - STQL query which can be used subsequently in getting topology using [Topology Script Api](./topology.md)
* state - View state object, holding view state

**Args:**

None

**Builder methods**

`withStarCount` - the flag asking the api to include the star count to the response.

If this flag is set the query response will contain the `viewInfo` holding star count.
The stars count is available on this path `viewResponse.viewInfo.stars.count`

**Examples:**

The example showing how to query views and subsequently the names of topology components from those views is given below:

```text
View.getAll()
    .thenInject([]) { components, viewResponse ->
      Topology.query(viewResponse.view.query)
              .components()
              .then { topologyComponents ->
                  def currentBatch = topologyComponents.collect { it.name }
                  (components + currentBatch).unique()
              }
    }

```
