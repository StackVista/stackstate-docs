---
description: StackState Self-hosted v4.5.x
---

# Async - script API

{% hint style="warning" %}
This page describes StackState v4.5.x.
The StackState 4.5 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.5 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/develop/reference/scripting/script-apis/async).
{% endhint %}

The Script API functions are executed asynchronously and instead of returning result directly they return a `promise` of result in the form of `AsyncScriptResult`. The `Async` Script API offers functions to work with `AsyncScriptResult`

## Function `sequence`

Flattening async results of Script API functions.

**Args:**

* `list` - the list of `AsyncScriptResult`

**Examples:**

The example below will return the AsyncScriptResult of the list of results of functions `asyncFn2()` and `asyncFn3()`

```text
Async.sequence([ScriptApi.asyncFn2(), ScriptApi.asyncFn3()])
```

Optionally the flattening can be done implicitly with `ScriptApi.then()` combinator.

