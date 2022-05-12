---
description: StackState Self-hosted v4.6.x
---

# CLI: sts (new)

## Overview

The StackState CLI provides easy access to the functionality provided by the StackState APIs. It can be used for automate using StackState data, configure StackState and to develop StackPacks. 

This page describes the new `sts` CLI. The CLI will eventually fully replace the current `stac` CLI, but currently does not yet support all commands. For an overview of the differences and overlap between the new `sts` CLI and the old `stac` CLI, see this [comparison page](setup/cli/cli-comparison.md).

## Install

{% tabs %}
{% tab title="Windows" %}
{% hint style="info" %}
**Prerequisites**

For these installation instruction to work, you need Windows 10 build 1803 or need to manually install `curl` and `tar`. 
{% endhint %}

Open a **Powershell** terminal and execute the steps below. This can be done one step at a time, or all together as a single script.

```powershell
# Step 1 - Set the source version and target path.
$CLI_PATH = $env:USERPROFILE +"\stackstate-cli"
$VERSION=curl.exe https://dl.stackstate.com/stackstate-cli/LATEST_VERSION
$CLI_DL = "https://dl.stackstate.com/stackstate-cli/v$VERSION/stackstate-cli-full-$VERSION.windows-x86_64.zip"
echo "Installing StackState CLI v$VERSION to: $CLI_PATH"

# Step 2 - Download and unpack the CLI to the target CLI path.
If (!(test-path $CLI_PATH)) { md $CLI_PATH }
curl.exe -fLo $CLI_PATH\stackstate-cli.zip $CLI_DL
tar.exe -xf "$CLI_PATH\stackstate-cli.zip" -C $CLI_PATH
rm $CLI_PATH\stackstate-cli.zip

# Step 3 - Register the CLI path to the current user's PATH. This will make the `sts` command available everywhere.
$PATH = (Get-ItemProperty -Path ‘Registry::HKEY_CURRENT_USER\Environment’ -Name PATH).Path
if ( $PATH -notlike "*$CLI_PATH*" ) { 
  $PATH = "$PATH;$CLI_PATH"
  (Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Environment' -Name PATH –Value $PATH) 
  $MACHINE_PATH = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
  $env:Path = "$PATH;$MACHINE_PATH"
}

# Step 4 - Verify that the CLI works.
  try {  
    sts version >$null 2>&1
    if ($LastExitCode -eq 0) { echo "StackState CLI installed succesfully! Type 'sts' to get started." } else { "Error: StackState CLI error code $LastExitCode." }
} Catch { "Error: could not find 'sts' on the path." }
```

After installation, the `sts` command will be available for the current user on both the Powershell terminal and the command prompt (cmd.exe).

{% endtab %}
{% tab title="MacOS" %}

Open a terminal and execute the steps below. This can be done one step at a time, or all together as a single script.

```bash
# Step 1 - Download latest version for x86_64 (Intel) or arm64 (M1).
(VERSION=`curl https://dl.stackstate.com/stackstate-cli/LATEST_VERSION` && 
  ARCH=`uname -m` &&
  curl -fLo stackstate-cli.tar.gz https://dl.stackstate.com/stackstate-cli/v$VERSION/stackstate-cli-full-$VERSION.darwin-$ARCH.tar.gz)

# Step 2 - Move to /usr/local/bin and remove stack.
tar xzvf stackstate-cli.tar.gz --directory /usr/local/bin
rm stackstate-cli.tar.gz

# Step 3 - Verify installation success.
sts version
```

After installation the `sts` command is available for the current user.

{% endtab %}
{% tab title="Linux" %}

Open a terminal and execute the steps below. This can be done one step at a time, or all together as a single script.

```bash
# Step 1 - Download latest version for x86_64.
(VERSION=`curl https://dl.stackstate.com/stackstate-cli/LATEST_VERSION` && 
  curl -fLo stackstate-cli.tar.gz https://dl.stackstate.com/stackstate-cli/v$VERSION/stackstate-cli-full-$VERSION.linux-x86_64.tar.gz)

# Step 2 - Move to /usr/local/bin and remove stack.
tar xzvf stackstate-cli.tar.gz --directory /usr/local/bin
rm stackstate-cli.tar.gz

# Step 3 - Verify installation success.
sts version
```

After installation the `sts` command is available for the current user.

{% endtab %}
{% endtabs %}

## Configure

{% hint style="warning" %}
The most secure way to use your API token is through an environment variable. You can store the API token with a secrets manager and inject it as an environment variable into your shell.
{% endhint %}

### Quick start

Get your API token from the CLI page then run:

```bash
sts cli save-config --url URL --api-token API-TOKEN 
```

A config file will be stored at `~/.config/stackstate-cli/config.yaml`.

### Configuration options

You do not need a configuration file to run the `sts` CLI. You can configure the CLI through (a combination of) environment variables and flags.

If multiple types of configuration are presented to the CLI the order of processing will be: flags first, environment variables second and config file third.

| Name | Flag |  Description |
| :--- |:--- | :--- |
| `STS_CLI_URL` | `--url` | URL to your StackState instance. |
| `STS_CLI_API_TOKEN` | `--api-token` | API token to your StackState instance. |
| `STS_CLI_API_PATH` | n/a | The path appended to the end of the URL to get the API endpoint. (Defaults to `/api`)|

## Uninstall

{% tabs %}
{% tab title="Windows" %}

Open a **Powershell** terminal and execute each step one-by-one or all at once.

```powershell
  # Step 1 - remove binary
  $CLI_PATH = $env:USERPROFILE+"\stackstate-cli"
  rm -R $CLI_PATH 2>1  > $null

  # Step 2 - remove config
  rm -R $env:USERPROFILE+"\.config\stackstate-cli" 2>1  > $null

  # Step 3 - remove the CLI from the environment path
  $PATH = (Get-ItemProperty -Path ‘Registry::HKEY_CURRENT_USER\Environment’ -Name PATH).Path
  $i = $PATH.IndexOf(";$CLI_PATH")
  if ($i -ne -1) {
    $PATH = $PATH.Remove($i, $CLI_PATH.Length+1)
    (Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Environment' -Name PATH –Value $PATH) 
  }
```

The `sts` CLI and all associated configuration are now removed for the current user.

{% endtab %}
{% tab title="MacOS" %}

Open a terminal and execute:

```bash
rm -r /usr/local/bin/sts ~/.config/stackstate-cli
```

The `sts` CLI and all associated configuration are now removed for the current user.

{% endtab %}
{% tab title="Linux" %}

Open a terminal and execute:

```bash
rm -r /usr/local/bin/sts ~/.config/stackstate-cli
```

The `sts` CLI and all associated configuration are now removed for the current user.

{% endtab %}
{% endtabs %}
