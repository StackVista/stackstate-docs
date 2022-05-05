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

Open a **Powershell** terminal and execute each step one-by-one or all at once.

```powershell
# Step 1 - set the source version and target path 
$CLI_PATH = $env:USERPROFILE +"\stackstate-cli"
$VERSION=curl.exe https://dl.stackstate.com/stackstate-cli/LATEST_VERSION
$CLI_DL = "https://dl.stackstate.com/stackstate-cli/v$VERSION/stackstate-cli-full-$VERSION.windows-x86_64.zip"
echo "Installing StackState CLI v$VERSION to: $CLI_PATH"

# Step 2 - Download and unpack the CLI to the target CLI path
If (!(test-path $CLI_PATH)) { md $CLI_PATH }
curl.exe -fLo $CLI_PATH\stackstate-cli.zip $CLI_DL
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

After installation the `sts` command is available on both the Powershell terminal as well as the command prompt (cmd.exe) for the current user.

{% endtab %}
{% tab title="Mac Os" %}

{% tabs %}
{% tab title="Manual" %}

Open a terminal and execute each step one-by-one or all at once.

```bash
# Step 1 - Download latest version for x86_64 (Intel) or arm64 (M1)
(VERSION=`curl https://dl.stackstate.com/stackstate-cli/LATEST_VERSION` && 
  ARCH=`uname -m` &&
  curl -fLo stackstate-cli.tar.gz https://dl.stackstate.com/stackstate-cli/v$VERSION/stackstate-cli-full-$VERSION.darwin-$ARCH.tar.gz)

# Step 2 - Move to /usr/local/bin and remove stack
tar xzvf stackstate-cli.tar.gz --directory /usr/local/bin
rm stackstate-cli.tar.gz

# Step 3 - Verify installation success
sts version
```

After installation the `sts` command is available to the current user from any path location.

{% endtab %}
{% tab title="Homebrew" %}

{% hint style="warning" %}
This is currently still in beta and only available to StackState employees. You need to add the StackState brew tap in order for this to work:
```
brew tap stackvista/homebrew-tap https://gitlab.com/stackvista/homebrew-tap.git
```
{% endhint %}

Make sure you have [Homebrew](https://brew.sh/) installed. Then open a terminal and run:

```bash
brew install stackstate-cli
```

After installation the `sts` command is available to the current user from any path location.

{% endtab %}
{% endtabs %}


{% endtab %}
{% tab title="Linux" %}

Open a terminal and execute each step one-by-one or all at once.

```bash
# Step 1 - Download latest version for x86_64
(VERSION=`curl https://dl.stackstate.com/stackstate-cli/LATEST_VERSION` && 
  curl -fLo stackstate-cli.tar.gz https://dl.stackstate.com/stackstate-cli/v$VERSION/stackstate-cli-full-$VERSION.linux-x86_64.tar.gz)

# Step 2 - Move to /usr/local/bin and remove stack
tar xzvf stackstate-cli.tar.gz --directory /usr/local/bin
rm stackstate-cli.tar.gz

# Step 3 - Verify installation success
sts version
```

{% endtab %}
{% endtabs %}

## Configure the StackState CLI

Get your API token from the CLI page then run:

```bash
sts cli save-config --url URL --api-token API-TOKEN 
```

## Uninstalling 

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

The StackState CLI as well as its config are now removed for the current user.

{% endtab %}
{% tab title="Mac Os" %}

{% tabs %}
{% tab title="Manual" %}
Open a terminal and execute:

```bassh
rm -r /usr/local/bin/sts ~/.config/stackstate-cli
```

The StackState CLI as well as its config are now removed for the current user.

{% endtab %}
{% tab title="Homebrew" %}

{% hint style="warning" %}
This is currently still in beta and only available to StackState employees. You need to add the StackState brew tap in order for this to work:
```
brew tap stackvista/homebrew-tap https://gitlab.com/stackvista/homebrew-tap.git
```
{% endhint %}

Open a terminal and run:

```bash
brew uninstall stackstate-cli
```

The StackState CLI as well as its config are now removed for the current user.

{% endtab %}
{% endtabs %}

{% endtab %}
{% tab title="Linux" %}

Open a terminal and execute:

```bassh
rm -r /usr/local/bin/sts ~/.config/stackstate-cli
```

The StackState CLI as well as its config are now removed for the current user.

{% endtab %}
{% endtabs %}
