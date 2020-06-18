---
title: Identifiers
kind: Documentation
---

# Identifiers

This page explains the reasoning behind introducing enforced identifier convention and provides guidelines on how to use Identifiers in the configuration of StackState.

## About Identifiers in StackState

Identifier in StackState is a URN that matches the following convention:

```text
urn:<prefix>:<type-name>:<free-form>
```

Identifiers are structured around the `<type-name>` to reflect the the StackGraph having indices per type, as well as the `type` is a sensible part of identifications of nodes. Above format allows to have consistent namespaces and control of what Identifiers represent.

The `free-form` part of the Identifier is where it is possible to provide custom taxonomies that are useful in specific configurations.

Please note that using the `:` character is not allowed in any segment of the Identifier.

### Supported prefixes

A `prefix` is a required part of the identifier naming the scope the identifier belongs to, purely for organizational purposes. Currently recognized prefixes are:

* `stackpack:<name>` - objects belonging to StackPacks
* `stackpack:<name>:shared` - objects shared between instances of a StackPack
* `stackpack:<name>:instance:{{instanceId}}`- objects belonging to a specific instance of a StackPack
* `system:auto` - objects created by the system that do not belong to any specific StackPacks

Note that `{{instanceId}}` is a handlebar that provides an object that is created in StackGraph for each specific instance of a StackPack. That object has an ID in StackGraph that is used during StackPack installation process.

### Type and Name

`<type-name>:<free-form>` is the uniquely identifying part of the identifier. The type-name must match the domain object type of the object the identifier is assigned to \(sans the letter case\), while the free-form is arbitrary as long as it is unique for the type. The free-form doesn't need to match the name of the object \(if any is present\) and can consist of multiple segments. It's up to the user to decide on the format of the free-form.

Examples of the uniquely identifying segments:

* `component-type:cmdb_ci_netgear` for `cmdb_ci_netgear` Component Type
* `view-health-state-configuration-function:minimum-health-states` for Minimum Health States in the `ViewHealthStateConfigurationFunction`

### Examples of Identifiers in StackState

* `urn:stackpack:aws:shared:check-function:aws-event-run-state` for `AWS event run state` check function that is shared across AWS StackPack instances
* `urn:stackpack:servicenow:componenttype:cmdb_ci_netgear` for `cmdb_ci_netgear` Component Type in the ServiceNow StackPack
* `urn:stackpack:common:view-health-state-configuration-function:minimum-health-states` for Minimum Health States `ViewHealthStateConfigurationFunction` in the Common StackPack

## Topology identifiers

Identifiers are also used to uniquely identify topology components in StackState. When StackState receives components from different sources that have matching identifiers, StackState will merge the components and their properties \(labels, streams, checks\) into a single component. This makes it possible to combine data from different sources into a single picture of an IT landscape.

The following identifiers are used by the StackState StackPacks:

| StackPack | URN namespace identifier | Description | Example |
| :--- | :--- | :--- | :--- |
| AWS | aws | Amazon Resource name, URI based | urn:aws:ec2:region:account-id:instance/instance-id |
| Azure | azure | Azure Resource ID, URI based | urn:azure:subscription/resourcegroup/provider/resourcename |
| Agent v2 | host | Host identifier | urn:host:/hostName |
| Agent v2 | process | Process identifier | urn:process:/hostName:pid:createTime |
| Agent v2 | container | Container identifier | urn:container:/hostName:containerId |

