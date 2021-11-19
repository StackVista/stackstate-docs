---
title: Zabbix StackPack
kind: documentation
---

# Zabbix

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the Zabbix StackPack?

The Zabbix StackPack is used to create a near real time synchronization with your Zabbix instance.

## Prerequisites

The following prerequisites need to be met:

* [StackState Agent V2](agent.md) must be installed on a single machine which can connect to Zabbix and StackState.
* A Zabbix instance must be running.

**NOTE**: Zabbix versions 3 and 4 are supported.

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
2. [Restart the StackState Agent\(s\)](agent.md#start-stop-restart-the-stackstate-agent) to publish the configuration changes.
3. Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

