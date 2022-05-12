---
description: StackState Self-hosted v4.6.x
---

# Comparison between sts and stackstate CLI's

StackState has a new CLI: [stac](cli-stac.md) instead of [sts](cli-sts.md)! The new `stac` CLI has many [advantages](cli-comparison.md#advantages) and a few notable [differences](cli-comparison.md#notable-differences). 

Eventually `stac` will fully replace all `sts` most commands and `sts` will be deprecated. See [port status](cli-comparison.md#port-status])) for an up-to-date overview of the port process.

## Advantages

We've built a new StackState CLI for a reason. Here are the major advantages of switching to `stac`:

 * Easy installation and configuration for all Operating Systems
 * Native MacOS support
 * Versioned independently from the StackState product (faster releases)
 * Backwards as well as forwards compatible with StackState versions
 * Machine readable output for every command
 * Many UX improvements (syntax highlighting, auto-completion, progress bars, etc.)
 * SaaS support

## Notable Differences

 * Unlike `sts`, `stac` will not have commands for sending data to StackState. For these purposes we would like you to use either the Agent or the API. 
 * Some commands have been renamed to fall more in line with how we think of StackState today. For example, `sts graph` has now been called `sts settings`.
 * `stac` only works with StackState 5.0 or older.

## Port status

The new `stac` CLI will completely replace the `sts` CLI, but not all commands have been ported (moved) as of yet. The following is an overview of the `port` status.

Port status:
 - ✅ This command has been fully ported.
 - 🚧 This command will be ported.
 - ❌ This command will not be ported.

| `sts` command | `stac` command | Port status |   Description | 
| :--- |:--- | :- | :--- |
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
