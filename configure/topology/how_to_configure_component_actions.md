# Configure component actions

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

This how-to describes the steps to create a Component Action that can be executed from the component context menu in a Topology View.

To start working with Component Actions, go to the Settings page and then in Actions, select "Component Actions". There you can add a new Component Action or edit one that already exists.

![Component Actions](../../.gitbook/assets/component_actions.png)

## 1. Provide a name and description

A Component Action requires a name that is displayed in the **Actions** context menu; it is mandatory to provide a name. The Description, on the other hand, is optional. However, it is a good practice to provide a bit of explanation that gives more context about your Action.

Please note that the Component Action name is case-sensitive.

## 2. Bind components to your Action with an STQL query

In this step, you determine which components of your topology are going to be able to use this Action. To do that, provide an STQL query that selects all components that should have access to this specific Action. You can find more about queries in StackState on our page about [using STQL](../../develop/reference/stql_reference.md).

The below example binds an Action to all components in the "Production" domain that are present in the "databases" layer.

```text
(domain IN ("Production") AND layer IN ("databases"))
```

## 3. Write a script for your Action to execute

This step determines Action's behavior when it is executed from the component context menu. The scripting language here is [Groovy](https://groovy-lang.org/), and you can script almost any action you need, from redirecting to another View with context, restarting remote components, to calling predictions for components.

Find more about the possibilities of [scripting in StackState](../../develop/reference/scripting/).

## 4. Provide a valid Identifier \(optional\)

A valid Identifier for an Action is a URN that follows the below convention:

```text
urn:stackpack:{stackpack-name}:component-action:{component-action-name}
```

## Examples

Actions have access to a `component` object, representing the component the Action was invoked on.

Component properties can be accessed directly:

```text
def podName = component.name
```

Component labels can be accessed via the `labels` property:

```text
def cluster = (component.labels.find {it -> it.name.startsWith("cluster-name") }).name.split(':')[1]
```

Using `GraphQL`, it is possible to access a specific StackPack's metadata:

```text
def k8sSync = component.synced.find { s ->
    Graph.query({
        it
        .V(s.sync)[0]
        .property('name').value().contains("Kubernetes")
    })
}
def containerId = k8sSync.extTopologyElement.data.containerId
```

### Showing a topology query

The Action can direct StackState to open a new topology query:

```text
def componentId = component.id.longValue()
UI.showTopologyByQuery("withNeighborsOf(direction = 'both', components = (id = '${componentId}'), levels = '15') and label = 'stackpack:openshift'")
```

### Navigating to an external URL

The Action can direct StackState to navigate to a specific URL:

```text
def awsSync = component.synced.find { s ->
    Graph.query({
        it
        .V(s.sync)[0]
        .property('name').value().contains("AWS")
    })
}

def region = awsSync.extTopologyElement.data.Location.AwsRegion
def url = "https://${region}.console.aws.amazon.com/ec2/home?region=${region}#Instances:sort=instanceId"

UI.redirectToURL(url)
```

### Making HTTP requests

The Action can invoke an HTTP request to a remote URL:

```text
Http.post("https://postman-echo.com/post")
    .timeout("30s")
.jsonResponse()
```

