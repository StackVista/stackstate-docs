---
description: StackState Self-hosted v5.0.x 
---

# Async - script API

{% hint style="warning" %}
**This page describes StackState version 5.0.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/develop/reference/scripting/script-apis/async).
{% endhint %}

Some Script API functions are executed asynchronously and, instead of returning result directly, they return a `promise` of a result in the form of an `AsyncScriptResult`. The `Async` Script API offers functions to work with `AsyncScriptResult`.

## Function: `sequence`

Flattens async results of Script API functions.

### Args

* `list` - the list of `AsyncScriptResult`

### Examples

The example below will return the AsyncScriptResult of the list of results of functions `asyncFn2()` and `asyncFn3()`

```text
Async.sequence([ScriptApi.asyncFn2(), ScriptApi.asyncFn3()])
```

Optionally the flattening can be done implicitly with `ScriptApi.then()` combinator.

