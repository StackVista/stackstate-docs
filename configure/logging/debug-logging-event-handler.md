---
description: Set the logging level for an event handler
---

# How to enable DEBUG logging for an event handler

## Overview

You can set the logging level of event handlers using the StackState CLI. 

## Set logging level to DEBUG for an event handler

Follow the steps below to enable DEBUG logging for a specific event handler ID. This will add DEBUG level messages to the `stackstate.log` together with the event handler ID.

1. Get the ID of the event handler function:
    ```
    Graph.query{it.V().hasLabel("EventHandler")}
    ```

2. Get the ID of the correct event handler, there might be more in this output — I only have one. Correct ID in this case is: 39169420504614
Scope is in this case the QueryView:
    ```
    Graph.query{it.V(59013784209828)}
    ```

3. Set the log level using the [StackState CLI](/setup/cli.md):
    ```
    sts serverlog setlevel 39169420504614 DEBUG
    ```

4. Monitor the `stackstate.log` using the event handler ID.
    ```
    tail -f stackstate.log | grep 39169420504614
    ```

## See also

- [Alerting using event handlers](/use/alerting.md#send-alerts-with-event-handlers)
- [StackState log files](/configure/logging/stackstate_log_files.md)
- [StackState CLI](/setup/cli.md)