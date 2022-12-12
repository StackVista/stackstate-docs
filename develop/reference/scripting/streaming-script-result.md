---
description: StackState Self-hosted v5.1.x 
---

# Streaming script result

Most API functions execute asynchronously. That means they won't directly return results. Some functions are dependent on the network or other resources to complete, therefore they can't immediately return results. Such asynchronous functions return an `AsyncScriptResult`. On top of that, some APIs can deal with large amounts of data, in which case we don't want to process all the data at once. Such APIs return a `StreamingScriptResult`, which allows for the result to be processed one element at a time. 

## Working with `StreamingScriptResult.then`

If the result of your script is returned as a `StreamingScriptResult`, StackState will produce an asynchronously executed stream of data. If you want to further process the data in the `StreamingScriptResult`, the `.then` method can be used.

The `.then` method expects a [Groovy closure /(groovy-lang.org/)](https://groovy-lang.org/closures.html). The closure will be executed for each element in the `StreamingScriptResult`. This lambda function can work with the element and returns a new list of items or a single new item.

For example:

```text
streamingScriptResult = ScriptApi.streamingFn()
streamingScriptResult.then { result -> result.toString() }
```

The Groovy script above can be shortened to:

```text
ScriptApi.streamingFn().then { it.toString() }
```

The `it` keyword is a default Groovy keyword that means you don't need to define a variable in which you receive your result. You might see this being used in our examples.

## Chaining

To avoid computations becoming too heavy, the `StreamingScriptResult` can't be chained with either `AsyncScriptResult` or `StreamingScriptResult` itself. 

## Collecting results

The `StreamingScriptResult` can be returned from a script, after which the script runtime will take care of collecting the results. This is the preferred way of using the `StreamingScriptResult` because it allows StackState to process data incrementally with constant memory. In exceptional cases, it can be useful to actually run a stream, such that all results are accessible. This can be achieved with the `collectStream` function.

{% hint style="warning" %}
Be careful collecting data from a stream with higher limits. This can cause memory pressure and the script to fail. It's always best not to collect the data and process the data in a streaming fashion.
{% endhint %}

For example:

```text
ScriptApi.streamingFn().collectStream(10)
```

Will result in an [AsyncScriptResult](async-script-result.md) with the streamed items in a list. If the limit is exceeded, the execution will fail. To avoid failing if the limit is reached, but still produce the maximum amount of results, collectStream takes a second parameter:

```text
ScriptApi.streamingFn().collectStream(10, false)
```

## See also

* [Async script result](async-script-result.md)

