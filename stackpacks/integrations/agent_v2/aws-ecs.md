---
description: StackState curated integration
---

# AWS ECS

## Overview

Get topology and telemetry information from an Amazon Elastic Container Service (ECS) cluster.

This integration is still in __BETA__.

## Functionality

The StackState Agent V2 provides the following functionality:

- Reporting hosts, processes, and containers
- Reporting all network connections between processes / containers including network traffic telemetry
- Telemetry for hosts, processes, and containers
- Trace agent support

## Setup

### Installation

To monitor your ECS containers and tasks run the agent as a container on every EC2 instance in your ECS cluster.

Download the manifest from the StackState UI page **StackPacks** > **AWS ECS** and edit it providing the configuration parameters provided there.

Once the manifest is ready, the agent task can be registered with the following command:

```
aws ecs register-task-definition --cli-input-json file://path/to/stackstate-agent-v2-ecs.json
```

The agent should be loaded on one container on each EC2 instance.
The way to achieve this is to run agent as a [Daemon Service \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html#service_scheduler_daemon).

Schedule a Daemon Service in AWS using StackState Agent V2 ECS Task:

1. Log in to the AWS console and navigate to the ECS Clusters section. Select the cluster you run the Agent on.
2. Create a new service by clicking the __Create__ button under Services.
3. For launch type, select EC2 then the task definition created previously.
4. For service type, select `DAEMON`, and enter a Service name. Click __Next__.
5. Since the Service runs once on each instance, you won’t need a load balancer. Select None. Click __Next__.
6. Daemon services don’t need Auto Scaling, so click __Next Step__ and then __Create Service__.


#### Integrate with Java traces

When used in conjunction with one of our language specific trace clients, eg. [StackState Java Trace Client](/stackpacks/integrations/java-apm.md) to allow automatic merging of components within StackState
make sure to configure you app to use the host’s pid namespace:

```
  "containerDefinitions": [
    {
      ...
      "pidMode": "host", # ensure pid's match with processes reported by the StackState process agent
      ...
```

#### Advanced configurations

Process blacklist can be tuned specifying values for rule that will include otherwise excluded processes:

| Parameter | Mandatory | Default Value | Description |
|-----------|-----------|---------------|-------------|
| `STS_PROCESS_BLACKLIST_PATTERNS` | no | [see GitHub](https://github.com/StackVista/stackstate-process-agent/blob/master/config/config_nix.go) | A list of regex patterns that will exclude a process if matched |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_CPU` | no | 0 | Number of processes to report that have a high CPU usage |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_IO_READ` | no | 0 | Number of processes to report that have a high IO read usage |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_IO_WRITE` | no | 0 | Number of processes to report that have a high IO write usage |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_TOP_MEM` | no | 0 | Number of processes to report that have a high Memory usage |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_CPU_THRESHOLD` | no |  | Threshold that enables the reporting of high CPU usage processes |
| `STS_PROCESS_BLACKLIST_INCLUSIONS_MEM_THRESHOLD` | no |  | Threshold that enables the reporting of high Memory usage processes |

Certain feature of the agent can be turned off if not needed:

| Parameter | Mandatory | Default Value | Description |
|-----------|-----------|---------------|-------------|
| `STS_PROCESS_AGENT_ENABLED` | no | True | Whenever process agent should be enabled |
| `STS_APM_ENABLED` | no | True | Whenever trace agent should be enabled |
| `STS_NETWORK_TRACING_ENABLED` | no | True | Whenever network tracer should be enabled |
