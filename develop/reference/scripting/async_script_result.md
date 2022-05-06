---
description: StackState Self-hosted v5.0.x
---

# Async script result

Most API functions execute asynchronously. That means they will not directly return results. Some functions are dependent on the network or other resources in order to complete, therefore they can not immediately return results. Such asynchronous functions return an `AsyncScriptResult`. The concept of an `AsyncScriptResult` is modelled after how promises work in JavaScript.

## Working with `AsyncScriptResult.then`

If the result of your script returns is an `AsyncScriptResult` StackState will automatically wait for the actual result to resolve. If however you want to continue your script with the resolved result of an `AsyncScriptResult` you must use the `.then` method.

The `.then` method expects a [Groovy closure](https://groovy-lang.org/closures.html). The closure will execute as soon as the result is received. This lambda function can work with the result and return either a new `AsyncScriptResult` or a simple \(synchronous\) result.

For example:

```text
asyncScriptResult = ScriptApi.asyncFn()
asyncScriptResult.then { result -> result.toString() }
```

The Groovy script above can be shortened to:

```text
ScriptApi.asyncFn().then { it.toString() }
```

The `it` keyword is default Groovy keyword that you do not need to define a variable in which you receive your result. You might see this being used in our examples.

### Chaining

Multiple asynchronous script results can be chained together. This is useful for combining for example the results of topology with telemetry.

For example:

```text
ScriptApi.asyncFn1()
  .then {  ScriptApi.asyncFn2(it)  }
  .then {  ScriptApi.asyncFn3(it)  }
```

Is equivalent to:

```text
ScriptApi.asyncFn1()
  .then {  ScriptApi.asyncFn2(it).then { ScriptApi.asyncFn3(it) }  }
```

The above means that the results of `asyncFn1` are passed to `asyncFn2`, then the results of `asyncFn2` in turn are passed to `asyncFn3`.

### Flattening

Arrays of `AsyncScriptResult` are automatically flattened when returned from a `.then` call. For example:

```text
ScriptApi.asyncFn1().then  {
  [ScriptApi.asyncFn2(), ScriptApi.asyncFn3()]
}
```

will return an array of both the result of `asyncFn2` and `asyncFn3`.

### Transforming a list using `thenCollect`

Often it is desirable to transform a list of element coming from an `AsyncScriptResult`.

Assuming `ScriptApi.asyncFn1()` return an `AsyncScriptResult` that contains the list `[1,2,3]`, this can be transformed to `[2,3,4]` in the following way:

```text
ScriptApi.asyncFn1().then { result
  result.collect { it + 1}
}
```

However, since this pattern is seen so often a shortcut is available for `.then { it.collect { ... }}`, which makes it possible to rewrite the above as:

```text
ScriptApi.asyncFn1().thenCollect { it + 1}
```

### Reducing with `thenInject`

Arrays of `AsyncScriptResult` can be automatically reduced when returned. For example:

```text
ScriptApi.asyncFn1().thenInject([])  { accumulator, element ->
  accumulator + element
}
```

Suppose that `asyncFn1` returns a list, then subsequent `thenInject` call can accumulate the result, in this case using summation.

In particular this call can be interesting for the cases where an accumulating operation returns the `AsyncScriptResult`. See example below:

```text
ScriptApi.asyncFn1().thenInject([])  { accumulator, element ->
  ScriptApi.asyncFn2(element)
    .then { result -> accumulator + result }
}
```

### Handling Exceptions

It is sometimes necessary to handle exceptions raised during execution of `AsyncScriptResult`. This can be achieved using `catchError` function. For example:

```text
ScriptApi.asyncFn1().catchError { ex ->
  // Do something with the exception
  ex.getMessage()
}
```

Any result returned by the closure passed to `catchError` gets automatically flattened just like `.then` call.

