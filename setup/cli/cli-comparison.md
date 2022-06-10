---
description: StackState Self-hosted v4.6.x
---

# Comparison between the old and new StackState CLIs

StackState has a new CLI! The new CLI has many advantages and a few notable differences. 

{% hint style="info" %}
The old CLI has been renamed to `stac`. In a future release of StackState, the new CLI will fully replace the `stac` CLI. Most commands will be ported to the new CLI, but some will be deprecated. See [CLI commands](#cli-commands) for an up-to-date overview of the port process.
{% endhint %}

## Advantages of the new CLI

The new StackState CLI has been built for a reason. Here are the major advantages of switching:

 * Easy installation and configuration for all Operating Systems
 * Native MacOS support
 * Faster releases - the CLI is versioned independently of the StackState product
 * Backwards as well as forwards compatible with StackState versions
 * Machine readable output for every command
 * Many UX improvements, including syntax highlighting, auto-completion and progress bars.
 * SaaS support

## Notable Differences

 * Unlike `stac`, the new CLI will not have commands for sending data to StackState. For these purposes, you can use either the StackState Agent or the StackState Receiver API. 
 * Some commands have been renamed to fall more in line with how we think of StackState today. For example, the old command `stac graph` is now called `sts settings`.
 * The new CLI only works with StackState v5.0 or later.

{% tabs %}
{% tab title="`sts` CLI" %}
* The new CLI. 
* Works with StackState v5.0 or later. 
* Contains all of the latest commands.
* [Learn how to install the new CLI](cli-sts.md).
{% endtab %}
{% tab title="`stac` CLI" %}
{% hint style="info" %}
Note that this CLI was previously named `sts`. It has been renamed to `stac` with the release of StackState v5.0.
{% endhint %}

* The old CLI. 
* Works with all supported versions of StackState
* ⚠️ Does not include the newest commands. 
* ⚠️ Will be deprecated in a future release of StackState.
{% endtab %}
{% endtabs %}

## CLI commands

The new CLI will completely replace the old `stac` CLI. Not all commands have been moved to the new CLI yet and some commands are not available in the old CLI. The following is an overview of the commands available in each CLI and the current `port` status.

### CLI versions

**`sts` CLI**
* The new CLI. 
* Works with StackState v5.0 or later. 
* Contains all of the latest commands.
* [Learn how to install the new CLI](cli-sts.md).

**`stac` CLI**


| CLI name | description                                                                                                                                                                                                                                                                        |
|:---|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `stac` | The old CLI. Works with all supported versions of StackState, but does not include the newest commands and will be deprecated in a future release of StackState. Note that this CLI was previously named `sts`. It has been renamed to `stac` with the release of StackState v5.0. |
| `sts` | The new CLI. Works with StackState v5.0 or later.                                                                                                                                                                                                                                  |

### Command status

 - 🚧 - Work in progress.
 - ❌ - Command will not be available in this CLI.

| `stac` command  | `sts` command | Description | 
| :--- |:--- | | :--- |
| `anomaly export` | `anomaly export` | Commands for exporting anomalies to disk. |
| `anomaly send` | ❌ | Command for sending anomalies. Will not be ported. This remains possible via the API. |
| `datasource list` | `settings list --type DataSource` | List all telemetry data sources. |
| `event send` | ❌ | Commands for sending events. Will not be ported. This remains possible via the agent and the API. |
| `graph *` | `settings *` | Configure StackState settings. |
| `graph retention` | 🚧 | Configure StackState graph database retention. |
| `health *` | 🚧 | Configuring health synchronization. |
| `metric send` | ❌ | Command for sending metrics. Will not be ported. This remains possible via the agent and the API. |
| ❌ | `monitor send` | |
| `permission *` | 🚧 | Configuring user/group permissions. |
| `serverlog` | ❌ | Command for reading StackState log files. Will not be ported. Log files can be read via Kubernetes or directly from disk. |
| `script execute` | `script execute` | Execute StackState scripts. | 
| `stackpack *` | `stackpack *` | Install, configure and uninstall StackPacks. |
| `subscription *` | 🚧 | Configuring StackState's license. |
| `subject *` | 🚧 | Configuring users/groups. |
| `topology send` | ❌ | Command for sending topology. Will not be ported. This remains possible via the StackState Agent or the StackState Receiver API. |
| `topic *` | 🚧 | Inspect StackState messaging topics. |
| `trace send` |❌ | Command for sending traces. Will not be ported. This remains possible via the agent or the API. |
