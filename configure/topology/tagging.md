---
description: StackState Self-hosted v5.0.x
---

# Tags

## Introduction

Tags \(also known as _labels_\) are a way of associating names with topology so it can be filtered.

## Define Tags

Below are StackState's tagging restrictions, requirements, and suggestions:

1. Tags must **start with a letter** and after that may contain the characters listed below:
   * Alphanumerics
   * Underscores
   * Minuses
   * Colons
   * Periods
   * Slashes

     Other special characters are converted to underscores.

     **Note**: A tag cannot end with a colon, for example `tag:`
2. Tags can be **up to 200 characters** long and support Unicode.
3. Tags are converted to lowercase. Therefore, `CamelCase` tags are not recommended.
4. A tag can be in the format `value` or `<KEY>:<VALUE>`. For optimal functionality, **we recommend constructing tags in the `<KEY>:<VALUE>` format.** Commonly used tag keys are `env`, `instance`, and `name`. The key always precedes the first colon of the global tag definition, for example:

   | Tag | Key | Value |
   | :--- | :--- | :--- |
   | `customer:US:acme` | `customer` | `US:acme` |
   | `customer:acme` | `customer` | `acme` |

5. Tags shouldn't originate from unbounded sources, such as EPOCH timestamps, user IDs, or request IDs. Doing so may infinitely increase the number of tags in StackState.

## Assign Tags

Tags may be assigned using any \(or all\) of the following methods.

| Method | Assign tags |
| :--- | :--- |
| Configuration Files | Manually in your main agent configuration files, or in your integrations configuration file. |
| StackPack Inheritance | Automatically with supported StackPacks after setup |

### Configuration Files

The hostname \(tag key `host`\) is assigned automatically by the StackState Agent. To customize the hostname, use the Agent configuration file, `stackstate.yaml`:

```yaml
# Set the hostname (default: auto-detected)
# Must comply with RFC-1123, which permits only:
# "A" to "Z", "a" to "z", "0" to "9", and the hyphen (-)
hostname: mymachine.mydomain
```

The Agent configuration file \(`stackstate.yaml`\) is also used to set host tags which apply to all data forwarded by the StackState Agent \(see YAML formats below\).

Tags for the integrations installed with the Agent are configured via YAML files located in the **conf.d** directory of the Agent install.

**YAML formats**

In YAML files, use a tag dictionary with a list of tags you want assigned at that level. Tag dictionaries have two different yet functionally equivalent forms:

```text
tags: <KEY_1>:<VALUE_1>, <KEY_2>:<VALUE_2>, <KEY_3>:<VALUE_3>
```

or

```text
tags:
    - <KEY_1>:<VALUE_1>
    - <KEY_2>:<VALUE_2>
    - <KEY_3>:<VALUE_3>
```

It is recommended you assign tags as `<KEY>:<VALUE>` pairs, but simple tags are also accepted.

## StackPack Inheritance

The most efficient method for assigning tags is to rely on your StackPacks. Tags assigned to your Amazon Web Services components, Azure components, and more are all automatically assigned to the topology when they are brought into StackState.

### Common tags

A number of StackState integrations understand common tags. These are special tags that can be placed on items in the source system and are used by StackState when the topology is retrieved. For example, an application in VMWare vSphere with the tag `stackstate-layer:databases` would be placed in the StackState topology layer `databases` by the StackState VMWare vSphere integration.

| Tag | Description |
| :--- | :--- |
| `stackstate-layer` | The component will be placed in the specified layer in StackState. |
| `stackstate-domain` | The component will be placed in the specified domain in StackState. |
| `stackstate-environment` | The component will be placed in the specified environment in StackState. |
| `stackstate-identifiers` | The specified value will be added as an identifier to the StackState component. |

## Using Tags

After you have assigned tags at the host and integration level, you can use them to [create views](../../use/stackstate-ui/views/about_views.md).

