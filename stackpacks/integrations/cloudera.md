---
description: StackState Self-hosted v4.6.x
---

# Cloudera

{% hint style="warning" %}
**This page describes StackState version 4.6.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/stackpacks/integrations/cloudera).
{% endhint %}

## What is the Cloudera StackPack?

The Cloudera StackPack is used to create a near real time synchronization with your Cloudera instance.

Cloudera is a [community integration](/stackpacks/integrations/about_integrations.md#community-integrations).

## Prerequisites

The following prerequisites need to be met:

* [StackState Agent V2](../../setup/agent/about-stackstate-agent.md) must be installed on a single machine which can connect to Cloudera Manager and StackState.
* A Cloudera instance must be running.

**NOTE**:- We support Cloudera version 5.11.

## Enable Cloudera integration

To enable the Cloudera check and begin collecting data from your Cloudera instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/cloudera.d/conf.yaml` to include details of your Cloudera instance:
   * **url**
   * **username**
   * **password**- use [secrets management](../../configure/security/secrets_management.md) to store passwords outside of the configuration file.

     ```text
     # Section used for global Cloudera check config
     init_config:

     instances:
     # mandatory
     - url: <url>
       # SSL verification
       verify_ssl: false    

       # Read-only credentials to connect to cloudera
       # mandatory
       username: <username> # Admin
       password: <password> # cloudera

       # Cloudera API version
       # mandatory
       api_version: <api_version> # v18
     ```
2. [Restart the StackState Agent\(s\)](../../setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2) to publish the configuration changes.
3. Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

## Release notes

**Cloudera StackPack v1.3.1 \(2021-04-02\)**

* Improvement: Enable auto grouping on generated views.
* Improvement: Update documentation.
* Improvement: Common bumped from 2.2.3 to 2.5.1
* Improvement: StackState min version bumped to 4.3.0


