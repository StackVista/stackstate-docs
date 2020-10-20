---
description: Use logging in StackState functions
---

# How to add logging to StackState functions

## Overview

You can add logging statements to StackState functions. This is useful for debug purposes. Logs will appear in `stackstate.log`.

## Add logging to a StackState function

1) Add a log statement in the function's code. For example:
    - `log.info("message")`
    - `log.info(variable.toString)`

2) Find the StackState function ID from the StackState UI:
    a. Click on a component to open the component details.
    b. Click on **...** and select **Show JSON**.
    c. Find the section for the function type you would like to log, e.g. `propagation`.
    d. Copy the value from the field `id`.

![Show JSON](/.gitbook/assets/v41_show-json.png)

3) Use the [StackState CLI](/setup/cli.md) to set the log level for the function ID:
```
sts serverlog setlevel <id> DEBUG
```

4) Monitor the `stackstate.log` using the function ID.
```
tail -f stackstate.log | grep <id>
```

## See also

- [StackState CLI](/setup/cli.md)