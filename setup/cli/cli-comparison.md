---
description: StackState Self-hosted v4.6.x
---

# Comparison between the old and new StackState CLIs

## Overview

StackState has a new CLI! The new CLI has many advantages and a few notable differences. 

{% hint style="info" %}
**The old CLI has been renamed to `stac`.** 

In a future release of StackState, the new CLI will fully replace the `stac` CLI. Most commands will be ported to the new CLI, but some will be deprecated. See the [CLI command overview](#cli-command-overview) for up-to-date information on the port process.
{% endhint %}

## Why a new CLI?

The new StackState CLI has been built for a reason. Here are the major advantages of switching:

 * Easy installation and configuration for all Operating Systems
 * Native MacOS support
 * Faster releases - the CLI is versioned independently of the StackState product
 * Backwards as well as forwards compatible with StackState versions
 * Machine readable output for every command
 * Many UX improvements, including syntax highlighting, auto-completion and progress bars.
 * SaaS support

## Notable Differences between the CLIs

 * Unlike `stac`, the new CLI will not have commands for sending data to StackState. For these purposes, you can use either the StackState Agent or the StackState Receiver API. 
 * Some commands have been renamed to fall more in line with how we think of StackState today. For example, the old command `stac graph` is now called `sts settings`.
 * The new CLI only works with StackState v5.0 or later.

{% tabs %}
{% tab title="sts CLI" %}
The `sts` CLI is:

* 🎉 The new CLI!
* Works with StackState v5.0 or later. 
* Contains all of the latest commands - see the [CLI command overview](#cli-command-overview).

➡️ [Learn how to install the new CLI](cli-sts.md)
{% endtab %}
{% tab title="stac CLI" %}

The `stac` CLI is:

* The old CLI. 
* Works with all supported versions of StackState
* ⚠️ Does not include the newest commands - see the [CLI command overview](#cli-command-overview). 
* ⚠️ Will be deprecated in a future release of StackState.

{% hint style="info" %}
Note that this CLI was previously named `sts`. It has been renamed to `stac` with the release of StackState v5.0.
{% endhint %}

{% endtab %}
{% endtabs %}

## Which version of the CLI am I running?

There are now two versions of the StackState CLI and the old version of the CLI has been renamed: 

* The new CLI has the name previously used by the old CLI (`sts`). 
* The old CLI has been renamed to `stac`, this allows you to have the old CLI and new CLI installed on the same machine.

You can check which version of the `sts` CLI you are running with the following command:

```commandline
sts version

# new CLI - example output:
VERSION | BUILD DATE           | COMMIT                                   
1.0.0   | 2022-06-24T12:26:50Z | 6553352125d31a46c4790068e36c8eca32ace7fd


# old CLI - example output:
usage: cli.py [-h] [-v] [-i [INSTANCE]] [-c [CLIENT]]
  ...


```

If you are not running the new `sts` CLI yet, we recommend that you [install the new CLI](cli-sts.md) and rename the old CLI to `stac`.

## CLI command overview

The new CLI will completely replace the old `stac` CLI. Not all commands have been moved to the new CLI yet and some commands are not available in the old CLI. The following table gives an overview of the commands available in each CLI and the current `port` status.

 - 🚧 - Work in progress.
 - ❌ - Command will not be available in this CLI.

| `stac` CLI command  | `sts` CLI command | Description | 
| :--- |:--- | | :--- |
| `anomaly collect-feedback` | `anomaly collect-feedback` | Commands for exporting anomalies to disk. |
| `anomaly send` | ❌ | Command for sending anomalies. Will not be ported to the new CLI. This remains possible via the StackState Receiver API. |
| `datasource list` | `settings list --type DataSource` | List all telemetry data sources. |
| `event send` | ❌ | Commands for sending events. Will not be ported to the new CLI. This remains possible via the StackState Agent and the StackState Receiver API. |
| `graph *` | `settings *` | Configure StackState settings. |
| `graph retention` | 🚧 | Configure StackState graph database retention. |
| `health *` | 🚧 | Configuring health synchronization. |
| `metric *` | ❌ | Commands for sending and retrieving metrics. Will not be ported to the new CLI. Metrics can still be sent via the StackState Agent and the StackState Receiver API. To retrieve metrics, use the StackState UI [telemetry inspector](/use/metrics-and-events/browse-telemetry.md) or [analytics environment](/use/stackstate-ui/analytics.md). |
| `monitor send` | `monitor send` | |
| `permission *` | 🚧 | Configure user/group permissions. |
| `serverlog` | ❌ | Command for reading StackState log files. Will not be ported to the new CLI. Log files can be read via Kubernetes or directly from disk. |
| `script execute` | `script execute` | Execute StackState scripts. | 
| `stackpack *` | `stackpack *` | Install, configure and uninstall StackPacks. |
| `subscription *` | 🚧 | Configuring StackState's license. |
| `subject *` | 🚧 | Configuring users/groups. |
| `topology send` | ❌ | Command for sending topology. Will not be ported to the new CLI. This remains possible via the StackState Agent or the StackState Receiver API. |
| `topic *` | 🚧 | Inspect StackState messaging topics. |
| `trace send` |❌ | Command for sending traces. Will not be ported to the new CLI. This remains possible via the StackState Agent or the StackState Receiver API. |
