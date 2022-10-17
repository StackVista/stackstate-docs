---
description: StackState Self-hosted v4.5.x
---

# LDAP

{% hint style="warning" %}
This page describes StackState v4.5.x.
The StackState 4.5 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.5 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/configure/security/authentication/ldap).
{% endhint %}

## Overview

StackState can use an LDAP server \(including AD\) to authenticate against and to get roles/groups from. It does require a running LDAP server that is accessible to StackState.

The LDAP main directory and all subdirectories will be checked for user files. The bind credentials in the StackState configuration are used to authenticate StackState on the LDAP server. After authentication, StackState passes the top LDAP directory name for the user that wants to log in to StackState.

## Configure StackState for LDAP

### Kubernetes

To configure StackState to authenticate using an LDAP authentication server on Kubernetes, LDAP details and user role mapping needs to be added to the file `authentication.yaml`. For example:

{% tabs %}
{% tab title="authentication.yaml" %}
```yaml
stackstate:
  authentication:
    ldap:
      host: sts-ldap
      port: 10389 # For most LDAP servers 389 for plain, 636 for ssl connections
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

    # map the groups from LDAP to the
    # 4 standard subjects in StackState (guest, powerUser, admin and platformAdmin)
    roles:
      guest: ["ldap-guest-role-for-stackstate"]
      powerUser: ["ldap-power-user-role-for-stackstate"]
      admin: ["ldap-admin-role-for-stackstate"]
      platformAdmin: ["ldap-platform-admin-role-for-stackstate"]
```
{% endtab %}
{% endtabs %}

Follow the steps below to configure StackState to authenticate using LDAP:

1. In `authentication.yaml` - add LDAP details \(see the example above\):
   * **host** - The hostname of the LDAP server.
   * **port** - The port the LDAP server is listening on.
   * **sslType** - Optional. The type of LDAP secure connection `ssl` or `startTls`. Omit if plain LDAP connection is used.
   * **trustCertificates** - Optional, certificate file for SSL. Formats PEM, DER and PKCS7 are supported.
   * **trustStore** - Optional, Java trust store file for SSL. If both `trustCertificates` and `trustStore` are specified, `trustCertificatesPath` takes precedence.
   * **bind** - Optional, used to authenticate StackState to LDAP server if the LDAP server does not support anonymous LDAP searches.
   * **userQuery parameters and groupQuery parameters** - The set of parameters inside correspond to the base dn of your LDAP where users and groups can be found. The first one is used for authenticating users in StackState, while the second is used for retrieving the group of that user to determine if the user is an Administrator, Power User or a Guest.
   * **usernameKey** - The name of the attribute that stores the username, value is matched against the username provided on the login screen.
   * **emailKey** - The name of the attribute that is used as the email address in StackState.
   * **rolesKey** - The name of the attribute that stores the group name.
   * **groupMemberKey** - The name of the attribute that indicates whether a user is a member of a group. The constructed LDAP filter follows this pattern: `<groupMemberKey>=<user.dn>,ou=groups,dc=acme,dc=com`.
2. In `authentication.yaml` - map user roles from LDAP to the correct StackState subjects \(see the example above\):
   * **roles** - for details, see the [default StackState roles](../rbac/rbac_permissions.md#predefined-roles). More StackState roles can also be created, see the [RBAC documentation](../rbac/).
3. Store the file `authentication.yaml` together with the `values.yaml` from the StackState installation instructions.
4. Run a Helm upgrade to apply the changes. If you are using SSL with custom certificates, the binary certificate files that should be used when connecting to LDAP should be set from the command line, use the command under **SSL with custom certificates**:

{% tabs %}
{% tab title="Plain LDAP or Secure LDAP" %}
```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values authentication.yaml \
stackstate \
stackstate/stackstate
```
{% endtab %}

{% tab title="SSL with custom certificates" %}
**trustCertificates**

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

**trustStore**

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
{% endtab %}
{% endtabs %}

{% hint style="info" %}
**Note:**

* The first run of the helm upgrade command will result in pods restarting, which may cause a short interruption of availability.
* Include `authentication.yaml` on every `helm upgrade` run.
* The authentication configuration is stored as a Kubernetes secret.
{% endhint %}

### Linux

To configure StackState to authenticate using an LDAP authentication server on Linux, LDAP details and user role mapping needs to be added to the file `application_stackstate.conf`. For example:

{% tabs %}
{% tab title="application\_stackstate.conf" %}
```javascript
authorization {
  // map the groups from the LDAP to the
  // 4 standard subjects in StackState (guest, powerUser, admin and platformAdmin)
  // Please note! you have to use the syntax
  // `<group>Groups = ${stackstate.authorization.<group>Groups} ["ldap-role"]`
  // to extend the list of standard roles (stackstate-admin, stackstate-platform-admin, stackstate-guest, stackstate-power-user)
  // with the ones from Ldap
  guestGroups = ${stackstate.authorization.guestGroups} ["ldap-guest-role-for-stackstate"]
  powerUserGroups = ${stackstate.authorization.powerUserGroups} ["ldap-powerUser-role-for-stackstate"]
  adminGroups = ${stackstate.authorization.adminGroups} ["ldap-admin-role-for-stackstate"]
  platformAdminGroups = ${stackstate.authorization.platformAdminGroups} ["ldap-platform-admin-role-for-stackstate"]
}

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
}
```
{% endtab %}
{% endtabs %}

Follow the steps below to configure StackState to authenticate using LDAP:

1. In `application_stackstate.conf` - add LDAP details \(see the example above\):
   * **host** - The hostname of the LDAP server.
   * **port** - The port the LDAP server is listening on.
   * **sslType** - Optional. Omit if plain LDAP connection is used. The type of LDAP secure connection `ssl` \| `startTls`.
   * **trustCertificatesPath** - optional, path to the trust store on the StackState server. Formats PEM, DER and PKCS7 are supported.
   * **trustStorePath** - optional, path to a Java trust store on the StackState server. If both `trustCertificatesPath` and `trustStorePath` are specified, `trustCertificatesPath` takes precedence.
   * **bindCredentials** - optional, used to authenticate StackState on the LDAP server if the LDAP server does not support anonymous LDAP searches.
   * **userQuery and groupQuery parameters** - The set of parameters inside correspond to the base dn of your LDAP where users and groups can be found. The first one is used for authenticating users in StackState, while the second is used for retrieving the group of that user to determine if the user is an Administrator, Power User or a Guest.
   * **usernameKey** - The name of the attribute that stores the username, value is matched against the username provided on the login screen.
   * **emailKey** - The name of the attribute that is used as the email address in StackState.
   * **rolesKey** - The name of the attribute that stores the group name.
   * **groupMemberKey** - The name of the attribute that indicates whether a user is a member of a group. The constructed LDAP filter follows this pattern: `<groupMemberKey>=<user.dn>,ou=groups,dc=acme,dc=com`.
2. In `application_stackstate.conf` - map the LDAP groups to the correct StackState groups using **guestGroups**, **powerUserGroups**, **adminGroups** and **platformAdminGroups** \(see the example above\). For details, see the [default StackState roles](../rbac/rbac_permissions.md#predefined-roles). More StackState roles can also be created, see the [RBAC documentation](../rbac/).
3. Restart StackState to apply the changes.

## See also

* [Authentication options](authentication_options.md)
* [Permissions for pre-defined StackState roles](../rbac/rbac_permissions.md#predefined-roles)
* [Create RBAC roles](../rbac/rbac_roles.md)

