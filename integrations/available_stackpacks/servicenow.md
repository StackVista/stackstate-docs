---
title: ServiceNow StackPack
kind: documentation
---

# ServiceNow

{% hint style="warning" %}
**This page describes StackState version 4.0.**

The StackState 4.0 version range is End of Life \(EOL\) and **no longer supported**. We encourage customers still running the 4.0 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the ServiceNow StackPack?

The ServiceNow StackPack is used to create a near real time synchronization of CI's and their dependencies from ServiceNow to StackState.

To install this StackPack we need to know the instance id of your servicenow account.

## Prerequisites

* An API Integration Agent must be installed which can connect to ServiceNow and StackState. \(See the [API Integration StackPack](api-integration.md) for more details\)
* A ServiceNow instance must be running.

## Enabling ServiceNow integration

To enable the ServiceNow check which collects the data from ServiceNow:

Edit the `servicenow.yaml` file in your agent’s `conf.d` directory, replacing `<instance_ID>`, `<instance_username>` and `<instance_password>` with the information from your ServiceNow instance.

```text
init_config:
  # Any global configurable parameters should be added here
  default_timeout: 10
  min_collection_interval: 5

instances:
  - url: "https://<instance_ID>.service-now.com"
    basic_auth:
       user: <instance_username>
       password: <instance_password>
    batch_size: 100
```

To enable the ServiceNow check restart the StackState Agent\(s\) using below command.

```text
sudo /etc/init.d/stackstate-agent restart
```

Once the Agent is restarted, Wait for the Agent to collect the data and send it to StackState.

