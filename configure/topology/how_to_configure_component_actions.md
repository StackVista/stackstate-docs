# Configure component actions

This how-to describes the steps to create a Component Action that can be executed from the component context menu in a Topology View.

To start working with Component Actions, go to the Settings page and then in Actions, select "Component Actions". There you can add a new Component Action or edit one that already exists.

![Component Actions](../../.gitbook/assets/component_actions.png)

## Name 

The component action's name is used to display to users which component actions are available. The component action's name is case-sensitive.

## Description

The description is used to populate the tooltip. The tooltip becomes visible to users who hover over the component action in the user interface.

## STQL query

In this step, you determine which components of your topology are going to be able to use this Action. To do that, provide an STQL query that selects all components that should have access to this specific Action. You can find more about queries in StackState on our page about [using STQL](../../develop/reference/stql_reference.md).

The below example binds an Action to all components in the "Production" domain that are present in the "databases" layer.

```text
(domain IN ("Production") AND layer IN ("databases"))
```

## Script

This step determines action's behavior when it is executed from the component context menu. Using the [StackState Scripting Language](/develop/reference/scripting/scripting-in-stackstate.md) you can script almost any action you need, from redirecting the user to another view with context, restarting remote components, to calling predictions for components. See the example scripts below.

Action scripts have access to a `component` variable, representing the component the action was invoked on.

Component properties can be accessed directly:

| Property | Type | Returns |
| :--- | :--- | :--- |
| component.id | Long | The StackGraph id of the component. |
| component.lastUpdateTimestamp | Long | The timestamp the component was last updated. |
| component.name | String| The name of the component. | 
| component.description | Option[String] | The description of the component |
| component.labels | Set[Label] | Set of labels, each containing a `name` property. |  
| state.healthState | HealthStateValue | The health state of the component. Either `UNKNOWN`, `CLEAR`, `DEVIATING` or `CRITICAL`. |
| state.propagatedHealthState | HealthStateValue | The propagated health state of the component. Either `UNKNOWN`, `CLEAR`, `DEVIATING` or `CRITICAL`. |
| layer | Long | The StackGraph id of the layer the component is on. |
| domain | Long | The StackGraph id of the domain the component is on. |
| environments | Set[Long] | The StackGraph ids of the environments the component is on. |

Also see the [Component script API](/develop/reference/scripting/script-apis/component.md) for accessing other component properties.

### Example: Showing a topology query

The action can direct the StackState User Interface to open a new topology query:

```text
def componentId = component.id.longValue()
UI.showTopologyByQuery("withNeighborsOf(direction = 'both', components = (id = '${componentId}'), levels = '15') and label = 'stackpack:openshift'")
```

### Example: Navigating the user to an external URL

The action can direct the StackState User Interface to navigate to a specific URL:

```text
def region = (component.labels.find {it -> it.name.startsWith("region") }).name.split(':')[1]
def url = "https://${region}.console.aws.amazon.com/ec2/home?region=${region}#Instances:sort=instanceId"

UI.redirectToURL(url)
```

### Example: Making HTTP requests

The action can invoke an HTTP request to a remote URL:

```text
Http.post("https://postman-echo.com/post")
    .timeout("30s")
.jsonResponse()
```

This call is made from the StackState server.

## Identifier

Providing an identifier is optional, but is necessary when you want to store your component action in a StackPack. A valid [identifier](/configure/identifiers.md) for a component action is a URN that follows the below convention:

```text
urn:stackpack:{stackpack-name}:component-action:{component-action-name}
```

## See also

* [StackState Query Language (STQL)](/develop/reference/stql_reference.md)    
* [Scripting in StackState](/develop/reference/scripting/scripting-in-stackstate.md)
* [Component script API](/develop/reference/scripting/script-apis/component.md)