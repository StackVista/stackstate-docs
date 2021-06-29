# What is the StackState Agent?

## Overview

The StackState Agent functions as a collector and gateway. It connects to external systems to retrieve data and pushes this to StackState.

## StackState Agent architecture

The StackState Agent can run on Linux or Windows systems or inside a Docker container. It is not necessary to deploy the StackState Agent on every machine to retrieve data. Each deployed StackState Agent can run multiple checks to collect data from different external systems.

To collect data from Kubernetes and OpenShift clusters, the dedicated Agent, cluster Agent and ClusterCheck Agents can be deployed.

![StackState Agent architecture](/.gitbook/assets/stackstate-agent.svg)

## Integrate with external systems

In StackState, the StackState Agent V2 StackPack includes all the settings required to integrate with a number of external systems. Data from other external systems can be retrieved by installing additional StackPacks in StackState. 

To integrate with an external system, an Agent must be deployed in a location that can connect to both the external system and StackState. An Agent check  configured on the Agent can then connect to the external system to retrieve data. 

Documentation for the available StackState integrations, including how to configure the associated Agent checks, can be found on the [StackPacks > Integrations pages](/stackpacks/integrations/).

## Open source

The StackState Agent is open source and can be found on GitHub at: [https://github.com/StackVista/stackstate-agent](https://github.com/StackVista/stackstate-agent).

## Release notes

Release notes for the StackState Agent can be found on GitHub at: [https://github.com/StackVista/stackstate-agent/blob/master/stackstate-changelog.md](https://github.com/StackVista/stackstate-agent/blob/master/stackstate-changelog.md)

## See also

* [StackState Agent V2 StackPack](/stackpacks/integrations/agent.md)
* [StackState integrations](/stackpacks/integrations/)  
* Deploy StackState Agent V2 on:
    - [Docker](/setup/agent/docker.md)
    - [Kubernetes](/setup/agent/kubernetes.md)
    - [Linux](/setup/agent/linux.md)
    - [Windows](/setup/agent/windows.md)
* [StackState Agent V1 (Legacy)](/setup/agent/agent-v1.md)  
* [StackState Agent on GitHub \(github.com\)](https://github.com/StackVista/stackstate-agent)