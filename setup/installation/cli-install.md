---
description: Managing StackState using the CLI.
---

# StackState CLI

The StackState CLI can be used to configure StackState, work with data, automate using StackState data and help with developing StackPacks. The CLI provides easy access to the functionality provided by the StackState APIs. The CLI can be configured for multiple instances of StackState.

## Install the StackState CLI

A standalone executable is available to run the StackState CLI on [Linux](cli-install.md#linux-install) and [Windows](cli-install.md#windows-install). You can also run the CLI [inside a Docker container](cli-install.md#docker-install-mac-linux-windows) on Linux, Windows or MacOS.

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

### Docker install \(Mac, Linux, Windows\)

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

* **Linux or Windows install**: A [wizard will guide you through the configuration](cli-install.md#wizard-configuration-linux-and-windows-install) or you can [create the configuration file manually](cli-install.md#manual-configuration).
* **Docker install**: [Create the configuration file manually](cli-install.md#manual-configuration).

### Wizard configuration \(Linux and Windows install\)

The binary files downloaded in the Linux and Windows install methods described above include a configuration wizard to generate the StackState CLI configuration file. The first time you run any `sts` command (e.g. `sts graph list-types`), the StackState CLI will look for a configuration file. If no valid configuration file is found, the wizard will guide you through creating one and store it under the user's home directory. You will need to enter your [authentication credentials](cli-install.md#authentication).

For example:

```text
$ sts graph list-types
(base) ➜  stackstate-cli git:(releasing-4.3.0) ✗ ./run.sh graph list-types
No config was found. Would you like to configure the CLI using this wizard? (Y/n): Y
StackState base URL: https://stackstate.mycompany.com
Your API token (see https://stackstate.mycompany.com#/cli): HfM_tgB7Lci7NMWH9OesrMOioRuSY40e
Receiver API URL (default - https://stackstate.mycompany.com/receiver):
Receiver API key (default - API_KEY):
Hostname used for receiver ingestion via the CLI (default - mycli):
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
   * The `base_api` API has support for [API tokens](cli-install.md#authentication). You can copy your private API Token from the **CLI** page in the StackState UI.
   * Client details.

{% tabs %}
{% tab title="Example conf.yaml" %}
```yaml
instances:
 default:
   base_api:
     url: "https://localhost:7070"
     ## StackState authentication. This type of authentication is exclusive to the `base_api`.
     ## You can copy your private API Token from the CLI page in the StackState web interface.
     apitoken_auth:
      token: "your API Token"
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
       api_key: "default_api_key"
       ## The name of the host that is passed to StackState when sending. Leave these values unchanged
       ## if you have no idea what to fill here.
       hostname: "hostname"
       internal_hostname: "internal_hostname"
```
{% endtab %}
{% endtabs %}

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

## Authentication

The CLI uses two types of APIs: the Base API and the Receiver API. StackState receives topology, telemetry and trace data via the Receiver API. All other operations use the Base API.

### Authenticating against the Base API using an API token

{% hint style="warning" %}
Authenticating using a username/password combination is being deprecated. It is recommended to switch over to token based authentication. The CLI will issue a warning when using this form of authentication. 
{% endhint %}

Base API access is needed for all operations except for sending topology, telemetry or traces to StackState. The CLI authenticates against the base API using a unique API token that is auto-generated for your user account. You can find your API token in the web interface under the **Main menu -> CLI**. 

### Authenticating against the Receiver API using an API key

StackState receives topology, telemetry and trace data via the receiver API. If you want to push information to StackState using the CLI you will need to provide a receiver API key. This is the same API key that is used by the StackState agent, which is configured by your administrator.

## Use the StackState CLI

For details on how to work with the StackState CLI, see the [CLI reference guide](/develop/reference/cli_reference.md) or refer to the help provided in the CLI.

```
sts --help
```