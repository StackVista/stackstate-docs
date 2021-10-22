# File-based authentication

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

In case no external authentication provider can be used, you can use file based authentication. This will require every StackState user to be pre-configured in the configuration file. For every change made to a user in the configuration, StackState must be restarted.

StackState includes three default roles - Administrator, Power user and Guest. The permissions assigned to each default role and instructions on how to create other roles can be found in the [RBAC documentation](/configure/security/rbac/role_based_access_control.md).

## Set up file based authentication

### Kubernetes

To configure file based authentication on Kubernetes, StackState users need to be added to the `authentication.yaml` file. For example:

{% tabs %}
{% tab title="authentication.yaml" %}
```yaml
# Three users, `admin-demo`, `power-user-demo` and `guest-demo`
# with the three default roles Administrator, Power user and Guest

stackstate:
  authentication:
    file:
      logins:
        - username: admin-demo
          passwordMd5: 5f4dcc3b5aa765d61d8327deb882cf99
          roles: [ stackstate-admin ]
        - username: guest-demo
          passwordMd5: 5f4dcc3b5aa765d61d8327deb882cf99
          roles: [ stackstate-guest ]
        - username: power-user-demo
          passwordMd5: 5f4dcc3b5aa765d61d8327deb882cf99
          roles: [ stackstate-power-user ]  
```
{% endtab %}
{% endtabs %}

Follow the steps below to configure users and apply changes:

1. In `authentication.yaml` - add users. The following configuration should be added for each user (see the example above):
    - **username** - the username used to log into StackState.
    - **passwordMd5** - the password used to log into StackState. Passwords are stored as an MD5 hash and need to be provided as such, for example on a Linux or Mac command line the `md5sum` or `md5` tools can be used.
    - **roles** - the list of roles that the user is a member of. The [default StackState roles](/configure/security/rbac/rbac_permissions.md#predefined-roles) are `stackstate-admin`, `stackstate-power-user` and `stackstate-guest`, for details on how to create other roles, see [RBAC roles](/configure/security/rbac/rbac_roles.md).

2. Store the file `authentication.yaml` together with the file `values.yaml` from the StackState installation instructions.

3. Run a Helm upgrade to apply the changes:
    ```
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
* The first run of the helm upgrade command will result in pods restarting, which may cause a short interruption of availability.
* Include `authentication.yaml` on every `helm upgrade` run.
* The authentication configuration is stored as a Kubernetes secret.
{% endhint %}

### Linux

To configure file based authentication on Linux, StackState users need to be added to the `application_stackstate.conf` file. For example:

{% tabs %}
{% tab title="application_stackstate.conf" %}

```javascript
# Three users, `admin-demo`, `power-user-demo` and `guest-demo`
# with the three default roles Administrator, Power user and Guest

authentication {
  authServer {
    authServerType = "stackstateAuthServer"

    stackstateAuthServer {
      # echo -n "password" | md5sum
      logins = [
        { username = "admin-demo", password: "5f4dcc3b5aa765d61d8327deb882cf99", roles = ["stackstate-admin"] }
        { username = "power-user-demo", password: "5f4dcc3b5aa765d61d8327deb882cf99", roles = ["stackstate-power-user"] }
        { username = "guest-demo", password: "5f4dcc3b5aa765d61d8327deb882cf99", roles = ["stackstate-guest"] }
      ]
    }
  }
}
```
{% endtab %}
{% endtabs %}

Follow the steps below to configure users and apply changes:

1. In `authentication.yaml` - add users. The following configuration should be added for each user (see the example above):
    - **username** - the username used to log into StackState.
    - **password** - the password used to log into StackState. Passwords are stored as an MD5 hash and need to be provided as such, for example on a Linux or Mac command line the `md5sum` or `md5` tools can be used.
    - **roles** - the list of roles that the user is a member of. The [default StackState roles](/configure/security/rbac/rbac_permissions.md#predefined-roles) are `stackstate-admin`, `stackstate-power-user` and `stackstate-guest`, for details on how to create other roles, see [RBAC roles](/configure/security/rbac/rbac_roles.md).

2. Restart StackState to apply the changes.


## See also

- [Authentication options](/configure/security/authentication/authentication_options.md)
- [Permissions for pre-defined StackState roles](/configure/security/rbac/rbac_permissions.md#predefined-roles)
- [Create RBAC roles](/configure/security/rbac/rbac_roles.md)
