---
description: StackState Self-hosted v4.5.x
---

# Role-based Access Control

{% hint style="warning" %}
**This page describes StackState version 4.5.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/configure/security/rbac/role_based_access_control).
{% endhint %}

Role Based Access Control \(RBAC\) is a critical function for any Managed Service Provider \(MSP\) organization, but its use is not limited to MSPs. Access Management helps you manage who has access to the specific topology elements, UI elements, and which APIs they can call.

RBAC is an authorization system that provides fine-grained access management of StackState resources, that provides a clean and easy way to audit user privileges and to fix identified issues with access rights.

## What can I do with RBAC?

Here are some examples of what you can do with RBAC:

* Allow one user to have access to the Applications layer, and another one to have access to the Databases layer.
* Allow a group of users to access Analytics in StackState.
* Create a group for users with access to specific elements of the topology.

## What is a role in StackState?

A role in StackState is a combination of a [configured subject](rbac_subjects.md) and a set of [permissions](rbac_permissions.md). Process of setting up a role in StackState is described in [How to set up roles](rbac_roles.md).

## More on RBAC configuration

* [Permissions](rbac_permissions.md)
* [Scopes](rbac_scopes.md)
* [Subject Configuration](rbac_subjects.md)
* [How to configure authentication](../authentication/)
* [How to set up roles](rbac_roles.md)

