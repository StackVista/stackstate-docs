---
title: SCOM StackPack
kind: documentation
---

# SCOM

{% hint style="warning" %}
**This page describes StackState version 4.0.**

The StackState 4.0 version range is End of Life \(EOL\) and **no longer supported**. We encourage customers still running the 4.0 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the SCOM StackPack?

The SCOM StackPack is used to create a near real time synchronisation with your SCOM instance.

## Prerequisites

The following prerequisites need to be met:

* StackState Agent V2 must be installed on a single machine which can connect to SCOM and StackState \(See the [StackState Agent V2 StackPack](agent.md) for more details\).
* A SCOM instance must be running.

**NOTE**:- We support SCOM version 1806 and 2019.

## Enabling SCOM check

To enable the SCOM check which collects the data from SCOM instance:

Edit the `conf.yaml` file in your agent `/etc/stackstate-agent/conf.d/scom.d/` directory, replacing `hostip`,`domain` ,`auth_mode`, `<username>` and `<password>` with the information from your SCOM instance. Streams are disabled by default.

```text
# Section used for global SCOM check config
init_config:
    # run every minute
    min_collection_interval: 60

instances:
  - hostip: #SCOM IP
    domain: # active directory domain where the SCOM is located
    username: # username
    password: # password
    auth_mode: Network # Network or Windows (Default is Network)
    streams:
      #- name: SCOM
      #  class: Microsoft.SystemCenter.ManagementGroup  --> Management Pack root class
      #- name: Exchange
      #  class: Microsoft.Exchange.15.Organization
      #- name: Skype
      #  class: Microsoft.LS.2015.Site
```

To publish the configuration changes, restart the StackState Agent\(s\) using below command.

```text
sudo /etc/init.d/stackstate-agent restart
```

Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

