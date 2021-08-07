---
title: StackState Template Language Functions
kind: documentation
---

# Template functions

{% hint style="warning" %}
**This page describes StackState version 4.1.** 

The StackState 4.1 version range is End of Life \(EOL\) and no longer supported. We encourage customers still running the 4.1 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

StackState's templated json incorporates several functions helpful to resolve nodes either by name or [identifier](../../../configure/identifiers.md) that need to be addressed while creating other nodes, for example on a `ComponentTemplate` you want to attach to your about to be created `Component` a `Domain`.

## Function: `get`

The `get` function finds a node of a certain type by its unique identifier without needing to specify the type of the node.

```text
get <identifier> Type=<type>;Name=<name>
```

Example: resolve the `Production` `Environment` using

```text
get "urn:stackpack:aws:environment:production"
```

The `get` function finds a node in a nested way by first finding the identifier and then finding the type and name in the scope of the first resolved node. For example it is possible to resolve the `Parameters` `metrics` from the CheckFunction identified by `urn:stackpack:aws:check_function:basic` by

```text
get "urn:stackpack:aws:check_function:basic" "Type=Parameter;Name=metrics"
```

## Function: `getOrCreate`

The `getOrCreate` function tries to resolve a node by first its identifier and then by the fallback create-identifier. If it can't find any it'll create it using the type and name argument and it'll identify the newly created node with the create-identifier value.

```text
getOrCreate <identifier> <create-identifier> Type=<type>;Name=<name>
```

Example: find the `Production` `Environment` by its identifier and by its fallback identifier or otherwise create it

```text
getOrCreate "urn:stackpack:aws:environment:production" "urn:system:auto:stackpack:aws:environment:production" "Type=Environment;Name=Production"
```

Note that `getOrCreate` works only with the following \(simple\) types: Environment, Layer, Domain, ComponentType and RelationType. Note that `create-identifier` must be a value in the "urn:system:auto" namespace.

We strongly encourage to use `get` and `getOrCreate` as resolving nodes by identifier is safer than by name due to the unique constraint enforced in the `identifier` values.

## Function: identifier

The `identifier` function creates an identifier out of an identifier prefix, a component type and a component name.

```text
identifier "urn:stackpack:common" "ComponentType" element.type.name
```

## Function: concat

The `concat` function concatenates two values:

```text
concat "Type=ComponentType;Name=" element.type.name
```

