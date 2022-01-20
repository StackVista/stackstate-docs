---
description: StackState SaaS
---

# Zabbix

## What is the Zabbix StackPack?

The Zabbix StackPack is used to create a near real time synchronization with your Zabbix instance.

Zabbix is a [StackState curated integration](/stackpacks/integrations/about_integrations.md#stackstate-curated-integrations).

## Prerequisites

The following prerequisites need to be met:

* [StackState Agent V2](../../setup/agent/about-stackstate-agent.md) must be installed on a single machine which can connect to Zabbix and StackState.
* A Zabbix instance must be running.

**NOTE**: Zabbix versions 3 and 4 are supported.

## Enable Zabbix integration

To enable the Zabbix check and begin collecting data from your Zabbix instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/zabbix.d/conf.yaml` to include details of your Zabbix instance:
   * **url**
   * **username** 
   * **password** - use [secrets management](../../configure/security/secrets_management.md) to store passwords outside of the configuration file.

     ```text
     # Section used for global Zabbix check config
     init_config:

     instances:
     # mandatory
     - url: <url> # http://10.0.0.1/zabbix/api_jsonrpc.php

       # Read-only credentials to connect to zabbix
       # mandatory
       username: <username> # Admin
       password: <password> # zabbix
     ```
2. [Restart the StackState Agent\(s\)](../../setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2) to publish the configuration changes.
3. Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

## Release notes

**Zabbix StackPack v3.2.0 (2021-09-22)**

* Feature: Support StackState Common tags


**Zabbix StackPack v3.1.1 \(2021-04-12\)**

* Improvement: Common bumped from 2.5.0 to 2.5.1

**Zabbix StackPack v3.1.0 \(2021-04-02\)**

* Improvement: Enable auto grouping on generated views.
* Improvement: Common bumped from 2.2.3 to 2.5.0
* Improvement: StackState min version bumped to 4.3.0

**Zabbix StackPack v3.0.1 \(2020-08-18\)**

* Feature: Introduced the Release notes pop up for customer

**Zabbix StackPack v3.0.0 \(2020-08-04\)**

* Bugfix: Fix and make Component mapping function per instance to support multi-instance properly.
* Improvement: Deprecated stackpack specific layers and introduced a new common layer structure.
* Improvement: Replace resolveOrCreate with getOrCreate.

**Zabbix StackPack v2.2.2 \(2020-06-08\)**

* Bugfix: Fix typo in Zabbix component template for zabbix and add host filter in the event stream for multi-instance support.

**Zabbix StackPack v2.2.1 \(2020-04-30\)**

* Bugfix: Fix redirecting to false URL from Zabbix check function message.

**Zabbix StackPack v2.2.0 \(2020-04-10\)**

* Improvement: Updated StackPacks integration page, categories, and icons for the SaaS trial

**Zabbix StackPack v2.1.0 \(2020-03-27\)**

* Improvement: Change pre-requisite of Zabbix from AgentV1 to AgentV2

**Zabbix StackPack v2.0.2 \(2020-01-17\)** This release of the Zabbix StackPack that provides support to monitor your Cloudera Manager instance. Improvements and Bugfixes

* Bugfix: Fixing the upgrade problem from older version to new version in last StackState version.
* Improvement: Moving the instance name attribute to first parameter of input field.

NOTE:- We support Zabbix version 3 and 4.

