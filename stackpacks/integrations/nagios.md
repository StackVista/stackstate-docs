# Nagios

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the Nagios StackPack?

The Nagios StackPack allows StackState to connect to Nagios. We support the Nagios version 5.x onwards.

Using this StackPack, you can:

* map Nagios alerts onto your topology

## Prerequisites

The following prerequisites need to be met:

* [StackState Agent V2](agent.md) must be installed on a single machine which can connect to Nagios and StackState.
* A Nagios instance must be running.

## Configuration

The Nagios StackPack requires the following parameters to collect the topology information:

* **Nagios HostName** -- the Nagios HostName from which topology need to be collected.

**NOTE** - Make sure once Nagios is installed properly, you configure your `hostname` and rename from `localhost` to proper fully qualified domain name.

## Enable Nagios integration

To enable the Nagios check and begin collecting data from your Nagios instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/nagios.d/conf.yaml`:
   * Include details of your Nagios instance: 
     * **nagios\_conf** - path to the `nagios.cfg` file
   * By default the Nagios check will not collect any metrics. To enable data collection, set one or both of the following to **True**:

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
2. [Restart the StackState Agent\(s\)](agent.md#start-stop-restart-the-stackstate-agent) to publish the configuration changes.
3. Once the Agent is restarted, wait for the Agent to collect data and send it to StackState.

## Permissions for Nagios files

Nagios StackState Agent check tails Nagios config and log files, so it should have permission to read those files. If you run StackState Agent with some other user than `root`, the StackState Agent user must be added to the same group that is attached to the config and log files. Note that manually setting read permission is not an option as the files can sometimes be recreated by Nagios.

## Release notes

**Nagios StackPack v2.4.1 \(2020-11-02\)**

* Bugfix: Fix for Component State evaluation in Service check.

**Nagios StackPack v2.4.0 \(2020-09-25\)**

* Feature: Added support for ITRS OP5 Monitor.

**Nagios StackPack v2.3.1 \(2020-08-18\)**

* Feature: Introduced the Release notes pop up for customer.

**Nagios StackPack v2.3.0 \(2020-08-04\)**

* Improvement: Deprecated stackpack specific layers and introduced a new common layer structure.
* Improvement: Replace resolveOrCreate with getOrCreate.

**Nagios StackPack v2.2.0 \(2020-07-27\)**

* Improvement: Updated integration page with StackState Agent V2 usage info.

**Nagios StackPack v2.1.2 \(2020-07-22\)**

* Bugfix: Fixed StackPack installation.

**Nagios StackPack v2.1.1 \(2020-06-25\)**

* Bugfix: Fixed the translation of host events to health state in the check function.
* Bugfix: Fixed the minimal deviating health state on the Nagios view.

**Nagios StackPack v2.1.0 \(2020-04-08\)**

* Improvement: Updated StackPacks integration page, categories, and icons for the SaaS trial.

