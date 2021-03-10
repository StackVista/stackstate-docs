---
title: Script API - StackPack
kind: Documentation
description: Functions to work with StackPacks
---

# StackPack - script API

The StackPack script API provides handy operations to get the status of a StackPack or resources that provided or originated from a StackPack

## Function `isInstalled`

Returns a flag indicating if the StackPack is installed

**Args:**

* `name` - the name of a StackPack

**Examples:**

The example below will return the AsyncScriptResult of the boolean indicating if the `"agent"` StackPack is installed

```text
StackPack.isInstalled("agent")
```

## Function `getResources`

Returns resources originating from the StackPack

**Args:**

* `name` - the name of a StackPack
* `resourceType` - the type of resource, e.g. CheckFunction

**Examples:**

The example below will return the AsyncScriptResult of the array of resources with type `"CheckFunction"` from from `"agent"` StackPack.

```text
StackPack.getResources("agent", "CheckFunction")
```
