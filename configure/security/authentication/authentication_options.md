# Authentication options

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

Out of the box, StackState is configured with [file-based authentication](./file.md) with a [default username and password](README.md#default-username-and-password). This authenticates users against a file on the server. However this is not a production-ready setup.

For better security StackState can be configured to use exactly one of the following authentication mechanisms (replacing the standard admin user):

* [File based](./file.md)
* [LDAP](./ldap.md)
* [Open ID Connect (OIDC)](./oidc.md)
* [KeyCloak (a specialized version of OIDC)](./keycloak.md)

{% hint style="info" %}
- **Kubernetes** authentication configuration is part of the Helm chart, any changes will automatically triger a restart of the pods requiring that.
- **Linux** authentication configuration is stored in the file `etc/application_stackstate.conf` in the StackState installation directory. Restart StackState for any changes made to this file to take effect.
{% endhint %}

## User roles

When a user has been authenticated permissions for that user are usually assigned based of the roles the user has. The documentation for the specific authentication mechanisms also contain examples on how to map the roles or groups from the external systems to the 3 standard roles of StackState:

* **Guest** - able to see information but make no changes.
* **Power User** - able to see and change all configuration and install StackPacks.
* **Administrator** - able to see and change all configuration, install StackPacks, grant and revoke user permissions and upload \(new versions of\) StackPacks.

When deciding on the roles to assign your users it is strongly advised to have only a small group of Administrators, for example only the engineers responsible for installing StackState and doing the initial configuration. Administrator users can manage access to StackState and decide which StackPacks can be used. Installing StackPacks and other fine tuning of the configuration can be delegated to a larger number of users with the Power User role.

It is also possible to add more roles, see the page [Roles \(RBAC\)](../rbac/rbac_roles.md) and the other [RBAC documentation pages](../configure/security/rbac/)

## Default username and password

StackState is configured by default with the following administrator account:

{% tabs %}
{% tab title="Kubernetes" %}
* **username:** `admin`
* **password:** Set during installation. This is collected by the `generate_values.sh` script and stored in MD5 hash format in `values.yaml`
{% endtab %}

{% tab title="Linux" %}
* **username:** `admin`
* **password:** `topology-telemetry-time`
{% endtab %}
{% endtabs %}
