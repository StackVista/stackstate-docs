## File-based authentication

In case no external authentication provider can be used, you can use file based authentication. This will require every StackState user to be pre-configured in the configuration file. For every change made to a user in the configuration file, StackState must be restarted.

If you want to have 3 users, `admin-demo`, `power-user-demo` and `guest-demo`, with the default roles Administrator, Power user and Guest.

Passwords are stored as MD5 hashes and need to be provided as such, for example on a linux or Mac command line the `md5sum` or `md5` tools can be used.

{% tabs %}
{% tab title="Kubernetes" %}
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

Configuration field explanation:

1. **username** - the users username for logging into StackState.
2. **passwordMd5** - the user's password in MD5 hash format.
3. **roles** - the list of roles the user is a member of. Default available roles are `stackstate-admin`, `stackstate-power-user` and `stackstate-guest`; see also the [default roles](../rbac/rbac_permissions.md#predefined-roles).

{% endhint %}

{% endtab %}
{% tab title="Linux" %}

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

Configuration field explanation:

1. **username** - the users username for logging into StackState.
2. **password** - the user's password in MD5 hash format.
3. **roles** - the list of roles the user is a member of. Default available roles are `stackstate-admin`, `stackstate-power-user` and `stackstate-guest`. 
{% endtab %}

{% endtabs %}

For the permissions of the default roles and how to crate other roles see the [RBAC](../rbac/role_based_access_control.md) documentation.