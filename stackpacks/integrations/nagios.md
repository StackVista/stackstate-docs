---
description: StackState Self-hosted v5.1.x 
---

# Nagios

## Overview

The Nagios StackPack allows StackState to connect to Nagios. We support the Nagios version 5.x onwards.

Using this StackPack, you can:

* map Nagios alerts onto your topology

Nagios is a [StackState curated integration](/stackpacks/integrations/about_integrations.md#stackstate-curated-integrations).

## Prerequisites

The following prerequisites need to be met:

* [StackState Agent V2](../../setup/agent/about-stackstate-agent.md) must be installed on a single machine which can connect to Nagios and StackState.
* A Nagios instance must be running.

## Configuration

The Nagios StackPack requires the following parameters to collect the topology information:

* **Nagios HostName** - the Nagios HostName from which topology need to be collected.

**NOTE** - Make sure once Nagios is installed properly, you configure your `hostname` and rename from `localhost` to proper fully qualified domain name.

## Enable Nagios integration

To enable the Nagios check and begin collecting data from your Nagios instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/nagios.d/conf.yaml`:
   * Include details of your Nagios instance: 
     * **nagios\_conf** - path to the `nagios.cfg` file
   * By default, the Nagios check won't collect any metrics. To enable data collection, set one or both of the following to **True**:

     * **collect\_host\_performance\_data**
     * **collect\_service\_performance\_data**.

     ```text
     # Section used for global Nagios check config
     init_config:
     # check_freq: 15 # default is 15

     instances:
     - nagios_conf: <nagios_conf_path>          # /etc/nagios/nagios.cfg
       # collect_events: False                  # default is True
       # passive_checks_events: True            # default is False
       collect_host_performance_data: True      # default is False
       collect_service_performance_data: True   # default is False
     ```
2. [Restart StackState Agent V2](../../setup/agent/about-stackstate-agent.md#deployment) to publish the configuration changes.
3. Once the Agent is restarted, wait for the Agent to collect data and send it to StackState.

## Permissions for Nagios files

Nagios StackState Agent check tails Nagios config and log files, so it should have permission to read those files. If you run StackState Agent with some other user than `root`, the StackState Agent user must be added to the same group that's attached to the config and log files. Note that manually setting read permission isn't an option as the files can sometimes be recreated by Nagios.

## Release notes

**Nagios StackPack v2.6.3 \(2021-07-19\)**

* Improvement: Remove API-Integration references from the documentation.

