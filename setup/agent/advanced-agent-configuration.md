---
description: StackState SaaS
---

# Advanced Agent configuration

## Overview

A number of advanced configuration options are available for StackState Agent V2. These can be set either in the `stackstate.yaml` configuration file \(Linux and Windows\) or using environment variables \(Docker, Kubernetes and OpenShift\).

## Reduce data production

The StackState Agent V2 collection interval can be configured. This will reduce the amount of data produced by the Agent.

{% tabs %}
{% tab title="Kubernetes, OpenShift" %}
To configure the collection interval of the Kubernetes and system level integrations, create a `values.yaml` file with the below contents and specify this when you install/upgrade StackState Agent V2. In this `values.yaml` example, the `min_collection_interval` has been set to double the default setting. This should result in a noticeable drop in the amount of data produced. If required, you can increase the interval further, however, the aim should be to find a balance between the frequency of data collection and the amount of data received by StackState: 

{% code lineNumbers="true" %}
```yaml
nodeAgent:
  config:
    override:
    - name: conf.yaml
      path: /etc/stackstate-agent/conf.d/kubelet.d
      data: |
        init_config:        
        instances:
          - min_collection_interval: 60
    - name: conf.yaml
      path: /etc/stackstate-agent/conf.d/memory.d
      data: |
        init_config:        
        instances:
          - min_collection_interval: 30
    - name: conf.yaml
      path: /etc/stackstate-agent/conf.d/cpu.d
      data: |
        init_config:        
        instances:
          - min_collection_interval: 30
    - name: conf.yaml
      path: /etc/stackstate-agent/conf.d/disk.d
      data: |
        init_config:        
        instances:
          - min_collection_interval: 30
            use_mount: false
            excluded_filesystems:
              - tmpfs
              - squashfs
    - name: conf.yaml
      path: /etc/stackstate-agent/conf.d/io.d
      data: |
        init_config:        
        instances:
          - min_collection_interval: 30
    - name: conf.yaml
      path: /etc/stackstate-agent/conf.d/load.d
      data: |
        init_config:        
        instances:
          - min_collection_interval: 30
    - name: conf.yaml
      path: /etc/stackstate-agent/conf.d/docker.d
      data: |
        init_config:        
        instances:
          - min_collection_interval: 30
    - name: conf.yaml
      path: /etc/stackstate-agent/conf.d/file_handle.d
      data: |
        init_config:        
        instances:
          - min_collection_interval: 30
    - name: auto_conf.yaml
      path: /etc/stackstate-agent/conf.d/kubernetes_state.d
      data: |
    - name: stackstate.yaml
      path: /etc/stackstate-agent
      data: |
        ## Provides autodetected defaults, for kubernetes environments,
        ## please see stackstate.yaml.example for all supported options

        # Autodiscovery for Kubernetes
        listeners:
          - name: kubelet
        config_providers:
          - name: kubelet
            polling: true
        
        process_config:
          intervals:
            container: 40
            process: 30
            connections: 30

        apm_config:
          apm_non_local_traffic: true
          max_memory: 0
          max_cpu_percent: 0

        # Use java container support

clusterAgent:
  config:
    override:
    - name: conf.yaml
      path: /etc/stackstate-agent/conf.d/kubernetes_state.d
      data: |
        cluster_check: true
        init_config:
        instances:
          - kube_state_url: http://YOUR_KUBE_STATE_METRICS_SERVICE_NAME:8080/metrics
            min_collection_interval: 60
```
{% endcode %}

Specify the `values.yaml` file during installation / upgrade of the StackState Agent with the `--values` argument:

```bash
helm upgrade --install \
--namespace stackstate \
--create-namespace \
--set-string 'stackstate.apiKey=<STACKSTATE_RECEIVER_API_KEY>' \
... (set all custom fields)
--values values.yaml
stackstate-agent stackstate/stackstate-agent
```

{% endtab %}

{% tab title="Docker" %}

To reduce data production in StackState Agent running in a Docker container:

1. Configure the `min_collection_interval` for each of the following system integrations. The default setting is `15` seconds. Doubling this value should result in a noticeable drop in the amount of data produced. If required, you can increase the interval further, however, the aim should be to find a balance between the frequency of data collection and the amount of data received by StackState: 
   - **Memory** - `/etc/stackstate-agent/conf.d/memory.d/conf.yaml`
   - **CPU** - `/etc/stackstate-agent/conf.d/cpu.d/conf.yaml`
   - **Disk** - `/etc/stackstate-agent/conf.d/disk.d/conf.yaml`
   - **Load** - `/etc/stackstate-agent/conf.d/load.d/conf.yaml`
   - **File handle** - `/etc/stackstate-agent/conf.d/file_handle.d/conf.yaml`
2. Set the intervals for process, container and connection gathering in `/etc/stackstate-agent/stackstate.yaml`:
    ```yaml
    process_config:
      intervals:
        container: 40
        process: 30
        connections: 30
    ```
3. Mount the config files as a volume into the container running the Agent as described in [Docker Agent integration configuration](/setup/agent/docker.md#external-integration-configuration).

{% endtab %}

{% tab title="Linux" %}

To reduce data production in StackState Agent running on Linux:

1. Configure the `min_collection_interval` for each of the following system integrations. The default setting is `15` seconds. Doubling this value should result in a noticeable drop in the amount of data produced. If required, you can increase the interval further, however, the aim should be to find a balance between the frequency of data collection and the amount of data received by StackState: 
   - **Memory** - `/etc/stackstate-agent/conf.d/memory.d/conf.yaml`
   - **CPU** - `/etc/stackstate-agent/conf.d/cpu.d/conf.yaml`
   - **Disk** - `/etc/stackstate-agent/conf.d/disk.d/conf.yaml`
   - **Load** - `/etc/stackstate-agent/conf.d/load.d/conf.yaml`
   - **File handle** - `/etc/stackstate-agent/conf.d/file_handle.d/conf.yaml`
2. Set the intervals for process, container and connection gathering in `/etc/stackstate-agent/stackstate.yaml`:
    ```yaml
    process_config:
      intervals:
        container: 40
        process: 30
        connections: 30
    ```

{% endtab %}

{% tab title="Windows" %}

To reduce data production in StackState Agent running on Windows:

1. Configure the `min_collection_interval` for each of the following system integrations. The default setting is `15` seconds. Doubling this value should result in a noticeable drop in the amount of data produced. If required, you can increase the interval further, however, the aim should be to find a balance between the frequency of data collection and the amount of data received by StackState: 
   - **Memory** - `C:\ProgramData\StackState\conf.d\memory.d\conf.yaml`
   - **CPU** - `C:\ProgramData\StackState\conf.d\cpu.d\conf.yaml`
   - **Disk** - `C:\ProgramData\StackState\conf.d\disk.d\conf.yaml`
   - **Load** - `C:\ProgramData\StackState\conf.d\load.d\conf.yaml`
   - **File handle** - `C:\ProgramData\StackState\conf.d\file_handle.d\conf.yaml`
2. Set the intervals for process, container and connection gathering in `C:\ProgramData\StackState\stackstate.yaml`:
    ```yaml
    process_config:
      intervals:
        container: 40
        process: 30
        connections: 30
    ```

{% endtab %}

{% endtabs %}

## Use a proxy for HTTP/HTTPS

The Agent can be configured to use a proxy for HTTP and HTTPS requests. For details, see [use an HTTP/HTTPS proxy](/setup/agent/agent-proxy.md).


## Blacklist and inclusions

Processes reported by StackState Agent V2 can optionally be filtered using a blacklist. Using this in conjunction with inclusion rules will allow otherwise excluded processes to be included.

The blacklist is specified as a list of regex patterns. Inclusions override the blacklist patterns, these are used to include processes that consume a lot of resources. Each inclusion type specifies an amount of processes to report as the top resource using processes. For `top_cpu` and `top_mem` a threshold must first be met, meaning that a process needs to consume a higher percentage of resources than the specified threshold before it's reported.

{% tabs %}
{% tab title="Docker, Kubernetes, OpenShift" %}
To specify a blacklist or inclusions, set the associated environment variables and restart StackState Agent V2.

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
To specify a blacklist or inclusions, edit the below settings in the Agent configuration file `stackstate.yaml` and restart StackState Agent V2.

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

## Enable traces

The trace Agent will be enabled by default when StackState Agent is installed. It's required to receive traces in StackState. In case it has been disabled, you can enable it again using the instructions below.

{% tabs %}
{% tab title="Docker" %}
To enable tracing on StackState Agent running on Docker, edd the following parameters to your `docker run` command:
- `-e STS_APM_URL="https://stackstate-ip:receiver-port/stsAgent"`
  - The default StackState Receiver port is `7077`.
- `-e STS_APM_ENABLED="true"`
  - Allows the StackState Trace Agent to capture traces.
{% endtab %}
{% tab title="Linux" %}
To enable tracing on StackState Agent running on Linux, edit the configuration file `/etc/stackstate-agent/stackstate.yaml`and set the following variables:
- `apm_sts_url="https://stackstate-ip:receiver-port/stsAgent"`
  - The default StackState Receiver port is `7077`.
- `enabled="true"`
  - Can be found under `apm_config.enabled`.
  - Allows the StackState Trace Agent to capture traces.
{% endtab %}
{% tab title="Windows" %} 
To enable tracing on StackState Agent running on Windows, edit the configuration file `C:\ProgramData\StackState\stackstate.yaml` and change the following variables:
- `apm_sts_url="https://stackstate-ip:receiver-port/stsAgent"`
  - The default StackState Receiver port is `7077`.
- `enabled="true"`
  - Can be found under `apm_config.enabled`.
  - Allows the StackState Trace Agent to capture traces.
{% endtab %}
{% endtabs %}

## Disable Agent features

Certain features of the Agent can optionally be turned off if they aren't needed.

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

