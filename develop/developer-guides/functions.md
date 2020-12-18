---
description: Extending StackState's capabilities using functions.
---

# Extend StackState with functions

{% hint style="warning" %}
This page describes StackState version 4.1.  
Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

StackState is built to deal with a wide variety of different situations. StackState comes with functions to stay flexible enough to account for different types of logic.

Functions are predefined scripts that transform input into an output. Functions are called by StackState on-demand. For example, when a component changed state, some new telemetry flowed in or when the user triggered an action.

## Packaging functions

Functions give power-users the ability to customize StackState fully. However, everyday users of StackState should not need to know that they exist.

StackPacks pre-package functions and automatically install functions on StackState whenever the StackPack gets installed. You can develop your function in StackState. When you are confident that it does what you want, you can export it and package it with a StackPack. Read more about it in [how to create StackPacks](../../stackpacks/about-stackpacks.md).

## Async vs synchronous functions

Functions in StackState can be either synchronous or asynchronous \(async\).

| Function | Synchronous | Async |
| :--- | :---: | :---: |
| Baseline function | ✅ | - |
| Check function | ✅ | - |
| Component mapper function | ✅ | - |
| Event handler function | ✅ | - |
| Id extractor function | ✅ | - |
| Propagation functions | ✅ | ✅ \(from v1.15.1\) |
| Relation mapper function | ✅ | - |

### Async functions

Propagation functions can optionally be created as asynchronous \(async\) functions. This gives the function access to the [Script APIs](../reference/scripting/) and allows more functions to be run in parallel.

Read more about [propagation functions](../../configure/topology/propagation.md#custom-propagation-functions).

### Synchronous functions

In StackState, functions are generally written in a synchronous blocking manner.

Read more about:

* [Baseline functions](../../use/baselining.md#baseline-functions)
* [Check functions](../../configure/telemetry/checks_and_streams.md#check-functions)
* [Component mapper functions](../../use/introduction-to-stackstate/mapping_functions.md)
* [Event handler functions](../../use/alerting.md#alerting-using-event-handlers)
* [Id extractor functions](../../use/introduction-to-stackstate/id_extraction.md)
* [Propagation functions](../../configure/topology/propagation.md#custom-propagation-functions)
* [Relation mapper functions](../../use/introduction-to-stackstate/mapping_functions.md)

