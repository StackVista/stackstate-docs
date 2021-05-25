# Docker

## Overview

Get topology and telemetry information while running the agent as a docker container.

## Functionality

The StackState Agent V2 provides the following functionality:

- Reporting hosts, processes, and containers
- Reporting all network connections between processes/containers/services including network traffic telemetry
- Telemetry for hosts, processes, and containers
- Trace agent support

## Setup

### Installation

#### Install Step

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
      STS_API_KEY: "{{config.apiKey}}"
      STS_STS_URL: "{{config.baseUrl}}/stsAgent"
      STS_PROCESS_AGENT_URL: "{{config.baseUrl}}/stsAgent"
      STS_PROCESS_AGENT_ENABLED: "true"
      STS_NETWORK_TRACING_ENABLED: "true"
      STS_APM_URL: "{{config.baseUrl}}/stsAgent"
      STS_APM_ENABLED: "true"
      HOST_PROC: "/host/proc"
      HOST_SYS: "/host/sys"
```
### Using Docker-Swarm mode
To run the StackState Agent in Docker-Swarm mode as a docker-compose setup, use the above configuration in your compose file on each node where you want to run the Agent. After placing the compose file on each node, run the command `docker-compose up -d`.

#### Limitation of Docker-Swarm mode
Some specific features are not supported in Docker-Swarm mode. This limitation prevents StackState Agent from collecting relations between Containers, Processes and other resources while in Docker-Swarm mode. To run StackState Agent in Docker-Swarm mode, use a docker-compose setup.

### Using Self-Signed Certificate

When checks are being configured to use self-signed certificate for https requests, then the following environment variable should be overwritten:

```
  CURL_CA_BUNDLE = ""
```

### Integrate with traces

When used in conjunction with one of our language specific trace clients, e.g. [StackState Java Trace Client](/#/stackpacks/stackstate-agent-v2/java) / [StackState Dotnet Trace Client](/#/stackpacks/stackstate-agent-v2/dotnet)  to allow automatic merging of components within StackState make sure to configure your app to use the host’s pid namespace:

```
  service:
    ...
    pid: "host" # ensure pid's match with processes reported by the StackState process agent
    ...
```

#### Advanced configurations

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

## Troubleshooting

To troubleshoot the StackState Agent container, set the logging level to `debug` using the `STS_LOG_LEVEL` environment variable:
```
STS_LOG_LEVEL: "DEBUG"
```
