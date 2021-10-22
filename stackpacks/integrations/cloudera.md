---
title: Cloudera StackPack
kind: documentation
---

# Cloudera

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the Cloudera StackPack?

The Cloudera StackPack is used to create a near real time synchronization with your Cloudera instance.

## Prerequisites

The following prerequisites need to be met:

* [StackState Agent V2](agent.md)  must be installed on a single machine which can connect to Cloudera Manager and StackState.
* A Cloudera instance must be running.

**NOTE**:- We support Cloudera version 5.11.

## Enable Cloudera integration

To enable the Cloudera check and begin collecting data from your Cloudera instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/cloudera.d/conf.yaml` to include details of your Cloudera instance:
   * **url**
   * **username** 
   * **password** - use [secrets management](../../configure/security/secrets_management.md) to store passwords outside of the configuration file.

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

       # Cloudra API version
       # mandatory
       api_version: <api_version> # v18
     ```
2. [Restart the StackState Agent\(s\)](agent.md#start-stop-restart-the-stackstate-agent) to publish the configuration changes.
3. Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

