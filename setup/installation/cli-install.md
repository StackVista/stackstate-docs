---
description: Managing StackState using the CLI.
---

# StackState CLI

The StackState CLI can be used to configure StackState, work with data, and help with debugging problems. The CLI provides easy access to the functionality provided by the StackState API. The URLs and authentication credentials are configurable. Multiple configurations can be stored for access to different instances.

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

* **Linux or Windows install**: A [wizard will guide you through configuration](cli-install.md#wizard-configuration-linux-and-windows-install) or you can [create the configuration file manually](cli-install.md#manual-configuration).
* **Docker install**: [Create the configuration file manually](cli-install.md#manual-configuration).

### Wizard configuration \(Linux and Windows install\)

{% hint style="warning" %}
The configuration generated by the wizard will only work when StackState has been configured to use either LDAP authentication or the file-based authentication. When using OIDC or KeyCloak authentication, follow the directions in the [manual configuration section](cli-install.md#manual-configuration).
{% endhint %}

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
   * The `base_api` API has support for API Tokens. You can copy your private API Token from the **CLI** page in the StackState UI.
   * Client details.

{% tabs %}
{% tab title="Example conf.yaml" %}
```yaml
instances:
 default:
   base_api:
     url: "https://localhost:7070"
     ## StackState authentication. This type of authentication is exclusive to the `base_api`.
     ## You can copy your private API Token from the CLI page in the StackState UI.
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

## Use the StackState CLI

For details on how to work with the StackState CLI, see the [CLI reference guide](/develop/reference/cli_reference.md) or refer to the help provided in the CLI.

```
sts --help
```