---
title: Script API - StackPack
kind: Documentation
description: Functions to work with StackPacks
---

# StackPack - script API

{% hint style="warning" %}
**This page describes StackState version 4.2.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

The StackPack script API provides handy operations to get the status of a StackPack

## Function `isInstalled`

Returns a flag indicating if the StackPack is installed

**Args:**

* `name` - the name of a StackPack

**Examples:**

The example below will return the AsyncScriptResult of the boolean indicating if the `"agent"` StackPack is installed

```text
StackPack.isInstalled("agent")
```

