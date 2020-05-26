---
title: API Integration StackPack
kind: documentation
---

# API integration

## What is the API-Integration StackPack?

The StackState API-Integration StackPack enables the StackState synchronization for the StackState's API-Integration Agents.

With API-Integration Agents you can run checks which connect to external systems like [ServiceNow](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/integrations/servicenow/README.md).

The StackState API-Integration Agent is open source: [view the source code on GitHub](https://github.com/StackVista/sts-agent).

## Installation

Install the API-Integration StackPack by using the following sequence of steps:

1. [Download the API-Integration Agent from Bintray](https://dl.bintray.com/stackstate-agent/stackstate-agent-deb-repo/pool/s/stackstate-agent/stackstate-agent_1.2.18-1_amd64.deb)

   Alternatively run this command on the machine where you wish to install the Agent:

   ```text
    wget 'https://dl.bintray.com/stackstate-agent/stackstate-agent-deb-repo/pool/s/stackstate-agent/stackstate-agent_1.2.18-1_amd64.deb'
   ```

2. Use `dpkg` to install the Agent

   ```text
    dpkg -i stackstate-agent_1.2.18-1_amd64.deb
   ```

3. Set the following keys in the stackstate.conf.example file:

   ```text
    api_key: {{config.apiKey}}
    dd_url: {{config.baseUrl}}/stsAgent
   ```

   After this the example configuration can be used as configuration.

   ```text
    cp /etc/sts-agent/stackstate.conf.example /etc/sts-agent/stackstate.conf
   ```

If you're still having trouble, our [support team](https://support.stackstate.com/hc/en-us) will be glad to provide further assistance.

