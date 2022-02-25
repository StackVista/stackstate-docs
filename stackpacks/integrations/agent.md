---
description: StackState core integration
---

# StackState Agent

{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

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

StackState Agent is tested to run on the platforms listed below. Note that for Linux platforms, host data for network connections between processes and containers (including network traffic telemetry) can only be retrieved for OS versions with a network tracer (kernel version 4.3.0 or higher):

| Platform | Minimum version | Notes |
|:---|:---|:---|
| CentOS | CentOS 6 | CentOS 6 requires Agent v2.0.2 or above. Network tracer available from CentOS 8. |
| Debian | Debian 7 (Wheezy) | Debian 7 (Wheezy) requires glibc upgrade to 2.17. Network tracer available from Debian 9 (Stretch). |
| Fedora | Fedora 28 | - |
| RHEL | RHEL 7 | Network tracer available from RHEL 8. |
| Ubuntu | Ubuntu 14 (Trusty) | Network tracer available from Ubuntu 16 (Xenial). |
| Windows | Windows 10 | - |
| Windows Server | Windows Server 2012 | - |

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
    ./install.sh PATH_TO_PREDOWNLOADED_INSTALLER_PACKAGE
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

## Agent overhead

StackState Agent V2 consists of up to four different processes - `stackstate-agent`, `trace-agent`, `process-agent` and `cluster-agent`. To run the basic Agent, the resources named below are required. These were observed running StackState Agent V2 v2.13.0 on a c5.xlarge instance with 4 vCPU cores and 8GB RAM. They give an indication of the overhead for the most simple set up. Actual resource usage will increase based on the Agent configuration running. This can be impacted by factors such as the Agent processes that are enabled, the number and nature of checks running, whether network connection tracking and protocol inspection are enabled, and the number of Kubernetes pods from which metrics are collected on the same host as the Agent.

{% tabs %}

{% tab title="stackstate-agent" %}
| Resource | Usage |
|:---|:---|
| CPU | ~0.18% |
| Memory | 95-100MB RAM   |
| Disk space | 461MB (includes `stackstate-agent`, `process-agent` and `trace-agent`)  |
{% endtab %}

{% tab title="process-agent" %}
| Resource | Usage |
|:---|:---|
| CPU | up to 0.96% |
| Memory | 52-56MB |
| Disk space | 461MB (includes `stackstate-agent`, `process-agent` and `trace-agent`) |
{% endtab %}

{% tab title="trace-agent" %}
| Resource | Usage |
|:---|:---|
| CPU | less than 0.04% |
| Memory | less than 16.8MB  |
| Disk space | 461MB (includes `stackstate-agent`, `process-agent` and `trace-agent`) |
{% endtab %}

{% endtabs %}

On Kubernetes, limits are placed on CPU and memory usage of the Agent, Cluster Agent and Cluster checks. These can be configured in the [Agent Helm chart \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/cluster-agent).

## Release notes

**Agent V2 StackPack v4.3.1 \(2021-04-02\)**

* Features: Introduced swarm services as components and relations with containers.
* Features: Report desired replicas and active replicas for swarm services.
* Features: Health check added for swarm service on active replicas.
* Improvement: Enable auto grouping on generated views.
* Improvement: Common bumped from 2.3.1 to 2.5.0
* Improvement: StackState min version bumped to 4.3.0

**Agent V2 StackPack v4.2.1 \(2021-03-11\)**

* Bugfix: Fix for trace service types causing spurious updates on StackState.

**Agent V2 StackPack v4.2.0 \(2021-02-26\)**

* Features: Map the container restart event stream as metric stream.
* Features: Introduced the container health check for restart event.
* Features: Introduced Disk Metrics and Check on Host in Agent V2 StackPack.
* Features: Separate Sync and DataSource added for Disk Type.

**Agent V2 StackPack v4.1.0 \(2021-02-08\)**

* Improvement: Updated the "Agent Container Mapping Function" and "Agent Container Template" to map the container name instead of the container id to the identifier
* Bugfix: Fix the error stream for the traces not coming from traefik.

**Agent V2 StackPack v4.0.0 \(2021-01-29\)**

* Bugfix: Major bump the version for installation fix

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

