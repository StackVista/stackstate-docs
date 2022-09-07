---
description: StackState Self-hosted v5.0.x 
---

# About the Custom Synchronization StackPack

{% hint style="warning" %}
**This page describes StackState version 5.0.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/develop/developer-guides/custom_synchronization_stackpack/custom_synchronization_stackpack).
{% endhint %}

## Overview

Building a new topology synchronization pipeline starts with the custom synchronization StackPack. The Custom Synchronization StackPack eases the setup of a custom [topology synchronization](../../../configure/topology/send-topology-data.md). It works well with [Agent checks](../agent_check/agent_checks.md) and can be a first step before making a StackPack.

## When to use the Custom Synchronization StackPack

The Custom Synchronization StackPack is meant for integrations that include a topology aspect. If your integration only has telemetry, you do not need this StackPack.

## Getting started with the Custom Synchronization StackPack

The easiest way to get started is to follow the [push-integration tutorial](../../tutorials/push_integration_tutorial.md).

## How to use the Custom Synchronization StackPack

Refer to:

* [How to connect your agent check to a StackState instance](../agent_check/connect_agent_check_with_stackstate.md)
* [How to customize topology created with the Custom Synchronization StackPack](how_to_customize_elements_created_by_custom_synchronization_stackpack.md)
* [How to configure a Custom Synchronization](how_to_configure_custom_synchronization.md)

