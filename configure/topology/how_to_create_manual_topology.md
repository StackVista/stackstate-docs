---
description: >-
  Most topology in StackState is create automatically using topology
  synchronization. This section describes how you can create a topology
  manually.
---

# Create a topology manually

StackState automatically creates a topology based on real-time data sources. _There is typically no need to create a topology manually_. There may be a few exceptions:

* Business processes are typically not discoverable and may therefore be placed on top of the topology manually.
* When developing an automatic topology synchronization, creating a topology manually at first and then exporting the results is a good first step.

## Static Topology StackPack

The [Static Topology StackPack](/stackpacks/integrations/static_topology.md) can be used to import components and relations from external CSV files.

## How to create components and relations

First you need to define a component type. Go to `Settings -> Component Types -> Add Component Types`. From there you can define your own component types - the granularity is up to you. The component type consists of a `Name` field, a `Description` field \(optional\), and an Icon.

![Add component type screen](../../.gitbook/assets/add_comp_type.png)

When all required information is provided for the component type, click CREATE.

You can now use the [Static Topology StackPack](/stackpacks/integrations/static_topology.md) to import components and relations for CSV files.

## Export/import manually created topology

See [manual topology backup/restore](../../setup/data-management/backup_restore/manual_topology_backup.md).

