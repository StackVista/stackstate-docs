---
description: StackState Self-hosted v4.5.x
---

# UI - script API

{% hint style="info" %}
These functions only work in the context of scripts that are executed by a user from the user-interface. [Component actions](../../../../configure/topology/component_actions.md) are an example of scripts that can trigger actions in the user-interface.
{% endhint %}

## Function: baseUrl

Returns the baseUrl of the StackState instance as configured in the `application.conf` or `values.yaml`.

**Examples:**

Return the base URL from the StackState configuration.

```groovy
UI.baseUrl()
```

## Function: `createUrl`

Creates a URL builder that can be used to generate URLs that can be linked back in StackState.

**Args:**

No arguments.

**Return type:**

PerspectiveUrlBuilder

**Builder methods:**

* `view(viewURN)` or `explore()` - returns a `PerspectiveUrlBuilder` for either the specified view or the exploration mode with the following methods:
  * `at(time: instant)` -  specifies a [time](time.md) for which the view query should be executed.
  * `topologyQuery(query: String)` - specifies a topology query
  * `withComponent(component)` - creates a view URL with the specified component in focus.
  * `withTelemetryComponent(component: Any)` - specifies telemetry component to show charts for on the Telemetry Perspective
  * `eventsPerspective()` - points the URL to the Events Perspective
  * `tracesPerspective()` - points the URL to the Traces Perspective
  * `telemetryPerspective()` - points the URL to the Telemetry Perspective 
  * `topologyPerspective()` - points the URL to the Topology Perspective
  * `noRootCause()` - disable root cause analysis for the Topology Perspective
  * `rootCauseOnly()` - show root cause on the Topology Perspective
  * `fullCauseTree()` - show full cause tree on the Topology Perspective
  * `topologyListMode()` - use list mode on Topology Perspective
  * `topologyGraphMode()` - use graph mode on Topology Perspective
  * `withEventType(value: String)` - adds type to events filtering
  * `withEventTag(value: String)` - adds tag to events filtering
  * `withEventCategory(value: String)` - adds categories to events filtering
  * `withEventSource(value: String)` - adds a source to events filtering
  * `withTraceTag(value: String)` - adds tag to traces filtering
  * `withTraceSpanType(value: String)` - adds span type to traces filtering
  * `domainGrid(enabled: Boolean)` - enables or disables domain grid for the topology in graph mode
  * `layerGrid(enabled: Boolean)` - enables or disables layer grid for the topology in graph mode
  * `noGrouping()` - disables grouping of components on the topology in graph mode
  * `autoGrouping()` - enables automatic grouping of components on the topology in graph mode
  * `groupingByTypeAndState()` or `groupingByTypeAndState(minimumGroupSize: Int)` - enables grouping of components on the topology in graph mode by component type and state and specifies a minimum number of components to form a group
  * `groupingByTypeStateAndRelations()` or `groupingByTypeStateAndRelations(minimumGroupSize: Int)` - enables grouping of components on the topology in graph mode by component type, state and relations and specifies a minimum number of components to form a group
  * `showIndirectRelations()` - enables rendering of indirect relations on the Topology Perspective
  * `url()` - gives the final URL of the view.

**Examples:**

Create a URL to a view at a specific time.

```groovy
View.getAll().then { views ->
    UI.createUrl().view(views[0].view).at('-15m').url()
}
```

Create a URL to a view focussing on a component.

```groovy
View.getAll().then { views ->
    Component.withId(component).get().then { component ->
        UI.createUrl().view(views[0].view).at('-15m').withComponent(component).url()
    }
}
```

Create a URL to the Topology Perspective explore mode with filters in place to show all components from the production environment that are in critical state and showing the full root cause tree

```groovy
UI.createUrl().explore().topologyQuery('environment IN ("Production") AND healthstate IN ("CRITICAL")').fullCauseTree().url()
```

## Function: `redirectToURL`

Opens a new tab in the user's browser to some URL.

**Args:**

* `url` - the URL to redirect the browser to.

**Return type:**

* Async: URLRedirectResponse

**Examples:**

Open the stackstate.com website in a new tab in the browser.

```groovy
UI.redirectToURL("http://wwww.stackstate.com")
```

## Function: `showReport`

Shows a report in the user-interface. The user-interface will open a dialog with the report in it. You can also see the result of these reports in the preview of the analytics environment.

**Args:**

* `reportName` - Name of the report. In a dialog with the report, the name of the report will be in the title bar.
* `stmlContent` - The report markup. See [StackState Markup Language](../../stml/) for more information on how to format a report.
* Optional `data` - A map with data elements that can be referenced by the STML.

**Return type:**

* Async: ShowStmlReport

**Examples:**

The following example will show a nice shopping list report:

```groovy
UI.showReport(
    "My shopping list",
    """# To buy
    | Bring *report*.
    |  * Apples
    |  * Oranges
    """.stripMargin()
)
```

Note the `.stripMargin()` call. This is a Groovy function for strings that strips leading whitespace/control characters followed by '\|' from every line. This way, indenting can be retained without introducing leading whitespace in the STML.

## Function: `showTopologyByQuery`

Sets the user-interface to the Topology Perspective and changes the SQTL query.

If the user is currently in an unsaved view, the user receives a prompt dialog asking whether they are okay in navigating to another part of the topology. If the user continues the action they will loose their current view.

**Args:**

* `query` - [STQL query](../../stql_reference.md) that selects what part of the topology is shown.

**Return type:**

* Async: ShowTopologyByQuery

**Examples:**

Redirects the user-interface to show the Azure topology.

```groovy
UI.showTopologyByQuery('domain IN ("Azure")')
```

