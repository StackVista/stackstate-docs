---
description: Managing StackState using the CLI.
---

# StackState CLI

{% hint style="warning" %}
**This page describes StackState version 4.1. **

The StackState 4.1 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.1 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

The StackState CLI can be used to configure StackState, work with data, and help with debugging problems. The CLI provides easy access to the functionality provided by the StackState API. The URLs and authentication credentials are configurable. Multiple configurations can be stored for access to different instances.

## Install the StackState CLI

A standalone executable is available to run the StackState CLI on [Linux](cli-install.md#linux-install) and [Windows](cli-install.md#windows-install). You can also run the CLI [inside a Docker container](cli-install.md#docker-install-linux-windows-mac) on Linux, Windows or MacOS.

### Linux install

A standalone executable file is available to run the StackState CLI on Linux.

**Requirements:**

* Access to the StackState APIs.

**Installation:**

1. Download the Linux executable `sts-cli-VERSION-linux64` from [https://download.stackstate.com](https://download.stackstate.com).
2. Rename the downloaded file to be `sts` and make it executable:

   ```text
   mv sts-cli-VERSION-linux64 sts
   chmod +x sts
   ```

3. \(optional\) Place the file under your PATH to use StackState CLI commands from [anywhere on the command line](https://unix.stackexchange.com/questions/3809/how-can-i-make-a-program-executable-from-everywhere).
4. Follow the steps below to [launch the configuration wizard](cli-install.md#wizard-configuration-linux-and-windows-install) or [manually configure](cli-install.md#manual-configuration) the StackState CLI.

### Windows install

A standalone executable file is available to run the StackState CLI on Windows.

**Requirements:**

* Access to the StackState APIs.

**Installation:**

1. Download the executable `sts-cli-VERSION-windows.exe` from [https://download.stackstate.com](https://download.stackstate.com).
2. Rename the downloaded file to be `sts.exe`.
3. \(optional\) Place the file under your PATH to use StackState CLI commands from [anywhere on the command line](https://stackoverflow.com/questions/4822400/register-an-exe-so-you-can-run-it-from-any-command-line-in-windows).
4. Follow the steps below to [launch the configuration wizard](cli-install.md#wizard-configuration-linux-and-windows-install) or [manually configure](cli-install.md#manual-configuration) the StackState CLI.

### Docker install \(Linux, Windows, Mac\)

The StackState CLI can be run inside a Docker container on Linux, Windows or MacOS. The ZIP archive provided contains scripts that help you run the CLI without needing to worry about Docker invocations.

**Requirements:**

* Access to the StackState APIs.
* [Docker installed](https://docs.docker.com/get-docker/).
* Internet connection for first time run.

**Installation:**

1. Download the ZIP file `sts-cli-VERSION.zip` from [https://download.stackstate.com](https://download.stackstate.com).

   The ZIP archive contains the following files:

   ```text
   .
   +-- bin
   |   +-- sts     # Script to run the CLI in Docker for bash
   |   +-- sts.ps1 # Script to run the CLI in Docker for Powershell
   +-- conf.d
   |   +-- conf.yaml.example # Example CLI configuration
   |   +-- VERSION           # The CLI version to retrieve from Docker hub
   +-- templates
   |   +-- topology   # Topology templates in a format specific to the CLI
   +-- release_notes.md  # Changelog of the CLI
   +-- usage.md          # How to configure and use this package
   ```

2. \(optional\) Put put the `bin` folder to your PATH to use StackState CLI commands from [anywhere on the command line](https://unix.stackexchange.com/questions/3809/how-can-i-make-a-program-executable-from-everywhere).
3. Follow the steps below to [manually configure the StackState CLI](cli-install.md#manual-configuration).

## Configure the StackState CLI

To use the StackState CLI, you need to configure it with the API connection details for your StackState instance.

* **Linux or Windows install**: A [wizard will guide you through configuration](cli-install.md#wizard-configuration-linux-and-windows-install) or you can [create the configuration file manually](cli-install.md#manual-configuration).
* **Docker install**: [Create the configuration file manually](cli-install.md#manual-configuration).

### Wizard configuration \(Linux and Windows install\)

The binary files downloaded in the Linux and Windows install methods described above include a configuration wizard to generate the StackState CLI configuration file. The first time you run any `sts` command, the StackState CLI will look for a configuration file. If no valid configuration file is found, the wizard will guide you through creating one and store it under the user's home directory.

For example:

```text
$ sts graph list-types
No config was found. Would you like to configure CLI using wizard? (y/N) y

Base API URL (default - http://localhost:7070/) https://mystackstate.example.org
    username (empty if no auth) admin
    password secretpassword
Receiver API URL (default - https://mystackstate.example.org:7077) https://mystackstate.example.org/receiver
    username (empty if no auth) (default - admin)
    password (default - secretpassword)
Admin API URL (default - https://mystackstate.example.org:7071) https://mystackstate.example.org/admin
    username (empty if no auth) (default - admin)
    password (default - secretpassword)
API key (default - API_KEY) a912bc82d89dfba72def
Hostname used for ingested via CLI (default - hostname)
```

### Manual configuration

Follow the steps below to create a configuration file manually \(required for Docker install\).

1. Download the ZIP file `sts-cli-VERSION.zip` from [https://download.stackstate.com](https://download.stackstate.com). If you ran the Docker install, skip this step and use the ZIP archive you already downloaded.
2. Copy the file `conf.d/conf.example.yaml` from the ZIP archive and put it in one of the following directories:
   * **Docker:**
     * `conf.d/` - relative to the directory where the CLI is run.
   * **Linux or Windows:**
     * `conf.d/` - relative to the directory where the CLI is run.
     * `~/.stackstate/cli/` - relative to the user's home directory.
     * `%APPDATA%/StackState/cli/` - relative to the user's home directory.
3. Rename the file to be `conf.yaml`.
4. Edit the file and add:
   * URLs to the StackState APIs.
   * Any required authentication details for the APIs.
   * Client details.

For example:

```yaml
instances:
 default:
   base_api:
     url: "https://localhost:7070"
     ## StackState authentication. This type of authentication is exclusive to the `base_api`.
     # auth:
     #   username: "validUsername"
     #   password: "safePassword"
     ## HTTP basic authentication.
     # basic_auth:
     #   username: "validUsername"
     #   password: "safePassword"
   receiver_api:
     url: "https://???:7077"
     ## HTTP basic authentication.
     #basic_auth:
       #username: "validUsername"
       #password: "safePassword"
   admin_api:
     url: "https://???:7071"
     ## HTTP basic authentication.
     #basic_auth:
       #username: "adminUsername"
       #password: "safePassword"

   ## The CLI uses a client configuration to identify who is sending to the StackState instance. The client
   ## is used to send topology and/or telemetry to the receiver API.
   ##
   ## Unless the `--client` argument is passed the CLI will pick the `default` instance as configured below.
   ## Other clients follow the exact same configuration pattern as the default client. You may simply copy-paste its config and modify whatever is needed.
   clients:
     default:
       api_key: "???"
       ## The name of the host that is passed to StackState when sending. Leave these values unchanged
       ## if you have no idea what to fill here.
       hostname: "hostname"
       internal_hostname: "internal_hostname"
```

### Multiple configurations

The `conf.yaml` configuration file can hold multiple configurations. Other StackState instances can be added on the same level as the default configuration. For example:

```yaml
instances:
 default:
   base_api:
     ...
   clients:
     ...
 Preproduction:
   base_api:
     ...
   clients:
     ...
```

To use the StackState CLI with a non-default instance:

```text
sts --instance <instance_name> ...
```

## Use the StackState CLI

### Import and export StackState configuration

The StackState configuration is stored in StackState's graph database in so-called configuration nodes. These nodes can be inspected, imported and exported using the CLI.

```text
# See all types of configuration nodes:
sts graph list-types
```

You can use the `sts graph export` and `sts graph import` commands to export and import different types of configuration nodes from and to StackState. Nodes are stored in [StackState Templated Json](../../develop/reference/stj/) format.

For example:

```text
# Write all check functions to disk
sts graph list --ids CheckFunction | xargs sts graph export --ids > mycheckfunctions.stj

# Import check functions from file
sts graph import < mycheckfunctions.stj
```

### Inspect data

All data flowing through StackState \(e.g. topology, telemetry, traces, etc.\) flows through so-called topics. For debugging purposes, these topics can be inspected using the CLI. This can come in handy, for example, to make sure that StackState is receiving data correctly when you write your own integrations.

For example:

```text
# See all topics
sts topic list

# Inspect a topic
sts topic show <topic>
```

### Send data

You may not always want to try a new configuration on real data. First, you might want to see if it works correctly with predictable data. The CLI makes it easy to send test topology or telemetry data to StackState.

* [Send metrics data](cli-install.md#metrics)
* [Send events data](cli-install.md#events)
* [Send topology data](cli-install.md#topology)
* [Send anomaly data](cli-install.md#anomaly)

#### Metrics

The CLI provides some predefined settings to send metrics to StackState. Run the below command without any optional arguments to send one data point of the given value:

```text
sts metrics send <MetricName> <OptionalNumberValue>
```

You can also use optional arguments to create historical data for a test metric.

| Argument | Details |
| :--- | :--- |
| `-p` | Time period. This can be in weeks `w`, days `d`, hours `h`, minutes `m` and/or seconds `s`. For example: `-p 4w2d6h30m15s` |
| `-b` | The bandwidth between which values will be generated. For example: `-b 100-250` |

By default, a metrics pattern is random or, when a value is provided, a flatline. This can be changed using the pattern arguments `--linear` and `--baseline`.

| Argument | Details |
| :--- | :--- |
| `--linear` | Creates a line between the values given for `-b` plotted over the time given for `-p` |
| `--baseline` | Creates a daily usage curve. On Saturday and Sunday, the metric is much lower than on weekdays. The min and max of the curve are set by `-b` and `-p` |
| `--csv` | Reads a CSV file from the stdin and sends it to StackState. The content of the CSV file should be in the format `timestamp,value` |

To see all available options, use:

```text
sts metrics send -h
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

* [Install a StackPack](cli-install.md#install-a-stackpack)
* [Upgrade a StackPack](cli-install.md#upgrade-a-stackpack)
* [Uninstall a StackPack](cli-install.md#uninstall-a-stackpack)

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
sts stackpack install -p sap_host sap1.acme.com sap
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

