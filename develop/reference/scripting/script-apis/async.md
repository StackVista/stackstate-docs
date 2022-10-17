---
description: StackState Self-hosted v5.0.x 
---

# Async - script API

{% hint style="warning" %}
**This page describes StackState version 5.0.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/develop/reference/scripting/script-apis/async).
{% endhint %}

The Async API offers top-level helper functions for working with [asynchronous script results](../async-script-result.md).

## Function: `Async.sequence(list: AsyncScriptResult[])`

Flattens async results of Script API functions.

### Args

* `list` - a sequence of asynchronous script results.

### Examples

The example below will return the AsyncScriptResult of the list of results of functions `asyncFn2()` and `asyncFn3()`

```text
Async.sequence([ScriptApi.asyncFn2(), ScriptApi.asyncFn3()])
```

Optionally the flattening can be done implicitly with `ScriptApi.then()` combinator.

