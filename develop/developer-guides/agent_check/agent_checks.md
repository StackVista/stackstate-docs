---
description: StackState Self-hosted v5.1.x 
---

# About Agent checks

## Overview

Agent Checks can be used to monitor a wide variety of technologies. Some examples are:

* [MySQL](/stackpacks/integrations/mysql.md)
* [Tomcat](/stackpacks/integrations/apache-tomcat.md)
* API endpoints
* [SAP](/stackpacks/integrations/sap.md)
* [VSphere](/stackpacks/integrations/vsphere.md)

An Agent check is a Python script that is executed periodically by a StackState Agent. This is an easy way to periodically pull data \(i.e. polling\) from the system you are integrating with and push it to StackState.

Code examples for the open source StackState Agent checks can be found on GitHub at [https://github.com/StackVista/stackstate-agent-integrations](https://github.com/StackVista/stackstate-agent-integrations). If you would like to create your own Agent check, a simple starting point is to begin with our [sample Agent integration \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/tree/master/agent_integration_sample).

## When to use Agent checks

Agent checks are typically the easiest way to create an integration with StackState, but it's not the only way to integrate with StackState and may not necessarily be the best way. An integration via an Agent check means:

* At least one Agent must run in the environment and have access to the system to integrate with 
* Data will be polled periodically instead of streamed directly.

Alternative integrations to the Agent check are dependent on the system being integrated, so there is no generic documentation available for alternatives. An example of an alternative integration are the AWS and Azure integration that use serverless functions to push data reactively to StackState.

## Agent check deployment

Agent checks are deployed and configured alongside the Agent using a provisioning tool used by the customer. Typically, an Agent check is meant for one of two ways of deployment:

* **Deployment model No. 1** - The Agent check pulls data from a system that is running on the same host as the Agent is deployed on. Multiple Agents are deployed; one on each host. Each deployed Agent is configured to pull data from the local host and forward it to StackState.
* **deployment model No. 2** - The Agent check pulls data from a remote system. Typically, one Agent is configured per remote system or per instance of the remote system. Based on concerns of security and cost, this Agent typically is deployed in close proximity to the remote system.

When building an Agent check you have to consider how you want your Agent check to be deployed based on concerns like performance, cost, latency, security, reliability etc.

In some cases you may even want to build two Agent checks, one for each types of deployment. The StackState Kubernetes integration is a good example of this; it gathers low-level telemetry, process information and network connections through an Agent check built for deployment model No. 1 and gathers high-level telemetry and service-level topology information via an Agent check built for deployment model No. 2.

## See also

* [How to develop Agent checks](how_to_develop_agent_checks.md)
* [Agent check API](agent-check-api.md)
* [Agent check state](agent-check-state.md)
* [Connect an Agent check with StackState using the Custom Synchronization StackPack](connect_agent_check_with_stackstate.md)
* [Developer guide - Custom Synchronization StackPack](../custom_synchronization_stackpack/)

