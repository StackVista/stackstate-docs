---
description: StackState Self-hosted v5.0.x 
---

# File based

## Overview

In case no external authentication provider can be used, you can use file based authentication. This will require every StackState user to be pre-configured in the configuration file. For every change made to a user in the configuration, StackState must be restarted.

StackState includes four default roles - Administrator, Platform Administrator, Power user and Guest. The permissions assigned to each default role and instructions on how to create other roles can be found in the [RBAC documentation](../rbac/role_based_access_control.md).

## Set up file based authentication

### Kubernetes

To configure file based authentication on Kubernetes, StackState users need to be added to the `authentication.yaml` file. For example:

{% tabs %}
{% tab title="authentication.yaml" %}
```yaml
# Four users, `admin`, `platformAdmin`, `power-user` and `guest`
# with the four default roles Administrator, Platform Administrator, Power user and Guest

stackstate:
  authentication:
    file:
      logins:
        - username: admin
          passwordHash: 5f4dcc3b5aa765d61d8327deb882cf99
          roles: [ stackstate-admin ]
        - username: platformadmin
          passwordHash: 5f4dcc3b5aa765d61d8327deb882cf99
          roles: [ stackstate-platform-admin ]
        - username: guest
          passwordHash: 5f4dcc3b5aa765d61d8327deb882cf99
          roles: [ stackstate-guest ]
        - username: power-user
          passwordHash: 5f4dcc3b5aa765d61d8327deb882cf99
          roles: [ stackstate-power-user ]
```
{% endtab %}
{% endtabs %}

Follow the steps below to configure users and apply changes:

1. In `authentication.yaml` - add users. The following configuration should be added for each user \(see the example above\):
   * **username** - the username used to log into StackState.
   * **passwordHash** - the password used to log into StackState. Passwords are stored as either an MD5 hash or a bcrypt hash.
   * **roles** - the list of roles that the user is a member of. The [default StackState roles](../rbac/rbac_permissions.md#predefined-roles) are `stackstate-admin`,`stackstate-platform-admin`, `stackstate-power-user` and `stackstate-guest`, for details on how to create other roles, see [RBAC roles](../rbac/rbac_roles.md).
2. Store the file `authentication.yaml` together with the file `values.yaml` from the StackState installation instructions.
3. Run a Helm upgrade to apply the changes:

   ```text
    helm upgrade \
      --install \
      --namespace stackstate \
      --values values.yaml \
      --values authentication.yaml \
    stackstate \
    stackstate/stackstate
   ```

{% hint style="info" %}
**Note:**

* An MD5 password hash can be generated using the `md5sum` or `md5` command line applications on Linux and Mac.
* A bcrypt password hash can be generated using the following command line `htpasswd -bnBC 10 "" <password> | tr -d ':\n'` or using an online tool.
* The first run of the helm upgrade command will result in pods restarting, which may cause a short interruption of availability.
* Include `authentication.yaml` on every `helm upgrade` run.
* The authentication configuration is stored as a Kubernetes secret.
{% endhint %}

### Linux

To configure file based authentication on Linux, StackState users need to be added to the `application_stackstate.conf` file. For example:

{% tabs %}
{% tab title="application\_stackstate.conf" %}
```javascript
# Four users, `admin`, `platformadmin`, `power-user` and `guest`
# with the four default roles Administrator, Platform Administrator, Power user and Guest

authentication {
  authServer {
    authServerType = "stackstateAuthServer"

    stackstateAuthServer {
      # echo -n "password" | md5sum
      logins = [
        { username: "admin", password: "5f4dcc3b5aa765d61d8327deb882cf99", roles: ["stackstate-admin"] }
        { username: "platformadmin", password: "5f4dcc3b5aa765d61d8327deb882cf99", roles: ["stackstate-platform-admin"] }
        { username: "power-user", password: "5f4dcc3b5aa765d61d8327deb882cf99", roles: ["stackstate-power-user"] }
        { username: "guest", password: "5f4dcc3b5aa765d61d8327deb882cf99", roles: ["stackstate-guest"] }
      ]
    }
  }
}
```
{% endtab %}
{% endtabs %}

Follow the steps below to configure users and apply changes:

1. In `authentication.yaml` - add users. The following configuration should be added for each user \(see the example above\):
   * **username** - the username used to log into StackState.
   * **password** - the password used to log into StackState. Passwords are stored as either an MD5 hash or a bcrypt hash.
   * **roles** - the list of roles that the user is a member of. The [default StackState roles](../rbac/rbac_permissions.md#predefined-roles) are `stackstate-admin`, `stackstate-platform-admin`, `stackstate-power-user` and `stackstate-guest`, for details on how to create other roles, see [RBAC roles](../rbac/rbac_roles.md).
2. Restart StackState to apply the changes.

{% hint style="info" %}
**Note:**

* An MD5 password hash can be generated using the `md5sum` or `md5` command line applications on Linux and Mac.
* A bcrypt password hash can be generated using the following command line `htpasswd -bnBC 10 "" <password> | tr -d ':\n'` or using an online tool.
{% endhint %}

## See also

* [Authentication options](authentication_options.md)
* [Permissions for predefined StackState roles](../rbac/rbac_permissions.md#predefined-roles)
* [Create RBAC roles](../rbac/rbac_roles.md)

