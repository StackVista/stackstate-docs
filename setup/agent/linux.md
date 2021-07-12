# Linux

## Overview

{% hint style="info" %}
**StackState Agent V2**
{% endhint %}

StackState Agent V2 can be installed on Linux systems running CentOS, Debian, Fedora, RedHat or Ubuntu. The Agent collects data from the host where it is running and can be configured to integrate with external systems. Retrieved data is pushed to StackState, to work with this data the [StackState Agent V2 StackPack](/stackpacks/integrations/agent.md) must be installed in your StackState instance. For details of the data retrieved and available integrations, see the [StackPack integration documentation](/stackpacks/integrations).

## Setup 

### Supported Linux versions

StackState Agent is tested to run on the Linux versions listed below with 64bit architecture:

| OS | Release | Network Tracer | Notes |
|:---|:---|:---|:---|
| CentOS | 6 | - | Requires Agent v2.0.2 or above. |
| CentOS | 7 | - | - |
| Debian | Wheezy (7) | - | Needs glibc upgrade to 2.17. |
| Debian | Jessie (8) | - | - |
| Debian | Stretch (9) | ✅ | - |
| Fedora | 28 | ✅ | - |
| RHEL | 7 | - | - |
| Ubuntu | Trusty (14) | - | - |
| Ubuntu | Xenial (16) | ✅ | - |
| Ubuntu | Bionic (18) | ✅ | - |
| Ubuntu | Focal (20.04) | ✅ | - |

Host data for network connections between processes and containers (including network traffic telemetry) can only be retrieved for OS versions with a network tracer.

### Install

StackState Agent V2 is installed using an install script. 

* [Online install](#online-install) - If you have access to the internet on the machine where the Agent will be installed. 
* [Offline install](#offline-install) - If you **do not** have access to the internet on the machine where the Agent will be installed.

{% hint style="info" %}
The `apiKey` and `baseUrl` specified when running the install script are set during StackState installation, for details see:

* [StackState Kubernetes install - configuration parameters](/setup/installation/kubernetes_install/install_stackstate.md#generate-values-yaml) 
* [StackState Linux install - configuration parameters](/setup/installation/linux_install/install_stackstate.md#configuration-options-required-during-install) 
{% endhint %}
  
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

If you do not have access to the internet on the machine where the Agent will be installed, you will need to download both the install script and the Agent installer package before you install. You can then set the environment variable `STS_INSTALL_NO_REPO=yes` and specify the path to the downloaded installer package when you run the install.sh script.

1. Download the install script and copy this to the host where it will be installed:
   - [https://stackstate-agent-2.s3.amazonaws.com/install.sh](https://stackstate-agent-2.s3.amazonaws.com/install.sh)
2. Download the latest Agent installer package (DEB or RPM package) and copy this to the host where it will be installed. The download link can be constructed from the installer list URL and the installer package `Key`  that is provided on the installer list page.
   - **DEB installer list**: [https://stackstate-agent-2.s3.amazonaws.com/](https://stackstate-agent-2.s3.amazonaws.com/)
   - **RPM installer list**: [https://stackstate-agent-2-rpm.s3.amazonaws.com/](https://stackstate-agent-2-rpm.s3.amazonaws.com/)
   - **Download link**: `<installer_list_link><Key_from_installer_list>`
  For example, to download the DEB installer package for `agent_2.11.0-1_amd64.deb`, use:  `https://stackstate-agent-2.s3.amazonaws.com/pool/stable/s/st/stackstate-agent_2.11.0-1_amd64.deb`
3. Use the command below to set the required environment variables and run the installer script:
    ```text
    STS_API_KEY="{{config.apiKey}}" \
    STS_URL="{{config.baseUrl}}/stsAgent" \
    STS_INSTALL_NO_REPO=yes \
    ./install.sh <path_to_local_Agent_installer_package>
    ```

### Upgrade

To upgrade StackState Agent V2 on your system, stop the `stackstate-agent` service and upgrade using `yum` or `apt-get`. To upgrade offline, download the Agent installer package (DEB or RPM package) and copy this to the host where it will be installed - see step 2 in the [offline install instructions](#offline-install).

{% tabs %}
{% tab title="yum" %}
```
# stop the Agent with one of the below commands
sudo systemctl stop stackstate-agent
sudo service stackstate-agent stop

# online Agent upgrade
sudo yum upgrade stackstate-agent

# offline Agent upgrade
sudo yum upgrade <agent_installer_package>.rpm
```
{% endtab %}
{% tab title="apt-get" %}
```
# stop the Agent with one of the below commands
sudo systemctl stop stackstate-agent
sudo service stackstate-agent stop

# online Agent upgrade
sudo apt-get update && apt-get upgrade stackstate-agent

# offline Agent upgrade
sudo apt-get upgrade <agent_installer_package>.deb
```
{% endtab %}
{% endtabs %}

## Configure

### Agent configuration

The StackState Agent V2 configuration is located in the file `/etc/stackstate-agent/stackstate.yaml`. The `apiKey` and `baseUrl` specified during installation will be added here by the install script. No further configuration should be required, however, a number of advanced configuration options are available.

### Advanced Agent configuration 

#### Blacklist and inclusions

Processes reported by StackState Agent V2 can optionally be filtered using a blacklist. Using this in conjunction with inclusion rules will allow otherwise excluded processes to be included. 

The blacklist is specified as a list of regex patterns. Inclusions override the blacklist patterns, these are used to include processes that consume a lot of resources. Each inclusion type specifies an amount of processes to report as the top resource using processes. For `top_cpu` and `top_mem` a threshold must first be met, meaning that a process needs to consume a higher percentage of resources than the specified threshold before it is reported.

To specify a blacklist and/or inclusions, edit the below settings in the Agent configuration file `/etc/stackstate-agent/stackstate.yaml` and [restart StackState Agent V2](#start-stop-or-restart-the-agent).

| Configuration item | Description |
|:---|:---|
| `process_blacklist.patterns` | A list of regex patterns that will exclude a process if matched. [Default patterns \(github.com\)](https://github.com/StackVista/stackstate-process-agent/blob/master/config/config_nix.go).  |
| `process_blacklist.inclusions.cpu_pct_usage_threshold` | Threshold that enables the reporting of high CPU usage processes. |
| `process_blacklist.inclusions.amount_top_cpu_pct_usage` | The number of processes to report that have a high CPU usage. Default `0`. |
| `process_blacklist.inclusions.amount_top_io_read_usage` | The number of processes to report that have a high IO read usage. Default `0`. |
| `process_blacklist.inclusions.amount_top_io_write_usage` | The number of processes to report that have a high IO write usage. Default `0`. |
| `process_blacklist.inclusions.mem_usage_threshold` | Threshold that enables the reporting of high Memory usage processes. |
| `process_blacklist.inclusions.amount_top_mem_usage` | The number of processes to report that have a high memory usage. Default `0`. |

#### Disable Agent features

Certain features of the Agent can optionally be turned off if they are not needed. To disable a feature, edit the below settings in the Agent configuration file `/etc/stackstate-agent/stackstate.yaml` and [restart StackState Agent V2](#start-stop-or-restart-the-agent).

| Configuration item | Description |
|:---|:---|
|`process_config.enabled` | Default `true` (collects containers and processes). Set to `false` to collect only containers, or `disabled` to disable the process Agent.|
| `apm_config.enabled` | Default `true`. Set to `"false"` to disable the APM Agent. |
| `network_tracer_config.network_tracing_enabled` | Default `true`. Set to `false` to disable the network tracer. |
   
- **process_config.enabled** - Default `true` (collects containers and processes). Set to `false` to collect only containers, or `disabled` to disable the process Agent.
- **apm_config.enabled** - Default `true`. Set to `false` to disable the APM Agent.
- **network_tracer_config.network_tracing_enabled** - Default `true`. Set to `false` to disable the network tracer.
   
### Integration configuration

The Agent can be configured to run checks that integrate with external systems. Configuration files for integrations run through StackState Agent V2 can be found in the directory `/etc/stackstate-agent/conf.d/`. Each integration has its own configuration file that is used by the associated Agent check. 

Documentation for the available StackState integrations, including configuration details can be found on the [StackPacks > Integrations pages](/stackpacks/integrations/).

## Commands

{% hint style="info" %}
Commands require elevated privileges.
{% endhint %}

### Start, stop or restart the Agent

To manually start, stop or restart StackState Agent V2:

```text
# with systemctl
sudo systemctl start stackstate-agent
sudo systemctl stop stackstate-agent
sudo systemctl restart stackstate-agent

# with service
sudo service stackstate-agent start
sudo service stackstate-agent stop
sudo service stackstate-agent restart
```
### Status and information

To check if StackState Agent V2 is running and receive information about the Agent's state:

```text
# with systemctl
sudo systemctl status stackstate-agent

# with service
sudo service stackstate-agent status
```

To show tracebacks for errors or output the full log:

```text
# with systemctl
sudo journalctl -u stackstate-agent

# with service
sudo service stackstate-agent status -v

```
### Manually run a check

Use the command below to manually run an Agent check. 

```yaml
# Execute a check once and display the results.
sudo -u stackstate-agent agent check <CHECK_NAME>

# Execute a check once with log level debug and display the results.
sudo -u stackstate-agent agent check <CHECK_NAME> -l debug
```

## Troubleshooting

### Log files

Logs for the subsystems are in the following files:

* `/var/log/stackstate-agent/agent.log`
* `/var/log/stackstate-agent/process-agent.log`

### Support knowledge base

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

## Uninstall

To uninstall StackState Agent V2 from your system, stop the `stackstate-agent` service and remove it using `yum` or `apt-get`.

{% tabs %}
{% tab title="yum" %}
```
# stop the Agent with one of the below commands
sudo systemctl stop stackstate-agent
sudo service stackstate-agent stop

# uninstall the Agent
sudo yum remove stackstate-agent
```
{% endtab %}
{% tab title="apt-get" %}
```
# stop the Agent with one of the below commands
sudo systemctl stop stackstate-agent
sudo service stackstate-agent stop

# uninstall the Agent
sudo apt-get remove stackstate-agent
```
{% endtab %}
{% endtabs %}

## See also

* [About the StackState Agent](/setup/agent/about-stackstate-agent.md)
* [StackState Agent V2 StackPack](/stackpacks/integrations/agent.md)
* [StackPack integration documentation](/stackpacks/integrations)
* [StackState Agent V2 \(github.com\)](https://github.com/StackVista/stackstate-agent)
* [cURL \(haxx.se\)](https://curl.haxx.se)
* [wget \(gnu.org\)](https://www.gnu.org/software/wget/)