---
description: StackState Self-hosted v4.6.x
---

# Docker

{% hint style="warning" %}
**This page describes StackState version 4.6.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/setup/agent/docker).
{% endhint %}

## Overview

{% hint style="info" %}
**StackState Agent V2**
{% endhint %}

StackState Agent V2 can run in a Docker container. The Agent collects data from the host where it is running and can be configured to integrate with external systems. Retrieved data is pushed to StackState, to work with this data the [StackState Agent V2 StackPack](../../stackpacks/integrations/agent.md) must be installed in your StackState instance. For details of the data retrieved and available integrations, see the [StackPack integration documentation](../../stackpacks/integrations/).

In Docker Swarm mode, the StackState Cluster Agent can be deployed on the manager node to retrieve topology data for the cluster.

## Monitoring

StackState Agent V2 will synchronize the following data with StackState from the host it is running on:

* Hosts, processes, and containers
* Network connections between processes/containers/services including network traffic telemetry
* Telemetry for hosts, processes, and containers

In [Docker swarm mode](#docker-swarm-mode), StackState Cluster Agent running on the manager node will synchronize the following topology data for a Docker cluster:

* Containers
* Services
* Relations between containers and services

## Setup

### StackState Receiver API address

StackState Agent connects to the StackState Receiver API at the specified [StackState Receiver API address](/setup/agent/about-stackstate-agent.md#stackstate-receiver-api-address). The correct address to use is specific to your installation of StackState.

### Single container

To start a single Docker container with StackState Agent V2, run the following command:

```text
docker run -d \
    --name stackstate-agent \
    --privileged \
    --network="host" \
    --pid="host" \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v /proc/:/host/proc/:ro \
    -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
    -e STS_API_KEY="API_KEY" \
    -e STS_STS_URL="<stackstate-receiver-api-address>" \
    -e HOST_PROC="/host/proc" \
    -e HOST_SYS="/host/sys" \
    docker.io/stackstate/stackstate-agent-2:latest
```

### Docker compose

To run StackState Agent V2 with Docker compose:

1. Add the following configuration to the compose file on each node where the Agent will run:

   ```text
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
      STS_STS_URL: "<stackstate-receiver-api-address>"
      STS_PROCESS_AGENT_URL: "<stackstate-receiver-api-address>"
      STS_APM_URL: "<stackstate-receiver-api-address>"
      HOST_PROC: "/host/proc"
      HOST_SYS: "/host/sys"
   ```

2. Run the command:

   ```text
   docker-compose up -d
   ```

### Docker swarm mode

In Docker Swarm mode, the StackState Cluster Agent can be deployed on the manager node to retrieve basic topology data \(services, containers and the relations between them\). To retrieve full data, StackState Agent V2 must also be deployed on each node as a [Docker compose setup](docker.md#docker-compose).

To run StackState Cluster Agent in Docker Swarm mode:

1. Create a file `docker-compose.yml` with the following content. Update to include details of your StackState instance:

   * **STS\_API\_KEY** - the API Key for your StackState instance
   * **STS\_STS\_URL** - the URL of the StackState Receiver API
   * **STS\_CLUSTER\_NAME** - the name you would like to give this cluster

   ```yaml
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
         STS_STS_URL: "<stackstate-receiver-api-address>"
         STS_COLLECT_SWARM_TOPOLOGY: "true"
         STS_LOG_LEVEL: "debug"
         STS_LOG_TO_CONSOLE: "true"
         DOCKER_SWARM: "true"
         STS_CLUSTER_NAME: <cluster_name>
   ```

2. Run the command:

   ```text
   docker stack deploy -c docker-compose.yml
   ```

{% hint style="info" %}
Running the StackState Cluster Agent in Docker Swarm mode will collect basic topology data from the cluster. To retrieve more data, including telemetry, StackState Agent V2 must also be installed on each node in the Swarm cluster as a [Docker compose setup](docker.md#docker-compose).
{% endhint %}

### Upgrade

To upgrade StackState Agent V2 running inside a Docker container.

1. Stop the running container and remove it.

```text
docker stop stackstate-agent
docker container rm stackstate-agent
```

1. Run the container using the instructions provided in [setup](docker.md#setup).

## Configure

### Agent configuration

The StackState Agent V2 configuration is located in the file `/etc/stackstate-agent/stackstate.yaml`. The configuration file contains the `STS_API_KEY` and `STS_STS_URL` environment variables set when the Docker command is run. No further configuration should be required, however, a number of advanced configuration options are available.

### Advanced Agent configuration

StackState Agent V2 can be configured to reduce data production, tune the process blacklist, or turn off specific features when not needed. The required settings are described in detail on the page [advanced Agent configuration](advanced-agent-configuration.md).

### Integration configuration

StackState Agent V2 can be configured to run checks that integrate with external systems. Each integration has its own configuration file that is used by the associated Agent check. Configuration files for integrations that will run through the StackState Agent in Docker should be added as a volume to the directory `/etc/stackstate-agent/conf.d/` when the container is started.

For example, the Agent Docker configuration below includes a volume with a check configuration file for the ServiceNow integration:

```text
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
      STS_STS_URL: "<stackstate-receiver-api-address>"
      HOST_PROC: "/host/proc"
      HOST_SYS: "/host/sys"
```

Documentation for the available StackState integrations, including how to configure the associated Agent checks, can be found on the [StackPacks &gt; Integrations pages](../../stackpacks/integrations/).

### Proxy configuration

The Agent can be configured to use a proxy for HTTP and HTTPS requests. For details, see [use an HTTP/HTTPS proxy](/setup/agent/agent-proxy.md).

### Self-Signed Certificates

If StackState Agent V2 will run checks that are configured to use self-signed certificates for HTTPs requests, override the `CURL_CA_BUNDLE` environment variable:

```text
  CURL_CA_BUNDLE = ""
```

### Traces

StackState Agent V2 can be configured to collect traces via a [StackState tracing integration](../../configure/traces/set-up-traces.md#2-configure-tracing-integrations). If the Agent will be used in conjunction with a language specific trace client, make sure to configure your app to use the host’s PID namespace:

```text
  service:
    ...
    pid: "host" # should match with processes reported by the StackState process Agent
    ...
```

## Commands

### Start or stop the Agent

To start, stop or restart StackState Agent V2, start or stop the container it is running in:

```text
# Start container
docker start stackstate-agent

# Stop container
docker stop stackstate-agent
```

### Status and information

For status information, refer to the Docker log files for the container.

To run the Agent status command inside a container:

```yaml
docker exec stackstate-agent bash -c 'agent status'
```

### Manually run a check

Use the command below to manually run an Agent check.

```yaml
# Execute a check once and display the results.
docker exec stackstate-agent bash -c 'agent check <CHECK_NAME>'

# Execute a check once with log level debug and display the results.
docker exec stackstate-agent bash -c 'agent check -l debug <CHECK_NAME>'
```

## Troubleshooting

To troubleshoot the Agent, try to [check the Agent status](docker.md#status) or [manually run a check](docker.md#manually-run-a-check).

### Log files

Docker logs for the StackState Agent container can be followed using the command:

```text
docker logs -f stackstate-agent
```

Inside the running container, StackState Agent V2 logs are in the following files:

* `/var/log/stackstate-agent/agent.log`
* `/var/log/stackstate-agent/process-agent.log`

### Set log level

To troubleshoot the StackState Agent container, set the logging level to `debug` using the `STS_LOG_LEVEL` environment variable:

```text
STS_LOG_LEVEL: "DEBUG"
```

### Support knowledge base

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

## Uninstall

To uninstall StackState Agent V2, stop the Docker container it is running in and remove it.

```text
docker stop stackstate-agent
docker container rm stackstate-agent
```

## See also

* [About the StackState Agent](about-stackstate-agent.md)
* [StackState Agent V2 StackPack](../../stackpacks/integrations/agent.md)
* [StackPack integration documentation](../../stackpacks/integrations/)
* [StackState Agent V2 \(github.com\)](https://github.com/StackVista/stackstate-agent)

