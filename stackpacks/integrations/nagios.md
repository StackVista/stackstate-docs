---
title: Nagios StackPack
kind: documentation
---

# Nagios

## What is the Nagios StackPack?

The Nagios StackPack allows StackState to connect to Nagios. We support the Nagios version 5.x onwards.

Using this StackPack, you can:

* map Nagios alerts onto your topology

## Prerequisites

The following prerequisites need to be met:

* StackState Agent V2 must be installed on a single machine which can connect to Nagios and StackState. \(See the [StackState Agent V2 StackPack](agent.md) for more details\)
* A Nagios instance must be running.

## Configuration

The Nagios StackPack requires the following parameters to collect the topology information:

* **Nagios HostName** -- the Nagios HostName from which topology need to be collected.

**NOTE** - Make sure once Nagios is installed properly, you configure your `hostname` and rename from `localhost` to proper fully qualified domain name.

## Enabling Nagios check

To enable the Nagios check which collects the data from Nagios instance:

Edit the `nagios.yaml` file in your StackState Agent `conf.d` directory, replacing `<nagios_conf_path>` with the information from your Nagios instance.

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

To publish the configuration changes, restart the StackState Agent using below command.

```text
sudo service stackstate-agent restart
```

Once the StackState Agent is restarted, wait for the Agent to collect the data and send it to StackState.

## Permissions for Nagios files

Nagios StackState Agent check tails Nagios config and log files, so it should have permission to read those files. If you run StackState Agent with some other user than `root`, the StackState Agent user must be added to the same group that is attached to the config and log files. Note that manually setting read permission is not an option as the files can sometimes be recreated by Nagios.
