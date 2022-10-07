---
description: StackState Self-hosted v5.1.x 
---

# Agent V1 \(Legacy\)

{% hint style="warning" %}
**Agent V1 (legacy) will be deprecated in a future release of StackState.** 

If you are still running Agent V1 (legacy), it is advised that you upgrade to Agent V2 and migrate all checks to run on Agent V2.

➡️ [Migrate Agent V1 (legacy) to Agent V2](/setup/agent/migrate-agent-v1-to-v2)
{% endhint %}

## Overview

Prior to StackState v5.1, Agent V1 was used to run checks that connect to [Splunk](/stackpacks/integrations/splunk/splunk_stackpack.md) to retrieve metrics and events data. From StackState v5.1, all Agent checks run on [StackState Agent V2](about-stackstate-agent.md).

StackState Agent V1 is open source: [View the source code on GitHub](https://github.com/StackVista/sts-agent).

## Installation

{% hint style="warning" %}
**Agent V1 (legacy) will be deprecated in a future release of StackState.** 

It is advised that you install Agent V2 and migrate all checks to run on Agent V2.

➡️ [Migrate Agent V1 (legacy) to Agent V2](/setup/agent/migrate-agent-v1-to-v2)
{% endhint %}

Install StackState Agent V1 by using the following sequence of steps:

{% tabs %}
{% tab title="Debian, Ubuntu" %}
1. Download the [StackState Agent V1 Debian package](https://l.stackstate.com/stackstate-agent-1-deb-latest) or run this command on the machine where you wish to install the Agent:

   ```text
   wget https://s3-eu-west-1.amazonaws.com/agent.stackstate.com/stackstate-agent-deb-repo/pool/s/stackstate-agent/stackstate-agent_1.3.0-1_amd64.deb'
   ```

2. Use `dpkg` to install the downloaded package:

   ```text
   dpkg -i stackstate-agent_1.3.0-1_amd64.deb
   ```

3. Set the following keys in the `stackstate.conf.example` file:

   ```text
    api_key: {{config.apiKey}}
    dd_url: {{config.baseUrl}}/stsAgent/
   ```

4. After this the example configuration can be used as configuration.

   ```text
    cp /etc/sts-agent/stackstate.conf.example /etc/sts-agent/stackstate.conf
   ```
{% endtab %}

{% tab title="Amazon linux, CentOS, Fedora, Red Hat" %}
1. Download the [StackState Agent V1 RPM package](https://l.stackstate.com/stackstate-agent-1-rpm-latest) or run this command on the machine where you wish to install the Agent:

   ```text
   wget 'https://s3-eu-west-1.amazonaws.com/agent.stackstate.com/stackstate-agent-yum-repo/stackstate-agent_1.3.0-1.x86_64.rpm'
   ```

2. Use `rpm` to install the downloaded package:

   ```text
   rpm -i stackstate-agent_1.3.0-1.x86_64.rpm
   ```

3. Set the following keys in the `stackstate.conf.example` file:

   ```text
    api_key: {{config.apiKey}}
    dd_url: {{config.baseUrl}}/stsAgent
   ```

4. After this the example configuration can be used as configuration.

   ```text
    cp /etc/sts-agent/stackstate.conf.example /etc/sts-agent/stackstate.conf
   ```
{% endtab %}
{% endtabs %}

If you need further assistance, our [support team](https://support.stackstate.com/hc/en-us) will be glad to help.

## Start / stop / restart the Agent

{% hint style="info" %}
* Commands require elevated privileges.
* Restarting StackState Agent V1 (legacy) will reload the configuration files.
{% endhint %}

To manually start, stop or restart StackState Agent V1 (legacy):

{% tabs %}
{% tab title="Linux" %}
```text
sudo /etc/init.d/stackstate-agent start
sudo /etc/init.d/stackstate-agent stop
sudo /etc/init.d/stackstate-agent restart
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
To check if StackState Agent V1 is running:

```text
sudo /etc/init.d/stackstate-agent status
```

To receive information about the StackState Agent V1 (legacy) state:

```text
sudo /etc/init.d/stackstate-agent info
```

Tracebacks for errors can be retrieved by setting the `-v` flag:

```text
sudo /etc/init.d/stackstate-agent info -v
```
{% endtab %}

{% tab title="Windows" %}
To check if the StackState Agent V1 (legacy) is running and receive information about the Agent's state:

```text
"./agent.exe status"
```
{% endtab %}
{% endtabs %}

## Troubleshooting

Try running the [info command](agent-v1.md#status-and-information) to see the state of StackState Agent V1.

Logs for the subsystems are in the following files:

* `/var/log/stackstate/supervisord.log`
* `/var/log/stackstate/collector.log`
* `/var/log/stackstate/stsstatsd.log`
* `/var/log/stackstate/forwarder.log`

If you are still having trouble, contact our support team on the [StackState support site](http://support.stackstate.com/).

## See also

* [StackState Agent V2](/setup/agent/about-stackstate-agent.md)
* [Migrate Agent V1 \(lecacy\) to Agent V2](/setup/agent/migrate-agent-v1-to-v2)

