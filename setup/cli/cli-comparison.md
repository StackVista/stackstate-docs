---
description: StackState Self-hosted v5.0.x
---

# Comparison between the old and new StackState CLIs

## Overview

StackState has a new CLI! The new CLI has many advantages and a few notable differences. 

{% hint style="info" %}
**The old `sts` CLI has been renamed to `stac`.** 

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. Most commands will be ported to the new `sts` CLI, but some will be deprecated. See the [CLI command overview](#cli-command-overview) for up-to-date information on the port process.
{% endhint %}

## Why a new CLI?

The new `sts` CLI has been built for a reason. Here are the major advantages of switching:

 * Easy installation and configuration for all Operating Systems
 * Native macOS support
 * Faster releases - the CLI is versioned independently of the StackState product
 * Backwards as well as forwards compatible with StackState versions
 * Machine readable output for every command
 * Many UX improvements, including syntax highlighting, auto-completion and progress bars.
 * SaaS support

## Notable Differences between the CLIs

 * Unlike `stac`, the new `sts` CLI will not have commands for sending data to StackState. For these purposes, you can use either the StackState Agent or the StackState Receiver API. 
 * Some commands have been renamed to fall more in line with how we think of StackState today. For example, the old command `stac graph` is now called `sts settings`.
 * The new `sts` CLI only works with StackState v5.0 or later.

{% tabs %}
{% tab title="CLI: sts (new)" %}
The `sts` CLI is:

* 🎉 The new CLI!
* Works with StackState v5.0 or later. 
* Contains all of the latest commands - see the [CLI command overview](#cli-command-overview).

➡️ [Install the new `sts` CLI](cli-sts.md)
{% endtab %}
{% tab title="CLI: stac" %}

The `stac` CLI is:

* The old CLI. 
* Works with all supported versions of StackState
* ⚠️ Does not include the newest commands - see the [CLI command overview](#cli-command-overview). 
* ⚠️ Will be deprecated in a future release of StackState.

{% hint style="info" %}
Note that this CLI was previously named `sts`. It has been renamed to `stac` with the release of StackState v5.0.

**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
{% endhint %}

{% endtab %}
{% endtabs %}

## Which version of the CLI am I running?

There are now two versions of the StackState CLI and the old version of the CLI has been renamed: 

* The new CLI is called `sts` - note that this name was used by the old CLI in previous releases of StackState. 
* The old CLI has been renamed to `stac`, this allows you to have the old CLI and new CLI installed on the same machine.

You can check which version of the `sts` CLI you are running with the following command:

```commandline
sts version

# new `sts` CLI - example output:
VERSION | BUILD DATE           | COMMIT                                   
1.0.0   | 2022-06-24T12:26:50Z | 6553352125d31a46c4790068e36c8eca32ace7fd


# old `sts` CLI - example output:
usage: cli.py [-h] [-v] [-i [INSTANCE]] [-c [CLIENT]]


# no `sts` CLI installed - example output:
command not found: sts


```

If you are not running the new `sts` CLI yet, we recommend that you:

1. [Upgrade the old `sts` CLI to `stac`](cli-stac.md).
2. [Install the new `sts` CLI](cli-sts.md) 

## CLI command overview

The new `sts` CLI will completely replace the old `stac` CLI. Not all commands have been moved to the new CLI yet and some commands are not available in the old CLI. The following table gives an overview of the commands available in each CLI and the current `port` status.

 - 🚧 - Work in progress.
 - ❌ - Command will not be available in this CLI.

| `stac` CLI command  | `sts` CLI command | Description | 
| :--- |:--- | | :--- |
| `anomaly collect-feedback` | `anomaly collect-feedback` | Export anomalies to disk. |
| `anomaly send` | ❌ | Send anomalies. Will not be ported to the new `sts` CLI. This remains possible via the StackState Receiver API. |
| ❌ | `completion` | Generate the CLI autocompletion script for the specified shell. |
| ❌ | `context` | Manage CLI authentication contexts. |
| `datasource list` | `settings list --type DataSource` | List all telemetry data sources. |
| `event send` | ❌ | Send events. Will not be ported to the new `sts` CLI. This remains possible via the StackState Agent and the StackState Receiver API. |
| `graph *` | `settings *` | Configure StackState settings. |
| `graph retention` | 🚧 | Configure StackState graph database retention. |
| `health *` | 🚧 | Configure health synchronization. |
| `metric *` | ❌ | Send and retrieve metrics. Will not be ported to the new `sts` CLI. Metrics can still be sent via the StackState Agent and the StackState Receiver API. To retrieve metrics, use the StackState UI [telemetry inspector](/use/metrics-and-events/browse-telemetry.md) or [analytics environment](/use/stackstate-ui/analytics.md). |
| `monitor send` | `monitor send` | |
| `permission *` | 🚧 | Configure user/group permissions. |
| `serverlog` | ❌ | Read StackState log files. Will not be ported to the new `sts` CLI. Log files can be read via Kubernetes or directly from disk. |
| `script execute` | `script execute` | Execute StackState scripts. | 
| `stackpack *` | `stackpack *` | Install, configure and uninstall StackPacks. |
| `subscription *` | 🚧 | Configure the StackState license. |
| `subject *` | 🚧 | Configure users/groups. |
| `topology send` | ❌ | Send topology. Will not be ported to the new `sts` CLI. This remains possible via the StackState Agent or the StackState Receiver API. |
| `topic *` | 🚧 | Inspect StackState messaging topics. |
| `trace send` |❌ | Send traces. Will not be ported to the new `sts` CLI. This remains possible via the StackState Agent or the StackState Receiver API. |
