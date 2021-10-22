---
description: >-
  Building a new topology synchronization pipeline starts with the custom
  synchronization StackPack.
---

# Custom Synchronization StackPack

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

The Custom Synchronization StackPack is a StackPack that is meant to ease the setup of a custom [topology synchronization](../../../configure/topology/topology_synchronization.md). It works well with agent checks and can be a first step before making a StackPack.

## When to use the Custom Synchronization StackPack

The Custom Synchronization StackPack is meant for integrations that include a topology aspect. If your integration only has telemetry then you do not need this StackPack.

## Getting started with the Custom Synchronization StackPack

The easiest way to get started is to follow the [push-integration tutorial](../../tutorials/push_integration_tutorial.md).

## How to use the Custom Synchronization StackPack

Refer to:

* [How to connect your agent check to a StackState instance](how_to_connect_agent_check_with_stackstate_instance.md)
* [How to customize topology created with the Custom Synchronization StackPack](how_to_customize_elements_created_by_custom_synchronization_stackpack.md)
* [How to configure a Custom Synchronization](how_to_configure_custom_synchronization.md)

