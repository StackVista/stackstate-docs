# Windows

## Overview

The StackState Debian Agent provides the following functionality:
- Reporting hosts, processes and containers
- Reporting all network connections between processes / containers including network traffic telemetry
- Telemetry for hosts, processes and containers

### Install

Using [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-6)

```text
. { iwr -useb https://stackstate-agent-2.s3.amazonaws.com/install.ps1 } | iex; `
install -stsApiKey "{{config.apiKey}}" `
-stsUrl "{{config.baseUrl}}/stsAgent"
```
#### Offline installation

On your host, download a copy of the PowerShell script from [https://stackstate-agent-2.s3.amazonaws.com/install.ps1](https://stackstate-agent-2.s3.amazonaws.com/install.ps1) alongside with the agent installer in the form `.msi`. The latest version of the installer can be downloaded from [https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86\_64.msi](https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86_64.msi).

Assuming your installer is saved as `C:\stackstate-custom.msi`, and the PowerShell script saved as `C:\install_script.ps1`, open PowerShell with elevated privileges and invoke the following set of commands:

```text
Import-Module C:\install_script.ps1
install -stsApiKey {{config.apiKey}} `
-stsUrl {{config.baseUrl}}/stsAgent `
-f C:\\stackstate-custom.msi
```

## Configure

The Agent can be configured to run checks that integrate with external systems. 

* StackState Agent configuration: `C:\ProgramData\StackState\stackstate.yaml`
* Integration configurations:`C:\ProgramData\StackState\conf.d`

## Commands

{% hint style="info" %}
* Commands require elevated privileges.
* Restarting the StackState Agent will reload the configuration files.
{% endhint %}

To check if the StackState Agent is running and receive information about the Agent's state:

```text
"./agent.exe status"
```
  
### CMD

To manually start, stop or restart the StackState Agent:

```text
"C:\Program Files\StackState\StackState Agent\embedded\agent.exe" start-service
"C:\Program Files\StackState\StackState Agent\embedded\agent.exe" stopservice
"C:\Program Files\StackState\StackState Agent\embedded\agent.exe" restart-service
```

### PowerShell

To manually start, stop or restart the StackState Agent:

```text
& "C:\Program Files\StackState\StackState Agent\embedded\agent.exe" start-service
& "C:\Program Files\StackState\StackState Agent\embedded\agent.exe" stopservice
& "C:\Program Files\StackState\StackState Agent\embedded\agent.exe" restart-service
```

## Log files

Logs for the subsystems are in the following files:

* `C:\ProgramData\StackState\logs\agent.log`
* `C:\ProgramData\StackState\logs\process-agent.log`

## Supported configurations

The StackState Agent is supported on the following platforms:

| OS | Release | Arch | Network Tracer| Status | Notes|
|----|---------|--------|--------|--------|--------|
| Windows | 2016 | 64bit | OK | OK | - |

Need help? Please contact [StackState support](https://support.stackstate.com/hc/en-us).
