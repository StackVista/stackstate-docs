---
description: StackState Self-hosted v4.6.x
---

# Zabbix

{% hint style="warning" %}
**This page describes StackState version 4.6.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/stackpacks/integrations/zabbix).
{% endhint %}

## What is the Zabbix StackPack?

The Zabbix StackPack is used to create a near real time synchronization with your Zabbix instance.

Zabbix is a [StackState curated integration](/stackpacks/integrations/about_integrations.md#stackstate-curated-integrations).

## Prerequisites

The following prerequisites need to be met:

* [StackState Agent V2](../../setup/agent/about-stackstate-agent.md) must be installed on a single machine which can connect to Zabbix and StackState.
* A Zabbix instance must be running.

**NOTE**: Zabbix versions 3, 4 and 5 are supported.

## Enable Zabbix integration

To enable the Zabbix check and begin collecting data from your Zabbix instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/zabbix.d/conf.yaml` to include details of your Zabbix instance:
   * **url**
   * **username** 
   * **password** - use [secrets management](../../configure/security/secrets_management.md) to store passwords outside of the configuration file.

     ```text
     # Section used for global Zabbix check config
     init_config:

     instances:
     # mandatory
     - url: <url> # http://10.0.0.1/zabbix/api_jsonrpc.php

       # Read-only credentials to connect to zabbix
       # mandatory
       username: <username> # Admin
       password: <password> # zabbix
     ```
2. [Restart the StackState Agent\(s\)](../../setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2) to publish the configuration changes.
3. Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

## Release notes

**Zabbix StackPack v3.2.0 (2021-09-22)**

* Feature: Support StackState Common tags


**Zabbix StackPack v3.1.1 \(2021-04-12\)**

* Improvement: Common bumped from 2.5.0 to 2.5.1
