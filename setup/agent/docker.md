# Docker

## Overview

{% hint style="info" %}
**StackState Agent V2**
{% endhint %}

StackState Agent V2 can run in a Docker container. The Agent collects data from the host where it is running and can be configured to integrate with external systems. Retrieved data is pushed to StackState, to work with this data the [StackState Agent V2 StackPack](/stackpacks/integrations/agent.md) must be installed in your StackState instance. For details of the data retrieved and available integrations, see the [StackPack integration documentation](/stackpacks/integrations).

In Docker Swarm mode, the StackState Cluster Agent can be deployed on the manager node to retrieve topology data for the cluster.

## Setup

### Single container

To start a single Docker container with StackState Agent V2, run the following command:

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

To run StackState Agent V2 with Docker compose:

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
      STS_APM_URL: "https://your.stackstate.url/receiver/stsAgent"
      HOST_PROC: "/host/proc"
      HOST_SYS: "/host/sys"
```
   
2. Run the command:
```
docker-compose up -d
```

### Docker swarm mode

In Docker Swarm mode, the StackState Cluster Agent can be deployed on the manager node to retrieve basic topology data (services, containers and the relations between them). To retrieve full data, StackState Agent V2 must also be deployed on each node as a [Docker compose setup](#docker-compose).

To run StackState Cluster Agent in Docker Swarm mode:

1.  Create a file `docker-compose.yml` with the following content. Update with details of your StackState instance:
    - **STS_API_KEY** - the API Key for your StackState instance
    - **STS_STS_URL** - the URL of the StackState Receiver API
    - **STS_CLUSTER_NAME** - the name that will be given to this cluster in StackState
```
stackstate-agent:
    image: docker.io/stackstate/stackstate-cluster-agent:latest
    deploy:
      placement:
        constraints: [ node.role == manager ]
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /etc/passwd:/etc/passwd:ro
      - /sys/kernel/debug:/sys/kernel/debug
    environment:
      STS_API_KEY: "API_KEY"
      STS_STS_URL: "http://receiver:7077/stsAgent"
      STS_COLLECT_SWARM_TOPOLOGY: "true"
      STS_LOG_LEVEL: "debug"
      STS_LOG_TO_CONSOLE: "true"
      DOCKER_SWARM: "true"
      STS_CLUSTER_NAME: <cluster_name>
```

2. Run the command:
```
docker stack deploy -c docker-compose.yml
```

{% hint style="hint" %}
Running the StackState Cluster Agent in Docker Swarm mode will collect basic topology data from the cluster. To retrieve more data, including telemetry, StackState Agent V2 must also be installed on each node in the Swarm cluster as a [Docker compose setup](#docker-compose).
{% endhint %}

### Upgrade

To upgrade StackState Agent V2 running inside a Docker container.

1. Stop the running container and remove it.

```
docker stop stackstate-agent
docker container rm stackstate-agent
```   

2. Run the container using the instructions provided in [setup](#setup).

## Configure

### Agent configuration

The StackState Agent V2 configuration is located in the file `/etc/stackstate-agent/stackstate.yaml`. The configuration file contains the `STS_API_KEY` and `STS_STS_URL` environment variables set when the Docker command is run. No further configuration should be required, however, a number of advanced configuration options are available.

### Advanced Agent configuration

#### Blacklist and inclusions

Processes reported by StackState Agent V2 can optionally be filtered using a blacklist. Using this in conjunction with inclusion rules will allow otherwise excluded processes to be included. 

The blacklist is specified as a list of regex patterns. Inclusions override the blacklist patterns, these are used to include processes that consume a lot of resources. Each inclusion type specifies an amount of processes to report as the top resource using processes. For `top_cpu` and `top_mem` a threshold must first be met, meaning that a process needs to consume a higher percentage of resources than the specified threshold before it is reported.

To specify a blacklist and/or inclusions, set the below environment variables and restart StackState Agent V2.

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

Certain features of the Agent can optionally be turned off if they are not needed. To disable a feature, set the below environment variables and restart StackState Agent V2.

| Environment variable | Description |
|:---|:---|
| `STS_PROCESS_AGENT_ENABLED` | Default `true` (collects containers and processes). Set to `false` to collect only containers, or `disabled` to disable the process Agent.|
| `STS_APM_ENABLED` | Default `true`. Set to `"false"` to disable the APM Agent. |
| `STS_NETWORK_TRACING_ENABLED` | Default `true`. Set to `false` to disable the network tracer. |

### Integration configuration

StackState Agent V2 can be configured to run checks that integrate with external systems. Each integration has its own configuration file that is used by the associated Agent check. Configuration files for integrations that will run through the StackState Agent in Docker should be added as a volume to the directory `/etc/stackstate-agent/conf.d/` when the container is started.

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
      - "/etc/stackstate-agent/conf.d/servicenow.d/conf.yaml:/servicenow.d/conf.yaml:ro"
    environment:
      STS_API_KEY: "API_KEY"
      STS_STS_URL: "https://your.stackstate.url/receiver/stsAgent"
      HOST_PROC: "/host/proc"
      HOST_SYS: "/host/sys"
```

Documentation for the available StackState integrations, including how to configure the associated Agent checks, can be found on the [StackPacks > Integrations pages](/stackpacks/integrations/).

### Self-Signed Certificates

If StackState Agent V2 will run checks that are configured to use self-signed certificates for HTTPs requests, override the `CURL_CA_BUNDLE` environment variable:

```
  CURL_CA_BUNDLE = ""
```

### Traces

StackState Agent V2 can be configured to collect traces via a [StackState tracing integration](/configure/traces/how_to_setup_traces.md#2-configure-tracing-integrations). If the Agent will be used in conjunction with a language specific trace client, make sure to configure your app to use the host’s PID namespace:

```
  service:
    ...
    pid: "host" # should match with processes reported by the StackState process Agent
    ...
```

## Commands

It is not possible to directly manage the service inside the running Docker container. 

To start, stop or restart StackState Agent V2, start or stop the container it is running in:

```
# Start container
docker start stackstate-agent

# Stop container
docker stop stackstate-agent
```

For status information, refer to the log files.

## Troubleshooting

### Log files

Docker logs for the StackState Agent container can be followed using the command:

```
docker logs -f stackstate-agent
```

Inside the running container, StackState Agent V2 logs are in the following files:

* `/var/log/stackstate-agent/agent.log`
* `/var/log/stackstate-agent/process-agent.log`

### Set log level

To troubleshoot the StackState Agent container, set the logging level to `debug` using the `STS_LOG_LEVEL` environment variable:
```
STS_LOG_LEVEL: "DEBUG"
```

### Support knowledge base

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

## Uninstall

To uninstall StackState Agent V2, stop the Docker container it is running in and remove it.

```
docker stop stackstate-agent
docker container rm stackstate-agent
```   

## See also

* [About the StackState Agent](/setup/agent/about-stackstate-agent.md)
* [StackState Agent V2 StackPack](/stackpacks/integrations/agent.md)
* [StackPack integration documentation](/stackpacks/integrations)
* [StackState Agent V2 \(github.com\)](https://github.com/StackVista/stackstate-agent)