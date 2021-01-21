# File-based authentication

## Overview

In case no external authentication provider can be used, you can use file based authentication. This will require every StackState user to be pre-configured in the configuration file. For every change made to a user in the configuration, StackState must be restarted.

StackState includes three default roles - Administrator, Power user and Guest. The permissions assigned to each default role and instructions on how to create other roles can be found in the [RBAC documentation](/configure/security/rbac/role_based_access_control.md).

## Kubernetes

If you want to have 3 users, `admin-demo`, `power-user-demo` and `guest-demo`, with the default roles Administrator, Power user and Guest you would need to include the below configuration in the file `authentication.yaml`.

{% tabs %}
{% tab title="`authentication.yaml`" %}
```yaml
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

Update it with your own values. See the [default roles](../rbac/rbac_permissions.md#predefined-roles) for details on the available roles. More roles can be created as well. See the [RBAC](../rbac/role_based_access_control.md) documentation for the details.

Store the `authentication.yaml` together with the `values.yaml` from the installation instructions. To apply the changes run a Helm upgrade:

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
* Running the helm upgrade command for the first time will result in restarting of pods possibly causing a short interruption of availability.
* The `authentication.yaml` needs to be included on every `helm upgrade` run
* The authentication configuration is stored as a Kubernetes secret.

Provide the following configuration for each user:

- **username** - the username for logging into StackState.
- **password** - the password for logging into StackState. Passwords are stored in the configuration file as an MD5 hash and need to be provided as such, for example on a Linux or Mac command line the `md5sum` or `md5` tools can be used.
- **roles** - the list of roles that the user is a member of. Default available roles are `stackstate-admin`, `stackstate-power-user` and `stackstate-guest`, for details see the [pre-defined roles](/configure/security/rbac/rbac_permissions.md#predefined-roles).

{% endhint %}


## Linux

If you want to have 3 users, `admin-demo`, `power-user-demo` and `guest-demo`, with the default roles Administrator, Power user and Guest you would need to include the below configuration in the file `application_stackstate.conf`.

{% tabs %}
{% tab title="`application_stackstate.conf`" %}

```javascript
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

Provide the following configuration for each user:

- **username** - the username for logging into StackState.
- **password** - the password for logging into StackState.  Passwords are stored in the configuration file as an MD5 hash and need to be provided as such, for example on a Linux or Mac command line the `md5sum` or `md5` tools can be used.
- **roles** - the list of roles that the user is a member of. Default available roles are `stackstate-admin`, `stackstate-power-user` and `stackstate-guest`, for details see the [pre-defined roles](/configure/security/rbac/rbac_permissions.md#predefined-roles).


