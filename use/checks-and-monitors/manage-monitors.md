---
description: StackState Self-hosted v5.0.x
---

# Manage monitors

## Overview

Monitors process 4T data, such as metrics, events and topology, to produce a health state for elements \(components and relations\). The states are calculated and attached to relevant topology elements by a specific monitor function that is selected by the user.

Monitors are run by a dedicated subsystem of StackState called the monitor runner. The main task of the monitor runner is to schedule the execution of all existing monitors in such a way as to ensure that all of them produce viable results in a timely manner. The monitor runner is maintenance free - it starts whenever StackState starts and picks up any newly applied monitor definitions automatically whenever they are created, changed or removed. Any changes that have been applied to the monitors are reflected with the next execution cycle. 

## Add a monitor

Most Monitors in StackState are created as part of a StackPack installed by the user. They are added automatically upon installation and start producing health state results immediately afterwards, no further user action is required. Monitors automatically handle newly created topology elements and do not need to be specifically reconfigured after any topology changes occur or otherwise added to the newly created elements.

* Details of the monitor functions provided by StackPacks can be found in [the StackPack documentation](../../stackpacks/integrations/README.md).
* You can [create a custom monitor](../../develop/developer-guides/monitors/create-custom-monitors.md) from scratch using the StackState CLI.

It might be beneficial to modify an existing monitor definition to change its parameters, run interval or to disable it. All of these actions are done by utilizing the StackState CLI and are described in greater detail in the following sections.

## Make and apply changes to a monitor

Monitor configuration can be changed by modifying the monitor definition. 

1. FInd the ID of the monitor to be modified. This can be done by either:
   * In the StackState UI: Inspect the monitor definition using the context menu (...) of the [monitor result panel](/use/checks-and-monitors/monitors.md#monitor-results).
   * Another way ???
2. Export the monitor definition into a file named `path/to/export.stj`:
   ```
   # new sts CLI
   sts settings describe --ids <id-of-a-monitor> -f path/to/export.stj
   
   # stac CLI
   stac monitor describe <id-or-identifier-of-a-monitor> > path/to/export.stj
   ```
3. Modify the exported file to change the monitor `parameters` or `intervalSeconds`. 
4. Apply the changes to the monitor:
   ```
   # new sts CLI:
   sts monitor apply -f path/to/export.stj
   
   # stac CLI
   stac monitor apply < path/to/export.stj
   ```

Once applied, the updated monitor definition will be in effect. Changes will be reflected with the next execution cycle. 

## Set the run interval for a monitor

The monitor runner schedules monitor execution using an interval parameter that is configured on a per-monitor basis - the `intervalSeconds`. The runner will attempt to schedule a monitor execution every `intervalSeconds`, counting from the end of the previous execution cycle, in parallel to the other existing monitors (subject to resource limits). For example, setting `intervalSeconds` of a monitor definition to the value `600` will cause the monitor runner to attempt to schedule the execution of this monitor every ten minutes, assuming that the execution time itself is negligible.

To set a new run interval for a monitor, adjust the `intervalSeconds` parameter in the monitor STJ definition as described in the instructions to [make and apply changes to the monitor](#make-and-apply-changes-to-a-monitor). 

For example, to run the monitor every 5 minutes, set the `intervalSeconds` to `300`:

{% tabs %}
{% tab title="Monitor STJ definition" %}
```commandline
{
  "_version": "1.0.39",
  "timestamp": "2022-05-23T13:16:27.369269Z[GMT]",
  "nodes": [
    {
      "_type": "Monitor",
      "name": "CPU Usage",
      "description": "A simple CPU-usage monitor. If the metric is above a given threshold, the state is set to CRITICAL.",
      "identifier": "urn:system:default:monitor:cpu-usage",
      "remediationHint": "Turn it off and on again.",
      "function": {{ get "urn:system:default:monitor-function:metric-above-threshold" }},
      "arguments": [
        ...
      ],
      "intervalSeconds": 300
    }
  ]
}
```

{% endtab %}
{% endtabs %}

## Check the monitor status

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
`stac monitor status <id-or-identifier-of-a-monitor`[](http://not.a.link "StackState Self-Hosted only")

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
`stac monitor delete --identifier <identifier-of-the-monitor>`[](http://not.a.link "StackState Self-Hosted only")

**Not running the `stac` CLI yet?**[](http://not.a.link "StackState Self-Hosted only")

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}[](http://not.a.link "StackState Self-Hosted only")

{% hint style="info" %}
Upon removal, all health states associated with the monitor will also be removed.
{% endhint %}

## Disable the monitor runner

{% hint style="success" "self-hosted info" %}

The monitor runner subsystem can be disabled in the StackState configuration by appending the following line at the end of the file `etc/application_stackstate.conf`:

`stackstate.featureSwitches.monitorRunner = false`

{% endhint %}

## See also

* [StackState CLI](../../setup/cli/README.md)
* [Integrations](../../stackpacks/integrations/README.md)