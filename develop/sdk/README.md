---
title: Integration SDK
kind: documentation
description: StackStates
---

# Developing integrations

StackState is an open platform that allows anyone to connect external systems to StackState using integrations. These integrations are packaged in [StackPacks](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/integrations/introduction/README.md). Read on to find out how you can connect StackState to your own tools.

## Background

StackState creates a real-time, always up-to-date map of your IT landscape. This landscape is expressed in a model, called the **4T data model**. StackState's functionality uses the data in the 4T data model, no matter the source of the data.

**StackPacks and Integrations** connect external systems to StackState and deliver data for one or more of the `T`s in the model \(Topology, Telemetry, Traces\). The fourth `T`, Time, applies to all types of data.

Read the [background article on the 4T data model](https://www.stackstate.com/product/under-the-hood/) to understand the types of data that integrations can deliver.

## Data types

Before creating a new integration, you need to decide the type\(s\) of data the integration will deliver. This depends on the types of data available in the source system.

For example, a CMDB is a registry of \(physical or virtual\) IT components within your IT landscape. It can serve as a source of _Topology_ information for StackState. Each IT asset in the CMDB can be represented as a _component_ and connections between the assets as a _relation_.

In another example, a service such as AWS CloudWatch can serve as a _Telemetry_ source. CloudWatch registers metrics about AWS resources and each of the metrics CloudWatch tracks can be registered in StackState.

Some systems can be a source for multiple types of data. Kubernetes, for instance, can be a source for both _Topology_ \(containers, pods, clusters and their relations\) as well as _Telemetry_ \(metrics about pod performance, among others\).

## Planning a new integration

In StackState, telemetry is **always** mapped onto a component or relation. When creating a new integration, you should therefore always start with topology and add telemetry later.

If your integration is working, you can package it as a StackPack for distribution and installation.

## Integrating topology

Topology data sent to StackState is processed in a number of steps which result in components and relations. The easiest way to get started is to use StackState's [default topology synchronization](../../configure/default_topology_synchronization.md) mechanism, which does a lot of the heavy lifting for you, provided you can deliver data in a pre-determined JSON format.

If you don't have the option to do this, you can create a [custom synchronization](../../integrations/available_stackpacks/customsync.md) from scratch.

## Integrating telemetry

Telemetry data can be pushed to StackState using a JSON data format. This [telemetry guide](../../configure/send_telemetry.md) explains how this works.

## Packaging a StackPack

If your integration works, you can package it as a StackPack. Read this [guide](../stackpack/prepare_package.md) for more information.

## Sample code

Writing a new integration is easiest if you have a sample to start with. Here are a few of our integrations that are part of our open-source [StackState agent](https://github.com/StackVista/sts-agent-integrations-core):

* [Zabbix integration](https://github.com/StackVista/sts-agent-integrations-core/blob/master/zabbix/check.py)
* [Nagios integration](https://github.com/StackVista/sts-agent-integrations-core/blob/master/nagios/check.py)

