---
description: StackState Self-hosted v4.5.x
---

# How to customize elements created by the Custom Synchronization StackPack

## 1. Configure Layers, Domains, and Environments

Once you have installed the Custom Synchronization StackPack, you need to start preparing the configuration for your integration.

There are some default Layers, Domains, and Environments created by StackState. Layers are used for vertical separation between components; Domains are used for horizontal separation between components; Environments are grouping components. You can add custom Layers, Domains, and Environments in the Settings pages to match your StackPack needs.

These can also be created automatically by StackState using the `getOrCreate` functionality described alongside Component and Relation Templates below.

## 2. Configure Component and Relation types

There are some default component and relation types in StackState. Component types are used to visualize components with a given icon; Relation types are here to describe relations between components. 

➡️ [Learn more about Component and Relation types](../../../use/concepts/components_relations.md).

Component types and Relation types can also be created automatically by StackState using the `getOrCreate` functionality described in the `Configure Component and Relation Templates` section below. Auto-generated components types will be created without an icon.

## 3. Configure Component and Relation Templates

Once you have installed the `Custom Synchronization` StackPack, it creates a Component Template called `autosync-component-template`. Similarly, `Custom Synchronization` StackPack, creates a Relation Template called `autosync-relation-template`.

You can go ahead and rename it, add a description if needed. It is recommended to change the default value of the `ComponentType` from `Auto-synced Component` to something that represents a generic component in your data source. The same goes for `Layer`, `Domain` and `Environment` which defaults to `Auto-synced Components`, `Auto-synced Domain`,`Auto-synced Environment` respectively. As this template is using the `getOrCreate` functionality, these values are auto-created by StackState if they don't already exist. [Find more on Templates](../../reference/stj/using_stj.md).

The `getOrCreate` function tries to resolve a node by first its identifier and then by the fallback create-identifier. If it can't find any it'll create it using the type and name argument and it'll identify the newly created node with the create-identifier value.

```text
getOrCreate <identifier> <create-identifier> Type=<type>;Name=<name>
```

Once you have completed all the changes, you can click on `update` and confirm the popup dialog to unlock this Template from the `Custom Synchronization` StackPack.

## 4. Prepare Id Extractor Functions

When creating an integration, or a StackPack, it is important to have a `component` and `relation` identity extractor function. There are a few default Id Extractor Functions present in StackState. The `Auto sync component id extractor` and `Auto sync relation id extractor` are good starting points for your StackPack. You can go ahead and rename these, add a description if needed, and confirm the popup dialog to unlock these Id Extractor Functions from the `Custom Synchronization` StackPack.

You can find more on [Id Extractors page](../custom-functions/id-extractor-functions.md).

## 5. Configure Sts Sources - Topology Sources

Once you have installed the `Custom Synchronization` StackPack, it creates a StackState DataSource called `Internal kafka`. This data source is a good starting point for your StackPack. You can change the name of it, add a description if needed. You can observe the `Integration Type` and `Kafka Topic` are a representation of the information you supplied in the `Custom Synchronization` StackPack instance details. More on [Topology Sources.](../../../configure/topology/topology_sources.md)

Once you have completed all the changes, you can click on `update` and confirm the popup dialog to unlock this StackState DataSource from the `Custom Synchronization` StackPack.

