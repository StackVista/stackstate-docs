# Asynchronous and synchronous execution

## Overview

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

* [Component actions](../../configure/topology/how_to_configure_component_actions.md)
* [Event handlers](/develop/developer-guides/custom-functions/event-handler-functions.md)
* [Propagation functions](/develop/developer-guides/custom-functions/propagation-functions.md)

### Synchronous functions

In StackState, functions are generally written in a synchronous blocking manner.

Read more about:

* [Baseline functions](/develop/developer-guides/custom-functions/baseline-functions.md)
* [Check functions](/develop/developer-guides/custom-functions/check-functions.md)
* [Anomaly check functions](/develop/developer-guides/custom-functions/anomaly-check-functions.md)
* [Component and relation mapping functions](/develop/developer-guides/custom-functions/mapping_functions.md)
* [Id extractor functions](/develop/developer-guides/custom-functions/id_extraction.md)
* [Propagation functions](/develop/developer-guides/custom-functions/propagation-functions.md)