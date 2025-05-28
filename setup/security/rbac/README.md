---
description: SUSE Observability Self-hosted
---

# Role based access control (RBAC)

Access Management helps you manage who has access to the specific topology elements, UI elements, and which APIs they can call.

RBAC is an authorization system that provides fine-grained access management of SUSE Observability resources, a clean and easy way to audit user privileges and to fix identified issues with access rights.

## What can I do with RBAC?

Here are some examples of what you can do with RBAC:

* Allow one user to have access to the development cluster only, another one to both the production and development cluster and a third can access the development cluster and only 1 namespace in the production cluster.
* Give a small group of users an administrator role to setup and configure SUSE Observability. While giving all developers a troubleshooter role to view all topology, metrics, logs and events, but with limited configuration capability.

## What's a role in SUSE Observability?

This depends a bit on how SUSE Observability is deployed.  Both modes of deployment support the same capabilities, but there are slight variations in how scoping is applied.
* **In Rancher** - a role is a Kubernetes Role based on a Rancher `RoleTemplate`, see [Rancher RBAC](rbac_rancher.md) for details.  Capabilities are modelled as "verbs" on "resources".  Scopes can be set to Instance (all data), Cluster or Namespace and will limit access to topology, metrics and traces.
* **Standalone** - a role is a combination of a configured subject and a set of [permissions](rbac_permissions.md). Process of setting up a role in SUSE Observability is described in [How to set up roles](rbac_roles.md).  Scopes are defined with an STQL query, but only apply to topology.

## More on RBAC configuration

* [Rancher RBAC](rbac_rancher.md)
* [Permissions](rbac_permissions.md)
* [How to set up roles](rbac_roles.md)
* [Scopes](rbac_scopes.md)
* [How to configure authentication](../authentication/)


