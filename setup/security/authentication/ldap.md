---
description: StackState for Kubernetes troubleshooting Self-hosted
---

# LDAP

## Overview

StackState can use an LDAP server \(including AD\) to authenticate against and to get roles/groups from. It does require a running LDAP server that's accessible to StackState.

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
        # to return all nested groups, use:
        # groupMemberKey: "member:1.2.840.113556.1.4.1941:"

    # map the groups from LDAP to the
    # standard subjects in StackState (guest, powerUser, admin and platformAdmin)
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
   * **bind** - Optional, used to authenticate StackState to LDAP server if the LDAP server doesn't support anonymous LDAP searches.
   * **userQuery parameters and groupQuery parameters** - The set of parameters inside correspond to the base dn of your LDAP where users and groups can be found. The first one is used for authenticating users in StackState, while the second is used for retrieving the group of that user to determine if the user is an Administrator, Power User or a Guest.
   * **usernameKey** - The name of the attribute that stores the username, value is matched against the username provided on the login screen.
   * **emailKey** - The name of the attribute that's used as the email address in StackState.
   * **rolesKey** - The name of the attribute that stores the group name.
   * **groupMemberKey** - The name of the attribute that indicates whether a user is a member of a group. The constructed LDAP filter follows this pattern: `<groupMemberKey>=<user.dn>,ou=groups,dc=acme,dc=com`. To return all nested groups, use `groupMemberKey: "member:1.2.840.113556.1.4.1941:"`.
2. In `authentication.yaml` - map user roles from LDAP to the correct StackState subjects \(see the example above\):
   * **roles** - for details, see the [default StackState roles](../rbac/rbac_permissions.md#predefined-roles). More StackState roles can also be created, see the [RBAC documentation](../rbac/).
3. Store the file `authentication.yaml` together with the `values.yaml` from the StackState installation instructions.
4. Run a Helm upgrade to apply the changes. If you are using SSL with custom certificates, the binary certificate files that should be used when connecting to LDAP should be set from the command line, use the command under **SSL with custom certificates**:

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values authentication.yaml \
stackstate \
stackstate/stackstate-k8s
```

**trustCertificates**

```bash
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values authentication.yaml \
  --set-file stackstate.authentication.ldap.ssl.trustCertificates=./ldap-certificate.pem \
stackstate \
stackstate/stackstate-k8s
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
stackstate/stackstate-k8s
```

{% hint style="info" %}
**Note:**

* The first run of the helm upgrade command will result in pods restarting, which may cause a short interruption of availability.
* Include `authentication.yaml` on every `helm upgrade` run.
* The authentication configuration is stored as a Kubernetes secret.
{% endhint %}

## See also

* [Authentication options](authentication_options.md)
* [Permissions for predefined StackState roles](../rbac/rbac_permissions.md#predefined-roles)
* [Create RBAC roles](../rbac/rbac_roles.md)

