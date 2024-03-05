---
description: StackState SaaS
---

# Manage monitors

## Overview

Monitors process 4T data, such as metrics, events and topology, to produce a health state for elements \(components and relations\). The states are calculated and attached to relevant topology elements by a specific monitor function that's selected by the user.

Monitors are run by a dedicated subsystem of StackState called the monitor runner. The main task of the monitor runner is to schedule the execution of all existing monitors in such a way as to ensure that all of them produce viable results in a timely manner. The monitor runner is maintenance free - it starts whenever StackState starts and picks up any newly applied monitor definitions automatically whenever they're created, changed or removed. Any changes that have been applied to the monitors are reflected with the next execution cycle.

## Single monitor

### Add a monitor

Most Monitors in StackState are created as part of a StackPack installed by the user with no further action required. The monitors are added upon installation of the StackPack and immediately start to produce health state results. Monitors automatically handle newly created topology elements and don't need to be specifically reconfigured after any topology changes occur or otherwise added to the newly created elements.

* Details of the monitor functions provided by StackPacks can be found in [the StackPack documentation](../../stackpacks/integrations/README.md).
* You can [create a custom monitor](../../develop/developer-guides/monitors/create-custom-monitors.md) from scratch using the StackState CLI.

It might be beneficial to modify an existing monitor definition to change its parameters, run interval or to disable it. All of these actions are done by utilizing the StackState CLI and are described in greater detail in the following sections.

### Edit a monitor

Monitor configuration can be changed by modifying the monitor definition.

1. Find the ID or the identifier of the monitor to be modified. For example:
   * **In the StackState UI:** Inspect the monitor definition using the context menu (...) of the [monitor result panel](/use/checks-and-monitors/monitors.md#monitor-results).
   * **In the StackState CLI:** List the monitors using `sts monitor list` or `stac monitor list`.
2. Export the monitor definition into a file named `path/to/export.sty`:
   * **new `sts` CLI**: `sts settings describe --ids <id-of-a-monitor> -f path/to/export.sty`
3. Modify the exported file to change the monitor `parameters` or `intervalSeconds`.
4. Apply the changes to the monitor:
   * **new `sts` CLI**: `sts monitor apply -f path/to/export.sty`

Once applied, the updated monitor definition will be in effect. Changes will be reflected with the next execution cycle.

### Set the run interval

The monitor runner schedules monitor execution using an interval parameter that's configured on a per-monitor basis - the `intervalSeconds`. The runner will attempt to schedule a monitor execution every `intervalSeconds`, counting from the end of the previous execution cycle, in parallel to the other existing monitors (subject to resource limits). For example, setting `intervalSeconds` of a monitor definition to the value `600` will cause the monitor runner to attempt to schedule the execution of this monitor every ten minutes, assuming that the execution time itself is negligible.

To set a new run interval for a monitor, adjust the `intervalSeconds` parameter in the monitor STY definition as described in the instructions to [edit the monitor](#edit-a-monitor).

For example, to run the monitor every 5 minutes, set the `intervalSeconds` to `300`.

{% tabs %}
{% tab title="Monitor STY definition" %}
{% code lineNumbers="true" %}
```yaml
_version: "1.0.39"
timestamp: "2022-05-23T13:16:27.369269Z[GMT]"
nodes:
  - _type: "Monitor"
    name: "CPU Usage"
    description: "A simple CPU-usage monitor. If the metric is above a given threshold, the state is set to CRITICAL."
    identifier: "urn:system:default:monitor:cpu-usage"
    remediationHint: "Turn it off and on again."
    function: {{ get "urn:system:default:monitor-function:metric-above-threshold" }}
    arguments:
      -
      ...
    intervalSeconds": 300
```
{% endcode %}
{% endtab %}
{% endtabs %}

### Monitor status

The status of a monitor can be obtained via the StackState CLI:


{% endhint %}

```shell
# By ID
$ sts monitor status --id <id-of-a-monitor>
# By Identifier
$ sts monitor status --identifier <identifier-of-a-monitor>
```


{% endhint %}

```shell
$ stac monitor status <id-or-identifier-of-a-monitor>
```


The output of this command indicates the specific errors that occurred along with the counts of how many times they happened and the health stream statistics associated with this monitor. Any execution issues are also logged in the global StackState log file.

### Preview a monitor

You can use the CLI to run a monitor and preview its output without persisting its results.



{% endhint %}

```shell
# By ID
$ sts monitor run --id <id-of-a-monitor>
# By Identifier
$ sts monitor run --identifier <identifier-of-a-monitor>
```


{% endhint %}

```shell
$ stac monitor preview <id-or-identifier-of-a-monitor>
```

### Enable/disable a monitor

{% hint style="info" %}
When a monitor is disabled, all health states associated with the monitor will be removed, and they will no longer be visible in the StackState UI. Disabling a monitor is quite useful to debug and fix execution errors without having the monitor produce health states or errors. A disabled monitor can still be used to do a `dry-run`.
{% endhint %}

Individual monitors can be disabled using the StackState CLI. To disable/enable a monitor:

1. Identify the monitor to enable/disable. This can be done by finding the monitor identifier or ID in the StackState UI or using the StackState CLI:
   * Inspect the monitor definition available under the context menu of a monitor result panel in the StackState UI.
   * Use the StackState CLI command `sts monitor list` to retrieve details of all monitors.

2. Enable/disable the monitor using the StackState CLI:


{% endhint %}

```
# Disable By ID
sts monitor disable --id <id-of-the-monitor>

# Disable By Identifier
sts monitor disabled --identifier <identifier-of-the-monitor>


# Enable By ID
sts monitor enable --id <id-of-the-monitor>

# Enable By Identifier
sts monitor enable --identifier <identifier-of-the-monitor>

```



{% endhint %}

```
# Disable a monitor
stac monitor disable <id-or-identifier-of-the-monitor>

# Enable a monitor
stac monitor enable <id-or-identifier-of-the-monitor>
```


### Delete a monitor

{% hint style="info" %}
A deleted monitor will be entirely removed from StackState. When a monitor is deleted, all health states associated with the monitor will also be removed, and they will no longer be visible in the StackState UI.

You can also [disable a monitor](#enable-disable-a-monitor) to stop it running and producing health states without the need to completely delete it.
{% endhint %}

To delete a monitor and remove it from StackState, use the StackState CLI:


{% endhint %}

```shell
# By ID
$ sts monitor delete --id <id-of-the-monitor>
# By Identifier
$ sts monitor delete --identifier <identifier-of-the-monitor>
```


{% endhint %}

```shell
$ stac monitor delete --identifier <identifier-of-the-monitor>
```

## Disable the monitor runner

{% hint style="success" "self-hosted info" %}

**StackState Self-Hosted**

Extra information for the [StackState Self-Hosted product](https://docs.stackstate.com/):

    
The monitor runner subsystem can be disabled in the StackState configuration by appending the following line at the end of the file `etc/application_stackstate.conf`:

`stackstate.featureSwitches.monitorRunner = false`

{% endhint %}

## See also

* [StackState `sts` CLI](../../setup/cli/cli-sts.md)
* [Integrations](../../stackpacks/integrations/README.md)
