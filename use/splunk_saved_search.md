---
title: Splunk saved search
kind: Documentation
aliases:
  - /usage/splunk_saved_search/
---

# Splunk saved search

{% hint style="warning" %}
This page describes StackState version 4.0.<br />Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

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

