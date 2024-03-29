---
description: StackState Self-hosted v5.1.x 
---

# StackState functions

## Overview

Functions in StackState are predefined scripts that transform input into an output. They're called by StackState on-demand. For example, when a component changes state, new telemetry flows in or a user triggers an action. Advanced users can develop their own functions to customize StackState. These functions can then be exported and [packaged with a custom StackPack](../stackpack/develop_stackpacks.md).

## Function types

In StackState, different function types complete different tasks. Depending on the function type, it may be possible to specify [asynchronous or synchronous execution](functions.md#asynchronous-and-synchronous-execution) when creating a custom function. Some default functions are implemented as [native functions](functions.md#native-functions).

| Function type | Synchronous execution | Asynchronous execution | Native functions |
| :--- | :---: | :---: | :--- |
| [Propagation functions](propagation-functions.md#propagation-functions) | ✅ | ✅ | ✅ |
| [Event handler functions](event-handler-functions.md) | ✅ | ✅ | - |
| [Component actions](component-actions.md) | - | ✅ | - |
| [Monitor functions](monitor-functions.md) | - | ✅ | - |
| [Check functions](check-functions.md) | ✅ | - | - |
| [Component mapping functions](mapping-functions.md) | ✅ | - | - |
| [ID extractor functions](id-extractor-functions.md) | ✅ | - | - |
| [Relation mapping functions](mapping-functions.md) | ✅ | - | - |

## Asynchronous and synchronous execution

Functions in StackState run with either synchronous or asynchronous execution. For some functions it's possible to choose the execution type.

* **Asynchronous execution** - functions have access to all StackState [Script APIs](../../reference/scripting/). Selecting asynchronous execution also makes it possible for more functions to run in parallel.
* **Synchronous execution** - functions don't have access to the StackState script APIs. If the function offers the possibility to be run with either asynchronous or synchronous execution, it's recommended to use asynchronous execution.

## Native functions

To improve performance, some default StackState functions have been implemented as native functions. It isn't possible to view or edit the script body of a native function in the StackState UI. It isn't possible to create a custom native function.

