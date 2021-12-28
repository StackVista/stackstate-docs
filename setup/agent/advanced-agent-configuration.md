# Advanced Agent configuration

{% hint style="warning" %}
**This page describes StackState version 4.4.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/setup/agent/advanced-agent-configuration).
{% endhint %}

## Overview

A number of advanced configuration options are available for StackState Agent V2. These can be set either in the `stackstate.yaml` configuration file \(Linux and Windows\) or using environment variables \(Docker, Kubernetes and OpenShift\).

## Blacklist and inclusions

Processes reported by StackState Agent V2 can optionally be filtered using a blacklist. Using this in conjunction with inclusion rules will allow otherwise excluded processes to be included.

The blacklist is specified as a list of regex patterns. Inclusions override the blacklist patterns, these are used to include processes that consume a lot of resources. Each inclusion type specifies an amount of processes to report as the top resource using processes. For `top_cpu` and `top_mem` a threshold must first be met, meaning that a process needs to consume a higher percentage of resources than the specified threshold before it is reported.

{% tabs %}
{% tab title="Docker, Kubernetes, OpenShift" %}
To specify a blacklist and/or inclusions, set the associated environment variables and restart StackState Agent V2.

| Environment variable | Description |
| :--- | :--- |
| `STS_PROCESS_BLACKLIST_PATTERNS` | A list of regex patterns that will exclude a process if matched. [Default patterns \(github.com\)](https://github.com/StackVista/stackstate-process-agent/blob/master/config/config_nix.go). |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_CPU_THRESHOLD` | Threshold that enables the reporting of high CPU usage processes. |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_CPU` | The number of processes to report that have a high CPU usage. Default `0`. |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_IO_READ` | The number of processes to report that have a high IO read usage. Default `0`. |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_IO_WRITE` | The number of processes to report that have a high IO write usage. Default `0`. |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_MEM_THRESHOLD` | Threshold that enables the reporting of high memory usage processes. |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_MEM` | The number of processes to report that have a high memory usage. Default `0`. |
{% endtab %}

{% tab title="Linux, Windows" %}
To specify a blacklist and/or inclusions, edit the below settings in the Agent configuration file `stackstate.yaml` and restart StackState Agent V2.

* **Linux** - `/etc/stackstate-agent/stackstate.yaml`
* **Windows** - `C:\ProgramData\StackState\stackstate.yaml`

| Configuration item | Description |
| :--- | :--- |
| `process_blacklist.patterns` | A list of regex patterns that will exclude a process if matched. [Default patterns \(github.com\)](https://github.com/StackVista/stackstate-process-agent/blob/master/config/config_nix.go). |
| `process_blacklist.inclusions.cpu_pct_usage_threshold` | Threshold that enables the reporting of high CPU usage processes. |
| `process_blacklist.inclusions.amount_top_cpu_pct_usage` | The number of processes to report that have a high CPU usage. Default `0`. |
| `process_blacklist.inclusions.amount_top_io_read_usage` | The number of processes to report that have a high IO read usage. Default `0`. |
| `process_blacklist.inclusions.amount_top_io_write_usage` | The number of processes to report that have a high IO write usage. Default `0`. |
| `process_blacklist.inclusions.mem_usage_threshold` | Threshold that enables the reporting of high memory usage processes. |
| `process_blacklist.inclusions.amount_top_mem_usage` | The number of processes to report that have a high memory usage. Default `0`. |
{% endtab %}
{% endtabs %}

## Disable Agent features

Certain features of the Agent can optionally be turned off if they are not needed.

{% tabs %}
{% tab title="Docker, Kubernetes, OpenShift" %}
To disable a feature, set the associated environment variable and restart StackState Agent V2.

| Environment variable | Description |
| :--- | :--- |
| `STS_PROCESS_AGENT_ENABLED` | Default `true` \(collects containers and processes\). Set to `false` to collect only containers, or `disabled` to disable the process Agent. |
| `STS_APM_ENABLED` | Default `true`. Set to `"false"` to disable the APM Agent. |
| `STS_NETWORK_TRACING_ENABLED` | Default `true`. Set to `false` to disable the network tracer. |
{% endtab %}

{% tab title="Linux, Windows" %}
To disable a feature, edit the below settings in the Agent configuration file `stackstate.yaml` and restart StackState Agent V2.

* **Linux** - `/etc/stackstate-agent/stackstate.yaml`
* **Windows** - `C:\ProgramData\StackState\stackstate.yaml`

| Configuration item | Description |
| :--- | :--- |
| `process_config.enabled` | Default `true` \(collects containers and processes\). Set to `false` to collect only containers, or `disabled` to disable the process Agent. |
| `apm_config.enabled` | Default `true`. Set to `"false"` to disable the APM Agent. |
| `network_tracer_config.network_tracing_enabled` | Default `true`. Set to `false` to disable the network tracer. |
{% endtab %}
{% endtabs %}

