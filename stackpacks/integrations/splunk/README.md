# Splunk

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the Splunk StackPack?

The Splunk StackPack synchronizes topology, events and metrics from Splunk to StackState.

## Prerequisites

The Splunk StackPack depends on the [API Integration](../api-integration.md) StackPack.

## Synchronizing data from Splunk

The Splunk StackPack synchronizes different types of data from Splunk to StackState. The Splunk StackPack requires the API Integration StackPack and agent to be installed. Using specific checks, the Splunk StackPack periodically retrieves selected data from Splunk and stores it in StackState.

The Splunk StackPack supports three different types of information:

* build **topology** out of Splunk data
* retrieve **events** from Splunk
* retrieve **metrics** from Splunk

StackState provides ability to call Splunk saved searches from the StackState Splunk plugin. This approach replaces index lookup by saved search, and takes data from a Splunk saved search instead.

### Optional Prerequisites:

* Your Splunk data source should be extended with a Splunk username and a valid namespace. This information is optional - if not provided, the default `Search&Reporting` is set as a namespace.

## Usage

You can call Splunk saved searches in Telemetry Stream pane for selected Splunk components. Add a new stream to your component and provide following as Filters:

* `~savedsearch` - this filter requires a string value that represents the name under that search is saved in Splunk Reports.
* `~savedsearchparam_<savedsearch_param_name>` - if your search has some additional parameters \(macro replacements from Splunk\), they should be specified in this filter as the parameter name after `_`\(underscore\). Value is a string.

### Example

To call a Splunk saved search `testsearch` with parameter `host` and a hostname `machine1` you need to add two filters in the Telemetry Stream:

`~savedsearch` == `testsearch` `~savedsearchparam_host` == `machine1`

## Further information

* [Synchronize Splunk topology](splunk_topology.md) for more information.
* [Synchronize Splunk events](splunk_event.md) for more information.
* [Synchronize Splunk metrics](splunk_metric.md) for more information.

