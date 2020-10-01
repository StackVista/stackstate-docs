---
description: Manage StackState using the CLI
---

The StackState CLI can be used to configure StackState, work with data, and help with debugging problems. The CLI provides easy access to the functionality provided by the StackState API. The URLs and authentication credentials are configurable. Multiple configurations can be stored for access to different instances.

# Use

To use the StackState CLI commands, [install the StackState CLI](/setup/cli.md) on the machine where you want to run the commands.

# Export / import configuration

## sts graph list-types

StackState configuration is stored in the StackState graph database (StackGraph) in configuration nodes. Use the `sts graph list-types` command to see the types of all configuration nodes.

```text
sts graph list-types
```

### Output



## sts graph export

You can use the `sts graph export` to export different types of [configuration nodes](#sts-graph-list-types) from and to StackState. Nodes are stored in [StackState Templated Json](/develop/sts_template_language_intro/) format.

`sts graph export --ids ids_to_export > file_name`


### Parameters / fields

| Parameter | Format | Default | Description |
|:---|:---|:---|:---|
| `--ids` | list of string(s) | "all" | The IDs to export. If none are specified all configuration will be exported. |
| file_name | file_name | ??? | The file to store the backup in. If none is specified, will be stored in ??? |

### Examples

The example below will write all check functions to the file mycheckfunctions.stj

```
sts graph list --ids CheckFunction | xargs sts graph export --ids > mycheckfunctions.stj
```

## sts graph import

You can use the `sts graph import` command to import configuration previously exported configuration back into StackState.

`sts graph import < file_name`

### Parameters / fields

| Parameter | Format | Required | Description |
|:---|:---|:---|
| file_name | file_name | ??? | The file to import StackState configuration from. If none is specified, will be taken from ??? |

### Examples

```
# actual examples of use
```

# Send data to StackState

The CLI makes it easy to send test data to StackState.

* [Send metrics data](cli.md#metrics)
* [Send events data](cli.md#events)
* [Send topology data](cli.md#topology)
* [Send anomaly data](cli.md#anomaly)

## sts metrics send

You can use the CLI to send one data point of a given value data. You can also use the CLI to generate values within a defined bandwidth. By default, a generated metrics pattern is random or, when a value is provided, a flatline. This can be changed using the pattern arguments `--linear` and `--baseline`.

`sts metrics send <optional_argument> <MetricName> <OptionalNumberValue>`

| Argument | Details |
| :--- | :--- |
| `-p` | Time period. This can be in weeks `w`, days `d`, hours `h`, minutes `m` and/or seconds `s`. For example: `-p 4w2d6h30m15s` |
| `-b` | The bandwidth between which values will be generated. For example: `-b 100-250` |
| `--linear` | Creates a line between the values given for `-b` plotted over the time given for `-p` |
| `--baseline` | Creates a daily usage curve. On Saturday and Sunday, the metric is much lower than on weekdays. The min and max of the curve are set by `-b` and `-p` |
| `--csv` | Reads a CSV file from the stdin and sends it to StackState. The content of the CSV file should be in the format `timestamp,value` |
| `-h` | See all available options |

# Inspect topic data

All data flowing through StackState \(e.g. topology, telemetry, traces, etc.\) flows through topics. For debugging purposes, these topics can be inspected using the CLI. This can come in handy, for example, to make sure that StackState is receiving data correctly when you write your own integrations.

## sts topic list

See all topics.

```
sts topic list
```

### Output

## sts topic show

`sts topic show <topic>`

### Parameters / fields

| Parameter | Format | Description |
|:---|:---|:---|
| `list` | string | A description of |
| `of` | True, False | what each paramater |
| `parameters` | Number | is used for |




# See also

End the page with pointers to relevant, further info. This might just be a list with any links already included in the page. If the use of the functions/commands are explained in more detail elsewhere include it here (e.g. in a tutorial or how-to).

- [StackState Templated Json](/develop/sts_template_language_intro/)
- link 2
- link 3



-------

### Send data

You may not always want to try a new configuration on real data. First, you might want to see if it works correctly with predictable data. 
```

#### Events

The CLI can send events using `sts events send <eventName>` It will send one event with the given name.

For help on sending events data, use:

```text
sts events send -h
```

#### Topology

Please refer to `usage.md` in the CLI zip archive for detailed instructions.

For help on sending topology data, use:

```text
sts topology send -h
```

#### Anomaly

The CLI provides an `anomaly` command used to send anomaly data for a metric stream of a component.

```text
sts anomaly send --component-name <Component> --stream-name <Metric Stream> --start-time=-30m
```

You can also use the optional arguments below to create a specific anomaly.

| Argument | Details |
| :--- | :--- |
| `--duration` | Anomaly duration \(seconds\) |
| `--severity` | Anomaly severity \(HIGH, MEDIUM, LOW\) |
| `--severity-score` | Anomaly severity score |
| `--description` | Anomaly description field contents |

For help on sending anomaly data, use:

```text
sts anomaly send -h
```

### Manage StackPacks

The StackState CLI can be used to manage the StackPacks in your StackState instance.

* [Install a StackPack](cli.md#install-a-stackpack)
* [Upgrade a StackPack](cli.md#upgrade-a-stackpack)
* [Uninstall a StackPack](cli.md#uninstall-a-stackpack)

#### Install a StackPack

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

#### Upgrade a StackPack

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

#### Uninstall a StackPack

Uninstall a StackPack as follows:

```text
sts stackpack uninstall MyStackPack
```

### Scripting

It is possible to execute scripts using the StackState CLI. Use `sts script` to execute a script via standard input. For example:

```text
echo "Topology.query(\"label IN ('stackpack:aws')\")" | sts script execute
```

{% hint style="info" %}
Note that the script provided as input must use proper quoting.
{% endhint %}

### License

The StackState CLI can check your license validity and update a license key when needed, for example in case of expiration.

```text
# check license key validity
sts subscription show

# Update license key
sts subscription update new-license-key
```

{% hint style="info" %}
Note that it is not necessary to do this via the CLI. StackState will also offer this option in the UI when a license is about to expire or has expired.
{% endhint %}