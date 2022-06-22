---
description: StackState Self-hosted v5.0.x 
---

# StackState CLI

## Overview

The StackState CLI can be used to configure StackState, work with data, and help with debugging problems. The CLI provides easy access to the functionality provided by the StackState API. The URLs and authentication credentials are configurable. Multiple configurations can be stored for access to different instances.

To use StackState CLI commands, you need to [install the StackState CLI](../../setup/cli-install.md) on the machine they will be run from.

## Export / import configuration

Use the CLI to export all or specific data from StackState. Exported data can be imported from file.

### sts graph list-types

StackState configuration is stored in the StackState graph database \(StackGraph\) in configuration nodes. Use the `sts graph list-types` command to see the types of all configuration nodes.

```text
sts graph list-types
```

### sts graph export

Use the `sts graph export` command to export different types of [configuration nodes](cli_reference.md#sts-graph-list-types) from and to StackState. Nodes are stored in [StackState Templated JSON](stj/) format.

```text
sts graph export -i ids_to_export > file_name
```

#### Arguments

| Argument | Format | Default | Description |
| :--- | :--- | :--- | :--- |
| `-i` | list of strings | "all" | The IDs to export. If none are specified all configuration will be exported. |
| `-h` | - | - | Show usage information and available arguments. |
| `file_name` | file\_name |  | The file to store the backup in. If none is specified, will be output to stdout. |

#### Examples

The example below will write all check functions to the file `mycheckfunctions.stj`

```text
sts graph list --ids CheckFunction | xargs sts graph export --ids > mycheckfunctions.stj
```

### sts graph import

Use the `sts graph import` command to import configuration previously exported configuration back into StackState.

```text
sts graph import < file_name
```

#### Arguments

| Argument | Format | Required | Description |
| :--- | :--- | :--- | :--- |
| `-h` | - | - | Show usage information and available arguments. |
| `file_name` | file\_name |  | The file to import StackState configuration from. |

#### Examples

```text
# actual examples of use
```

## Send data to StackState

The CLI makes it easy to send test data to StackState.

* [Send anomaly data](cli_reference.md#sts-anomaly-send)
* [Send events data](cli_reference.md#sts-event-send)
* [Send health data](cli_reference.md#sts-health-send)  
* [Send metrics data](cli_reference.md#sts-metric-send)
* [Send topology data](cli_reference.md#sts-topology-send)

### sts anomaly send

The CLI provides an `anomaly` command used to send anomaly data to StackState for a metric stream of a component.

```text
sts anomaly send --component-name <Component> --stream-name <Metric Stream> --start-time=<time>
```

| Argument | Required/Optional | Details |
| :--- | :--- | :--- |
| `--component-name` | Required |  |
| `--start-time` | Required |  |
| `--stream-name` | Required |  |
| `--description` | Optional | Anomaly description field contents |
| `--duration` | Optional | Anomaly duration \(seconds\) |
| `--severity` | Optional | Anomaly severity \(HIGH, MEDIUM, LOW\) |
| `--severity-score` | Optional | Anomaly severity score |
| `-h` | Optional | See all available options |

### sts event send

Use `sts event send` to send a single event with a given name.

```text
sts event send
```

| Argument | Details |
| :--- | :--- |
| `-h` | Show usage information and available arguments. |

### sts health send

Please refer to `usage.md` in the CLI zip archive for detailed instructions.

```text
sts health send -h
```

| Argument | Details |
| :--- | :--- |
| `-h` | Show usage information and available arguments. |

### sts metric send

You can use the CLI to send one data point of a given value or to generate a set of values within a defined bandwidth. This is useful if you want to check a new configuration with predictable data.

By default, generated metrics patterns are random between the specified bandwidth values. If a single bandwidth value is provided, the generated pattern will be a flat line. To generate a different type of pattern, use the arguments `--baseline` and `--linear`.

```text
sts metric send [-b | -h | -p] <MetricName> <OptionalNumberValue> [--baseline | --linear ] --csv <file_name>
```

| Argument | Details |
| :--- | :--- |
| `-b` | The bandwidth between which values will be generated. For example: `-b 100-250` |
| `-h` | Show usage information and available arguments. |
| `-p` | Time period. This can be in weeks, days, hours, minutes and/or seconds. For example: `-p 4w2d6h30m15s` |
| `--baseline` | Creates a daily usage curve. On Saturday and Sunday, the metric is much lower than on weekdays. The min and max of the curve are set by `-b` and `-p` |
| `--linear` | Creates a line between the values given for `-b` plotted over the time given for `-p` |
| `--csv` | Reads a CSV file from the stdin and sends it to StackState. The content of the CSV file should be in the format `timestamp,value` |

### sts topology send

Please refer to `usage.md` in the CLI zip archive for detailed instructions.

```text
sts topology send -h
```

| Argument | Details |
| :--- | :--- |
| `-h` | Show usage information and available arguments. |

## Inspect topic data

All data flowing through StackState flows through topics, for example topology, telemetry and traces. For debugging purposes, these topics can be inspected using the CLI. This can come in handy, for example, to make sure that StackState is receiving data correctly when you write your own integrations.

### sts topic list

Get a list of all Kafka topics.

```text
sts topic list
```

### sts topic show

Use the `topic show` command to display data for a specific topic.

```text
sts topic show <topic>
```

#### Arguments

| Argument | Format | Description |
| :--- | :--- | :--- |
| `<topic>` | string | The Kafka topic to show data for. Topic names can be retrieved using [sts topic list](cli_reference.md#sts-topic-list). |

## Manage StackPacks

The StackState CLI can be used to manage the StackPacks in your StackState instance.

* [Details of installed StackPacks](cli_reference.md#details-of-installed-stackpacks)
* [Install a StackPack](cli_reference.md#install-a-stackpack)
* [Upgrade a StackPack](cli_reference.md#upgrade-a-stackpack)
* [Uninstall a StackPack](cli_reference.md#uninstall-a-stackpack)

### Details of installed StackPacks

The command below returns an overview of all StackPacks currently installed on a StackState instance.

```text
# Returns the category, installed version, next version, latest version
# and instance count for all installed StackPacks
sts stackpack list -i
```

### Install a StackPack

To install a StackPack, you must first upload it to the StackState server.

```text
# Upload a StackPack
sts stackpack upload /path/to/MyStackPack-1.0.0.sts

# Install an uploaded StackPack
sts stackpack install MyStackPack

# Provide parameters for StackPack install:
sts stackpack install -p param1 value1 -p param2 value2 MyStackPack
```

For example, the open-source [SAP StackPack](https://github.com/StackVista/stackpack-sap) requires the parameter [sap\_host](https://github.com/StackVista/stackpack-sap/blob/master/src/main/stackpack/stackpack.conf#L24) during installation. This command kicks off that installation:

```text
sts stackpack install -p sap_host sap1.acme.com stackpack-sap-1.0.1.sts
```

### Upgrade a StackPack

If you want to upgrade a StackPack, first upload the new StackPack version to the StackState server, then trigger the upgrade with the following command:

```text
# Upload new StackPack version
sts stackpack upload /path/to/MyStackPack-1.0.1.sts

# Upgrade to the uploaded StackPack
sts stackpack upgrade MyStackPack
```

{% hint style="info" %}
Note that StackState will upgrade to the latest StackPack version available on the StackState server.
{% endhint %}

### Uninstall a StackPack

Uninstall a StackPack as follows:

```text
sts stackpack uninstall MyStackPack
```

## Scripting

Use `sts script` to execute a script via standard input. For example:

```text
echo "Topology.query(\"label IN ('stackpack:aws')\")" | sts script execute
```

{% hint style="info" %}
Note that the script provided as input must use proper quoting.
{% endhint %}

## License

The StackState CLI can be used to check your license validity and update a license key when needed, for example, in case of expiration.

```text
# check license key validity
sts subscription show

# Update license key
sts subscription update new-license-key
```

{% hint style="info" %}
Note that it is not necessary to do this via the CLI. StackState will also offer this option in the UI when a license is about to expire or has expired.
{% endhint %}

## See also

* [StackState Templated JSON](stj/)

