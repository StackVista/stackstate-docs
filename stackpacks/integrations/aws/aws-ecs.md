---
description: StackState Self-hosted v4.6.x
---

# AWS ECS

## Overview

Get topology and telemetry information from an Amazon Elastic Container Service \(ECS\) cluster.

AWS ECS is a [StackState core integration](/stackpacks/integrations/about_integrations.md#stackstate-core-integrations "StackState Self-Hosted only").

## Functionality

The StackState Agent V2 provides the following functionality:

* Reporting hosts, processes, and containers
* Reporting all network connections between processes / containers including network traffic telemetry
* Telemetry for hosts, processes, and containers
* Trace agent support

## Setup

### Installation

To monitor your ECS containers and tasks run the agent as a container on every EC2 instance in your ECS cluster.

Download the manifest from the StackState UI page **StackPacks** &gt; **AWS ECS** and edit it providing the configuration parameters provided there.

Once the manifest is ready, the agent task can be registered with the following command:

```text
aws ecs register-task-definition --cli-input-json file://path/to/stackstate-agent-v2-ecs.json
```

The agent should be loaded on one container on each EC2 instance. The way to achieve this is to run agent as a [Daemon Service \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html#service_scheduler_daemon).

Schedule a Daemon Service in AWS using StackState Agent V2 ECS Task:

1. Log in to the AWS console and navigate to the ECS Clusters section. Select the cluster you run the Agent on.
2. Create a new service by clicking the **Create** button under Services.
3. For launch type, select EC2 then the task definition created previously.
4. For service type, select `DAEMON`, and enter a Service name. Click **Next**.
5. Since the Service runs once on each instance, you won’t need a load balancer. Select None. Click **Next**.
6. Daemon services don’t need Auto Scaling, so click **Next Step** and then **Create Service**.

#### Integrate with Java traces

When used in conjunction with one of our language specific trace clients, eg. [StackState Java Trace Client](../java-apm.md) to allow automatic merging of components within StackState make sure to configure you app to use the host’s pid namespace:

```text
  "containerDefinitions": [
    {
      ...
      "pidMode": "host", # ensure pid's match with processes reported by the StackState process agent
      ...
```

#### Advanced Agent configurations

The Agent can be configured to tune the process blacklist, or turn off specific features when not needed. For details, see [advanced Agent configuration](/setup/agent/advanced-agent-configuration.md).
