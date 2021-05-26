# CentOS

## Overview

The StackState Agent can be installed on CentOS. It runs checks that collect data from external systems and push this to StackState using the [StackState Agent StackPack](/stackpacks/integrations/agent.md).

The Agent is open source and available on github at [https://github.com/StackVista/stackstate-agent](https://github.com/StackVista/stackstate-agent).

## Setup 

### Prerequisites

The following versions are supported:

| OS | Release | Arch | Network Tracer| Status | Notes|
|----|---------|--------|--------|--------|--------|
| CentOS | 6 | 64bit | - | OK | Since version 2.0.2 |
| CentOS | 7 | 64bit | - | OK | - |

### Install

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

#### Offline installation

On your host, download the installation script from [https://stackstate-agent-2.s3.amazonaws.com/install.sh](https://stackstate-agent-2.s3.amazonaws.com/install.sh).

By default, installer tries to configure the package update channel, which would allow to update packages using the host package manager. If you for any reason do not want this behavior, please include `STS_INSTALL_NO_REPO=yes` as an environment parameter:

```text
STS_API_KEY="{{config.apiKey}}" \
    STS_URL="{{config.baseUrl}}/stsAgent" \
    STS_INSTALL_NO_REPO=yes \
    ./install.sh PATH_TO_PREDOWNLOADED_INSTALLER_PACKAGE
```

### Configure

The Agent can be configured to run checks that integrate with external systems. 

* StackState Agent configuration: `/etc/stackstate-agent/stackstate.yaml`
* Integration configurations: `/etc/stackstate-agent/conf.d/`

### Upgrade


## Commands

{% hint style="info" %}
* Commands require elevated privileges.
* Restarting the StackState Agent will reload the configuration files.
{% endhint %}

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


## Release notes


## See also

* [StackState Agent StackPack](/stackpacks/integrations/agent.md)
* [StackState Agent \(github.com\)](https://github.com/StackVista/stackstate-agent)