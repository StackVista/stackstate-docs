---
description: StackState Self-hosted v4.6.x
---

# CLI: sts (new)

## Overview

The new StackState `sts` CLI provides easy access to the functionality provided by the StackState APIs. It can be used for automate using StackState data, configure StackState and to develop StackPacks.

The new `sts` CLI will eventually replace the [`stac` CLI](cli-stac.md), however, not all commands are currently supported. For an overview of the differences and overlap between the new and the old CLI, see the [CLI comparison page](/setup/cli/cli-comparison.md).

## Install

{% hint style="warning" %}
**The new `sts` CLI works with StackState version 5.0 and above.**

If you are running an older version of StackState, use the [`stac` CLI](cli-stac.md).
{% endhint %}

1. If it is installed, upgrade the old `sts` CLI to `stac`:
   * [Check if the old `sts` CLI is installed](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running).
   * [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade).
2. Follow the steps below to install the new `sts` CLI:

{% tabs %}
{% tab title="Windows" %}

{% tabs %}
{% tab title="Installer" %}

Open a **Powershell** terminal (version 5.1 or later), change the `<URL>` and `<API-TOKEN>` and run the command below. After installation, the `sts` command will be available for the current user on both the Powershell terminal and the command prompt (cmd.exe).

```powershell
. { iwr -useb https://dl.stackstate.com/stackstate-cli/install.ps1 } | iex; install -StsUrl "<URL>" -StsApiToken "<API-TOKEN>"
```

{% endtab %}
{% tab title="Manual install steps" %}

Open a **Powershell** terminal (version 5.1 or later) and run the steps below. This can be done one step at a time, or joined together as a single script. After installation, the `sts` command will be available for the current user on both the Powershell terminal and the command prompt (cmd.exe).

1. Set the source version and target path for the CLI:
    ```powershell
    $CLI_PATH = $env:USERPROFILE +"\stackstate-cli"
    If (!(test-path $CLI_PATH)) { md $CLI_PATH }
    Invoke-WebRequest https://dl.stackstate.com/stackstate-cli/LATEST_VERSION -OutFile $CLI_PATH\VERSION
    $VERSION=type $CLI_PATH\VERSION
    $CLI_DL = "https://dl.stackstate.com/stackstate-cli/v$VERSION/stackstate-cli-full-$VERSION.windows-x86_64.zip"
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

4. Verify that the CLI works:
    ```powershell
    sts version
    ```

{% endtab %}
{% endtabs %}

{% endtab %}
{% tab title="macOS" %}

{% tabs %}
{% tab title="Installer" %}
Open a terminal, change the `<URL>` and `<API-TOKEN>` and run the command below. After installation, the `sts` command will be available for the current user.

```bash
curl -o- https://dl.stackstate.com/stackstate-cli/install.sh | STS_URL="<URL>" STS_API_TOKEN="<API-TOKEN>" bash
```

{% endtab %}

{% tab title="Manual" %}
Open a terminal and run the steps below. This can be done one step at a time, or all together as a single script. After installation, the `sts` command will be available for the current user.

1. Download the latest version for x86_64 (Intel) or arm64 (M1).
   ```bash
   (VERSION=`curl https://dl.stackstate.com/stackstate-cli/LATEST_VERSION` &&
     ARCH=`uname -m` &&
     curl https://dl.stackstate.com/stackstate-cli/v$VERSION/stackstate-cli-full-$VERSION.darwin-$ARCH.tar.gz | tar xz --directory /usr/local/bin)
   ```

2. Verify that the CLI works:
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

{% endtab %}

{% tab title="Manual install steps" %}
Open a terminal and run the steps below. This can be done one step at a time, or all together as a single script. After installation, the `sts` command will be available for the current user.

1. Download and unpack the latest version for x86_64:
   ```bash
   (VERSION=`curl https://dl.stackstate.com/stackstate-cli/LATEST_VERSION` &&
   curl https://dl.stackstate.com/stackstate-cli/v$VERSION/stackstate-cli-full-$VERSION.linux-x86_64.tar.gz | tar xz --directory /usr/local/bin)
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

You can now run CLI commands by adding appending them to the end of the `docker run` command (e.g. `docker run stackstate/stackstate-cli2 version`).

{% endtab %}
{% endtabs %}

## Configure

### Quick start

{% hint style="warning" %}
The most secure way to use your API token is through an environment variable. You can store the API token with a secrets manager and inject it as an environment variable into your shell.
{% endhint %}

#### Linux, macOS and Windows

1. In the StackState UI, go to **Main menu** &gt; **CLI** and copy your API token.

2. Run the command below, where `<URL>` is the URL to your StackState instance and `<API-TOKEN>` is the API token you copied from the CLI page in the StackState UI:
   ```bash
   sts cli save-config --url <URL> --api-token <API-TOKEN>
   ```

3. The connection to your StackState instance will be tested and a configuration file stored at `~/.config/stackstate-cli/config.yaml`.

#### Docker

The Docker version of the CLI cannot be configured with a config file. Specify the configuration of your StackState instance using environment variables and pass these to Docker:

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

By default the CLI will use the API token you provided when you saved the configuration. You can also use the CLI to create one (more more) Service Token(s) to authenticate with the StackState API. The ServiceTokens can be used in for instance Continuous Integration scenarios where there is no real user doing the operations on the StackState instance.

To create a Service Token, run the command below:

```bash
sts service-token create --name <NAME> --roles <ROLE(s)> [--expiration <yyyy-MM-dd>]
```

This will create a new Service Token and print it. The `--expiration` parameter is optional and can be used to set the expiration date of the Service Token.

Once you have this, you can configure the CLI to use it:

```bash
sts context save --name <NAME> --service-token <TOKEN> --url <URL>
```

### Configuration options

You do not need a configuration file to run the `sts` CLI. You can configure the CLI through (a combination of) environment variables and flags.

If multiple types of configuration are presented to the CLI the order of processing will be: flags first, environment variables second and config file third.

| Name | Flag | Description                                                                           |
| :--- |:--- |:--------------------------------------------------------------------------------------|
| `STS_CLI_URL` | `--url` | URL to your StackState instance.                                                      |
| `STS_CLI_API_TOKEN` | `--api-token` | API token to your StackState instance. The most secure way to use your API token is through an environment variable. You can store the API token with a secrets manager and inject it as an environment variable into your shell.                                               |
| `STS_CLI_SERVICE_TOKEN` | `--service-token` | Service Token to your StackState instance. The most secure way to use your service token is through an environment variable. You can store the service token with a secrets manager and inject it as an environment variable into your shell.                                               |
| `STS_CLI_API_PATH` | n/a | The path appended to the end of the URL to get the API endpoint. (Defaults to `/api`) |

## Uninstall

{% tabs %}
{% tab title="Windows" %}

{% tabs %}
{% tab title="Uninstaller" %}
Open a **Powershell** terminal and run:

```powershell
. { iwr -useb https://dl.stackstate.com/stackstate-cli/install.ps1 } | iex; uninstall
```

The `sts` CLI and all associated configuration are now removed for the current user.
{% endtab %}

{% tab title="Manual" %}
Open a **Powershell** terminal and run each step one-by-one or all at once. The `sts` CLI and all associated configuration will be removed for the current user.

1. Remove binary:
   ```powershell
   $CLI_PATH = $env:USERPROFILE+"\stackstate-cli"
   rm -R $CLI_PATH 2>1  > $null
   ```

2.Remove config:
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

The `sts` CLI and all associated configuration are now removed for the current user.
{% endtab %}

{% tab title="Manual" %}
Open a terminal and run:

```bash
rm -r /usr/local/bin/sts ~/.config/stackstate-cli
```

The `sts` CLI and all associated configuration are now removed for the current user.
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

The `sts` CLI and all associated configuration are now removed for the current user.
{% endtab %}

{% tab title="Manual" %}
Open a terminal and run:

```bash
rm -r /usr/local/bin/sts ~/.config/stackstate-cli
```

The `sts` CLI and all associated configuration are now removed for the current user.
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

The StackState CLI is open source and can be found on Gitlab at: [https://gitlab.com/stackvista/stackstate-cli2](https://gitlab.com/stackvista/stackstate-cli2)
