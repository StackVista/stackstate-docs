---
description: StackState curated integration
---

# Docker

## Overview

The StackState Agent can run in a Docker container.  The Agent collects data from the host where it is running and can be configured to integrate with external systems. Retrieved data is pushed to StackState via the [StackState Agent StackPack](/stackpacks/integrations/agent.md). For details of the data retrieved and available integrations, see the [StackPack integration documentation](/stackpacks/integrations).

The StackState Agent is open source, code is available on GitHub at: [https://github.com/StackVista/stackstate-agent](https://github.com/StackVista/stackstate-agent).

## Setup

### Supported versions


### Install

To run the StackState Agent as a docker container, use the following configuration:

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

### Docker-Swarm mode

{% hint style="warning" %}
**Limitation of Docker-Swarm mode**

Some specific features are not supported in Docker-Swarm mode. This limitation prevents StackState Agent from collecting relations between containers, processes and other resources while in Docker-Swarm mode.
{% endhint %}

To run the StackState Agent in Docker-Swarm mode, use a docker-compose setup:

1. Add the [Docker install](#install) configuration in your compose file on each node where you want to run the Agent. 
2. Run the command:
```docker-compose up -d```

### Upgrade


## Configure

### Agent configuration

### Advanced Agent configuration

Process reported by the StackState Agent can be filtered using a blacklist. Using it in conjunction with the inclusion rules will include otherwise excluded processes.

| Parameter | Mandatory | Default Value | Description |
|-----------|-----------|---------------|-------------|
| `STS_PROCESS_BLACKLIST_PATTERNS` | no | [see github](https://github.com/StackVista/stackstate-process-agent/blob/master/config/config_nix.go) | A list of regex patterns that will exclude a process if matched |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_CPU` | no | 0 | Number of processes to report that have a high CPU usage |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_IO_READ` | no | 0 | Number of processes to report that have a high IO read usage |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_IO_WRITE` | no | 0 | Number of processes to report that have a high IO write usage |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_MEM` | no | 0 | Number of processes to report that have a high Memory usage |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_CPU_THRESHOLD` | no |  | Threshold that enables the reporting of high CPU usage processes |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_MEM_THRESHOLD` | no |  | Threshold that enables the reporting of high Memory usage processes |

Certain features of the agent can be turned off if not needed:

| Parameter | Mandatory | Default Value | Description |
|-----------|-----------|---------------|-------------|
| `STS_PROCESS_AGENT_ENABLED` | no | True | Whenever process agent should be enabled |
| `STS_APM_ENABLED` | no | True | Whenever trace agent should be enabled |
| `STS_NETWORK_TRACING_ENABLED` | no | True | Whenever network tracer should be enabled |

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
      STS_PROCESS_AGENT_URL: "https://your.stackstate.url/receiver/stsAgent"
      STS_PROCESS_AGENT_ENABLED: "true"
      STS_NETWORK_TRACING_ENABLED: "true"
      STS_APM_URL: "https://your.stackstate.url/receiver/stsAgent"
      STS_APM_ENABLED: "true"
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