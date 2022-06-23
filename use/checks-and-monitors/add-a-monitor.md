---
description: StackState Self-hosted v5.0.x
---

# Manage monitors

## Overview

Monitors process 4T data, such as metrics, events and topology, to produce a health state for elements \(components and relations\). The states are calculated by a specific monitor function selected by the user.

## Add a monitor

Most Monitors in StackState are created as part of a StackPack installed by the user. They are added automatically upon installation and start producing health state results immediately afterwards, no further user action is required. Monitors automatically handle newly created topology elements and do not need to be specifically reconfigured after any topology changes occur or otherwise added to the newly created elements.

* Details of the monitors provided by StackPacks can be found in [their respective documentation](../../stackpacks/integrations/README.md).
* You can also [create a custom monitor](../../develop/developer-guides/monitors/how-to-create-monitors.md) from scratch using the StackState CLI.

It might be beneficial to modify an existing Monitor definition to change its parameters, run interval or to disable it. All of these actions are done by utilizing the StackState CLI and are described in greater detail in the following sections.

## Change Monitor parameters or run interval

Monitor configuration can be changed by modifying their definition. Onec a Monitor to be modified is identified, either by inspecting the definition of a Monitor available under the context menu of a Monitor result panel, or otherwise by obtaining the Monitors identifier, a dedicated CLI command can be used to export the definition out of the system into a file named `path/to/export.stj`:

{% tabs %}
{% tab title="CLI: sts (new)" %}
`sts settings describe --id <id-of-a-monitor> -f path/to/export.stj`
{% endtab %}
{% tab title="CLI: stac" %}
`stac monitor describe <id-or-identifier-of-a-monitor> > path/to/export.stj`
{% endtab %}
{% endtabs %}

Afterwards, the file can be modified to change the Monitor `parameters` & `intervalSeconds` properties. Once modified, the Monitor can be reapplied in StackState by running another CLI command:

{% tabs %}
{% tab title="CLI: sts (new)" %}
`sts monitor apply -f path/to/export.stj`
{% endtab %}
{% tab title="CLI: stac" %}
`stac monitor apply < path/to/export.stj`
{% endtab %}
{% endtabs %}

Once reapplied, the updated Monitor definition will be in effect. If the `intervalSeconds` property has been modified, the execution freequency of the Monitor will be adjusted accordingly.

## Disable a Monitor

Monitors can be disabled by removing them. Once a Monitor to be disabled is identified, either by inspecting the definition of a Monitor available under the context menu of a Monitor result panel, or otherwise by obtaining the Monitors identifier, a dedicated CLI command can be used to remove it:

{% tabs %}
{% tab title="CLI: sts (new)" %}
```
# By ID
sts monitor delete --id <id-of-the-monitor>
# By Identifier
sts monitor delete --identifier <identifier-of-the-monitor>
```
{% endtab %}
{% tab title="CLI: stac" %}
`stac monitor delete --identifier <identifier-of-the-monitor>`
{% endtab %}
{% endtabs %}

Upon removal, all health states associated with the Monitor will also be removed.

## Monitor functions

Each monitor configured in StackState uses a monitor function to compute the health state results attached to the elements.

Monitor functions are scripts that accept the 4T data as input, check the data based on some internal logic and output health state mappings for the affected topology elements. The function is run periodically by the monitor runner and it is responsible for detecting any changes in the data that can be considered to change an elements health state.

* Details of the monitor functions provided by StackPacks can be found in [the StackPack documentation](../../stackpacks/integrations/README.md).
* You can [create a custom monitor function](../../develop/developer-guides/custom-functions/monitor-functions.md) to customize how StackState processes the 4T data.

## See also

* [StackState CLI](../../setup/cli/README.md)
* [Integrations](../../stackpacks/integrations/README.md)
