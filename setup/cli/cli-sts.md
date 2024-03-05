---
description: StackState SaaS
---

# CLI: sts

## Overview

The new StackState `sts` CLI provides easy access to the functionality provided by the StackState APIs. It can be used for automate using StackState data, configure StackState and to develop StackPacks.

{% hint style="success" "self-hosted info" %}

**StackState Self-Hosted**

Extra information for the [StackState Self-Hosted product](https://docs.stackstate.com/):

    
* The new `sts` CLI replaces the `stac` CLI, however, not all commands are currently supported. For an overview of the differences and overlap between the new `sts` CLI and the `stac` CLI, see the CLI comparison page.
* In the meantime, you can install and run as the new `sts` CLI on the same machine as the `stac` CLI.

{% endhint %}

## Install the new `sts` CLI



2. Follow the steps below to install the new `sts` CLI:

{% tabs %}
{% tab title="Windows" %}

{% tabs %}
{% tab title="Installer" %}

Open a **Powershell** terminal (version 5.1 or later), change the `<URL>` and `<API-TOKEN>` and run the command below. After installation, the `sts` command will be available for the current user on both the Powershell terminal and the command prompt (cmd.exe).

```powershell
. { iwr -useb https://dl.stackstate.com/stackstate-cli/install.ps1 } | iex; install -StsUrl "<URL>" -StsApiToken "<API-TOKEN>"
```

Alternatively, go to the **CLI** page in the StackState UI and copy the **Quick installation** command for **Windows** - this is pre-filled with the correct `<URL>` and `<API-TOKEN>` for your StackState instance.

{% endtab %}
{% tab title="Manual install steps" %}

Open a **Powershell** terminal (version 5.1 or later) and run the steps below. This can be done one step at a time, or joined together as a single script. After installation, the `sts` command will be available for the current user on both the Powershell terminal and the command prompt (cmd.exe).

1. Set the source version and target path for the CLI:
    ```powershell
    $CLI_PATH = $env:USERPROFILE +"\stackstate-cli"
    If (!(test-path $CLI_PATH)) { md $CLI_PATH }
    Invoke-WebRequest https://dl.stackstate.com/stackstate-cli/LATEST_VERSION -OutFile $CLI_PATH\VERSION
    $VERSION=type $CLI_PATH\VERSION
    $CLI_DL = "https://dl.stackstate.com/stackstate-cli/v$VERSION/stackstate-cli-$VERSION.windows-x86_64.zip"
    echo "Installing StackState CLI v$VERSION to: $CLI_PATH"
    ```

2. Download and unpack the CLI to the target CLI path. Remove remaining artifacts:
    ```powershell
    Invoke-WebRequest $CLI_DL -OutFile $CLI_PATH\stackstate-cli.zip
    Expand-Archive -Path "$CLI_PATH\stackstate-cli.zip" -DestinationPath $CLI_PATH -Force
    rm $CLI_PATH\stackstate-cli.zip, $CLI_PATH\VERSION
    ```

3. Register the CLI path to the current user's PATH. This will make the `sts` command available everywhere:
   ```powershell
    $PATH = (Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Environment" -Name PATH).Path
    if ( $PATH -notlike "*$CLI_PATH*" ) {
      $PATH = "$PATH;$CLI_PATH"
      (Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Environment" -Name PATH –Value $PATH)
      $MACHINE_PATH = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH).path
      $env:Path = "$PATH;$MACHINE_PATH"
    }
   ```

5. Verify that the CLI works:
    ```powershell
    sts version
    ```

{% endtab %}
{% endtabs %}

{% endtab %}
{% tab title="macOS" %}

{% tabs %}
{% tab title="Installer" %}
Open a terminal, change the `<URL>` and `<API-TOKEN>` and run the command below. 

* The default install location is `/usr/local/bin`,  which might require sudo permissions depending on the version of your machine. 
* You can specify an install location by adding `STS_CLI_LOCATION` to the command, as shown below. Note that the path provided must be available in your OS Path or the script might fail to complete.

After installation, the `sts` command will be available for the current user.

```bash
# Install in default location `/usr/local/bin`
curl -o- https://dl.stackstate.com/stackstate-cli/install.sh | STS_URL="<URL>" STS_API_TOKEN="<API-TOKEN>" bash

# Install in a specified location
curl -o- https://dl.stackstate.com/stackstate-cli/install.sh | STS_URL="<URL>" STS_API_TOKEN="<API-TOKEN>" STS_CLI_LOCATION="<INSTALL-PATH>" bash
```

Alternatively, go to the **CLI** page in the StackState UI and copy the **Quick installation** command for **MacOS** - this is pre-filled with the correct `<URL>` and `<API-TOKEN>` for your StackState instance and will install the CLI at the default location.

{% endtab %}

{% tab title="Manual install steps" %}
Open a terminal and run the steps below. This can be done one step at a time, or all together as a single script. After installation, the `sts` command will be available for the current user.

3. Download the latest CLI version for x86_64 (Intel) or arm64 (M1).
   ```bash
   (VERSION=`curl https://dl.stackstate.com/stackstate-cli/LATEST_VERSION` &&
     ARCH=`uname -m` &&
     curl https://dl.stackstate.com/stackstate-cli/v$VERSION/stackstate-cli-$VERSION.darwin-$ARCH.tar.gz | tar xz --directory /usr/local/bin)
   ```

4. Verify that the CLI works:
    ```bash
    sts version
    ```

{% endtab %}
{% endtabs %}

{% endtab %}
{% tab title="Linux" %}

{% tabs %}
{% tab title="Installer" %}
Open a terminal, change the `<URL>` and `<API-TOKEN>` and run the command below. After installation, the `sts` command will be available for the current user.

```bash
curl -o- https://dl.stackstate.com/stackstate-cli/install.sh | STS_URL="<URL>" STS_API_TOKEN="<API-TOKEN>" bash
```

Alternatively, go to the **CLI** page in the StackState UI and copy the **Quick installation** command for **Linux** - this is pre-filled with the correct `<URL>` and `<API-TOKEN>` for your StackState instance.

{% endtab %}

{% tab title="Manual install steps" %}
Open a terminal and run the steps below. This can be done one step at a time, or all together as a single script. After installation, the `sts` command will be available for the current user.

1. Download and unpack the latest version for x86_64:
   ```bash
   (VERSION=`curl https://dl.stackstate.com/stackstate-cli/LATEST_VERSION` &&
   curl https://dl.stackstate.com/stackstate-cli/v$VERSION/stackstate-cli-$VERSION.linux-x86_64.tar.gz | tar xz --directory /usr/local/bin)
   ```

2. Verify that the CLI works:
    ```bash
    sts version
    ```

{% endtab %}
{% endtabs %}

{% endtab %}
{% tab title="Docker" %}

To run the latest version of the CLI using Docker execute:

```bash
docker run stackstate/stackstate-cli2
```

Alternatively, go to the **CLI** page in the StackState UI and copy the **Quick installation** command for **Docker** - this is pre-filled with the correct `<URL>` and `<API-TOKEN>` required to configure the CLI for your StackState instance.

You can now run CLI commands by adding appending them to the end of the `docker run` command (for example, `docker run stackstate/stackstate-cli2 version`).

{% endtab %}
{% endtabs %}

## Configure the new `sts` CLI

### Quick start

{% hint style="warning" %}
The most secure way to use your API token is through an environment variable. You can store the API token with a secrets manager and inject it as an environment variable into your shell.
{% endhint %}

#### Linux, macOS and Windows

1. In the StackState UI, go to **Main menu** &gt; **CLI** and copy your API token.

2. Run the command below, where `<URL>` is the URL to your StackState instance and `<API-TOKEN>` is the API token you copied from the CLI page in the StackState UI:
   ```bash
   sts context save --name <NAME> --url <URL> --api-token <API-TOKEN>
   ```

3. The connection to your StackState instance will be tested and a configuration file stored at `~/.config/stackstate-cli/config.yaml`.

#### Docker

The Docker version of the CLI can't be configured with a config file. Specify the configuration of your StackState instance using environment variables and pass these to Docker:

* `STS_CLI_URL` - the URL to your StackState instance.
* `STS_CLI_API_TOKEN` - the API token taken from the StackState UI **Main menu** &gt; **CLI** page.

For example:
```
docker run \
   -e STS_CLI_URL \
   -e STS_CLI_API_TOKEN \
   stackstate/stackstate-cli2 settings list --type Layer
```

### Authentication

#### API token

By default, the CLI will authenticate using the API token that you provided when the CLI configuration was saved.

#### Service tokens

You can optionally use the CLI to create one or more service tokens to authenticate with the StackState Base and Admin APIs. For example, a service token can be used to authenticate in CI (Continuous Integration) scenarios where no real user is doing the operations on the StackState instance.

To create a service token, run the command below:

```bash
sts service-token create --name <NAME> --roles <ROLE(s)> [--expiration <yyyy-MM-dd>]
```

This will create a new service token and print it. The `--expiration` parameter is optional and can be used to set the expiration date of the service token.

Once you have this, you can configure the CLI to use it:

```bash
sts context save --name <NAME> --service-token <TOKEN> --url <URL>
```

### Manage multiple contexts

The new `sts` CLI supports configuration and management of different (authentication) contexts. This enables you to easily switch between an administrative and regular user, or to switch between different StackState instances. For example, you could use a different context for a test and production instance of StackState. You can list, save, delete, set and validate contexts in the new `sts` CLI. Run `sts context -h` for details of the available commands and their usage.

### Configuration options

You don't need a configuration file to run the new `sts` CLI. You can also configure the CLI through a combination of environment variables and flags.

If multiple types of configuration are presented to the CLI the order of processing will be:

1. Flags
2. Environment variables
3. Config file

| Environment variable    | Flag | Description                                                                                                                                                                                                                                     |
|:------------------------|:--- |:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `STS_CLI_URL`           | `--url` | URL to your StackState instance.                                                                                                                                                                                                               |
| `STS_CLI_API_TOKEN`     | `--api-token` | API token to your StackState instance. The most secure way to use your API token is through an environment variable. You can store the API token with a secrets manager and inject it as an environment variable into your shell.              |
| `STS_CLI_SERVICE_TOKEN` | `--service-token` | A service token to your StackState instance. The most secure way to use your service token is through an environment variable. You can store the service token with a secrets manager and inject it as an environment variable into your shell. |
| `STS_CLI_API_PATH`      | n/a | The path appended to the end of the URL to get the API endpoint. (Defaults to `/api`)                                                                                                                                                           |
| `STS_CLI_CONTEXT` | `--context` | The name of the context to use.                                                                                                                                                                                                                |

Next to overriding specific parts of the config file, it's also possible to override the default config file location. This is done through the `--config <PATH>` flag.

## Upgrade

To upgrade to the latest version of the new `sts` CLI, [run the install command again](#install-the-new-sts-cli).

You can check the version of the `sts` CLI that you are currently running with the command `sts version`.

## Uninstall

Follow the instructions below to uninstall the StackState CLI.

{% tabs %}
{% tab title="Windows" %}

{% tabs %}
{% tab title="Uninstaller" %}
Open a **Powershell** terminal and run:

```powershell
. { iwr -useb https://dl.stackstate.com/stackstate-cli/install.ps1 } | iex; uninstall
```

The new `sts` CLI and all associated configuration are now removed for the current user.
{% endtab %}

{% tab title="Manual" %}
Open a **Powershell** terminal and run each step one-by-one or all at once. The new `sts` CLI and all associated configuration will be removed for the current user.

1. Remove binary:
   ```powershell
   $CLI_PATH = $env:USERPROFILE+"\stackstate-cli"
   rm -R $CLI_PATH 2>1  > $null
   ```

2. Remove config:
   ```powershell
   rm -R $env:USERPROFILE+"\.config\stackstate-cli" 2>1  > $null
   ```

3. Remove the CLI from the environment path:
   ```
   $PATH = (Get-ItemProperty -Path ‘Registry::HKEY_CURRENT_USER\Environment’ -Name PATH).Path
   $i = $PATH.IndexOf(";$CLI_PATH")
   if ($i -ne -1) {
     $PATH = $PATH.Remove($i, $CLI_PATH.Length+1)
     (Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Environment' -Name PATH –Value $PATH)
   }
   ```

{% endtab %}
{% endtabs %}

{% endtab %}
{% tab title="macOS" %}

{% tabs %}
{% tab title="Uninstaller" %}
Open a terminal and run:

```bash
curl -o- https://dl.stackstate.com/stackstate-cli/uninstall.sh | bash
```

The new `sts` CLI and all associated configuration are now removed for the current user.
{% endtab %}

{% tab title="Manual" %}
To manually uninstall the new `sts` CLI, follow the steps below.

1. Open a terminal.
2. To remove the new `sts` CLI, run the command:
   ```bash
   rm -r /usr/local/bin/sts
   ```

3. To remove configuration for the new `sts` CLI, run the command:
   ```bash
   rm -r ~/.config/stackstate-cli
   ```

The new `sts` CLI and all associated configuration are now removed for the current user.
{% endtab %}
{% endtabs %}

{% endtab %}
{% tab title="Linux" %}

{% tabs %}
{% tab title="Uninstaller" %}
Open a terminal and run:

```bash
curl -o- https://dl.stackstate.com/stackstate-cli/uninstall.sh | bash
```

The new `sts` CLI and all associated configuration are now removed for the current user.
{% endtab %}

{% tab title="Manual" %}
To manually uninstall the new `sts` CLI, follow the steps below.

1. Open a terminal.
2. To remove the new `sts` CLI, run the command:
   ```bash
   rm -r /usr/local/bin/sts
   ```

3. To remove configuration for the new `sts` CLI, run the command:
   ```bash
   rm -r ~/.config/stackstate-cli
   ```

The new `sts` CLI and all associated configuration are now removed for the current user.
{% endtab %}
{% endtabs %}

{% endtab %}
{% tab title="Docker" %}

To remove the CLI image and containers run:

```bash
docker rmi -f stackstate/stackstate-cli2
```

{% endtab %}
{% endtabs %}

## Open source

The StackState `sts` CLI is open source and can be found on GitHub at:

* [https://github.com/stackvista/stackstate-cli](https://github.com/stackvista/stackstate-cli)
