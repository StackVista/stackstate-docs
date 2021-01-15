# Authentication

Out of the box, StackState is configured with [file-based authentication](file.md) with a [default configuration](README.md#default-username-and-password). This authenticates users against a file on the server. 

StackState can be configured to use exactly one of the following authentication mechanisms:

* [File based](file.md)
* [LDAP](ldap.md)
* [Open ID Connect (OIDC)](odic.md)
* [KeyCloak (a specialized version of OIDC)](keycloak.md)

{% hint style="info" %}
On Linux installations authentication configuration is stored in the file `etc/application_stackstate.conf` in the StackState installation directory. Restart StackState for any changes made to this file to take effect.

For Kubernetes installations authentication configuration is part of the Helm chart, any changes will automatically triger a restart of the pods requiring that.
{% endhint %}

## User roles

StackState ships with the default user roles **Guest**, **Power User** and **Administrator**:

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
