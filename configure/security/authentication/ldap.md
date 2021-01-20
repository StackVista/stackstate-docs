## LDAP authentication server

StackState can use an LDAP server (including AD) to authenticate against and to get roles/groups from. It does require a running LDAP server that is accessible to StackState. You either need anonymous query access or bind credentials that StackState can use to query the LDAP server.

{% tabs %}
{% tab title="Kubernetes" %}

Here is an example of an authentication values YAML file that uses an LDAP server.

```yaml
stackstate:
  authentication:
    ldap:
      host: sts-ldap
      port: 10389 # For most LDAP servers 10389 for plain, 10636 for ssl connections
      #ssl:
      #  sslType: ssl
      #  trustStore: <see below>
      #  trustCertificates <see below>
      bind:
        dn: "cn=admin,ou=employees,dc=acme,dc=com"
        password: "password"
      userQuery:
        parameters:
          - ou: employees
          - dc: acme
          - dc: com
        usernameKey: cn
        emailKey: mail
      groupQuery:
        parameters:
          - ou: groups
          - dc: acme
          - dc: com
        rolesKey: cn
        groupMemberKey: member

    # map the groups from LDAP to the 3 standard subjects in StackState (guest, powerUser and admin)
    roles:
      guest: ["ldap-guest-role-for-stackstate"]
      powerUser: ["ldap-power-user-role-for-stackstate"]
      admin: ["ldap-admin-role-for-stackstate"]
```

Update it with your own values and use it to install, or update your running installation, of StackState with Helm. Store it together with the `values.yaml` from the installation instructions, it needs to be included on every `helm upgrade` command for StackState:

```
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values authentication.yaml \
stackstate \
stackstate/stackstate
```

Make sure that the groups in LDAP for your users are mapped to StackState groups using the `guestGroups`, `powerUserGroups` and `adminGroups` configurations. More roles can be created as well. See the [RBAC roles](../rbac/rbac_roles.md) documentation for the details.

The configuration fields are:

1. _**host**_ - The hostname of the LDAP server
2. _**port**_ - The port the LDAP server is listening on
3. _**sslType**_ - Optional. Omit if plain LDAP connection is used. The type of LDAP secure connection `ssl` \| `startTls`.
4.  _**trustCertificates**_ - optional, certificate file for SSL. Formats PEM, DER and PKCS7 are supported.
5.  _**trustStore**_ - optional, Java trust store file for SSL. \(if both `trustCertificates` and `trustStore` are specified, `trustCertificatesPath` takes precedence\)
6.  _**bind**_ - optional, used to authenticate StackState to LDAP server if the LDAP server does not support anonymous LDAP searches.
7.  _**userQuery and groupQuery parameters**_ - The set of parameters inside correspond to the base dn of your LDAP where users and groups can be found. The first one is used for authenticating users in StackState, while the second is used for retrieving the group of that user to determine if the user is an Administrator, Power User or a Guest.
8.  _**usernameKey**_ - The name of the attribute that stores the username, value is matched against the username provided on the login screen.
9.  _**emailKey**_ - The name of the attribute that is used as the email address in StackState
10. _**rolesKey**_ - The name of the attribute that stores the group name.
11. _**groupMemberKey**_ - The name of the attribute that indicates whether a user is a member of a group. The constructed LDAP filter folows this pattern: `<groupMemberKey>=<user.dn>,ou=groups,dc=acme,dc=com`


For configuring certificates that should be used when connecting to LDAP use one of the 2 keys, `trustStore` or `trustCertificates`. Since these values usually are binary files they should be set from the command line instead of in a yaml file:

```bash
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values authentication.yaml \
  --set-file stackstate.authentication.ldap.ssl.trustStore=./ldap-cacerts \
stackstate \
stackstate/stackstate
```

or 

```bash
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values authentication.yaml \
  --set-file stackstate.authentication.ldap.ssl.trustCertificates=./ldap-certificate.pem \
stackstate \
stackstate/stackstate
```

{% hint style="info" %}
* Running the helm upgrade command for the first time will result in restarting of pods possibly causing a short interruption of availability.
* The authentication configuration is stored as a Kubernetes secret.
{% endhint %}

{% endtab %}
{% tab title="Linux" %}

Here is an example of an authentication configuration that uses an OIDC provider. Replace the existing `authentication` section (nested in `stackstate.api`) in the configuration file with the example and edit it to match your LDAP server configuration. Restart StackState to make the change take effect.

```javascript
authentication {
  authServer {
    authServerType = [ "ldapAuthServer" ]

    ldapAuthServer {
      connection {
        host = localhost
        port = 8000
        # ssl {
        #    sslType = ssl
        #    trustCertificatesPath = "/var/lib/ssl/sts-ldap.pem"
        #    trustStorePath = "/var/lib/ssl/cacerts"
        # }
        bindCredentials {
           dn = "cn=admin,ou=employees,dc=acme,dc=com"
           password = "password"
         }
      }
      userQuery {
        parameters = [
          { ou : employees }
          { dc : acme }
          { dc : com }
        ]
        usernameKey = cn
        emailKey = mail
      }
      groupQuery {
        parameters = [
          { ou : groups }
          { dc : acme }
          { dc : com }
        ]
        rolesKey = cn
        groupMemberKey = member
      }
    }
  }

  // map the groups from the LDAP to the 3 standard subjects in StackState (guest, powerUser and admin)
  guestGroups = ["ldap-guest-role-for-stackstate"]
  powerUserGroups = ["ldap-powerUser-role-for-stackstate"]
  adminGroups = ["ldap-admin-role-for-stackstate"]
}
```

The configuration fields are:

1. _**host**_ - The hostname of the LDAP server
2. _**port**_ - The port the LDAP server is listening on
3. _**sslType**_ - Optional. Omit if plain LDAP connection is used. The type of LDAP secure connection `ssl` \| `startTls`.
4.  _**trustCertificatesPath**_ - optional, path to the trust store on the StackState server. Formats PEM, DER and PKCS7 are supported.
5.  _**trustStorePath**_ - optional, path to a Java trust store on the StackState server. \(if both `trustCertificatesPath` and `trustStorePath` are specified, `trustCertificatesPath` takes precedence\)
6.  _**bindCredentials**_ - optional, used to authenticate StackState to LDAP server if the LDAP server does not support anonymous LDAP searches.
7.  _**userQuery and groupQuery parameters**_ - The set of parameters inside correspond to the base dn of your LDAP where users and groups can be found. The first one is used for authenticating users in StackState, while the second is used for retrieving the group of that user to determine if the user is an Administrator, Power User or a Guest.
8.  _**usernameKey**_ - The name of the attribute that stores the username, value is matched against the username provided on the login screen.
9.  _**emailKey**_ - The name of the attribute that is used as the email address in StackState
10. _**rolesKey**_ - The name of the attribute that stores the group name.
11. _**groupMemberKey**_ - The name of the attribute that indicates whether a user is a member of a group. The constructed LDAP filter folows this pattern: `<groupMemberKey>=<user.dn>,ou=groups,dc=acme,dc=com`

 
Finally make sure that the groups in LDAP for your users are mapped to StackState groups using the `guestGroups`, `powerUserGroups` and `adminGroups` configurations; see also the [default roles](../rbac/rbac_permissions.md#predefined-roles). More roles can be created as well. See the [RBAC](../rbac/role_based_access_control.md) documentation for the details.

{% endtab %}
{% endtabs %}

Please note that StackState can check for user files in LDAP main directory as well as in all subdirectories. To do that StackState LDAP configuration requires `bind credentials` configured. Bind credentials are used to authenticate StackState to LDAP server, only after that StackState passes the top LDAP directory name for the user that wants to login to StackState.
