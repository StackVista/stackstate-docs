---
title: Script API - StackPack
kind: Documentation
description: Functions to work with StackPacks
---

# StackPack - script API

The StackPack script API provides handy operations to get the status of a StackPack or resources that are provided by a StackPack.

## Function `isInstalled`

Returns a flag indicating if the StackPack is installed

**Args:**

* `name` - the name of a StackPack. The name must match exactly (case sensitive). The name of a StackPack is visible in the breadcrumb of the StackPack in the user-interface or can be gotten by executing the [CLI](/setup/installation/cli-install.md) command: `sts stackpack list`.

**Examples:**

The example below will return the AsyncScriptResult of the boolean indicating if the `"agent"` StackPack is installed

```text
StackPack.isInstalled("agent")
```

## Function `getResources`

Returns resources originating from the StackPack.

**Args:**

* `namespaceName` - the name of the URN namespace of the StackPack. For example `aad` checks for resources in the namespace `urn:stackpack:aad`.
* `nodeType` - the type of node, e.g. `CheckFunction`, `QueryView`, etc. You can get a full listing of all types by executing the [CLI](/setup/installation/cli-install.md) command: `sts graph list-types`.

**Examples:**

The example below will return an AsyncScriptResult of an array of resources with type `CheckFunction` from the `agent` StackPack.

```text
StackPack.getResources("agent", "CheckFunction")
```
