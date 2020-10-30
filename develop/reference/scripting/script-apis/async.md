---
title: Script API - Async
kind: Documentation
description: Functions to work with `AsyncScriptResult`
---

# Script API: Async

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

