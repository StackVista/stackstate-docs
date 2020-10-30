---
title: Script API - View
kind: Documentation
description: Fetch a list of views.
---

# Script API: View

## Function `getAll`

Returns a list of all views.

**Args:**

None

**Return type:**

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

**Examples:**

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

