# StackState Agent

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the Agent StackPack?

The StackState Agent provides the following functionality:

* Reporting hosts, processes and containers
* Reporting all network connections between processes/containers including network traffic telemetry
* Telemetry for hosts, processes, and containers
* 100+ additional integrations

The StackState Agent is open source and available on github at [https://github.com/StackVista/stackstate-agent](https://github.com/StackVista/stackstate-agent).

## Supported configurations

The StackState Agent is supported on the following platforms:

| OS | Release | Arch | Network Tracer | Status | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Ubuntu | Trusty \(14\) | 64bit | - | OK | - |
| Ubuntu | Xenial \(16\) | 64bit | OK | OK | - |
| Ubuntu | Bionic \(18\) | 64bit | OK | OK | - |
| Debian | Wheezy \(7\) | 64bit | - | - | Needs glibc upgrade to 2.17 |
| Debian | Jessie \(8\) | 64bit | - | OK | - |
| Debian | Stretch \(9\) | 64bit | OK | OK | - |
| CentOS | 6 | 64bit | - | OK | Since version 2.0.2 |
| CentOS | 7 | 64bit | - | OK | - |
| RHEL | 7 | 64bit | - | OK | - |
| Fedora | 28 | 64bit | OK | OK | - |
| Windows | 2016 | 64bit | OK | OK | - |

## Installation

Install the StackState Agent with one of the following commands:

### Linux

Using [cURL](https://curl.haxx.se)

```text
curl -o- https://stackstate-agent-2.s3.amazonaws.com/install.sh | \
    STS_API_KEY="{{config.apiKey}}" \
    STS_URL="{{config.baseUrl}}/stsAgent" bash
```

Using [wget](https://www.gnu.org/software/wget/)

```text
wget -qO- https://stackstate-agent-2.s3.amazonaws.com/install.sh | \
    STS_API_KEY="{{config.apiKey}}" \
    STS_URL="{{config.baseUrl}}/stsAgent" bash
```

#### Linux offline installation

On your host, download the installation script from [https://stackstate-agent-2.s3.amazonaws.com/install.sh](https://stackstate-agent-2.s3.amazonaws.com/install.sh).

By default, installer tries to configure the package update channel, which would allow to update packages using the host package manager. If you for any reason do not want this behavior, please include `STS_INSTALL_NO_REPO=yes` as an environment parameter:

```text
STS_API_KEY="{{config.apiKey}}" \
    STS_URL="{{config.baseUrl}}/stsAgent" \
    STS_INSTALL_NO_REPO=yes \
    install.sh PATH_TO_PREDOWNLOADED_INSTALLER_PACKAGE
```

### Windows

Using [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-6)

```text
. { iwr -useb https://stackstate-agent-2.s3.amazonaws.com/install.ps1 } | iex; `
install -stsApiKey "{{config.apiKey}}" `
-stsUrl "{{config.baseUrl}}/stsAgent"
```

#### Windows offline installation

On your host, download a copy of the PowerShell script from [https://stackstate-agent-2.s3.amazonaws.com/install.ps1](https://stackstate-agent-2.s3.amazonaws.com/install.ps1) alongside with the agent installer in the form `.msi`. The latest version of the installer can be downloaded from [https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86\_64.msi](https://stackstate-agent-2.s3.amazonaws.com/windows/stable/stackstate-agent-latest-1-x86_64.msi).

Assuming your installer is saved as `C:\stackstate-custom.msi`, and the PowerShell script saved as `C:\install_script.ps1`, open PowerShell with elevated privileges and invoke the following set of commands:

```text
Import-Module C:\install_script.ps1
install -stsApiKey {{config.apiKey}} `
-stsUrl {{config.baseUrl}}/stsAgent `
-f C:\\stackstate-custom.msi
```

### Docker

#### Installation

To run the StackState Agent as a docker container, use the following configuration:

```text
stackstate-agent:
    image: docker.io/stackstate/stackstate-agent-2:latest
    network_mode: "host"
    pid: "host"
    privileged: true
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - "/proc/:/host/proc/:ro"
      - "/sys/fs/cgroup/:/host/sys/fs/cgroup:ro"
      - "/etc/passwd:/etc/passwd:ro"
      - "/sys/kernel/debug:/sys/kernel/debug"
    environment:
      STS_API_KEY: "API_KEY"
      STS_STS_URL: "https://your.stackstate.url/receiver/stsAgent"
      STS_PROCESS_AGENT_URL: "https://your.stackstate.url/receiver/stsAgent"
      STS_PROCESS_AGENT_ENABLED: "true"
      STS_NETWORK_TRACING_ENABLED: "true"
      STS_APM_URL: "https://your.stackstate.url/receiver/stsAgent"
      STS_APM_ENABLED: "true"
      HOST_PROC: "/host/proc"
      HOST_SYS: "/host/sys"
```

#### Using Docker-Swarm mode

To run the StackState Agent in Docker-Swarm mode as a docker-compose setup, use the above configuration in your compose file on each node where you want to run the Agent. After placing the compose file on each node, run the command `docker-compose up -d`.

**Limitation of Docker-Swarm mode**

Some specific features are not supported in Docker-Swarm mode. This limitation prevents StackState Agent from collecting relations between Containers, Processes and other resources while in Docker-Swarm mode. To run StackState Agent in Docker-Swarm mode, use a docker-compose setup.

#### Using Self-Signed Certificate

When checks are being configured to use a self-signed certificate for https requests, then the following environment variable should be overwritten:

```text
  CURL_CA_BUNDLE = ""
```

#### Advanced Configurations

Process reported by the StackState Agent can be filtered using a blacklist. Using it in conjunction with the inclusion rules will include otherwise excluded processes.

| Parameter | Mandatory | Default Value | Description |
| :--- | :--- | :--- | :--- |
| STS\_PROCESS\_BLACKLIST\_PATTERNS | No | [See  Github](https://github.com/StackVista/stackstate-process-agent/blob/master/config/config_nix.go) | A list of regex patterns that will exclude a process if matched |
| STS\_PROCESS\_BLACKLIST\_INCLUSIONS\_TOP\_CPU | No | 0 | Number of processes to report that have a high CPU usage |
| STS\_PROCESS\_BLACKLIST\_INCLUSIONS\_TOP\_IO\_READ | No | 0 | Number of processes to report that have a high IO read usage |
| STS\_PROCESS\_BLACKLIST\_INCLUSIONS\_TOP\_IO\_WRITE | No | 0 | Number of processes to report that have a high IO write usage |
| STS\_PROCESS\_BLACKLIST\_INCLUSIONS\_TOP\_MEM | No | 0 | Number of processes to report that have a high Memory usage |
| STS\_PROCESS\_BLACKLIST\_INCLUSIONS\_CPU\_THRESHOLD | No |  | Threshold that enables the reporting of high CPU usage processes |
| STS\_PROCESS\_BLACKLIST\_INCLUSIONS\_MEM\_THRESHOLD | No |  | Threshold that enables the reporting of high Memory usage processes |

Certain features of the agent can be turned off if not needed:

| Parameter | Mandatory | Default Value | Description |
| :--- | :--- | :--- | :--- |
| STS\_PROCESS\_AGENT\_ENABLED | No | True | Whenever process agent should be enabled |
| STS\_APM\_ENABLED | No | True | Whenever trace agent should be enabled |
| STS\_NETWORK\_TRACING\_ENABLED | No | True | Whenever network tracer should be enabled |

#### Troubleshooting

To troubleshoot the StackState Agent container, set the logging level to `debug` using the `STS_LOG_LEVEL` environment variable:

```text
STS_LOG_LEVEL: "DEBUG"
```

## Configuration files

{% tabs %}
{% tab title="Linux" %}
* StackState Agent configuration: `/etc/stackstate-agent/stackstate.yaml`
* Integration configurations: `/etc/stackstate-agent/conf.d/`
{% endtab %}

{% tab title="Windows" %}
* StackState Agent configuration: `C:\ProgramData\StackState\stackstate.yaml`
* Integration configurations:`C:\ProgramData\StackState\conf.d`
{% endtab %}
{% endtabs %}

## Troubleshooting

Try running the [status](agent.md#status-and-information) command to see the state of the StackState Agent.

### Log files

{% tabs %}
{% tab title="Linux" %}
Logs for the subsystems are in the following files:

```text
/var/log/stackstate-agent/agent.log
/var/log/stackstate-agent/process-agent.log
```
{% endtab %}

{% tab title="Windows" %}
Logs for the subsystems are in the following files:

```text
C:\ProgramData\StackState\logs\agent.log
C:\ProgramData\StackState\logs\process-agent.log
```
{% endtab %}
{% endtabs %}

## Start / stop / restart the StackState Agent

{% hint style="info" %}
* Commands require elevated privileges.
* Restarting the StackState Agent will reload the configuration files.
{% endhint %}

To manually start, stop or restart the StackState Agent:

{% tabs %}
{% tab title="Linux" %}
```text
sudo service stackstate-agent start
sudo service stackstate-agent stop
sudo service stackstate-agent restart
```
{% endtab %}

{% tab title="Windows" %}
**CMD**

```text
"C:\Program Files\StackState\StackState Agent\embedded\agent.exe" start-service
"C:\Program Files\StackState\StackState Agent\embedded\agent.exe" stopservice
"C:\Program Files\StackState\StackState Agent\embedded\agent.exe" restart-service
```

**PowerShell**

```text
& "C:\Program Files\StackState\StackState Agent\embedded\agent.exe" start-service
& "C:\Program Files\StackState\StackState Agent\embedded\agent.exe" stopservice
& "C:\Program Files\StackState\StackState Agent\embedded\agent.exe" restart-service
```
{% endtab %}
{% endtabs %}

## Status and information

{% tabs %}
{% tab title="Linux" %}
To check if the StackState Agent is running and receive information about the Agent's state:

```text
sudo service stackstate-agent status
```

Tracebacks for errors can be retrieved by setting the `-v` flag:

```text
sudo service stackstate-agent status -v
```
{% endtab %}

{% tab title="Windows" %}
To check if the StackState Agent is running and receive information about the Agent's state:

```text
"./agent.exe status"
```
{% endtab %}
{% endtabs %}

## Release notes

**Agent V2 StackPack v3.12.0 \(2020-12-15\)**

* Feature: Split error types in traces into:
  * 5xx errors - Use this in check function to determine critical status in the component.
  * 4xx errors.

**Agent V2 StackPack v3.11.0 \(2020-09-03\)**

* Feature: Added the Agent Integration synchronization, mapping functions and templates to synchronize topology and telemetry coming from custom Agent Integrations.
* Feature: Added the "Create your own" integration StackPack page that explains how to build a custom integration in the StackState Agent.
* Feature: Introduced monitoring of all StackState Agent Integrations in the Agent - Integrations - All View.

**Agent V2 StackPack v3.10.1 \(2020-08-18\)**

* Feature: Introduced the Release notes pop up for customer.
* Feature: Introduced the Docker-Swarm mode setup docs in Docker integration.

**Agent V2 StackPack v3.10.0 \(2020-08-04\)**

* Improvement: Deprecated stackpack specific layers and introduced a new common layer structure.

**Agent V2 StackPack v3.9.0 \(2020-07-22\)**

* Feature: Add metrics to trace call relations
* Improvement: Remove Openshift integration from StackState Agent V2
* Improvement: Improve Docker integration in StackState Agent V2.

**Agent V2 StackPack v3.8.1 \(2020-06-22\)**

* Bugfix: Fixed StackPack upgrade problem when there are Components in Host Layer.

**Agent V2 StackPack v3.8.0 \(2020-06-19\)**

* Improvement: Set the stream priorities on all streams.

**Agent V2 StackPack v3.7.1 \(2020-06-03\)**

* Bugfix: Remove duplicate streams.

**Agent V2 StackPack v3.7.0 \(2020-05-27\)**

* Improvement: Fix component template to use `Service-Instance` and `Service` icon.

**Agent V2 StackPack v3.6.0 \(2020-05-26\)**

* Improvement: Switched to use of Host layer from Common StackPack.
* Improvement: Added icon for `Service-Instance` component type.

**Agent V2 StackPack v3.5.0 \(2020-05-14\)**

* Improvement: Added priorities to metrics streams.
* Bugfix: Fixed service name extraction from tags for service names that contains a ":".

**Agent V2 StackPack v3.4.0 \(2020-04-28\)**

* Improvement: Updated Trace Service and Service Instance templates to support domain traces.

