---
description: StackState Self-hosted v5.0.x
---

# CLI: stac

## Overview

The StackState CLI provides easy access to the functionality provided by the StackState APIs. It can be used to configure StackState, work with data, automate using StackState data and help with developing StackPacks. You can configure the CLI to work with multiple instances of StackState.

## Install the StackState CLI

A standalone executable is available to run the StackState CLI on [Linux](cli-install.md#linux-install) and [Windows](cli-install.md#windows-install). You can also run the CLI [inside a Docker container](cli-install.md#docker-install-mac-linux-windows) on Linux, Windows or MacOS.

### Linux install

The steps below describe how to install the StackState CLI on Linux using the standalone executable file. If you prefer, you can run the CLI [inside a Docker container](#docker-install-mac-linux-windows) .

**Requirements:**

* Access to the StackState APIs.

**Installation:**

1. Download the Linux executable `sts-cli-VERSION-linux64` from [https://download.stackstate.com](https://download.stackstate.com).
2. Rename the downloaded file to be `stac` and make it executable:

   ```text
   mv sts-cli-VERSION-linux64 stac
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
2. Rename the downloaded file to be `stac.exe`.
3. \(optional\) Add the file to your PATH to use StackState CLI commands from [anywhere on the command line](https://stackoverflow.com/questions/4822400/register-an-exe-so-you-can-run-it-from-any-command-line-in-windows).
4. To configure the StackState CLI, do one of the following:
   * [Launch the configuration wizard](cli-install.md#configuration-wizard-linux-and-windows-install).
   * [Manually add configuration](cli-install.md#manual-configuration-docker).

### Docker install \(MacOS, Linux, Windows\)

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

2. Rename the bash and Powershell scripts in the `bin` directory to use the new `stac` name:
   * Script to run the CLI in Docker for bash: Rename from `sts` to `stac`.
   * Script to run the CLI in Docker for Powershell: Rename from `sts.ps1` to `stac.ps1`.

3. \(optional\) Add the `bin` directory to your PATH to use StackState CLI commands from [anywhere on the command line](https://unix.stackexchange.com/questions/3809/how-can-i-make-a-program-executable-from-everywhere).
4. To configure the StackState CLI, [manually add configuration](#manual-configuration-docker).

## Configure the StackState CLI

After installation, the StackState CLI must be configured with the API connection details for your StackState instance. If you installed the standalone executable StackState CLI on Linux or Windows, a wizard is available to guide you through configuration. If you installed the Docker version of the StackState CLI on MacOS, Linux or Windows, the configuration file must be manually created.

* **Linux or Windows install \(standalone executable\)**: [Configuration wizard](cli-install.md#configuration-wizard-linux-and-windows-install).
* **Docker install**: [Create the configuration file manually](cli-install.md#manual-configuration-docker).

### Configuration wizard \(Linux and Windows install\)

If the StackState CLI was installed on Linux or Windows using a standalone executable file, the first time you run any `sts` command, a configuration wizard will request the required configuration items. The wizard will then create a configuration file with the entered details and store it under the user's home directory. If a valid configuration file already exists, the StackState CLI will use this and the configuration wizard will not run.

The configuration wizard is not available when the CLI is run inside a Docker container on MacOS, Linux or Windows.

{% hint style="info" %}
To configure the CLI, you will need your [authentication credentials](cli-install.md#authentication).
{% endhint %}

Example configuration wizard:

```text
$ sts graph list-types
No config was found. Would you like to configure the CLI using this wizard? (Y/n): Y

StackState URL: https://company.stackstate.com/
Your API token (see https://company.stackstate.com/#/cli ):
Admin API URL (default: https://company.stackstate.com/admin):
Receiver API URL (default: https://company.stackstate.com/receiver):
Receiver API key (default: API_KEY):
Hostname used for receiver ingestion via the CLI (default: mycli):

Thank you! Config file saved to: /Users/myuser/.stackstate/cli/conf.yaml
```

### Manual configuration \(Docker\)

The CLI configuration file can be manually created or edited using the steps below. This is required for a Docker install and optional for a Linux or Windows install using a standalone executable file.

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
## The CLI uses an instance of StackState for all its commands.
## Unless the `--instance` argument is passed the CLI will pick the `default` instance as configured below.
## Other instances follow the exact same configuration pattern as the instance below.
instances:
  default:
    base_api:
      url: "https://stackstate.mycompany.com"
      # Get the api token from the user interface, see https://stackstate.mycompany.com/#/cli
      apitoken_auth:
        token: '???'
      ## HTTP basic authentication.
      #basic_auth:
        #username: '???'
        #password: '???'
    receiver_api:
      url: "https://stackstate.mycompany.com/receiver"
      ## HTTP basic authentication.
      #basic_auth:
        #username: '???'
        #password: '???'
    admin_api:
      url: "https://stackstate.mycompany.com/admin"
      # Get the api token from the user interface, see https://stackstate.mycompany.com/#/cli
      apitoken_auth:
        token: '???'
      ## HTTP basic authentication.
      #basic_auth:
        #username: '???'
        #password: '???'

    ## The CLI uses a client configuration to identify who is sending to the StackState instance. The client
    ## is used to send topology and/or telemetry to the receiver API.
    ##
    ## Unless the `--client` argument is passed the CLI will pick the `default` instance as configured below.
    ## Other clients follow the exact same configuration pattern as the default client. You may simply copy-paste its config and modify whatever is needed.
    clients:
      default:
        api_key: "<STACKSTATE_RECEIVER_API_KEY>"
        ## The name of the host that is passed to StackState when sending. Leave these values unchanged
        ## if you have no idea what to fill here.
        hostname: "hostname"
        internal_hostname: "internal_hostname"
```
{% endtab %}
{% endtabs %}

### Add multiple configurations

The `conf.yaml` CLI configuration file can hold multiple configurations. Other StackState instances can be added on the same level as the default configuration. For example:

```yaml
instances:
  default:
    base_api:
      ...
    admin_api:
      ...
    receiver_api:
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

The StackState CLI uses three StackState APIs: the Base API, the Admin API and the Receiver API. These APIs are secured differently and need to have separate authentication details entered in the CLI configuration file.

### API key - Receiver API

StackState receives topology, telemetry and trace data via the Receiver API. If you want to push information to StackState using the CLI, you will need to provide a Receiver API key. This is the same API key that is used by the StackState Agent and is available from your administrator.

### API token - Base API and Admin API

{% hint style="warning" %}
**Base API and Admin API authentication using username/password will be deprecated.**

The CLI will issue a warning when username/password authentication is used for the Base API and the Admin API. It is recommended to switch to token based authentication as described below.
{% endhint %}

The StackState CLI authenticates against the Base API and the Admin API using a unique API token that is auto-generated for your StackState user account. The same API token should be entered in the CLI configuration file for both the Base API and the Admin API. 

* The Base API is used for most operations. All users have access to this API, although the available operations will be restricted in accordance with the permissions assigned to each role. 
* The Admin API is used for some operations that affect the global configuration of StackState, such as the configuration of StackGraph's retention. Only users with the permission `access-admin-api` will have access to the Admin API and the associated operations.

➡️ [Learn more about StackState permissions](/configure/security/rbac/rbac_permissions.md)

{% hint style="info" %}
If you are using a custom tool instead of the CLI, you can authenticate with the same API token. For example, this can be done by including the following header in a curl request:

```
curl -H "Authorization: ApiToken <token>" <stackstate-api-endpoint>
```
{% endhint %}


You can find your API token in the StackState UI, go to **Main menu** &gt; **CLI**.


![](../../.gitbook/assets/v50_main_menu.png)

## Upgrade

To upgrade an installed version of the CLI:

1. Delete the existing CLI files:
   * **Windows and Linux:**
      1. Version 4.6 and older: The file was downloaded as `sts-cli-VERSION-linux64` and renamed to `sts`.
      2. Version 5.0 and above: The file was downloaded as `sts-cli-VERSION-linux64` and renamed to `stac`.
   * **Docker:**
     * The zip archive was downloaded as `sts-cli-VERSION.zip` and extracted. All files extracted from the zip archive should be removed. 

2. Follow the instructions to download and install the upgraded CLI:
   * [Linux install](#linux-install)
   * [Windows install](#windows-install)
   * [Docker install \(MacOS, Linux, Windows\)](#docker-install-mac-linux-windows)
   
3. It is not necessary to configure the CLI again, the existing CLI configuration will be used.

## Uninstall

To uninstall an installed version of the CLI:

1. Delete the old CLI files:
   * **Linux or Windows:**
      1. Version 4.6 and older: The file was downloaded as `sts-cli-VERSION-linux64` and renamed to `sts`.
      2. Version 5.0 and above: The file was downloaded as `sts-cli-VERSION-linux64` and renamed to `stac`.
   * **Docker:**
     * The zip archive was downloaded as `sts-cli-VERSION.zip` and extracted. All files extracted from the zip archive should be removed. 

2. Delete any CLI configuration files:
   * **Linux or Windows:**
     * `conf.d/conf.yaml` - relative to the directory where the CLI is run.
     * `~/.stackstate/cli/conf.yaml` - relative to the user's home directory.
     * `%APPDATA%/StackState/cli/conf.yaml` - relative to the user's home directory.
   * **Docker:** 
     * `conf.d/conf.yaml` - relative to the directory where the CLI would run. Should have been removed together with the old CLI files in step 1.

3. If you added the CLI file or directory to your path (an optional installation step), remove it.

## Use the StackState CLI

For details on how to work with the StackState CLI, refer to the help provided in the CLI.

```text
sts --help
```

