# Asynchronous and synchronous execution

## Overview

Functions in StackState run with either [synchronous](#synchronous-execution) or [asynchronous](#asynchronous-execution-recommended) execution. For some functions it is possible to choose the execution type.

| Function | Synchronous | Asynchronous |
| :--- | :---: | :---: |
| Event handler functions | ✅ | ✅ |
| Propagation functions | ✅ | ✅ |
| Component action functions | - | ✅ |
| Baseline functions \(deprecated\) | ✅ | - |
| Check functions | ✅ | - |
| Component mapper functions | ✅ | - |
| Id extractor functions | ✅ | - |
| Relation mapper functions | ✅ | - |

### Asynchronous execution \(recommended\)

Functions that run with asynchronous execution have access to all StackState [Script APIs](/develop/reference/scripting/README.md). It is also possible for more functions to run in parallel with asynchronous execution.

Read more about:

* [Component action functions](/develop/developer-guides/custom-functions/component-action-functions.md)
* [Event handler functions](/develop/developer-guides/custom-functions/event-handler-functions.md)
* [Propagation functions](/develop/developer-guides/custom-functions/propagation-functions.md)

### Synchronous execution

When a function runs with synchronous execution, it will not have access to the StackState script APIs. If it is possible to choose an execution type, it is recommended to choose asynchronous execution.

Read more about:

* [Check functions](/develop/developer-guides/custom-functions/check-functions.md)
* [Anomaly check functions](/develop/developer-guides/custom-functions/anomaly-check-functions.md)
* [Component and relation mapping functions](/develop/developer-guides/custom-functions/mapping_functions.md)
* [Id extractor functions](/develop/developer-guides/custom-functions/id_extraction.md)
* [Propagation functions](/develop/developer-guides/custom-functions/propagation-functions.md)
* [Baseline functions \(deprecated\)](/develop/developer-guides/custom-functions/baseline-functions.md)