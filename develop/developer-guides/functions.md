# Overview

Functions in StackState are predefined scripts that transform input into an output. They are called by StackState on-demand. For example, when a component changes state, new telemetry flows in ora user triggers an action. Advanced users can develop their own functions to customize StackState. These functions can then be exported and packaged with a custom StackPack. Read more about it in [how to create StackPacks](../../stackpacks/about-stackpacks.md).

Functions in StackState run as either [synchronous](#synchronous-execution) or [asynchronous](#asynchronous-execution) execution. The default execution type and available possibilities vary per function type:

| Function | Synchronous | Asynchronous |
| :--- | :---: | :---: |
| Event handler function | ✅ | ✅ |
| Propagation functions | ✅ | ✅ |
| Component actions | - | ✅ |
| Check functions | ✅ | - |
| Component mapper functions | ✅ | - |
| Id extractor functions | ✅ | - |
| Relation mapper functions | ✅ | - |
| Baseline function \(deprecated\) | ✅ | - |

### Asynchronous execution

Functions that run with asynchronous execution have access to all StackState [Script APIs](../reference/scripting/README.md). Selecting asynchronous execution also makes it possible for more functions to run in parallel.

Read more about:

* [Component actions](custom-functions/component-actions.md)
* [Event handler functions](custom-functions/event-handler-functions.md)
* [Propagation functions](custom-functions/propagation-functions.md#propagation-functions)

### Synchronous execution

Functions that run with synchronous execution do not have access to the StackState script APIs. If the function offers the possibility to be run with either asynchronous or synchronous execution, it is recommended to use asynchronous execution.

Read more about:

* [Check functions](/develop/developer-guides/custom-functions/check-functions.md)
* [Component mapper functions](custom-functions/mapping_functions.md)
* [Event handler functions](/develop/developer-guides/custom-functions/event-handler-functions.md)  
* [Id extractor functions](custom-functions/id-extractor-functions.md)
* [Propagation functions](custom-functions/propagation-functions.md#propagation-functions)
* [Relation mapper functions](custom-functions/mapping_functions.md)
* [Baseline functions\(deprecated\)](../../use/health-state-and-event-notifications/anomaly-detection-with-baselines.md#baseline-functions)

