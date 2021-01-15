## File-based authentication

In case no external authentication provider can be used you can use the file based authentication. This requires pre-configuring every user of StackState in the configuration file and (upon a change) a restart of StackState.

Here is an example to have 3 users, `admin-demo`, `power-user-demo` and `guest-demo`, with the default roles Administrator, Power user and Guest.

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

{% hint style="info" %}
* Running the helm upgrade command for the first time will result in restarting of pods possibly causing a short interruption of availability.
* The authentication configuration is stored as a Kubernetes secret.
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
4. **adminGroups** - the list of roles that receive Administrator privileges.
5. **powerUserGroups** - the list of roles that receive Power User privileges.
6. **guestGroups** - the list of roles that have Guest access privileges \(read-only\) in StackState.

{% endtab %}

