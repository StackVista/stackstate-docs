---
description: StackState SaaS
---

# Windows

## Overview

{% hint style="info" %}
**StackState Agent V2**
{% endhint %}

StackState Agent V2 can be installed on Windows systems. The Agent collects data from the host where it's running and can be configured to integrate with external systems. Retrieved data is pushed to StackState, to work with this data the [StackState Agent V2 StackPack](../../stackpacks/integrations/agent.md) must be installed in your StackState instance. For details of the data retrieved and available integrations, see the [StackPack integration documentation](../../stackpacks/integrations/).

## Monitoring

StackState Agent V2 will synchronize the following data from the host it's running on with StackState:

* Hosts, processes and containers.
* Telemetry for hosts, processes and containers   
* Network connections between processes and containers, including network traffic telemetry.

## Setup

### Supported versions

StackState Agent V2.19.x is supported to run on:

* Windows 10 or higher
* Windows Server 2012 or higher

### Install

StackState Agent V2 is installed using a [PowerShell \(learn.microsoft.com\)](https://learn.microsoft.com/en-us/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-7.2&viewFallbackFrom=powershell-6) script.

* [Online install](windows.md#online-install) - If you have access to the internet on the machine where the Agent will be installed. 
* [Offline install](windows.md#offline-install) - If you **don't** have access to the internet on the machine where the Agent will be installed.

{% hint style="info" %}

* `<STACKSTATE_RECEIVER_API_KEY>` is set during StackState installation.
* `<STACKSTATE_RECEIVER_API_ADDRESS>` is specific to your installation of StackState. 

For details see [StackState Receiver API](/setup/agent/about-stackstate-agent.md#connect-to-stackstate).
{% endhint %}

#### Online install

If you have access to the internet on the machine where the Agent will be installed, the `install.ps1` script can be run using `iwr` and the Agent installer package will be downloaded automatically.

```text
. { iwr -useb https://stackstate-agent-2.s3.amazonaws.com/install.ps1 } | iex; `
install -stsApiKey "<STACKSTATE_RECEIVER_API_KEY>" `
-stsUrl "<STACKSTATE_RECEIVER_API_ADDRESS>"
```

#### Offline install

If you don't have access to the internet on the machine where the Agent will be installed, you will need to download both the install script and the Agent installer package before you install.

1. Download the PowerShell install script and copy this to the host where it will be installed:
   * [https://stackstate-agent-2.s3.amazonaws.com/install.ps1](https://stackstate-agent-2.s3.amazonaws.com/install.ps1)
2. Download the latest version of the Agent installer package and copy this to the host where it will be installed next to the PowerShell install script:
   * [https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86\_64.msi](https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86_64.msi)
3. Assuming the installer script is saved as `C:\stackstate-custom.msi` and the PowerShell script is saved as `C:\install_script.ps1`, open PowerShell with elevated privileges and invoke the following set of commands:

   ```text
   Import-Module C:\install_script.ps1
   install -stsApiKey <STACKSTATE_RECEIVER_API_KEY> `
   -stsUrl <STACKSTATE_RECEIVER_API_ADDRESS> `
   -f C:\\stackstate-custom.msi
   ```

### Upgrade

To upgrade StackState Agent V2 running on Windows,

1. Download the latest version of the Agent installer package and copy this to the host where it will be installed next to the PowerShell install script:
   * [https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86\_64.msi](https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86_64.msi)
2. Double-click the downloaded `*.msi` file.  

## Configure

### Agent configuration

The StackState Agent V2 configuration is located in the file `C:\ProgramData\StackState\stackstate.yaml`. The `stsApiKey` and `stsUrl` specified during installation will be added here by the install script. No further configuration should be required.

### Advanced Agent configuration

StackState Agent V2 can be configured to reduce data production, tune the process blacklist, or turn off specific features when not needed. The required settings are described in detail on the page [advanced Agent configuration](advanced-agent-configuration.md).

### Integration configuration

The Agent can be configured to run checks that integrate with external systems. Configuration files for integrations run through StackState Agent V2 can be found in the directory `C:\ProgramData\StackState\conf.d`. Each integration has its own configuration file that's used by the enabled Agent checks.

Documentation for the available StackState integrations, including configuration details can be found on the [StackPacks &gt; Integrations pages](../../stackpacks/integrations/).

### Proxy configuration

The Agent can be configured to use a proxy for HTTP and HTTPS requests. For details, see [use an HTTP/HTTPS proxy](/setup/agent/agent-proxy.md).

## Commands

{% hint style="info" %}
Commands require elevated privileges.
{% endhint %}

### Start, stop or restart the Agent

To manually start, stop or restart StackState Agent V2:

{% tabs %}
{% tab title="CMD" %}
```text
"C:\Program Files\StackState\StackState Agent\embedded\agent.exe" start-service
"C:\Program Files\StackState\StackState Agent\embedded\agent.exe" stopservice
"C:\Program Files\StackState\StackState Agent\embedded\agent.exe" restart-service
```
{% endtab %}

{% tab title="PowerShell" %}
```text
& "C:\Program Files\StackState\StackState Agent\embedded\agent.exe" start-service
& "C:\Program Files\StackState\StackState Agent\embedded\agent.exe" stopservice
& "C:\Program Files\StackState\StackState Agent\embedded\agent.exe" restart-service
```
{% endtab %}
{% endtabs %}

### Status

To check if StackState Agent V2 is running and receive information about the Agent's status:

```text
"./agent.exe status"
```

### Manually run a check

Use the command below to manually run an Agent check once and output the results.

```yaml
C:\Program Files\StackState\StackState Agent\embedded\agent.exe check <CHECK_NAME>
```

## Troubleshooting

To troubleshoot the Agent, try to [check the Agent status](windows.md#status) or [manually run a check](windows.md#manually-run-a-check).

### Log files

Logs for the Agent subsystems can be found in the following files:

* `C:\ProgramData\StackState\logs\agent.log`
* `C:\ProgramData\StackState\logs\process-agent.log`

### Debug mode

By default, the log level of the Agent is set to `INFO`. To assist in troubleshooting, the Agent log level can be set to `DEBUG`. This will enable verbose logging and all errors encountered will be reported in the Agent log files.

To set the log level to `DEBUG` for an Agent running on Windows:

1. Edit the file `C:\ProgramData\StackState\stackstate.yaml`
2. To set the log level to `DEBUG`, add the line:
    ```
    log_level: debug
    ```
3. To also include the topology/telemetry payloads sent to StackState in the Agent log, add the line:
    ```
    log_payloads: true
    ```
4. Save the file and [restart the Agent](#start-stop-or-restart-the-agent) for changes to be applied.


### Support knowledge base

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

## Uninstall

To uninstall StackState Agent V2 running on Windows:

1. In the Windows task bar, search for **control panel**.
2. In the control panel, open **Add/remove programs**.
3. Follow the instructions to uninstall StackState Agent V2.

## See also

* [About StackState Agent V2](about-stackstate-agent.md)
* [Advanced Agent configuration](advanced-agent-configuration.md)  
* [StackState Agent V2 StackPack](../../stackpacks/integrations/agent.md)
* [StackState Agent V2 \(github.com\)](https://github.com/StackVista/stackstate-agent)

