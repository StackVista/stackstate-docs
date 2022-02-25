---
description: StackState core integration
---

# API integration

{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the API-Integration StackPack?

The StackState API-Integration StackPack enables StackState synchronizations through the StackState API-Integration Agent. The API-Integration Agent allows you to run checks that connect to [Splunk](/stackpacks/integrations/splunk/splunk_stackpack.md) to collect topology, metrics and events data.

The StackState API-Integration Agent is open source: [View the source code on GitHub](https://github.com/StackVista/sts-agent).

## Installation

To install the API-Integration StackPack, go to the StackState UI page **StackPacks** > **Integrations** > **API-Integration** and click INSTALL.

Install the StackState API-Integration Agent by using the following sequence of steps:

{% tabs %}
{% tab title="Debian, Ubuntu" %}
1. Download the [API-Integration Agent Debian package](https://l.stackstate.com/stackstate-agent-1-deb-latest) or run this command on the machine where you wish to install the Agent:

   ```text
   wget https://s3-eu-west-1.amazonaws.com/agent.stackstate.com/stackstate-agent-deb-repo/pool/s/stackstate-agent/stackstate-agent_1.3.0-1_amd64.deb'
   ```

2. Use `dpkg` to install the downloaded package:

   ```text
   dpkg -i stackstate-agent_1.3.0-1_amd64.deb
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
1. Download the [API-Integration Agent RPM package](https://l.stackstate.com/stackstate-agent-1-rpm-latest) or run this command on the machine where you wish to install the Agent:

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


## Start / stop / restart the StackState Agent

{% hint style="info" %}
* Commands require elevated privileges.
* Restarting the StackState Agent will reload the configuration files.
{% endhint %}

To manually start, stop or restart the StackState Agent:

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
To check if the StackState API-Integration Agent is running:

```text
sudo /etc/init.d/stackstate-agent status
```

To receive information about the StackState API-Integration Agent state:

```
sudo /etc/init.d/stackstate-agent info
```

Tracebacks for errors can be retrieved by setting the `-v` flag:

```text
sudo /etc/init.d/stackstate-agent info -v
```
{% endtab %}

{% tab title="Windows" %}
To check if the StackState Agent is running and receive information about the Agent's state:

```text
"./agent.exe status"
```
{% endtab %}
{% endtabs %}

## Troubleshooting

Try running the [info command](#status-and-information) to see the state of the API-Integration Agent.

Logs for the subsystems are in the following files:

- `/var/log/stackstate/supervisord.log`
- `/var/log/stackstate/collector.log`
- `/var/log/stackstate/stsstatsd.log`
- `/var/log/stackstate/forwarder.log`

If you are still having trouble, contact our support team on the [StackState support site](http://support.stackstate.com/).

## Release notes

**API Integration StackPack v2.4.1 \(2021-04-02\)**

* Improvement: Update documentation.
* Improvement: Enable auto grouping on generated views.
* Improvement: Common bumped from 2.2.3 to 2.5.1
* Improvement: StackState min version bumped to 4.3.0

**API Integration StackPack v3.0.2 \(2021-03-29\)**

* Bugfix: Update the minimum required StackState version to 4.3.0.

**API Integration StackPack v3.0.1 \(2021-03-25\)**

* Improvement: Update documentation.

**API Integration StackPack v3.0.0 \(2021-03-25\)**

* Improvement: Enable auto grouping on generated views.
* Improvement: Common bumped from 2.2.3 to 2.4.3

**API Integration StackPack v2.3.1 \(2020-08-18\)**

* Features: Introduced the Release notes pop up for customer
* Features: Use the latest StackState Agent V1

**API Integration StackPack v2.3.0 \(2020-08-04\)**

* Improvement: Deprecated stackpack specific layers and introduced a new common layer structure.
* Improvement: Replace resolveOrCreate with getOrCreate.

**API Integration StackPack v2.2.0 \(2020-06-04\)**

* Features: Token based authentication supported for Splunk.
* Features: Updated Splunk integration documents for metrics, events and topology.
* Features: Short link for doc site updated.

