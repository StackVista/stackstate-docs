---
title: Nagios StackPack
kind: documentation
---

# Nagios

{% hint style="warning" %}
This page describes StackState version 4.0.<br />Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the Nagios StackPack?

The Nagios StackPack allows StackState to connect to Nagios. We support the Nagios version 5.x onwards.

Using this StackPack, you can:

* map Nagios alerts onto your topology

## Prerequisites

The following prerequisites need to be met:

* StackState Agent V2 must be installed on a single machine which can connect to Nagios and StackState. \(See the [StackState Agent V2 StackPack](agent.md) for more details\)
* A Nagios instance must be running.

## Configuration

The Nagios StackPack requires the following parameters to collect the topology information :

* **Nagios HostName** -- the Nagios HostName from which topology need to be collected.

**NOTE** - Make sure once Nagios is installed properly, you configure your `hostname` and rename from `localhost` to proper fully qualified domain name.

## Enabling Nagios check

To enable the Nagios check which collects the data from Nagios instance:

Edit the `nagios.yaml` file in your API-Integration Agent `conf.d` directory, replacing `<nagios_conf_path>` with the information from your Nagios instance.

```text
# Section used for global Nagios check config
init_config:
# check_freq: 15 # default is 15

instances:
  - nagios_conf: <nagios_conf_path> # /etc/nagios/nagios.cfg
    # collect_events: True                   # default is True
    # passive_checks_events: True            # default is False
    # collect_host_performance_data: True    # default is False
    # collect_service_performance_data: True # default is False
```

With the default configuration, the Nagios check doesn’t collect any metrics. But if you set `collect_host_performance_data` and/or `collect_service_performance_data` to **True**, the check watches for Nagios metrics data and sends those to StackState.

To publish the configuration changes, restart the StackState API-Integration Agent using below command.

```text
sudo /etc/init.d/stackstate-agent restart
```

Once the API-Integration Agent is restarted, wait for the Agent to collect the data and send it to StackState.

