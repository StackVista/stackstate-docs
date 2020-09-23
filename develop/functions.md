---
description: Extending StackState's capabilities using functions.
---

# Extending StackState with functions

StackState is built to deal with a wide variety of different situations. StackState comes with functions to stay flexible enough to account for different types of logic.

Functions are predefined scripts that transform input into an output. Functions are called by StackState on-demand. For example, when a component changed state, some new telemetry flowed in or when the user triggered an action.

## Packaging Functions

Functions give power-users the ability to customize StackState fully. However, everyday users of StackState should not need to know that they exist.

StackPacks pre-package functions and automatically install functions on StackState whenever the StackPack gets installed. You can develop your function in StackState. When you are confident that it does what you want, you can export it and package it with a StackPack. Read more about it in [how to create StackPacks](../stackpacks/about-stackpacks.md).

## Async vs sync functions

Functions in StackState can be either synchronous or asynchronous (async).

| Function | Synchronous | Async |
|:---|:---:|:---:|
| Baseline function | ✅ | - |
| Check function | ✅ | - |
| Component mapper function | ✅ | - |
| Event handler function | ✅ | - |
| Id extractor function | ✅ | - |
| Propagation functions | ✅| ✅ \(from v1.15.1\) |
| Relation mapper function | ✅ | - |


### Async Functions

StackState started supporting a new kind of function called _async_ functions that allow anyone to access the [Script APIs](scripting/). The following functions have started supporting the _async_ mode and no longer allows you to edit the older \(legacy\) synchronous function anymore, though the older synchronous functions will remain working.

Read more about:

- [Propagation functions](../configure/propagation.md#custom-propagation-functions)

### Synchronous Functions

In StackState, functions are generally written in a synchronous blocking manner. This places some limitations on both the capability of what the functions can achieve and the number of functions that can be run in parallel.

Read more about:

- [Baseline functions](../use/baselining.md#baseline-functions)
- [Check functions](../configure/checks_and_streams.md#check-functions)
- [Component mapper functions](../concepts/component_and_relation_mapping_functions.md)
- [Event handlre functions](../use/alerting.md#alerting-using-event-handlers)
- [Id extractor functions](../concepts/id_extraction.md)
- [Propagation functions](../configure/propagation.md#custom-propagation-functions)
- [Relation mapper functions](../concepts/component_and_relation_mapping_functions.md)
