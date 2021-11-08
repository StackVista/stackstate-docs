# Linux

## Overview

{% hint style="info" %}
**StackState Agent V2**
{% endhint %}

StackState Agent V2 can be installed on Linux systems running CentOS, Debian, Fedora, RedHat or Ubuntu. The Agent collects data from the host where it is running and can be configured to integrate with external systems. Retrieved data is pushed to StackState, to work with this data the [StackState Agent V2 StackPack](../../stackpacks/integrations/agent.md) must be installed in your StackState instance. For details of the data retrieved and available integrations, see the [StackPack integration documentation](../../stackpacks/integrations/).

## Setup

### Supported versions

StackState Agent is tested to run on the Linux versions listed below with 64bit architecture. Note that host data for network connections between processes and containers \(including network traffic telemetry\) can only be retrieved for OS versions with a network tracer \(kernel version 4.3.0 or higher\):

| Platform | Minimum version | Notes |
| :--- | :--- | :--- |
| CentOS | CentOS 6 | CentOS 6 requires Agent v2.0.2 or above. Network tracer available from CentOS 8. |
| Debian | Debian 7 \(Wheezy\) | Debian 7 \(Wheezy\) requires glibc upgrade to 2.17. Network tracer available from Debian 9 \(Stretch\). |
| Fedora | Fedora 28 | - |
| RHEL | RHEL 7 | Network tracer available from RHEL 8. |
| Ubuntu | Ubuntu 15.04 \(Vivid Vervet\) | Network tracer available from Ubuntu 16.04 \(LTS\) \(Xenial Xerus\). |

### StackState Receiver API address

StackState Agent connects to the StackState Receiver API.

{% tabs %}
{% tab title="Kubernetes" %}
For StackState running on Kubernetes, the Receiver API is hosted by default at:

```text
https://<baseUrl>/receiver/stsAgent
```

The `baseUrl` is set during StackState installation, for details see [Kubernetes install - configuration parameters](../../setup/installation/kubernetes_install/install_stackstate.md#generate-values-yaml).
{% endtab %}

{% tab title="Linux" %}
For StackState running on Linux, the Receiver API is hosted by default at:
```text
https://<baseUrl>:7077/stsAgent
```

The `baseUrl` is set during StackState installation, for details see [Linux install - configuration parameters](../../setup/installation/linux_install/install_stackstate.md#configuration-options-required-during-install).
{% endtab %}
{% endtabs %}

### Install

StackState Agent V2 is installed using an install script.

* [Online install](linux.md#online-install) - If you have access to the internet on the machine where the Agent will be installed. 
* [Offline install](linux.md#offline-install) - If you **do not** have access to the internet on the machine where the Agent will be installed.

{% hint style="info" %}
The `apiKey` and `baseUrl` specified when running the install script are set during StackState installation, for details see:

* [StackState Kubernetes install - configuration parameters](../installation/kubernetes_install/install_stackstate.md#generate-values-yaml) 
* [StackState Linux install - configuration parameters](../installation/linux_install/install_stackstate.md#configuration-options-required-during-install) 
{% endhint %}

#### Online install

If you have access to the internet on the machine where the Agent will be installed, use one of the commands below to run the install.sh script. The Agent installer package will be downloaded automatically.

{% tabs %}
{% tab title="cURL" %}
```text
curl -o- https://stackstate-agent-2.s3.amazonaws.com/install.sh | \
STS_API_KEY="{{config.apiKey}}" \
STS_URL="<stackstate-receiver-api-address>" bash
```
{% endtab %}

{% tab title="wget" %}
```text
wget -qO- https://stackstate-agent-2.s3.amazonaws.com/install.sh | \
STS_API_KEY="{{config.apiKey}}" \
STS_URL="<stackstate-receiver-api-address>" bash
```
{% endtab %}
{% endtabs %}

#### Offline install

If you do not have access to the internet on the machine where the Agent will be installed, you will need to download both the install script and the Agent installer package before you install. You can then set the environment variable `STS_INSTALL_NO_REPO=yes` and specify the path to the downloaded installer package when you run the install.sh script.

1. Download the install script and copy this to the host where it will be installed:
   * [https://stackstate-agent-2.s3.amazonaws.com/install.sh](https://stackstate-agent-2.s3.amazonaws.com/install.sh)
2. Get the **Key** of the latest version of the Agent installer package (DEB or RPM package):
   * [DEB installer package list](https://stackstate-agent-2.s3.amazonaws.com/?prefix=pool/stable/s/st/stackstate-agent_2.1)
   * [RPM installer package list](https://stackstate-agent-2-rpm.s3.amazonaws.com/?prefix=stable/stackstate-agent-2.1)
3. Download the Agent installer package and copy this to the host where it will be installed. The download link can be constructed from the S3 bucket URL and the installer package `Key`  that is provided on the installer package list page. 
   For example, to download the DEB installer package for `agent_2.13.0-1_amd64.deb`, use:  `https://stackstate-agent-2.s3.amazonaws.com/pool/stable/s/st/stackstate-agent_2.13.0-1_amd64.deb`
   * **DEB Download link:** `https://stackstate-agent-2.s3.amazonaws.com/<Key_from_DEB_installer_package_list>`
   * **RPM Download link:** `https://stackstate-agent-2-rpm.s3.amazonaws.com/<Key_from_RPM_installer_package_list>`
4. Use the command below to set the required environment variables and run the installer script:

   ```text
    STS_API_KEY="{{config.apiKey}}" \
    STS_URL="<stackstate-receiver-api-address>" \
    STS_INSTALL_NO_REPO=yes \
    ./install.sh <path_to_local_Agent_installer_package>
   ```

### Upgrade

To upgrade StackState Agent V2 on your system, stop the `stackstate-agent` service and upgrade using `yum` or `apt-get`. To upgrade offline, download the Agent installer package \(DEB or RPM package\) and copy this to the host where it will be installed - see step 2 in the [offline install instructions](linux.md#offline-install).

{% tabs %}
{% tab title="yum" %}
```text
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
```text
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

A number of advanced configuration options are available for StackState Agent V2. These can be set in the Agent configuration file `/etc/stackstate-agent/stackstate.yaml` and are described in detail on the page [advanced Agent configuration](advanced-agent-configuration.md).

### Integration configuration

The Agent can be configured to run checks that integrate with external systems. Configuration files for integrations run through StackState Agent V2 can be found in the directory `/etc/stackstate-agent/conf.d/`. Each integration has its own configuration file that is used by the associated Agent check.

Documentation for the available StackState integrations, including configuration details can be found on the [StackPacks &gt; Integrations pages](../../stackpacks/integrations/).

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
sudo -u stackstate-agent stackstate-agent check <CHECK_NAME>

# Execute a check once with log level debug and display the results.
sudo -u stackstate-agent stackstate-agent check <CHECK_NAME> -l debug
```

## Troubleshooting

To troubleshoot the Agent, try to [check the Agent status](linux.md#status-and-information) or [manually run a check](linux.md#manually-run-a-check).

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
```text
# stop the Agent with one of the below commands
sudo systemctl stop stackstate-agent
sudo service stackstate-agent stop

# uninstall the Agent
sudo yum remove stackstate-agent
```
{% endtab %}

{% tab title="apt-get" %}
```text
# stop the Agent with one of the below commands
sudo systemctl stop stackstate-agent
sudo service stackstate-agent stop

# uninstall the Agent
sudo apt-get remove stackstate-agent
```
{% endtab %}
{% endtabs %}

## See also

* [About the StackState Agent](about-stackstate-agent.md)
* [Advanced Agent configuration](advanced-agent-configuration.md)  
* [StackState Agent V2 StackPack](../../stackpacks/integrations/agent.md)
* [StackPack integration documentation](../../stackpacks/integrations/)
* [StackState Agent V2 \(github.com\)](https://github.com/StackVista/stackstate-agent)

