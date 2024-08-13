---
description: Rancher Observability Self-hosted
---

# Authentication options

Out of the box, Rancher Observability is configured with [file-based authentication](file.md) with a username and password [configured during installation](../../../setup/install-stackstate/initial_run_guide.md#default-username-and-password). This authenticates users with a file on the server. However, this isn't a production-ready setup.

For better security Rancher Observability can be configured to use exactly one of the following authentication mechanisms \(replacing the standard admin user\):

* [File based](file.md)
* [LDAP](ldap.md)
* [Open ID Connect \(OIDC\)](oidc.md)
* [KeyCloak \(a specialized version of OIDC\)](keycloak.md)

{% hint style="info" %}
Authentication configuration is part of the Helm chart, any changes will automatically trigger a restart of the pods requiring that.
{% endhint %}

## User roles

When a user has been authenticated permissions for that user are usually assigned based of the roles the user has. The documentation for the specific authentication mechanisms also contain examples on how to map the roles or groups from the external systems to the 4 standard roles of Rancher Observability:

* **Guest** - able to see information but make no changes.
* **Kubernetes Troubleshooter** - able to see all information and see and change monitors and metric configuration.
* **Power User** - able to see and change all configuration and install StackPacks.
* **Administrator** - able to see and change content of Rancher Observability. For example, see all configuration, install StackPacks, grant and revoke user permissions and upload \(new versions of\) StackPacks.
* **Platform Administrator** - able to perform management of the Rancher Observability platform. For example, change data retention, clear the database, view logs and cache management.

When deciding on the roles to assign your users, it's strongly advised to have only a small group of Platform Administrators and Administrators. For example, only the engineers responsible for installing Rancher Observability and doing the initial configuration. Administrator users can manage access to Rancher Observability and decide which StackPacks can be used. You can delegate installation of StackPacks and other fine-tuning of the configuration to a larger number of users with the Power User role. Platform Administrator users can clear the database, change data retention settings, view logs and perform other platform management tasks.

It's also possible to add more roles, see the page [Roles \(RBAC\)](../rbac/rbac_roles.md) and the other [RBAC documentation pages](../rbac/)

