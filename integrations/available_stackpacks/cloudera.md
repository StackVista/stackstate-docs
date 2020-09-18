---
title: Cloudera StackPack
kind: documentation
---

# Cloudera

{% hint style="warning" %}
This page describes StackState version 4.0.  
Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the Cloudera StackPack?

The Cloudera StackPack is used to create a near real time synchronization with your Cloudera instance.

## Prerequisites

The following prerequisites need to be met:

* StackState Agent V2 must be installed on a single machine which can connect to Cloudera Manager and StackState. \(See the [StackState Agent V2 StackPack](agent.md) for more details\)
* A Cloudera instance must be running.

**NOTE**:- We support Cloudera version 5.11.

## Enabling Cloudera integration

To enable the cloudera check which collects the data from Cloudera instance:

Edit the `conf.yaml` file in your agent `/etc/stackstate-agent/conf.d/cloudera.d/` directory, replacing `<url>`, `<username>` and `<password>` with the information from your Cloudera instance.

```text
# Section used for global Cloudera check config
init_config:

instances:
  # mandatory
  - url: <url>
    # SSL verification
    verify_ssl: false    

    # Read-only credentials to connect to cloudera
    # mandatory
    username: <username> # Admin
    password: <password> # cloudera

    # Cloudra API version
    # mandatory
    api_version: <api_version> # v18
```

To publish the configuration changes, restart the StackState Agent\(s\) using below command.

```text
sudo /etc/init.d/stackstate-agent restart
```

Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

