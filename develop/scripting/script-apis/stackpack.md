---
title: Script API - StackPack
kind: Documentation
description: Functions to work with StackPacks
---

# Script API: StackPack

StackPack script api provides handy operations to get status of a StackPack

## Function `isInstalled`

Returns a flag indicating if the StackPack is installed

**Args:**

* `name` - the name of a StackPack

**Examples:**

The example below will return the AsyncScriptResult of the boolean indicating if the "agent" StackPack is installed

```text
StackPack.isInstalled("agent")
```
