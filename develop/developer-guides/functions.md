# Overview

Functions in StackState are predefined scripts that transform input into an output. They are called by StackState on-demand. For example, when a component changes state, new telemetry flows in ora user triggers an action. Advanced users can develop their own functions to customize StackState. These functions can then be exported and packaged with a custom StackPack. Read more about it in [how to create StackPacks](../../stackpacks/about-stackpacks.md).

Functions in StackState run with either synchronous or asynchronous execution. 

- **Asynchronous execution** - functions have access to all StackState [Script APIs](../reference/scripting/README.md). Selecting asynchronous execution also makes it possible for more functions to run in parallel.
- **Synchronous execution** - functions do not have access to the StackState script APIs. If the function offers the possibility to be run with either asynchronous or synchronous execution, it is recommended to use asynchronous execution.

The default execution type and available possibilities vary per function type:

| Function | Synchronous | Asynchronous |
| :--- | :---: | :---: |
| [Event handler functions](custom-functions/event-handler-functions.md) | ✅ | ✅ |
| [Propagation functions](custom-functions/propagation-functions.md#propagation-functions) | ✅ | ✅ |
| [Component actions](custom-functions/component-actions.md) | - | ✅ |
| [Check functions](/develop/developer-guides/custom-functions/check-functions.md) | ✅ | - |
| [Component mapper functions](custom-functions/mapper-functions.md) | ✅ | - |
| [Id extractor functions](custom-functions/id-extractor-functions.md) | ✅ | - |
| [Relation mapper functions](custom-functions/mapper-functions.md) | ✅ | - |


