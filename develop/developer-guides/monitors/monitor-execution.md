---
description: StackState Self-hosted v5.0.x
---

# Monitor execution

## Overview

Monitors are run by a dedicated subsystem of StackState called the monitor runner. The main task of the monitor runner is to schedule the execution of all existing monitors in such a way as to ensure that all of them produce viable results in a timely manner.

## Monitor run interval

The monitor runner schedules monitor execution using an interval parameter that is configured on a per-monitor basis - the `intervalSeconds`. The runner will attempt to schedule a monitor execution every `intervalSeconds`, counting from the end of the previous execution cycle, in parallel to the other existing Monitors (subject to resource limits). For example, setting `intervalSeconds` of a monitor definition to the value `600` will cause the monitor runner to attempt to schedule the execution of this monitor every ten minutes, assuming that the execution time itself is negligible.

## Apply changes to a monitor

The runner is maintenance free - it starts whenever StackState starts and picks up any newly applied monitor definitions automatically whenever they are created, changed or removed. Any changes to the Monitors are reflected with the next execution cycle and any execution issues are logged to the global StackState log file. 

## Monitor status

The status of a monitor can be obtained via the StackState CLI:

{% tabs %}
{% tab title="CLI: sts (new)" %}
```
# By ID
sts monitor status --id <id-of-a-monitor>
# By Identifier
sts monitor status --identifier <identifier-of-a-monitor>
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endtab %}
{% tab title="CLI: stac" %}
```
stac monitor status <id-or-identifier-of-a-monitor>
```

**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
{% endtab %}
{% endtabs %}

The output of this command indicates the specific errors that occurred along with the counts of how many times they happened and the health stream statistics associated with this monitor. Any execution issues are also logged in the global StackState log file. 

## Disable the monitor runner

The monitor runner subsystem can be disabled in the StackState configuration by appending the following line at the end of the file `etc/application_stackstate.conf`:

`stackstate.featureSwitches.monitorRunner = false`
