---
title: API Integration StackPack
kind: documentation
---

# API integration

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the API-Integration StackPack?

The StackState API-Integration StackPack enables the StackState synchronization for the StackState's API-Integration Agents.

With API-Integration Agents you can run checks which connect to external systems like [ServiceNow](servicenow.md).

The StackState API-Integration Agent is open source: [view the source code on GitHub](https://github.com/StackVista/sts-agent).

## Installation

Install the API-Integration StackPack by using the following sequence of steps:

{% tabs %}
{% tab title="Debian, Ubuntu" %}
1. Download the API-Integration Agent [from Bintray](https://dl.bintray.com/stackstate-agent/stackstate-agent-deb-repo/pool/s/stackstate-agent/stackstate-agent_1.2.18-1_amd64.deb) or run this command on the machine where you wish to install the Agent:

   ```text
   wget 'https://dl.bintray.com/stackstate-agent/stackstate-agent-deb-repo/pool/s/stackstate-agent/stackstate-agent_1.2.18-1_amd64.deb'
   ```

2. Use `dpkg` to install the downloaded package:

   ```text
   dpkg -i stackstate-agent_1.2.18-1_amd64.deb
   ```

3. Set the following keys in the stackstate.conf.example file:

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
1. Download the API-Integration Agent [from Bintray](http://dl.bintray.com/stackstate-agent/stackstate-agent-yum-repo/stackstate-agent_1.3.0-1.x86_64.rpm) or run this command on the machine where you wish to install the Agent:

   ```text
   wget https://dl.bintray.com/stackstate-agent/stackstate-agent-yum-repo/stackstate-agent_1.3.0-1.x86_64.rpm
   ```

2. Use `rpm` to install the downloaded package:

   ```text
   rpm -i stackstate-agent_1.3.0-1.x86_64.rpm
   ```

3. Set the following keys in the stackstate.conf.example file:

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

