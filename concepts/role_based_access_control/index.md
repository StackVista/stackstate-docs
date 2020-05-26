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
      href: "configure/permissions/"
    - text: Scopes
      href: "configure/scopes_in_rbac/"
    - text: Subject Configuration
      href: "configure/subject_configuration/"
    - text: LDAP setup
      href: "configure/how_to_configure_ldap_authentication/"
    - text: How to set up roles
      href: "configure/how_to_set_up_roles"
---


Role Based Access Control (RBAC) is a critical function for any Managed Service Provider (MSP) organization, but its use is not limited to MSPs. Access Management helps you manage who has access to the specific topology elements, UI elements, and which APIs they can call.

RBAC is an authorization system that provides fine-grained access management of StackState resources, that provides a clean and easy way to audit user privileges and to fix identified issues with access rights.

### What can I do with RBAC?

Here are some examples of what you can do with RBAC:

* Allow one user to have access to the Applications layer, and another one to have access to the Databases layer.
* Allow a group of users to access Analytics in StackState.
* Create a group for users with access to specific elements of the topology.


### What is a role in StackState?
A role in StackState is a combination of a [configured subject](/configure/subject_configuration/) and a set of [permissions](/configure/permissions/). Process of setting up a role in StackState is described in [How to set up roles](/configure/how_to_set_up_roles/).

### More on RBAC configuration

* [Permissions](/configure/permissions/)
* [Scopes](/configure/scopes_in_rbac/)
* [Subject Configuration](/configure/subject_configuration/)
* [How to configure LDAP authentication](/configure/how_to_configure_ldap_authentication/)
* [How to set up roles](/configure/how_to_set_up_roles/)
