# What is the StackState Agent?

## Overview

The StackState Agent functions as a collector and gateway. It connects to external systems to retrieve data and pushes this to StackState.

## Where to deploy the StackState Agent

The StackState Agent can run on Linux or Windows systems or inside a Docker container. To collect data from Kubernetes and Openshift clusters, the dedicated Agent, cluster Agent and ClusterCheck Agents can be deployed.

It is not necessary to deploy the StackState Agent on every machine to retrieve data. Each deployed StackState Agent can run multiple checks to collect data from different external systems.

![StackState Agent](/.gitbook/assets/stackstate-agent.svg)

## Integrations via the StackState Agent

In StackState, the StackState Agent V2 StackPack includes all the settings required to integrate with a number of external systems and data from more systems can be retrieved by installing additional StackPacks in StackState. 

To integrate with an external system, an Agent must be deployed in a location that can connect to both the external system and StackState, and that an Agent integration check has been configured on the Agent. 

Documentation for the available StackState integrations, including configuration details can be found on the [StackPacks > Integrations pages](/stackpacks/integrations/).


## See also

* [StackState Agent V2 StackPack](/stackpacks/integrations/agent.md)
* Deploy StackState Agent V2 on:
    - [Docker](/setup/agent/docker.md)
    - [Kubernetes](/setup/agent/kubernetes.md)
    - [Linux](/setup/agent/linux.md)
    - [Windows](/setup/agent/windows.md)
* [StackState API-Integration Agent](/stackpacks/integrations/api-integration.md)  