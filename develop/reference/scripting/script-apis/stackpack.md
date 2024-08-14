---
description: Rancher Observability Self-hosted v5.1.x
---

# StackPack - script API

The StackPack script API provides handy operations to get the status of a StackPack or resources that are provided by a StackPack.

## Function: `StackPack.isInstalled(name: String)`

Returns a flag indicating if the StackPack is installed

### Args

* `name` - the name of a StackPack. This much match exactly \(case-sensitive\). The name of a StackPack can be found in the breadcrumb trail of the StackPack in the Rancher Observability UI or can be retrieved using [Rancher Observability CLI](../../../../setup/cli/README.md) command:

```sh
sts stackpack list
```

### Examples

The example below will return an `AsyncScriptResult` of a boolean indicating if the `agent` StackPack is installed

```text
StackPack.isInstalled("agent")
```

## Function: `StackPack.getResources(stackPackNamespace: String, nodeType: String)`

Returns resources originating from the StackPack.

### Args

* `stackPackNamespace` - the name of the URN namespace of the StackPack. For example `aad` checks for resources in the namespace `urn:stackpack:aad`.
* `nodeType` - the type of node, for example `CheckFunction` or `QueryView`. You can get a full listing of all using the [Rancher Observability CLI](../../../../setup/cli/README.md) command:

```sh
sts settings list-types
```

### Examples

The example below will return an `AsyncScriptResult` of an array of resources with type `QueryView` from the `agent` StackPack.

```text
StackPack.getResources("agent", "QueryView")
```

