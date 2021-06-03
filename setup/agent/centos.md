# CentOS

## Overview

The StackState Agent can be installed on CentOS. When installed and running, StackState Agent will synchronize the following data with StackState from the host it is running on:

- Hosts, processes and containers.
- Telemetry for hosts, processes and containers   
- For OS versions with a Network Tracer: Network connections between processes and containers including network traffic telemetry.

The Agent can also be configured to run checks that [integrate StackState with external systems](/stackpacks/integrations/). 

Data from the Agent is pushed to StackState via the [StackState Agent StackPack](/stackpacks/integrations/agent.md).

## Setup 

### Prerequisites

StackState Agent is supported to run on Cent OS versions:

| OS | Release | Arch | Network Tracer | Notes|
|----|---------|--------|--------|--------|--------|
| CentOS | 6 | 64bit | - | Since version 2.0.2 |
| CentOS | 7 | 64bit | - | - |

### Install

The StackState Agent is installed using an install script. 

* [online install](#online-install) - If you have access to the internet on the machine where the Agent will be installed, the install.sh script can be run using curl or wget and the Agent installer package will be downloaded automatically. 
* [offline install](#offline-install) - If you do not have access to the internet, you will need to download both the install script and the Agent installer package before you install.

The `apiKey` and `baseUrl` specified when running the install script are set during StackState installation, for details see:

* [StackState Kubernetes install - configuration parameters](/setup/installation/kubernetes_install/install_stackstate.md#generate-values-yaml) 
* [StackState Linux install - configuration parameters](/setup/installation/linux_install/install_stackstate.md#configuration-options-required-during-install) 

#### Online install

If you have access to the internet on the machine where the Agent will be installed, use one of the commands below to run the install.sh script. The Agent installer package will be downloaded automatically. 

{% tabs %}
{% tab title="cURL" %}
```text
curl -o- https://stackstate-agent-2.s3.amazonaws.com/install.sh | \
STS_API_KEY="{{config.apiKey}}" \
STS_URL="{{config.baseUrl}}/stsAgent" bash
```
{% endtab %}
{% tab title="wget" %}
```text
wget -qO- https://stackstate-agent-2.s3.amazonaws.com/install.sh | \
STS_API_KEY="{{config.apiKey}}" \
STS_URL="{{config.baseUrl}}/stsAgent" bash
```
{% endtab %}
{% endtabs %}

#### Offline install

If you do not have access to the internet, you will need to download both the install script and the Agent installer package before you install. You can then set the environment variable `STS_INSTALL_NO_REPO=yes` and run the install.sh script by specifying the path to the installer package.

1. Download the install script and copy this to the host where it will be installed:
   - [https://stackstate-agent-2.s3.amazonaws.com/install.sh](https://stackstate-agent-2.s3.amazonaws.com/install.sh)
2. Download the latest Agent installer package (`*_amd64.deb`) and copy this to the host where it will be installed:
   - List of available installers: [https://stackstate-agent-2.s3.amazonaws.com/](https://stackstate-agent-2.s3.amazonaws.com/)
   - Link to download: `https://stackstate-agent-2.s3.amazonaws.com/\<Key\>`. For example, `https://stackstate-agent-2.s3.amazonaws.com/pool/stable/s/st/stackstate-agent_2.11.0-1_amd64.deb`
3. use the command below to set the required environment variables and run the installer script:
    ```text
    STS_API_KEY="{{config.apiKey}}" \
    STS_URL="{{config.baseUrl}}/stsAgent" \
    STS_INSTALL_NO_REPO=yes \
    ./install.sh <path_to_Agent_installer_package>
    ```

### Upgrade

To upgrade the StackState Agent on your system, stop the `stackstate-agent` service and upgrade using `yum` or `apt-get`.

{% tabs %}
{% tab title="yum" %}
```
sudo service stackstate-agent stop
sudo yum upgrade stackstate-agent
```
{% endtab %}
{% tab title="apt-get" %}
```
sudo systemctl stop stackstate-agent
sudo apt-get update && apt-get upgrade stackstate-agent
```
{% endtab %}
{% endtabs %}

## Configure

### Agent configuration

The StackState Agent configuration is located in the file `/etc/stackstate-agent/stackstate.yaml`. The `apiKey` and `baseUrl` specified during installation will be added here by the install script. No further configuration should be required, however, a number of advanced configuration options are available.

### Advanced Agent configuration 

#### Blacklist and inclusions

Processes reported by the StackState Agent can optionally be filtered using a blacklist. Using this in conjunction with inclusion rules will allow otherwise excluded processes to be included. 

The blacklist is specified as a list of regex patterns. Inclusions override the blacklist patterns, these are used to include processes that consume a lot of resources. Each inclusion type specifies an amount of processes to report as the top resource using processes. For `top_cpu` and `top_mem` a threshold must first be met, meaning that a process needs to consume a higher percentage of resources than the specified threshold before it is reported.

To specify a blacklist and/or inclusions, edit the below settings in the Agent configuration file `/etc/stackstate-agent/stackstate.yaml` and [restart the StackState Agent](#start-stop-or-restart-the-agent).

| Configuration item | Description |
|:---|:---|
| `process_blacklist.patterns` |A list of regex patterns that will exclude a process if matched. [Default patterns \(github.com\)](https://github.com/StackVista/stackstate-process-agent/blob/master/config/config_nix.go).  |
| `process_blacklist.inclusions.cpu_pct_usage_threshold` | Threshold that enables the reporting of high CPU usage processes. |
| `process_blacklist.inclusions.amount_top_cpu_pct_usage` | The number of processes to report that have a high CPU usage. Default `0`. |
| `process_blacklist.inclusions.amount_top_io_read_usage` | The number of processes to report that have a high IO read usage. Default `0`. |
| `process_blacklist.inclusions.amount_top_io_write_usage` | The number of processes to report that have a high IO write usage. Default `0`. |
| `process_blacklist.inclusions.mem_usage_threshold` | Threshold that enables the reporting of high Memory usage processes. |
| `process_blacklist.inclusions.amount_top_mem_usage` | The number of processes to report that have a high memory usage. Default `0`. |

#### Disable Agent features

Certain features of the Agent can optionally be turned off if they are not needed. To disable a feature, edit the below settings in the Agent configuration file `/etc/stackstate-agent/stackstate.yaml` and [restart the StackState Agent](#start-stop-or-restart-the-agent).

| Configuration item | Description |
|:---|:---|
|`process_config.enabled` | Default `true` (collects containers and processes). Set to `false` to collect only containers, or `disabled` to disable the process Agent.|
| `apm_config.enabled` | Default `true`. Set to `"false"` to disable the APM Agent. |
| `network_tracer_config.network_tracing_enabled` | Default `true`. Set to `false` to disable the network tracer. |
   
- **process_config.enabled** - Default `true` (collects containers and processes). Set to `false` to collect only containers, or `disabled` to disable the process Agent.
- **apm_config.enabled** - Default `true`. Set to `false` to disable the APM Agent.
- **network_tracer_config.network_tracing_enabled** - Default `true`. Set to `false` to disable the network tracer.
   
### Integration configuration

The Agent can be configured to run checks that integrate with external systems. Configuration files for integrations run through the StackState Agent can be found in the directory `/etc/stackstate-agent/conf.d/`. Each integration has its own configuration file that is used by the associated Agent check. 

Documentation for the available StackState integrations, including configuration details can be found on the [StackPacks > Integrations pages](/stackpacks/integrations/).


## Commands

{% hint style="info" %}
* Commands require elevated privileges.
* [Restart the StackState Agent](#start-stop-or-restart-the-agent) to reload the configuration files and apply any changes.
{% endhint %}

### Start, stop or restart the Agent

To manually start, stop or restart the StackState Agent:

```text
sudo service stackstate-agent start
sudo service stackstate-agent stop
sudo service stackstate-agent restart
```
### Status and information

To check if the StackState Agent is running and receive information about the Agent's state:

```text
sudo service stackstate-agent status
```

Tracebacks for errors can be retrieved by setting the `-v` flag:

```text
sudo service stackstate-agent status -v
```

## Log files

Logs for the subsystems are in the following files:

* `/var/log/stackstate-agent/agent.log`
* `/var/log/stackstate-agent/process-agent.log`

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

## Uninstall

To uninstall the StackState Agent from your system, stop the `stackstate-agent` service and remove using `yum` or `apt-get`.

{% tabs %}
{% tab title="yum" %}
```
sudo service stackstate-agent stop
sudo yum remove stackstate-agent
```
{% endtab %}
{% tab title="apt-get" %}
```
sudo systemctl stop stackstate-agent
sudo apt-get remove stackstate-agent
```
{% endtab %}
{% endtabs %}
## Open source

The StackState Agent is open source, code is available on github at [https://github.com/StackVista/stackstate-agent](https://github.com/StackVista/stackstate-agent).

## Release notes


## See also

* [StackState Agent StackPack](/stackpacks/integrations/agent.md)
* [StackState Agent \(github.com\)](https://github.com/StackVista/stackstate-agent)
* [cURL \(haxx.se\)](https://curl.haxx.se)
* [wget \(gnu.org\)](https://www.gnu.org/software/wget/)