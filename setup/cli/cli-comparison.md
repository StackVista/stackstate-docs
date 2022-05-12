---
description: StackState Self-hosted v4.6.x
---

# Comparison between sts and stackstate CLI's

StackState has a new CLI: [stac](setup/cli-stackstate) instead of [sts](setup/cli-sts)! The new `stac` CLI does not yet fully replace the old `sts` CLI, but will eventually do so.

## Advantes of `stac`

Advantages of the new `stac` CLI:
 * Native MacOS support
 * Easy installation and configuration for all Operating Systems
 * Backwards as well as forwards compatible with StackState versions
 * Versioned independently from the StackState product
 * Human readable as well as machine readable output for every command
 * Many UX improvements (syntax highlighting, auto-completion, progress bars, etc.)
 * SaaS support

## Major Differences

 * Unlike `sts`, `stac` will not have commands for sending data to StackState. For these purposes we would like you to use either the Agent or the API directly. 
 * Some commands have been renamed to fall more in line with how we think of StackState today. For example, `sts graph` has now been called `sts settings`.

## Command overview

The new `stac` CLI will completely replace the `sts` CLI, but not all commands have been ported as of yet. The following is an overview of the `port` status.

Port status:
 - ✅ This command has been fully ported.
 - 🚧 This command will be ported.
 - ❌ This command will not be ported.

| `sts` command | `stac` command | Port status |   Description | 
| :--- |:--- | :--- | :--- |
| `anomaly export` | `anomaly export` |  ✅ | Commands for exporting anomalies to disk. |
| `anomaly send` | - | ❌ | Command for sending anomalies. Will not be ported. This remains possible via the API. |
| `datasource list` | `settings list --type DataSource` | ✅ | List all telemetry data sources. |
| `event send` | - | ❌ | Commands for sending events. Will not be ported. This remains possible via the agent and the API. |
| `graph *` | `settings *` | ✅ | Configure StackState settings. |
| `graph retention` | TBD | 🚧 | Configure StackState graph database retention. |
| `health *` | TBD | 🚧 | Configuring health synchronization. |
| `metric send` | - | ❌ | Command for sending metrics. Will not be ported. This remains possible via the agent and the API. |
| `permission *` | TBD | 🚧 | Configuring user/group permissions. |
| `serverlog` | - | ❌ | Command for reading StackState log files. Will not be ported. Log files can be read via Kubernetes or directly from disk. |
| `script execute` | `script execute` | ✅ | Execute StackState scripts. | 
| `stackpack *` | `stackpack *` | ✅ | Install, configure and uninstall StackPacks. |
| `subscription *` | TBD | 🚧 | Configuring StackState's license. |
| `subject *` | TBD | 🚧 | Configuring users/groups. |
| `topology send` | - | ❌ | Command for sending topology. Will not be ported. This remains possible via the agent or the API. |
| `topic *` | TBD | 🚧 | Inspect StackState messaging topics. |
| `trace send` | - | ❌ | Command for sending traces. Will not be ported. This remains possible via the agent or the API. |
