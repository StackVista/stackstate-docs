---
description: Functions that control the user-interface.
---

# Script API: UI

{% hint style="info" %}
These functions only work in the context of scripts that are executed by a user from the user-interface. [Component actions](/configure/topology/component_actions.md) are an example of scripts that can trigger actions in the user-interface.
{% endhint %}

## Function: `baseUrl`

Returns the base URL from the StackState configuration. This is the parameter `stackstate.baseUrl` or the environment variable `STACKSTATE_BASE_URL`.

**Args:**

None.

**Return type:**

* ???

**Examples:**

Return the base URL from the StackState configuration.

```text
UI.baseUrl()
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
* `stmlContent` - The report markup. See [StackState Markup Language](/develop/reference/stml/README.md) for more information on how to format a report.
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

* `query` - [STQL query](/develop/reference/stql_reference.md) that selects what part of the topology is shown.

**Return type:**

* Async: ShowTopologyByQuery

**Examples:**

Redirects the user-interface to show the Azure topology.

```text
UI.showTopologyByQuery('domain IN ("Azure")')
```