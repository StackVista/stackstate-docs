# Windows

## Overview

{% hint style="info" %}
**StackState Agent V2**
{% endhint %}

StackState Agent V2 can be installed on Windows systems . The Agent collects data from the host where it is running and can be configured to integrate with external systems. Retrieved data is pushed to StackState, to work with this data the [StackState Agent V2 StackPack](/stackpacks/integrations/agent.md) must be installed in your StackState instance. For details of the data retrieved and available integrations, see the [StackPack integration documentation](/stackpacks/integrations).

## Setup

### Supported versions

StackState Agent V2 is supported to run on:

* Windows 10 or higher
* Windows Server 2012 or higher

### Install

StackState Agent V2 is installed using a [PowerShell \(docs.microsoft.com\)](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-6) script.

* [Online install](#online-install) - If you have access to the internet on the machine where the Agent will be installed. 
* [Offline install](#offline-install) - If you **do not** have access to the internet on the machine where the Agent will be installed.

{% hint style="info" %}
The `stsApiKey` and `stsUrl` (baseUrl) specified when running the install script are set during StackState installation, for details see:

* [StackState Kubernetes install - configuration parameters](/setup/installation/kubernetes_install/install_stackstate.md#generate-values-yaml) 
* [StackState Linux install - configuration parameters](/setup/installation/linux_install/install_stackstate.md#configuration-options-required-during-install) 
{% endhint %}

#### Online install

If you have access to the internet on the machine where the Agent will be installed, the `install.ps1` script can be run using `iwr` and the Agent installer package will be downloaded automatically. 

```text
. { iwr -useb https://stackstate-agent-2.s3.amazonaws.com/install.ps1 } | iex; `
install -stsApiKey "{{config.apiKey}}" `
-stsUrl "{{config.baseUrl}}/stsAgent"
```
#### Offline install

If you do not have access to the internet on the machine where the Agent will be installed, you will need to download both the install script and the Agent installer package before you install.

1. Download the PowerShell install script and copy this to the host where it will be installed:
   - [https://stackstate-agent-2.s3.amazonaws.com/install.ps1](https://stackstate-agent-2.s3.amazonaws.com/install.ps1)
2. Download the latest version of the Agent installer package and copy this to the host where it will be installed next to the PowerShell install script:
   - [https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86\_64.msi](https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86_64.msi)
3. Assuming the installer script is saved as `C:\stackstate-custom.msi` and the PowerShell script is saved as `C:\install_script.ps1`, open PowerShell with elevated privileges and invoke the following set of commands:
```text
Import-Module C:\install_script.ps1
install -stsApiKey {{config.apiKey}} `
-stsUrl {{config.baseUrl}}/stsAgent `
-f C:\\stackstate-custom.msi
```

### Upgrade

To upgrade StackState Agent V2 running on Windows,

1. Download the latest version of the Agent installer package and copy this to the host where it will be installed next to the PowerShell install script:
   - [https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86\_64.msi](https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86_64.msi)
2. Double-click on the downloaded `*.msi` file.   

## Configure

### Agent configuration

The StackState Agent V2 configuration is located in the file `C:\ProgramData\StackState\stackstate.yaml`. The `stsApiKey` and `stsUrl` specified during installation will be added here by the install script. No further configuration should be required.

### Advanced Agent configuration

A number of advanced configuration options are available for StackState Agent V2. These can be set in the Agent configuration file `C:\ProgramData\StackState\stackstate.yaml` and are described in detail on the page [advanced Agent configuration](/setup/agent/advanced-agent-configuration.md).

### Integration configuration

The Agent can be configured to run checks that integrate with external systems. Configuration files for integrations run through StackState Agent V2 can be found in the directory `C:\ProgramData\StackState\conf.d`. Each integration has its own configuration file that is used by the enabled Agent checks. 

Documentation for the available StackState integrations, including configuration details can be found on the [StackPacks > Integrations pages](/stackpacks/integrations/).

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

To troubleshoot the Agent, try to [check the Agent status](#status) or [manually run a check](#manually-run-a-check).

### Log files

Logs for the subsystems are in the following files:

* `C:\ProgramData\StackState\logs\agent.log`
* `C:\ProgramData\StackState\logs\process-agent.log`

### Support knowledge base

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

## Uninstall

To uninstall StackState Agent V2 running on Windows:

1. In the Windows task bar, search for **control panel**.
2. In the control panel, open **Add/remove programs**.
3. Follow the instructions to uninstall StackState Agent V2.

## See also

* [About the StackState Agent](/setup/agent/about-stackstate-agent.md)
* [Advanced Agent configuration](/setup/agent/advanced-agent-configuration.md)  
* [StackState Agent V2 StackPack](/stackpacks/integrations/agent.md)
* [StackState Agent V2 \(github.com\)](https://github.com/StackVista/stackstate-agent)