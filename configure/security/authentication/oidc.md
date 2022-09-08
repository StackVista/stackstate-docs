---
description: StackState Self-hosted v5.1.x 
---

# Open ID Connect \(OIDC\)

## Overview

StackState can authenticate using an OIDC authentication provider. To enable this, you will need to configure both StackState and the OIDC provider to be able to talk to each other. The following sections describe the respective setups.

## Configure the OIDC provider

Before you can configure StackState to authenticate using OIDC, you need to create a client for StackState on your OIDC provider. Use the following settings for the client \(if needed by the OIDC provider\):

* Use the OIDCAuthoirzation Flow
* Set the **Redirect URI** to the base URL of StackState suffixed with `/loginCallback`. For example `https://stackstate.acme.com/loginCallback`. For some OIDC providers, such as Google, the Redirect URI must match exactly, including any query parameters. In that case, you should configure the URI like this `https://stackstate.acme.com/loginCallback?client_name=StsOidcClient`.
* Give StackState access to at least the scopes `openid` and `email` or the equivalent of these for your OIDC provider.
* StackState needs OIDC offline access. For some identity providers, this requires an extra scope, usually called `offline_access`.

The result of this configuration should produce a **clientId** and a **secret**. Copy those and keep them around for configuring StackState. Also write down the **discoveryUri** of the provider. Usually this is either in the same screen or can be found in the documentation.

## Configure StackState for OIDC

### Kubernetes

To configure StackState to use an OIDC authentication provider on Kubernetes, OIDC details and user role mapping needs to be added to the file `authentication.yaml`. For example:

{% tabs %}
{% tab title="authentication.yaml" %}
```yaml
stackstate:
  authentication:
    oidc:
      clientId: "<client-id-from-oidc-provider>"
      secret: "<secret-from-oidc-provider>"
      discoveryUri: "https://oidc.acme.com/.well-known/openid-configuration"
      jwsAlgorithm: RS256
      scope: ["openid", "email"]
      jwtClaims:
        usernameField: email
        groupsField: groups
      customParameters:
        access_type: offline

    # map the groups from OIDC provider
    # to the 4 standard roles in StackState (guest, powerUser, admin and platformAdmin)
    roles:
      guest: ["oidc-guest-role-for-stackstate"]
      powerUser: ["oidc-power-user-role-for-stackstate"]
      admin: ["oidc-admin-role-for-stackstate"]
      platformAdmin: ["oidc-platform-admin-role-for-stackstate"]
```
{% endtab %}
{% endtabs %}

Follow the steps below to configure StackState to authenticate using OIDC:

1. In `authentication.yaml` - add details of the OIDC authentication provider \(see the example above\):
   * **clientId** - The ID of the [OIDC client you created for StackState](oidc.md#configure-the-oidc-provider).
   * **secret** - The secret for the [OIDC client you created for StackState](oidc.md#configure-the-oidc-provider)
   * **discoveryUri** - URI that can be used to discover the OIDC provider. Normally also documented or returned when creating the client in the OIDC provider.
   * **jwsAlgorithm** - The default for OIDC is `RS256`. If your OIDC provider uses a different one, it can be set here.
   * **scope** - Should match, or be a subset of, the scope provided in the OIDC provider configuration. StackState uses this to request access to these parts of a user profile in the OIDC provider.
   * **redirectUri** - Optional \(not in the example\): The URI where the login callback endpoint of StackState is reachable. Populated by default using the `stackstate.baseUrl`, but can be overridden. This must be a fully qualified URL that points to the `/loginCallback` path.
   * **customParameters** - Optional map of key/value pairs that are sent to the OIDC provider as custom request parameters. Some OIDC providers require extra request parameters not sent by default.
   * **jwtClaims** -
     * **usernameField** - The field in the OIDC user profile that should be used as the username. By default this will be the `preferred_username`, however, many providers omit this field. A good alternative is `email`.
     * **groupsField** - The field from which StackState will read the role/group for a user.
2. In `authentication.yaml` - map user roles from OIDC to the correct StackState subjects using the `roles.guest`, `roles.powerUser`, `roles.admin` or `roles.platformAdmin` settings \(see the example above\). For details, see the [default StackState roles](../rbac/rbac_permissions.md#predefined-roles). More StackState roles can also be created, see the [RBAC documentation](../rbac/).
3. Store the file `authentication.yaml` together with the `values.yaml` file from the StackState installation instructions.
4. Run a Helm upgrade to apply the changes:

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

* The first run of the helm upgrade command will result in pods restarting, which may cause a short interruption of availability.
* Include `authentication.yaml` on every `helm upgrade` run.
* The authentication configuration is stored as a Kubernetes secret.
{% endhint %}

### Linux

To configure StackState to use an OIDC authentication provider on Linux, OIDC details and user role mapping needs to be added to the file `application_stackstate.conf`. This should replace the existing `authentication` section that is nested in `stackstate.api`. For example:

{% tabs %}
{% tab title="application\_stackstate.conf" %}
```javascript
authorization {
  // map the groups from the OIDC provider to the
  // 4 standard subjects in StackState (guestGroups, powerUserGroups, adminGroups and platformAdminGroups)
  // Please note! you have to use the syntax
  // `<group>Groups = ${stackstate.authorization.<group>Groups} ["oidc-role"]`
  // to extend the list of standard roles (stackstate-admin, stackstate-platform-admin, stackstate-guest, stackstate-power-user)
  // with the ones from OIDC
  guestGroups = ${stackstate.authorization.guestGroups} ["oidc-guest-role-for-stackstate"]
  powerUserGroups = ${stackstate.authorization.powerUserGroups} ["oidc-power-user-role-for-stackstate"]
  adminGroups = ${stackstate.authorization.adminGroups} ["oidc-admin-role-for-stackstate"]
  platformAdminGroups = ${stackstate.authorization.platformAdminGroups} ["oidc-platform-admin-role-for-stackstate"]
}

authentication {
  enabled  = true

  authServer {
    authServerType = [ "oidcAuthServer" ]

    oidcAuthServer {
      clientId = "<client-id-from-oidc-provider>"
      secret = "<secret-from-oidc-provider>"
      discoveryUri = "https://oidc.acme.com/.well-known/openid-configuration"
      jwsAlgorithm = RS256
      scope = ["openid", "email"]
      redirectUri = "https://stackstate.acme.com/loginCallback"
      jwtClaims {
        usernameField = email
        groupsField = groups
      }
      customParams {
        access_type = "offline"
      }
    }
  }
}
```
{% endtab %}
{% endtabs %}

Follow the steps below to configure StackState to authenticate using OIDC:

1. In `application_stackstate.conf` - add details of the OIDC authentication provider \(see the example above\). This should replace the existing `authentication` section that is nested in `stackstate.api`:
   * **clientId** - The ID of the [OIDC client you created for StackState](oidc.md#configure-oidc-provider).
   * **secret** - The secret for the [OIDC client you created for StackState](oidc.md#configure-oidc-provider)
   * **discoveryUri** - URI that can be used to discover the OIDC provider. Normally also documented or returned when creating the client in the OIDC provider.
   * **jwsAlgorithm** - The default for OIDC is `RS256`. If your OIDC provider uses a different one, it can be set here.
   * **scope** - Should match, or be a subset of, the scope provided in the OIDC provider configuration. StackState uses this to request access to these parts of a user profile in the OIDC provider.
   * **redirectUri** - The URI where the login callback endpoint of StackState is reachable. This must be a fully qualified URL that points to the `/loginCallback` path.
   * **customParams** - Optional map of key/value pairs that are sent to the OIDC provider as custom request parameters. Some OIDC providers require extra request parameters not sent by default.
   * **jwtClaims** -
     * **usernameField** - The field in the OIDC user profile that should be used as the username. By default this will be the `preferred_username`, however, many providers omit this field. A good alternative is `email`.
     * **groupsField** - The field from which StackState will read the role/group for a user.
2. In `application_stackstate.conf` - map user roles from OIDC to the correct StackState subjects using the `guestGroups`, `powerUserGroups`, `adminGroups` or `platformAdminGroups` settings \(see the example above\). For details, see the [default StackState roles](../rbac/rbac_permissions.md#predefined-roles). More StackState roles can also be created, see the [RBAC documentation](../rbac/).
3. Restart StackState to apply the changes.

## Additional settings for specific OIDC providers

This section contains additional settings needed for specific OIDC providers.

### Microsoft Identity Platform

To authenticate StackState via OIDC with the Microsoft Identity Platform, the additional scope `offline_access` needs to be granted and requested during authentication.

In Microsoft Azure, approve the permission _"Maintain access to data you have given it access to"_ on the consent page of the authorization code flow.

In the StackState configuration described above, add the scope `offline_access`, in addition to `openid` and `email`. For example:

```yaml
jwsAlgorithm: RS256
      scope: ["openid", "email", "offline_access"]
      jwtClaims:
        usernameField: preferred_username
        groupsField: groups
```

For further details, see [Permissions and consent in the Microsoft identity platform \(docs.microsoft.com\)](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent).

## See also

* [Authentication options](authentication_options.md)
* [Permissions for predefined StackState roles](../rbac/rbac_permissions.md#predefined-roles)
* [Create RBAC roles](../rbac/rbac_roles.md)

