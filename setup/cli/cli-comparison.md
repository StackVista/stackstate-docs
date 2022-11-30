---
description: StackState Self-hosted v5.1.x
---

# Comparison between the old and new StackState CLIs

## Overview

StackState has a new CLI! The new CLI has many advantages and a few notable differences.

{% hint style="warning" %}
 **With the release of StackState v5.0, the old `sts` CLI was renamed to `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")
{% endhint %}

## Why a new CLI?

The new `sts` CLI has been built for a reason. Here are the major advantages of switching:

 * Easy installation and configuration for all Operating Systems
 * Native macOS support
 * Faster releases - the CLI is versioned independently of the StackState product
 * Backwards as well as forwards compatible with StackState versions
 * Machine-readable output for every command
 * Many UX improvements, including syntax highlighting, auto-completion and progress bars.
 * SaaS support

## Notable Differences between the CLIs

 * Unlike `stac`, the new `sts` CLI won't have commands for sending data to StackState. For these purposes, you can use either the StackState Agent or the StackState Receiver API.
 * Some commands have been renamed to fall more in line with how we think of StackState today. For example, the old command `stac graph` is now called `sts settings`.
 * The new `sts` CLI only works with StackState v5.0 or later.

{% tabs %}
{% tab title="CLI: sts" %}
The `sts` CLI is:

* 🎉 The new CLI!
* Works with StackState v5.0 or later.
* Contains all of the latest commands - see the [CLI command overview](#cli-command-overview).

➡️ [Install the new `sts` CLI](cli-sts.md)
{% endtab %}
{% tab title="CLI: stac (deprecated)" %}

The `stac` CLI is:

* The old CLI.
* Works with StackState v5.1 or earlier.
* ⚠️ Doesn't include the newest commands - see the [CLI command overview](#cli-command-overview).
* Deprecated since StackState v5.1 and will no longer be actively maintained.
{% hint style="warning" %}
 **With the release of StackState v5.0, the old `sts` CLI was renamed to `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")
{% endhint %}

{% endtab %}
{% endtabs %}

## Which version of the CLI am I running?

There are now two versions of the StackState CLI and the old version of the CLI has been renamed:

* The new CLI is `sts` - note that this name was used by the old CLI in earlier releases of StackState.
* The old CLI has been renamed to `stac`, you can have both the old CLI and new CLI installed on the same machine.

You can check which version of the `sts` CLI you are running with the following command:

```sh
$ sts version

# new `sts` CLI - example output:
VERSION | BUILD DATE           | COMMIT
1.0.0   | 2022-06-24T12:26:50Z | 6553352125d31a46c4790068e36c8eca32ace7fd


# old `sts` CLI - example output:
usage: cli.py [-h] [-v] [-i [INSTANCE]] [-c [CLIENT]]


# no `sts` CLI installed - example output:
command not found: sts


```

If you aren't running the new `sts` CLI yet, we recommend that you:

1. [Upgrade the old `sts` CLI to `stac`](cli-stac.md).
2. [Install the new `sts` CLI](cli-sts.md).

## CLI command overview

The new `sts` CLI replaces the old `stac` CLI, however, not all commands are available in both of the CLIs. An overview of the commands available in each CLI can be found in the table below.


| stac CLI (deprecated)      | sts CLI                           | Description                                                                                                                                                                                                                                                                                                             |
|:---------------------------|:----------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `anomaly collect-feedback` | `anomaly collect-feedback`        | Export anomalies to disk.                                                                                                                                                                                                                                                                                               |
| `datasource list`          | `settings list --type DataSource` | List all telemetry data sources.                                                                                                                                                                                                                                                                                        |
| `graph *`                  | `settings *`                      | Configure StackState settings.                                                                                                                                                                                                                                                                                          |
| `graph retention`          | `graph retention`                 | Configure StackState graph database retention.                                                                                                                                                                                                                                                                          |
| `health *`                 | `health *`                        | Configure health synchronization.                                                                                                                                                                                                                                                                                       |
| `monitor *`                | `monitor *`                       | Manage, test and develop [monitors](/use/checks-and-monitors/monitors.md).                                                                                                                                                                                                                                              |
| `permission *`             | `rbac *`                          | Configure user/group permissions.                                                                                                                                                                                                                                                                                       |
| `script execute`           | `script execute`                  | Execute StackState scripts.                                                                                                                                                                                                                                                                                             |
| `stackpack *`              | `stackpack *`                     | Install, configure and uninstall StackPacks.                                                                                                                                                                                                                                                                            |
| `subscription *`           | `license *`                       | Configure the StackState license.                                                                                                                                                                                                                                                                                       |
| `subject *`                | `rbac *`                          | Configure users/groups.                                                                                                                                                                                                                                                                                                 |
| `topic *`                  | `topic *`                         | Inspect StackState messaging topics.                                                                                                                                                                                                                                                                                    |
| ❌                          | `completion`                      | Generate the CLI autocompletion script for the specified shell.                                                                                                                                                                                                                                                         |
| ❌                          | `context`                         | Manage CLI authentication contexts.                                                                                                                                                                                                                                                                                     |
| `anomaly send`             | ❌                                 | Send anomalies. Won't be ported to the new `sts` CLI. This remains possible via the StackState Receiver API.                                                                                                                                                                                                         |
| `event send`               | ❌                                 | Send events. Won't be ported to the new `sts` CLI. This remains possible via the StackState Agent and the StackState Receiver API.                                                                                                                                                                                   |
| `metric *`                 | ❌                                 | Send and retrieve metrics. Won't be ported to the new `sts` CLI. Metrics can still be sent via the StackState Agent and the StackState Receiver API. To retrieve metrics, use the StackState UI [telemetry inspector](/use/metrics/browse-telemetry.md) or [analytics environment](/use/stackstate-ui/analytics.md). |
| `serverlog`                | ❌                                 | Read StackState log files. Won't be ported to the new `sts` CLI. Log files can be read via Kubernetes or directly from disk.                                                                                                                                                                                         |
| `topology send`            | ❌                                 | Send topology. Won't be ported to the new `sts` CLI. This remains possible via the StackState Agent or the StackState Receiver API.                                                                                                                                                                                  |
| `trace send`               | ❌                                 | Send traces. Won't be ported to the new `sts` CLI. This remains possible via the StackState Agent or the StackState Receiver API.                                                                                                                                                                                    |                                             
