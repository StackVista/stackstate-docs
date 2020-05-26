---
title: Agent checks
kind: Documentation
sidebar:
  nav:
    - header: References
    - text: How to develop agent checks
      href: /develop/agent_check/how_to_develop_agent_checks/
    - text: Agent v2 check reference
      href: /develop/agent_check/checks_in_agent_v2
---

# index

Agent checks are Python scripts that are periodically executed by an agent. They are an easy way to periodically pull data \(i.e. polling\) from the system you are integrating with and push it to StackState.

## When to use agent checks

Agent checks are typically the easiest way to create an integration with StackState, but it is not the only way to integrate with StackState and may not necessarily be the best way. An integration via an agent check means that the user of the integration will have to run at least one agent in their environment that can access the system to integrate and that data will be polled periodically instead of streamed directly.

Alternative integrations to the agent check are dependent on the system under integration, so there is no generic documentation available for alternatives. An example of an alternative integration are the AWS and Azure integration that use serverless functions to push data reactively to StackState.

## Agent check deployment

Agent checks are deployed and configured alongside the agent using a provisioning tool used by the customer. Typically an agent check is meant for one of two ways of deployment:

1. The agent check pulls data from a system that is running on the same host as the agent is deployed on. Multiple agents are deployed; one on each host. Each deployed agent is configured to pull data from the local host and forward it to StackState.
2. The agent check pulls data from a remote system. Typically one agent is configured per remote system or per instance of the remote system. Based on concerns of security and cost this agent typically is deployed in close proximity to the remote system.

When building an agent check you have to consider how you want your agent check to be deployed based on concerns like performance, cost, latency, security, reliability, etc.

In some cases you may even want to build two agent checks, one for each types of deployment. The StackState Kubernetes integration is a good example of this; it gather both low-level telemetry, process information and network connections through an agent check build for deployment model No. 1 and gathers high-level telemetry and service-level topology information via an agent check build for deployment model No. 2.

## How to create an agent check

Refer to:

* [How to create checks with agent v2](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/develop/agent_check/how_to_develop_agent_checks/README.md). 
* [Agent v2 check reference](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/develop/agent_check/checks_in_agent_v2/README.md)

