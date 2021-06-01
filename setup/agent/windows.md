# Windows

## Overview

The StackState Debian Agent provides the following functionality:
- Reporting hosts, processes and containers
- Reporting all network connections between processes / containers including network traffic telemetry
- Telemetry for hosts, processes and containers

## Setup

### Prerequisites

The StackState Agent is supported to run on Windows versions:

| OS | Release | Arch | Network Tracer| Status | Notes|
|----|---------|--------|--------|--------|--------|
| Windows | 2016 | 64bit | OK | OK | - |


### Install

The StackState Agent is installed using a [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-6) script.

* [online install](#online-install) - If you have access to the internet on the machine where the Agent will be installed, the `install.ps1` script can be run using `iwr` and the Agent installer package will be downloaded automatically. 
* [offline install](#offline-install) - If you do not have access to the internet, you will need to download both the install script and the Agent installer package before you install.

The `apiKey` and `baseUrl` specified when running the install script are set during StackState installation, for details see:

* [Kubernetes install - configuration parameters](/setup/installation/kubernetes_install/install_stackstate.md#generate-valuesyaml) 
* [Linux install - configuration parameters](/setup/installation/linux_install/install_stackstate.md#configuration-options-required-during-install) 

#### Online install



```text
. { iwr -useb https://stackstate-agent-2.s3.amazonaws.com/install.ps1 } | iex; `
install -stsApiKey "{{config.apiKey}}" `
-stsUrl "{{config.baseUrl}}/stsAgent"
```
#### Offline install

1. Download the PowerShell install script and copy this to the host where it will be installed:
   - [https://stackstate-agent-2.s3.amazonaws.com/install.ps1](https://stackstate-agent-2.s3.amazonaws.com/install.ps1)
2. Download the latest version of the Agent installer package and copy this to the host where it will be installed in the same location as the PowerShell install script:
   - [https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86\_64.msi](https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86_64.msi)
3. Assuming the installerscript is saved as `C:\stackstate-custom.msi` and the PowerShell script is saved as `C:\install_script.ps1`, open PowerShell with elevated privileges and invoke the following set of commands:
```text
Import-Module C:\install_script.ps1
install -stsApiKey {{config.apiKey}} `
-stsUrl {{config.baseUrl}}/stsAgent `
-f C:\\stackstate-custom.msi
```

### Configure

#### Configure the Agent

The StackState Agent configuration is located in the file `C:\ProgramData\StackState\stackstate.yaml`.

{% hint style="info" %}
[Restart the StackState Agent](#start-stop-or-restart-the-agent) to reload the configuration files and apply any changes.
{% endhint %}

#### Configure integrations

The Agent can be configured to run checks that integrate with external systems. Configuration for integrations run through the StackState Agent can be found in the directory `C:\ProgramData\StackState\conf.d`. Each integration has its own configuration file that is used by the enabled Agent checks. 

Documentation for the available StackState integrations, including configuration details can be found on the [StackPacks > Integrations pages](/stackpacks/integrations/).

{% hint style="info" %}
[Restart the StackState Agent](#start-stop-or-restart-the-agent) to reload the configuration files and apply any changes.
{% endhint %}

### Upgrade


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


Need help? Please contact [StackState support](https://support.stackstate.com/hc/en-us).
