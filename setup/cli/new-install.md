---
description: StackState Self-hosted v4.6.x
---

# StackState CLI v2

## Overview

The StackState CLI provides easy access to the functionality provided by the StackState APIs. It can be used to configure StackState, work with data, automate using StackState data and help with developing and configuring StackPacks. You can configure the CLI to work with multiple instances of StackState.

## Install

{% tabs %}
{% tab title="Windows" %}
{% hint style="info" %}
For these installation instruction to work, you need Windows 10 build 1803 or need to manually install `curl` and `tar`. 
{% endhint %}

Open a **Powershell** terminal and execute the following steps. You can execute them one by one or copy-paste this entire script to your terminal.

```powershell
  # Step 1 - set the target path to which to install the StackState CLI
  $CLI_PATH = $env:USERPROFILE +"\stackstate-cli"
  echo "Installing the StackState CLI to: $CLI_PATH"

  # Step 2 - Download and unpack the CLI to the target CLI path
  If (!(test-path $CLI_PATH)) { md $CLI_PATH }
  curl.exe -fLo $CLI_PATH\stackstate-cli.zip https://dl.stackstate.com/stackstate-cli/v0.1.1/stackstate-cli-full-0.1.1.windows-amd64.zip
  tar.exe -xf "$CLI_PATH\stackstate-cli.zip" -C $CLI_PATH
  rm $CLI_PATH\stackstate-cli.zip

  # Step 3 - Register the CLI path to the current user's PATH, so it will always be available everywhere
  $PATH = (Get-ItemProperty -Path ‘Registry::HKEY_CURRENT_USER\Environment’ -Name PATH).Path
  if ( $PATH -notlike "*$CLI_PATH*" ) { 
    $PATH = "$PATH;$CLI_PATH"
    (Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Environment' -Name PATH –Value $PATH) 
    $MACHINE_PATH = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
    $env:Path = "$PATH;$MACHINE_PATH"
  }

  # Step 4 - Verify that the CLI works
   try {  
     sts version >$null 2>&1
     if ($LastExitCode -eq 0) { echo "StackState CLI installed succesfully! Type 'sts' to get started." } else { "Error: StackState CLI error code $LastExitCode." }
  } Catch { "Error: could not find 'sts' on the path." }
```

After successful installation The `sts` command is  available on both Powershell as well as the traditional command terminal for this user.

{% endtab %}
{% tab title="Mac Os" %}

```bash
brew install stackstate-cli
```

{% endtab %}
{% tab title="Linux" %}

TODO

{% endtab %}
{% endtabs %}

## Configure the StackState CLI

Get your `API-KEY` and `API-URL` and then run

```bash
sts cli save-config --api-key API-KEY --api-URL API-URL
```

## Uninstalling 

{% tabs %}
{% tab title="Windows" %}

Open a **Powershell** terminal and execute the following steps. You can execute them one by one or copy-paste this entire script to your terminal.

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

{% endtab %}
{% tab title="Mac Os" %}

```bash
brew uninstall stackstate-cli
```

{% endtab %}
{% tab title="Linux" %}

TODO

{% endtab %}
{% endtabs %}
