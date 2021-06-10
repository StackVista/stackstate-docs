# Windows

## Overview

The StackState Agent can be installed on Windows systems . The Agent collects data from the host where it is running and can be configured to integrate with external systems. Retrieved data is pushed to StackState via the [StackState Agent StackPack](/stackpacks/integrations/agent.md). For details of the data retrieved and available integrations, see the [StackPack integration documentation](/stackpacks/integrations).

The StackState Agent is open source, code is available on GitHub at: [https://github.com/StackVista/stackstate-agent](https://github.com/StackVista/stackstate-agent).

## Setup

### Supported Windows versions

The StackState Agent is supported to run on the following Windows versions with 64bit architecture:

| OS | Release | Network Tracer| Notes|
|:---|:---|:---|:---|
| Windows | 2016 | ✅ |- |

### Install

The StackState Agent is installed using a [PowerShell \(docs.microsoft.com\)](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-6) script.

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

### Configure

#### Configure the Agent

The StackState Agent configuration is located in the file `C:\ProgramData\StackState\stackstate.yaml`. The `stsApiKey` and `stsUrl` specified during installation will be added here by the install script. No further configuration should be required.

#### Configure integrations

The Agent can be configured to run checks that integrate with external systems. Configuration files for integrations run through the StackState Agent can be found in the directory `C:\ProgramData\StackState\conf.d`. Each integration has its own configuration file that is used by the enabled Agent checks. 

Documentation for the available StackState integrations, including configuration details can be found on the [StackPacks > Integrations pages](/stackpacks/integrations/).

### Upgrade

To upgrade the StackState Agent running on Windows,

1. Download the latest version of the Agent installer package and copy this to the host where it will be installed next to the PowerShell install script:
   - [https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86\_64.msi](https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86_64.msi)
2. Double-click on the downloaded `*.msi` file.   

## Commands

{% hint style="info" %}
* Commands require elevated privileges.
* [Restart the StackState Agent](#start-stop-or-restart-the-agent) to reload the configuration files and apply any changes.
{% endhint %}

### Start, stop or restart the Agent

To manually start, stop or restart the StackState Agent:

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

To check if the StackState Agent is running and receive information about the Agent's status:

```text
"./agent.exe status"
```

## Log files

Logs for the subsystems are in the following files:

* `C:\ProgramData\StackState\logs\agent.log`
* `C:\ProgramData\StackState\logs\process-agent.log`

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

## Uninstall

To uninstall the StackState Agent running on Windows:

1. In the Windows task bar, search for **control panel**.
2. In the control panel, open **Add/remove programs**.
3. Follow the instructions to uninstall the StackState Agent.

## Open source

The StackState Agent is open source, code is available on GitHub at [https://github.com/StackVista/stackstate-agent](https://github.com/StackVista/stackstate-agent).

## Release notes

Release notes for the StackState Agent can be found on GitHub at: [https://github.com/StackVista/stackstate-agent/blob/master/stackstate-changelog.md](https://github.com/StackVista/stackstate-agent/blob/master/stackstate-changelog.md)

## See also

* [StackState Agent StackPack](/stackpacks/integrations/agent.md)
* [StackState Agent \(github.com\)](https://github.com/StackVista/stackstate-agent)
* [cURL \(haxx.se\)](https://curl.haxx.se)
* [wget \(gnu.org\)](https://www.gnu.org/software/wget/)