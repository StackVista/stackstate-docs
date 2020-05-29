---
title: How to configure a Custom Synchronization
kind: Documentation
---

# how\_to\_configure\_custom\_synchronization

Synchronizations are defined by a data source and several mappings from the external system topology data into StackState topology elements using Component and Relation Mapping Functions, as well as Component and Relation Templates. `Custom Synchronization` StackPack delivers a Synchronization called `default auto synchronization`. You can [find more on Synchronizations](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/guides/default_topology_synchronization/README.md#setting-up-an-default-synchronization) or proceed to edit `default auto synchronization` with the instructions below:

## Step 1

It is recommended that you change the `Synchronization Name` and add a `Description` if needed. There is no action required on `Plugin`, it uses the `Sts` plugin to synchronize data from the StackState Agent.

## Step 2

There is no action needed here. However, you can observe the data source, component, and relation identity extractor, as well as whether this synchronization processes historical data. The recommended setting here is to keep this setting off.

## Step 3

This is where the Component Mappings are defined. The `Custom Synchronization` StackPack defines a `default component mapping` which can be seen at the bottom of the wizard for all "Other Sources".

Here you can define all your own component mappings for different resources.

## Step 4

This is where the Relation Mappings are defined. The `Custom Synchronization` StackPack defines a `default relation mapping` which can be seen at the bottom of the wizard for all `Other Sources`.

Here you can define all your own relation mappings for different sources.

## Step 5

Verify all the changes and click "Save". On the popup dialog that appears right after saving click "Confirm" to unlock this synchronization from the `Custom Synchronizations` StackPacks.

