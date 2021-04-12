---
title: Zabbix StackPack
kind: documentation
---

# Zabbix

{% hint style="warning" %}
This page describes StackState version 4.x.  
The StackState 4.0 version range is End of Life (EOL) and no longer supported.

We encourage customers still running the 4.0 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the Zabbix StackPack?

The Zabbix StackPack is used to create a near real time synchronization with your Zabbix instance.

## Prerequisites

The following prerequisites need to be met:

* The StackState Agent StackPack must be installed on a single machine which can connect to Zabbix and StackState. \(See the [StackState Agent V2 StackPack](agent.md) for more details\).
* A Zabbix instance must be running.

**NOTE**: Zabbix versions 3 and 4 are supported.

## Enabling Zabbix integration

To enable the Zabbix check which collects the data from Zabbix instance:

Edit the `conf.yaml` file in your agent `/etc/stackstate-agent/conf.d/zabbix.d` directory, replacing `<url>`, `<username>` and `<password>` with the information from your Zabbix instance.

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

To publish the configuration changes, restart the StackState Agent\(s\) using below command.

```text
sudo /etc/init.d/stackstate-agent restart
```

Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

