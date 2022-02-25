---
description: StackState Self-hosted v4.5.x
---

# Customize a StackPack

{% hint style="warning" %}
**This page describes StackState version 4.5.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/develop/developer-guides/stackpack/how_to_customize_a_stackpack).
{% endhint %}

## StackPack configuration file

The StackPack configuration file is responsible for how StackState interprets the StackPack. The configuration file holds information like the StackPack version, or its category, but also defines what is presented to the user during installation and what input user is asked for. Find more details on fields in [The StackPack Configuration file](prepare_package.md) or follow the instructions below.

StackPack configuration file structure is as follows:

```text
name = example
displayName = Example stackpack
version = "1.0.0"
isNew = yes
logoUrl = "http://url.to.the.logo"
categories = ["Infrastructure"]
overviewUrl = "overview.md"
detailedOverviewUrl = "detailed-overview.md"
configurationUrls = {
    INSTALLED = "installed.md"
    NOT_INSTALLED = "notinstalled.md"
    ERROR = "error.md"
    PROVISIONING = "provisioning.md"
    DEPROVISIONING = "deprovisioning.md"
    WAITING_FOR_DATA = "waitingfordata.md"
}
faqs = []
steps = [
  {
    name = "text"
    display = "Text"
    value {
      type = "text"
      default = "value"
    }
  },
  {
    name = "password"
    display = "Password"
    value {
      type = "password"
    }
  }
]
provision = "ExampleProvision"
```

### URLs in StackPack configuration

* Any relative/absolute path is considered as a resource inside the `resources` directory in the StackPack.
* Any absolute URL with a scheme \(`http`/`https`\) refers to an externally hosted resource with the given URL.
* Configuration URLs are representing [documentation and states files](stackpack_resources.md) that reside in the `resources` directory in the StackPack.

## Configuration input

During installation, a StackPack can prompt for some input from the user. The prompt can be configured in `steps` part of the StackPack configuration file. Each step is rendered as an input field. There are two different types of inputs currently supported, a `text`, and a `password` input field.

### Text input

The `text` input field is described as below:

```text
{
    name = "text"
    display = "Text"
    value {
        type = "text"
        default = "value"
    }
}
```

StackState assumes all the input fields in the StackPack are mandatory, and to circumvent that, an optional field could be provided with a default value.

### Password input

The `password` input field is described like the `text` input field except that there are no default values, as it's presented below:

```text
{
    name = "password"
    display = "Password"
    value {
      type = "password"
    }
}
```

If the user does not provide any value to any of the input fields defined in the `steps`, StackState will raise a validation error and prompt the user to enter the values. The input values of the entered fields are provided as a un-modifiable map to the `provision` function of the `ProvisioningScript` which can be used for further provisioning. The map is indexed by the names of the fields provided for each field.

## Customize Components and Relations

If you have not completed this step during [configuration of the elements created by Custom Synchronization](../custom_synchronization_stackpack/how_to_customize_elements_created_by_custom_synchronization_stackpack.md) StackPack, then you need to configure Components and Relations with icons now.

### Component and Relation types

There are some default component and relation types in StackState. Component types are used to visualize components with a given icon - you can change it to reflect the context of your environment; Relation types are here to describe relations between components. 

➡️ [Learn more about Component and Relation types](../../../use/concepts/components_relations.md).

Component types and Relation types can also be created automatically by StackState using the `getOrCreate` functionality described in the `Component + Relation Templates` section below. Auto-generated components types will be created without an icon.

### Component and Relation Templates

The `Custom Synchronization` StackPack installed as an integration prerequisite, creates a Component Template called `autosync-component-template`. Similarly, `Custom Synchronization` StackPack, creates a Relation Template called `autosync-relation-template`.

You can go ahead to Settings page section `Topology Synchronization` and rename it, add a description if needed. It is recommended to change the default value of the `ComponentType` from `Auto-synced Component` to something that represents a generic component in your data source. The same goes for `Layer`, `Domain` and `Environment` which defaults to `Auto-synced Components`, `Auto-synced Domain`,`Auto-synced Environment` respectively. As this template is using the `getOrCreate` functionality, these values are auto-created by StackState if they don't already exist. Find more on [Templates](../../reference/stj/using_stj.md).

Once you have completed all the changes, you can click on `update` and confirm the popup dialog to unlock this Template from the `Custom Synchronization` StackPack.

