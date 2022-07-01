---
description: StackState Self-hosted v5.0.x
---

# Manage monitors

## Overview

Monitors process 4T data, such as metrics, events and topology, to produce a health state for elements \(components and relations\). The states are calculated by a specific monitor function selected by the user.

Monitors are run by a dedicated subsystem of StackState called the monitor runner. The main task of the monitor runner is to schedule the execution of all existing monitors in such a way as to ensure that all of them produce viable results in a timely manner. The monitor runner is maintenance free - it starts whenever StackState starts and picks up any newly applied monitor definitions automatically whenever they are created, changed or removed. Any changes that have been applied to the monitors are reflected with the next execution cycle. 

## Add a monitor

Most Monitors in StackState are created as part of a StackPack installed by the user. They are added automatically upon installation and start producing health state results immediately afterwards, no further user action is required. Monitors automatically handle newly created topology elements and do not need to be specifically reconfigured after any topology changes occur or otherwise added to the newly created elements.

* Details of the monitor functions provided by StackPacks can be found in [the StackPack documentation](../../stackpacks/integrations/README.md).
* You can [create a custom monitor](../../develop/developer-guides/monitors/create-custom-monitors.md) from scratch using the StackState CLI.

It might be beneficial to modify an existing monitor definition to change its parameters, run interval or to disable it. All of these actions are done by utilizing the StackState CLI and are described in greater detail in the following sections.

## Make and apply changes to a monitor

Monitor configuration can be changed by modifying their definition. Once a monitor to be modified is identified, either by inspecting the definition of a monitor available under the context menu of a monitor result panel, or otherwise by obtaining the Monitors identifier, a dedicated CLI command can be used to export the definition out of the system into a file named `path/to/export.stj`:

{% tabs %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: sts (new)" %}[](http://not.a.link "StackState Self-Hosted only")

```
sts settings describe --ids <id-of-a-monitor> -f path/to/export.stj
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: stac" %}[](http://not.a.link "StackState Self-Hosted only")
```[](http://not.a.link "StackState Self-Hosted only")
stac monitor describe <id-or-identifier-of-a-monitor> > path/to/export.stj
```[](http://not.a.link "StackState Self-Hosted only")

**Not running the `stac` CLI yet?**[](http://not.a.link "StackState Self-Hosted only")

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}[](http://not.a.link "StackState Self-Hosted only")

Afterwards, the file can be modified to change the monitor `parameters` and `intervalSeconds` properties. Once modified, the monitor can be reapplied in StackState by running another CLI command:

{% tabs %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: sts (new)" %}[](http://not.a.link "StackState Self-Hosted only")
```
sts monitor apply -f path/to/export.stj
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: stac" %}[](http://not.a.link "StackState Self-Hosted only")
```[](http://not.a.link "StackState Self-Hosted only")
stac monitor apply < path/to/export.stj
```[](http://not.a.link "StackState Self-Hosted only")

**Not running the `stac` CLI yet?**[](http://not.a.link "StackState Self-Hosted only")

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}[](http://not.a.link "StackState Self-Hosted only")

Once reapplied, the updated monitor definition will be in effect. If the `intervalSeconds` property has been modified, the execution frequency of the monitor will be adjusted accordingly.

## Set the run interval for a monitor

The monitor runner schedules monitor execution using an interval parameter that is configured on a per-monitor basis - the `intervalSeconds`. The runner will attempt to schedule a monitor execution every `intervalSeconds`, counting from the end of the previous execution cycle, in parallel to the other existing Monitors (subject to resource limits). For example, setting `intervalSeconds` of a monitor definition to the value `600` will cause the monitor runner to attempt to schedule the execution of this monitor every ten minutes, assuming that the execution time itself is negligible.

To set a new run interval for a monitor, adjust the `intervalSeconds` parameter in the monitor definition. Follow the instructions to [make and apply changes to a monitor](#make-and-apply-changes-to-a-monitor).

## Monitor status

The status of a monitor can be obtained via the StackState CLI:

{% tabs %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: sts (new)" %}[](http://not.a.link "StackState Self-Hosted only")
```
# By ID
sts monitor status --id <id-of-a-monitor>
# By Identifier
sts monitor status --identifier <identifier-of-a-monitor>
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: stac" %}[](http://not.a.link "StackState Self-Hosted only")
```[](http://not.a.link "StackState Self-Hosted only")
stac monitor status <id-or-identifier-of-a-monitor
```[](http://not.a.link "StackState Self-Hosted only")

**Not running the `stac` CLI yet?**[](http://not.a.link "StackState Self-Hosted only")

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}[](http://not.a.link "StackState Self-Hosted only")

The output of this command indicates the specific errors that occurred along with the counts of how many times they happened and the health stream statistics associated with this monitor. Any execution issues are also logged in the global StackState log file.

## Disable a single monitor

Monitors can be disabled by removing them. Once a monitor to be disabled is identified, either by inspecting the definition of a monitor available under the context menu of a monitor result panel, or otherwise by obtaining the Monitors identifier, a dedicated CLI command can be used to remove it:

{% tabs %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: sts (new)" %}[](http://not.a.link "StackState Self-Hosted only")
```
# By ID
sts monitor delete --id <id-of-the-monitor>
# By Identifier
sts monitor delete --identifier <identifier-of-the-monitor>
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="CLI: stac" %}[](http://not.a.link "StackState Self-Hosted only")
```[](http://not.a.link "StackState Self-Hosted only")
stac monitor delete --identifier <identifier-of-the-monitor>
```[](http://not.a.link "StackState Self-Hosted only")

**Not running the `stac` CLI yet?**[](http://not.a.link "StackState Self-Hosted only")

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}[](http://not.a.link "StackState Self-Hosted only")

Upon removal, all health states associated with the monitor will also be removed.

## Disable the monitor runner

{% hint style="success" "self-hosted info" %}

The monitor runner subsystem can be disabled in the StackState configuration by appending the following line at the end of the file `etc/application_stackstate.conf`:

`stackstate.featureSwitches.monitorRunner = false`

{% endhint %}

## See also

* [StackState CLI](../../setup/cli/README.md)
* [Integrations](../../stackpacks/integrations/README.md)