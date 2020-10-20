---
description: Set the logging level for an event handler
---

# How to enable DEBUG logging for an event handler

## Overview

You can set the logging level of event handlers using the StackState CLI. 

## Set logging level to DEBUG for an event handler

Follow the steps below to enable DEBUG logging for a specific event handler ID. This will add DEBUG level messages to the `stackstate.log` together with the event handler ID.

1. Get the ID of the event handler function. Run the below query in the [StackState UI Analytics environment](/develop/scripting.md#running-scripts):
    ```
    Graph.query{it.V().hasLabel("EventHandler")}
    ```

2. Find the event handler ID in the returned **Result**.

3. Set the log level for the event handler ID using the [StackState CLI](/setup/cli.md):
    ```
    sts serverlog setlevel <id> DEBUG
    ```

4. Monitor the `stackstate.log` using the event handler ID.
    ```
    tail -f stackstate.log | grep 39169420504614
    ```

## See also

- [Alerting using event handlers](/use/alerting.md#send-alerts-with-event-handlers)
- [StackState log files](/configure/logging/stackstate_log_files.md)
- [StackState CLI](/setup/cli.md)
- [Running scripts in the StackState UI analytics environment](/develop/scripting.md#running-scripts)