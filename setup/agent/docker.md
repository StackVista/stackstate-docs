---
description: StackState curated integration
---

# Docker

## Overview

The StackState Agent can run in a Docker container.  The Agent collects data from the host where it is running and can be configured to integrate with external systems. Retrieved data is pushed to StackState via the [StackState Agent StackPack](/stackpacks/integrations/agent.md). For details of the data retrieved and available integrations, see the [StackPack integration documentation](/stackpacks/integrations).

The StackState Agent is open source, code is available on GitHub at: [https://github.com/StackVista/stackstate-agent](https://github.com/StackVista/stackstate-agent).

## Setup

### Single container

To start a single Docker container with StackState Agent, run the following command:

```
docker run -d \
    --name stackstate-agent \
    --privileged \
    --network="host" \
    --pid="host" \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v /proc/:/host/proc/:ro \
    -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
    -e STS_API_KEY="API_KEY" \
    -e STS_STS_URL="https://your.stackstate.url/receiver/stsAgent" \
    -e HOST_PROC="/host/proc" \
    -e HOST_SYS="/host/sys" \
    docker.io/stackstate/stackstate-agent-2:latest
```

### Docker compose

To run the StackState Agent with Docker compose:

1. Add the following configuration to the compose file on each node where the Agent will run:
```
stackstate-agent:
    image: docker.io/stackstate/stackstate-agent-2:latest
    network_mode: "host"
    pid: "host"
    privileged: true
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - "/proc/:/host/proc/:ro"
      - "/sys/fs/cgroup/:/host/sys/fs/cgroup:ro"
      - "/etc/passwd:/etc/passwd:ro"
      - "/sys/kernel/debug:/sys/kernel/debug"
    environment:
      STS_API_KEY: "API_KEY"
      STS_STS_URL: "https://your.stackstate.url/receiver/stsAgent"
          STS_PROCESS_AGENT_URL: "https://your.stackstate.url/receiver/stsAgent"
          STS_PROCESS_AGENT_ENABLED: "true"
          STS_NETWORK_TRACING_ENABLED: "true"
          STS_APM_URL: "https://your.stackstate.url/receiver/stsAgent"
          STS_APM_ENABLED: "true"
      HOST_PROC: "/host/proc"
      HOST_SYS: "/host/sys"
```
   
2. Run the command:
```
docker-compose up -d
```

### Docker swarm mode

{% hint style="warning" %}
**Limitation of Docker-Swarm mode**

Some specific features are not supported in Docker swarm mode. This limitation prevents StackState Agent from collecting relations between containers, processes and other resources while in Docker swarm mode.

To run the StackState Agent in Docker swarm mode, use a [Docker compose setup](#docker-compose).
{% endhint %}

### Upgrade


## Configure

### Agent configuration

The StackState Agent configuration is located in the file `/etc/stackstate-agent/stackstate.yaml`. The `STS_API_KEY` and `STS_STS_URL` environment variables set when the Docker command is run will be added here. No further configuration should be required, however, a number of advanced configuration options are available.

### Advanced Agent configuration

#### Blacklist and inclusions

Processes reported by the StackState Agent can optionally be filtered using a blacklist. Using this in conjunction with inclusion rules will allow otherwise excluded processes to be included. 

The blacklist is specified as a list of regex patterns. Inclusions override the blacklist patterns, these are used to include processes that consume a lot of resources. Each inclusion type specifies an amount of processes to report as the top resource using processes. For `top_cpu` and `top_mem` a threshold must first be met, meaning that a process needs to consume a higher percentage of resources than the specified threshold before it is reported.

To specify a blacklist and/or inclusions, set the below environment variables and restart the StackState Docker Agent.

| Environment variable | Description |
|:---|:---|
| `STS_PROCESS_BLACKLIST_PATTERNS` | A list of regex patterns that will exclude a process if matched. [Default patterns \(github.com\)](https://github.com/StackVista/stackstate-process-agent/blob/master/config/config_nix.go).  |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_CPU_THRESHOLD` | Threshold that enables the reporting of high CPU usage processes. |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_CPU` | The number of processes to report that have a high CPU usage. Default `0`. |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_IO_READ` | The number of processes to report that have a high IO read usage. Default `0`. |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_IO_WRITE` | The number of processes to report that have a high IO write usage. Default `0`. |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_MEM_THRESHOLD` | Threshold that enables the reporting of high Memory usage processes. |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_MEM` | The number of processes to report that have a high memory usage. Default `0`. |

#### Disable Agent features

Certain features of the Agent can optionally be turned off if they are not needed. To disable a feature, set the below environment variables and restart the StackState Docker Agent.

| Environment variable | Description |
|:---|:---|
| `STS_PROCESS_AGENT_ENABLED` | Default `true` (collects containers and processes). Set to `false` to collect only containers, or `disabled` to disable the process Agent.|
| `STS_APM_ENABLED` | Default `true`. Set to `"false"` to disable the APM Agent. |
| `STS_NETWORK_TRACING_ENABLED` | Default `true`. Set to `false` to disable the network tracer. |

### Integration configuration

The Agent can be configured to run checks that integrate with external systems. Each integration has its own configuration file that is used by the associated Agent check. Configuration files for integrations run through the StackState Agent in Docker should be added as a volume to the directory `/etc/stackstate-agent/conf.d/` in the container where the Agent is running.

For example, the Agent Docker configuration below includes a volume with a check configuration file for the ServiceNow integration:

```
stackstate-agent:
    image: docker.io/stackstate/stackstate-agent-2:latest
    network_mode: "host"
    pid: "host"
    privileged: true
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - "/proc/:/host/proc/:ro"
      - "/sys/fs/cgroup/:/host/sys/fs/cgroup:ro"
      - "/etc/passwd:/etc/passwd:ro"
      - "/sys/kernel/debug:/sys/kernel/debug"
      - "/etc/stackstate-agent/conf.d/servicenow.d/conf.yaml:/servicenow.d/conf.yaml"
    environment:
      STS_API_KEY: "API_KEY"
      STS_STS_URL: "https://your.stackstate.url/receiver/stsAgent"
      HOST_PROC: "/host/proc"
      HOST_SYS: "/host/sys"
```

Documentation for the available StackState integrations, including configuration details can be found on the [StackPacks > Integrations pages](/stackpacks/integrations/).

### Self-Signed Certificates

If checks running on the Agent will be configured to use self-signed certificates for HTTPs requests, the following environment variable should be overwritten:

```
  CURL_CA_BUNDLE = ""
```

### Traces

The StackState Agent can be configured to collect traces via a [StackState tracing integration](s/configure/traces/how_to_setup_traces.md#2-configure-tracing-integrations). When using the StackState Agent running on Docker in conjunction with one of our language specific trace clients, make sure to configure your app to use the host’s PID namespace:

```
  service:
    ...
    pid: "host" # should match with processes reported by the StackState process Agent
    ...
```

## Commands

### Start, stop or restart the Agent

### Status and information

## Troubleshooting

### Set log level

To troubleshoot the StackState Agent container, set the logging level to `debug` using the `STS_LOG_LEVEL` environment variable:
```
STS_LOG_LEVEL: "DEBUG"
```

### Support knowledge base

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

## Uninstall



## Release notes

## See also