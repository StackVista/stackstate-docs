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
* [Event handlers](../../use/health-state-and-event-notifications/send-event-notifications.md)
* [Propagation functions](../../configure/topology/propagation.md#custom-propagation-functions)

### Synchronous functions

In StackState, functions are generally written in a synchronous blocking manner.

Read more about:

* [Baseline functions]()
* [Check functions](../../configure/telemetry/checks_and_streams.md#check-functions)
* [Component mapper functions](../../use/introduction-to-stackstate/mapping_functions.md)
* [Id extractor functions](../../use/introduction-to-stackstate/id_extraction.md)
* [Propagation functions](../../configure/topology/propagation.md#custom-propagation-functions)
* [Relation mapper functions](../../use/introduction-to-stackstate/mapping_functions.md)