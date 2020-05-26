---
title: Role Based Access Control
kind: Documentation
aliases:
  - /concepts/rbac/
  - /authentication/rbac/
  - /concepts/authentication/
sidebar:
  nav:
    - header: References
    - text: Permissions
      href: configure/permissions/
    - text: Scopes
      href: configure/scopes_in_rbac/
    - text: Subject Configuration
      href: configure/subject_configuration/
    - text: LDAP setup
      href: configure/how_to_configure_ldap_authentication/
    - text: How to set up roles
      href: configure/how_to_set_up_roles
---

# index

Role Based Access Control \(RBAC\) is a critical function for any Managed Service Provider \(MSP\) organization, but its use is not limited to MSPs. Access Management helps you manage who has access to the specific topology elements, UI elements, and which APIs they can call.

RBAC is an authorization system that provides fine-grained access management of StackState resources, that provides a clean and easy way to audit user privileges and to fix identified issues with access rights.

## What can I do with RBAC?

Here are some examples of what you can do with RBAC:

* Allow one user to have access to the Applications layer, and another one to have access to the Databases layer.
* Allow a group of users to access Analytics in StackState.
* Create a group for users with access to specific elements of the topology.

## What is a role in StackState?

A role in StackState is a combination of a [configured subject](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/configure/subject_configuration/README.md) and a set of [permissions](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/configure/permissions/README.md). Process of setting up a role in StackState is described in [How to set up roles](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/configure/how_to_set_up_roles/README.md).

## More on RBAC configuration

* [Permissions](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/configure/permissions/README.md)
* [Scopes](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/configure/scopes_in_rbac/README.md)
* [Subject Configuration](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/configure/subject_configuration/README.md)
* [How to configure LDAP authentication](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/configure/how_to_configure_ldap_authentication/README.md)
* [How to set up roles](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/configure/how_to_set_up_roles/README.md)

