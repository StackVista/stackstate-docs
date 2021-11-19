---
description: Functions that control the StackState user-interface.
---

# UI - script API

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

{% hint style="info" %}
These functions only work in the context of scripts that are executed by a user from the user-interface. [Component actions](../../../../configure/topology/component_actions.md) are an example of scripts that can trigger actions in the user-interface.
{% endhint %}

## Function: baseUrl

Returns the baseUrl of the StackState instance as configured in the `application.conf` or `values.yaml`.

**Examples:**

Return the base URL from the StackState configuration.

```text
UI.baseUrl()
```

## Function: `createUrl`

Creates a URL builder that can be used to generate URLs that can be linked back in Stackstate.

**Args:**

No arguments.

**Return type:**

CreateUrlBuilder

**Builder methods:**

* `view()` - returns a `ViewUrlBuilder` for the specified view with the following methods:
  * `at(time: instant)` -  specifies a [time](time.md) for which the view query should be executed.
  * `withComponent(component)` - creates a view URL with the specified component in focus.
  * `url()` - gives the final URL of the view.

**Examples:**

Create a URL to a view at a specific time.

```text
View.getAll().then { views ->
    UI.createUrl().view(views[0]).at('-15m').url()
}
```

## Function: `redirectToURL`

Opens a new tab in the user's browser to some URL.

**Args:**

* `url` - the URL to redirect the browser to.

**Return type:**

* Async: URLRedirectResponse

**Examples:**

Open the stackstate.com website in a new tab in the browser.

```text
UI.redirectToUrl("http://wwww.stackstate.com")
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

```text
UI.showReport(
    "My shopping list",
    """# To buy
    | Bring *report*.
    |  * Apples
    |  * Oranges
    """.stripMargin()
)
```

Please note the `.stripMargin()` call. This is a Groovy function for strings that strips leading whitespace/control characters followed by '\|' from every line. This way, indenting can be retained without introducing leading whitespace in the STML.

## Function: `showTopologyByQuery`

Sets the user-interface to the Topology Perspective and changes the SQTL query.

If the user is currently in an unsaved view, the user receives a prompt dialog asking whether they are okay in navigating to another part of the topology. If the user continues the action they will loose their current view.

**Args:**

* `query` - [STQL query](../../stql_reference.md) that selects what part of the topology is shown.

**Return type:**

* Async: ShowTopologyByQuery

**Examples:**

Redirects the user-interface to show the Azure topology.

```text
UI.showTopologyByQuery('domain IN ("Azure")')
```

Create a URL to a view focussing on a component.

```text
View.getAll().then { views ->
    Component.withId(component).get().then { component ->
        UI.createUrl().view(views[0]).at('-15m').withComponent(component).url()
    }
}
```
