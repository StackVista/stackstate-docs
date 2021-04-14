---
description: Install the StackState CLI
---

# StackState CLI

## Overview

The StackState CLI provides easy access to the functionality provided by the StackState APIs. It can be used to configure StackState, work with data, automate using StackState data and help with developing StackPacks. You can configure the CLI to work with multiple instances of StackState.

## Install the StackState CLI

A standalone executable is available to run the StackState CLI on [Linux](cli-install.md#linux-install) and [Windows](cli-install.md#windows-install). You can also run the CLI [inside a Docker container](cli-install.md#docker-install-mac-linux-windows) on Linux, Windows or MacOS.

### Linux install

The steps below describe how to install the StackState CLI on Linux using the standalone executable file. If you prefer, you can run the CLI [inside a Docker container](cli-install.md#docker-install-mac-linux-windows) .

**Requirements:**

* Access to the StackState APIs.

**Installation:**

1. Download the Linux executable `sts-cli-VERSION-linux64` from [https://download.stackstate.com](https://download.stackstate.com).
2. Rename the downloaded file to be `sts` and make it executable:

   ```text
   mv sts-cli-VERSION-linux64 sts
   chmod +x sts
   ```

3. \(optional\) Add the file to your PATH to use StackState CLI commands from [anywhere on the command line](https://unix.stackexchange.com/questions/3809/how-can-i-make-a-program-executable-from-everywhere).
4. To configure the StackState CLI, do one of the following:
   * [Launch the configuration wizard](cli-install.md#configuration-wizard-linux-and-windows-install).
   * [Manually add configuration](cli-install.md#manual-configuration-docker).

### Windows install

The steps below describe how to install the StackState CLI on Windows using the standalone executable file. If you prefer, you can run the CLI [inside a Docker container](cli-install.md#docker-install-mac-linux-windows) .

**Requirements:**

* Access to the StackState APIs.

**Installation:**

1. Download the executable `sts-cli-VERSION-windows.exe` from [https://download.stackstate.com](https://download.stackstate.com).
2. Rename the downloaded file to be `sts.exe`.
3. \(optional\) Add the file to your PATH to use StackState CLI commands from [anywhere on the command line](https://stackoverflow.com/questions/4822400/register-an-exe-so-you-can-run-it-from-any-command-line-in-windows).
4. To configure the StackState CLI, do one of the following:
   * [Launch the configuration wizard](cli-install.md#configuration-wizard-linux-and-windows-install).
   * [Manually add configuration](cli-install.md#manual-configuration-docker).

### Docker install \(Mac, Linux, Windows\)

The StackState CLI can be run inside a Docker container on Linux, Windows or MacOS. The ZIP archive provided contains scripts that run the CLI without needing to worry about Docker invocations.

**Requirements:**

* Access to the StackState APIs.
* [Docker installed \(docker.com\)](https://docs.docker.com/get-docker/).
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

2. \(optional\) Add the `bin` directory to your PATH to use StackState CLI commands from [anywhere on the command line](https://unix.stackexchange.com/questions/3809/how-can-i-make-a-program-executable-from-everywhere).
3. To configure the StackState CLI, [manually add configuration](cli-install.md#manual-configuration-docker).

## Configure the StackState CLI

After installation, the StackState CLI must be configured with the API connection details for your StackState instance. If you installed the standalone executable StackState CLI on Linux or Windows, a wizard is available to guide you through configuration. If you installed the Docker version of the StackState CLI on Mac, Linux or Windows, the configuration file must be manually created.

* **Linux or Windows install \(standalone executable\)**: [Configuration wizard](cli-install.md#configuration-wizard-linux-and-windows-install).
* **Docker install**: [Create the configuration file manually](cli-install.md#manual-configuration-docker).

### Configuration wizard \(Linux and Windows install\)

The binary files downloaded in the Linux and Windows install methods described above include a configuration wizard to generate the StackState CLI configuration file. The first time you run any `sts` command, for example `sts graph list-types`, the StackState CLI will look for a configuration file. If no valid configuration file is found, the wizard will guide you through creating one and store it under the user's home directory. You will need to enter your [authentication credentials](cli-install.md#authentication).

For example:

```text
$ sts graph list-types

No config was found. Would you like to configure the CLI using this wizard? (Y/n): Y

StackState base URL: https://stackstate.mycompany.com
Your API token (see https://stackstate.mycompany.com#/cli): 
Receiver API URL (default - https://stackstate.mycompany.com/receiver):
Receiver API key (default - API_KEY):
Hostname used for receiver ingestion via the CLI (default - mycli):
```

### Manual configuration \(Docker\)

Follow the steps below to create a configuration file manually. This is required for a Docker install and optional for a Linux or Windows install using a standalone executable file.

1. Download the ZIP file `sts-cli-VERSION.zip` from [https://download.stackstate.com](https://download.stackstate.com). If you ran the Docker install, you can skip this step and use the ZIP archive you already downloaded.
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
   * Any required authentication details for the APIs. The `base_api` API has support for [API tokens](cli-install.md#authentication). You can copy your private API Token from the **CLI** page in the StackState UI.
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

### Add multiple configurations

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

To use the StackState CLI with a non-default instance, specify the instance name in the sts command:

```text
sts --instance <instance_name> ...
```

## Authentication

The StackState CLI predominantly uses two APIs: the Base API and the Receiver API. StackState receives topology, telemetry and trace data via the Receiver API. All other operations use the Base API.

### Base API - API token

{% hint style="warning" %}
**Base API authentication using username/password will be deprecated.**

The CLI will issue a warning when username/password authentication is used. It is recommended to switch to token based authentication.
{% endhint %}

Base API access is required for all operations, other than sending topology, telemetry or traces to StackState. The StackState CLI authenticates against the base API using a unique API token that is auto-generated for your user account.

You can find your API token in the StackState UI on the page **Main menu** &gt; **CLI**.

### Receiver API - API key

StackState receives topology, telemetry and trace data via the receiver API. If you want to push information to StackState using the CLI, you will need to provide a receiver API key. This is the same API key that is used by the StackState Agent, which is configured by your administrator.

## Use the StackState CLI

For details on how to work with the StackState CLI, see the [CLI reference guide](../../develop/reference/cli_reference.md) or refer to the help provided in the CLI.

```text
sts --help
```

