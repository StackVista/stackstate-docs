# Identifiers

## Overview

Identifiers are used in StackState to identify objects, such as topology elements (components and relations) and functions. This page describes the different types of identifiers used for topology elements and how global scope identifiers are structured in StackState.

## Topology identifiers

Topology elements use two types of identifiers in StackState:

| Identifier type | Description |
|:---|:---|
| **Integration scope identifiers** | Used for identifying components and relations within an integration. Each component or relation has only one integration scope identifier. The identifier is arbitrary, but must be consistent within the scope of the integration itself. |
| **Global scope identifiers** | Used for merging components between integrations, for example ServiceNow and the StackState Agent. Each component can have multiple global scope identifiers, while relations do not have any global identifiers. They are assigned by StackState and formatted in accordance with the [StackState global identifier convention](#global-scope-identifiers). |

The code sample below shows a component with both types of identifiers. 

* Integration scope identifier - `this-host-unique-identifier`
* Global scope identifier - `urn:host:/this-host-fqdn`

```
self.component("this-host-unique-identifier", "Host", {
    "name": "this-host",
    "domain": "Webshop",
    "layer": "Machines",
    "identifiers": ["urn:host:/this-host-fqdn"],
    "labels": ["host:this-host", "region:eu-west-1"],
    "environment": "Production"
})
```

## Global scope identifiers

When StackState receives components with matching global scope identifiers from different external sources, the components and their properties \(labels, streams, checks\) are merged into a single component. This makes it possible to combine data from different sources into a single picture of an IT landscape.

Global scope identifiers in StackState are a globally unique URN that matches the following convention:

```text
urn:<prefix>:<type-name>:<free-form>
```

Note that not all characters are allowed. You can check your identifiers with the following URN regex: 

```
``^urn:[a-z0-9][a-z0-9-]{0,31}:[a-z0-9()+,\-.:=@;$_!*'%/?#]+$
```

The format of the `<prefix>` and `<type-name>:<free-form>` segments are described below.

### Prefix

The `prefix` segment is a required part of a global identifier. It names the scope that the identifier belongs to and is used purely for organizational purposes. Recognized URN prefixes are:

* `stackpack:<name>` - objects belonging to StackPacks.
* `stackpack:<name>:shared` - objects shared between instances of a StackPack.
* `stackpack:<name>:instance:{{instanceId}}`- objects belonging to a specific instance of a StackPack.
* `system:auto` - objects created by the system that do not belong to any specific StackPacks.

Note that `{{instanceId}}` is a handlebar that returns the ID provided during the StackPack installation process for each specific instance of a StackPack.

### Type-name and free-form

The identifier is uniquely identified by the `<type-name>:<free-form>` segments. 

* `<type-name>` matches the domain object type of the object that the identifier is assigned to \(not case-sensitive\). 
* `<free-form>` is arbitrary, but must be unique for the type. The format of the free-form segment is decided by the user. It does not need to match the name of the object \(if any is present\) and can itself consist of multiple segments.

## StackState Agent topology identifiers

The identifiers used by the StackState Agent to identify topology elements:

| Resource type | Format |
| :--- | :--- |
| Host | urn:host:/\[hostName\] `urn:host:/example.org` | 
| Process | urn:process:/\[hostName\]:\[pid\]:\[createTime\] `urn:process:/db.infra.company.org:161841:1602158335000` | 
| Container | urn:container:/\[hostName\]:\[containerId\] `urn:container:/compnode5.k8s.example.org:8b18c68a820904c55b4909d7f5a9a52756d45e866c07c92bf478bcf6cd240901` | 
| Service discovered with traces | urn:service:/\[serviceName\] `urn:service:/prod-db` |
| Service instance discovered with traces | urn:service-instance:/\[serviceName\]:/\[hostName\] `urn:service-instance:/prod-db:/main.example.org` |

## Example identifiers

* `urn:stackpack:common:component-type:server` - for the component type `server` in the Common StackPack.
* `urn:stackpack:common:view-health-state-configuration-function:minimum-propagated-health-states` - for the `ViewHealthStateConfigurationFunction` named Minimum Propagated Health States in the Common StackPack.
* `urn:stackpack:aws:shared:check-function:aws-event-run-state` - for the `AWS event run state` check function that is shared across AWS StackPack instances
* `urn:stackpack:servicenow:componenttype:cmdb_ci_netgear` for the `cmdb_ci_netgear` Component Type in the ServiceNow StackPack

