# Identifiers

## Overview

Identifiers are used in StackState to identify ???, such as topology elements (components and relations), functions and ???. 

## Topology identifiers

There are two types of identifiers used by components and relations in StackState:

* **Integration scope identifier** - Used for identifying components and relations within an integration. Each component or relation has only one integration scope identifier. The identifier must be consistent within the scope of the integration itself, but otherwise it can be any reasonable string value.
* **Global scope identifier** - Used for merging components between integrations, for example ServiceNow and the StackState Agent. Each component can have multiple global scope identifiers, while relations do not have any global identifiers. They are assigned by StackState and formatted in accordance with the [StackState global identifier convention](#global-identifiers).

When StackState receives components with matching global identifiers from different external sources, StackState will merge the components and their properties \(labels, streams, checks\) into a single component. This makes it possible to combine data from different sources into a single picture of an IT landscape.

The code sample below shows both types of identifiers. 

* Integration scope identifier - `this-host-unique-identifier`
* Global scope identifier - `urn:host:/this-host-fqdn`

```buildoutcfg
self.component("this-host-unique-identifier", "Host", {
    "name": "this-host",
    "domain": "Webshop",
    "layer": "Machines",
    "identifiers": ["urn:host:/this-host-fqdn"],
    "labels": ["host:this-host", "region:eu-west-1"],
    "environment": "Production"
})
```

## StackState global scope identifiers

Global scope identifiers in StackState are an URN that matches the following convention:

```text
urn:<prefix>:<type-name>:<free-form>
```

The `<prefix>` and `<type-name>:<free-form>` segments are described below.

### Prefix

The `prefix` is a required part of a global identifier. It names the scope the identifier belongs to and is used purely for organizational purposes. Recognized URN prefixes are:

* `stackpack:<name>` - objects belonging to StackPacks.
* `stackpack:<name>:shared` - objects shared between instances of a StackPack.
* `stackpack:<name>:instance:{{instanceId}}`- objects belonging to a specific instance of a StackPack.
* `system:auto` - objects created by the system that do not belong to any specific StackPacks.

Note that `{{instanceId}}` is a handlebar that returns the ID provided during the StackPack installation process for each specific instance of a StackPack.

The following identifiers are used by the StackState StackPacks:

| StackPack | URN namespace identifier | Description | Format | Example |
| :--- | :--- | :--- | :--- | :--- |
| AWS | aws | Amazon Resource name, URI based | urn:aws:ec2:\[region\]:\[account-id\]:\[instance\]/\[instance-id\] |  |
| Azure | azure | Azure Resource ID, URI based | urn:azure:subscription/\[resourceGroup\]/\[provider\]/\[resourceName\] |  |
| Agent v2 | host | Host identifier | urn:host:/\[hostName\] | `urn:host:/example.org` |
| Agent v2 | process | Process identifier | urn:process:/\[hostName\]:\[pid\]:\[createTime\] | `urn:process:/db.infra.company.org:161841:1602158335000` |
| Agent v2 | container | Container identifier | urn:container:/\[hostName\]:\[containerId\] | `urn:container:/compnode5.k8s.example.org:8b18c68a820904c55b4909d7f5a9a52756d45e866c07c92bf478bcf6cd240901` |
| Agent v2 | service | Service discovered with traces | urn:service:/\[serviceName\] | `urn:service:/prod-db` |
| Agent v2 | service-instance | Service instance discovered with traces | urn:service-instance:/\[serviceName\]:/\[hostName\] | `urn:service-instance:/prod-db:/main.example.org` |

### Type-name and free-form

The identifier is uniquely identified by the `<type-name>:<free-form>` segments. 

* `<type-name>` matches the domain object type of the object that the identifier is assigned to \(not case-sensitive\). 
* `<free-form>` is arbitrary value unique for the type. The format of the free-form segment is decided by the user. It does not need to match the name of the object \(if any is present\) and can itself consist of multiple segments.

### Example identifiers

* `urn:stackpack:common:component-type:server` - for the component type `server` in the Common StackPack.
* `urn:stackpack:common:view-health-state-configuration-function:minimum-propagated-health-states` - for the `ViewHealthStateConfigurationFunction` named Minimum Propagated Health States in the Common StackPack.
* `urn:stackpack:aws:shared:check-function:aws-event-run-state` - for the `AWS event run state` check function that is shared across AWS StackPack instances
* `urn:stackpack:servicenow:componenttype:cmdb_ci_netgear` for the `cmdb_ci_netgear` Component Type in the ServiceNow StackPack

