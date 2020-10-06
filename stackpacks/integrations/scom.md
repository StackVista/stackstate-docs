---
title: SCOM StackPack
kind: documentation
---

# SCOM

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

{% hint style="info" %}
If you don't want to include a password directly in the configuration file, use [secrets management](/configure/security/secrets_management.md).
{% endhint %}

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

To publish the configuratiTo publish the configuration changes, [restart the StackState Agent\(s\)](/stackpacks/integrations/agent.md#start-stop-the-stackstate-agent).

Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

