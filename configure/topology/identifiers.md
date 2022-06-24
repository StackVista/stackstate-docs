---
description: StackState Self-hosted v4.6.x
---

# Identifiers

{% hint style="warning" %}
**This page describes StackState version 4.6.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/configure/identifiers).
{% endhint %}

## Overview

Identifiers are used in StackState to identify objects, such as topology elements \(components and relations\) and functions. This page describes the different types of identifiers used for topology elements and how global scope identifiers are structured in StackState.

## Topology identifiers

Topology elements use two types of identifiers in StackState:

| Identifier type | Description |
| :--- | :--- |
| **Integration scope identifiers** | Used for identifying components and relations within an integration. Each component or relation has only one integration scope identifier. The identifier is arbitrary, but must be consistent within the scope of the integration itself. |
| **Global scope identifiers** | Used for merging components between integrations, for example ServiceNow and the StackState Agent. Each component can have multiple global scope identifiers, while relations do not have any global identifiers. They are assigned by StackState and formatted in accordance with the [StackState global identifier convention](identifiers.md#global-scope-identifiers). |

The code sample below shows a component with both types of identifiers.

* Integration scope identifier - `this-host-unique-identifier`
* Global scope identifier - `urn:host:/this-host-fqdn`

```text
self.component("this-host-unique-identifier", "Host", {
    "name": "this-host",
    "domain": "Webshop",
    "layer": "Machines",
    "identifiers": ["urn:host:/this-host-fqdn"],
    "labels": ["host:this-host", "region:eu-west-1"],
    "environment": "Production"
})
```

## StackState Agent identifiers

The global scope identifiers used by the StackState Agent to identify synchronized topology elements are listed in the table below.

| Resource type | URN identifier format |
| :--- | :--- |
| Host | `urn:host:/[hostName]` |
| Process | `urn:process:/[hostName]:[pid]:[createTime]` |
| Container | `urn:container:/[hostName]:[containerId]` |
| Service discovered with traces | `urn:service:/[serviceName]` |
| Service instance discovered with traces | `urn:service-instance:/[serviceName]:/[hostName]` |

See the [example URN global scope identifiers from the StackState Agent](identifiers.md#stackstate-agent).

## Global scope identifiers

When StackState receives components with matching global scope identifiers from different external sources, the components and their properties \(labels, streams, checks\) are merged into a single component. This makes it possible to combine data from different sources into a single picture of an IT landscape.

Global scope identifiers in StackState are a globally unique URN that matches the following convention:

```text
urn:<prefix>:<type-name>:<free-form>
```

Note that not all characters are allowed in a URN identifier. You can check your identifiers with the following URN regex:

```text
^urn:[a-z0-9][a-z0-9-]{0,31}:[a-z0-9()+,\-.:=@;$_!*'%/?#]+$
```

The format of the `<prefix>` and `<type-name>:<free-form>` segments are described below.

### Prefix

The `prefix` segment is a required part of a global identifier. It names the scope that the identifier belongs to and is used purely for organizational purposes.

{% hint style="info" %}
When the prefix includes a StackPack name, the object will be under the control of that StackPack. This means that the object will be uninstalled when the StackPack is uninstalled.
{% endhint %}

Recognized URN prefixes are:

* `stackpack:<name>` - objects belonging to StackPacks.
* `stackpack:<name>:shared` - objects shared between instances of a StackPack.
* `stackpack:<name>:instance:{{instanceId}}`- objects belonging to a specific instance of a StackPack, where `{{instanceId}}` is a handlebar that returns the ID provided during the StackPack installation process for each specific instance of the StackPack.
* `system:auto` - objects created by the system that do not belong to any specific StackPacks.

### Type-name and free-form

The identifier is uniquely identified by the `<type-name>:<free-form>` segments.

* `<type-name>` matches the domain object type of the object that the identifier is assigned to \(not case-sensitive\). 
* `<free-form>` is arbitrary, but must be unique for the type. The format of the free-form segment is decided by the user. It does not need to match the name of the object \(if any is present\) and can itself consist of multiple segments.

## Example identifiers

### Common StackPack

Example URN global scope identifiers from the common StackPack. The objects will be uninstalled when the common StackPack is uninstalled.

* Component type server:
  * `urn:stackpack:common:component-type:server` 
* View health state configuration function Minimum Propagated Health States:
  * `urn:stackpack:common:view-health-state-configuration-function:minimum-propagated-health-states`

### StackState Agent

Example URN global scope identifiers from the StackState Agent.

* Host:
  * `urn:host:/example.org`
* Process:
  * `urn:process:/db.infra.company.org:161841:1602158335000`
* Container:
  * `urn:container:/compnode5.k8s.example.org:8b18c68a820904c55b4909d7f5a9a52756d45e866c07c92bf478bcf6cd240901`
* Service discovered with traces:
  * `urn:service:/prod-db` 
* Service instance discovered with traces:
  * `urn:service-instance:/prod-db:/main.example.org`

### Other StackPacks

Example URN global scope identifiers from various StackPacks. The objects will be uninstalled when the named StackPack is uninstalled.

* Check function AWS Event Run State shared across AWS StackPack instances:
  * `urn:stackpack:aws:shared:check-function:aws-event-run-state`
* Component type cmdb\_ci\_netgear in the ServiceNow StackPack:
  * `urn:stackpack:servicenow:componenttype:cmdb_ci_netgear`

