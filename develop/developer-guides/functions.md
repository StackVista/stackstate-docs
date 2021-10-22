---
description: Extending StackState's capabilities using functions.
---

# Extend StackState with functions

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

StackState is built to deal with a wide variety of different situations. StackState comes with functions to stay flexible enough to account for different types of logic.

Functions are predefined scripts that transform input into an output. Functions are called by StackState on-demand. For example, when a component changed state, some new telemetry flowed in or when the user triggered an action.

## Packaging functions

Functions give advanced users the ability to customize StackState fully. However, everyday users of StackState should not need to know that they exist.

StackPacks pre-package functions and automatically install functions on StackState whenever the StackPack gets installed. You can develop your function in StackState. When you are confident that it does what you want, you can export it and package it with a StackPack. Read more about it in [how to create StackPacks](../../stackpacks/about-stackpacks.md).

## Async vs synchronous functions

Functions in StackState can be either synchronous or asynchronous \(async\).

| Function | Synchronous | Async |
| :--- | :---: | :---: |
| Event handler function | ✅ | ✅ \(from v4.2\) |
| Propagation functions | ✅ | ✅ |
| Baseline function | ✅ | - |
| Check function | ✅ | - |
| Component actions | - | ✅ |
| Component mapper function | ✅ | - |
| Id extractor function | ✅ | - |
| Relation mapper function | ✅ | - |

### Async functions

Propagation functions and event handler functions can be created as asynchronous \(async\) functions, while component action scripts always run as async. This gives them access to all StackState [Script APIs](../reference/scripting/) and allows more functions to run in parallel.

Read more about:

* [Component actions](/configure/topology/how_to_configure_component_actions.md)
* [Event handlers](../../use/health-state-and-event-notifications/send-event-notifications.md)
* [Propagation functions](../../configure/topology/propagation.md#custom-propagation-functions)


### Synchronous functions

In StackState, functions are generally written in a synchronous blocking manner.

Read more about:

* [Baseline functions](../../use/health-state-and-event-notifications/anomaly-detection-with-baselines.md#baseline-functions)
* [Check functions](../../configure/telemetry/checks_and_streams.md#check-functions)
* [Component mapper functions](../../use/introduction-to-stackstate/mapping_functions.md)
* [Id extractor functions](../../use/introduction-to-stackstate/id_extraction.md)
* [Propagation functions](../../configure/topology/propagation.md#custom-propagation-functions)
* [Relation mapper functions](../../use/introduction-to-stackstate/mapping_functions.md)

