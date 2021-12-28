# KeyCloak

## Overview

StackState can authenticate using KeyCloak as an authentication provider, you will need to configure both StackState and KeyCloak to be able to talk to each other. The following sections describe the respective setups.

## Configure KeyCloak

Before you can configure StackState to authenticate using KeyCloak, you need to add a new client configuration to the KeyCloak Authentication Server. The necessary settings for the client are:

* **Client ID** - The ID of the client that is connecting, we recommend naming this `stackstate`
* **Client Protocol** - Set to `openid-connect`
* **Access Type** - Set to `confidential`, so that a secret is used to establish the connection between KeyCloak and StackState
* **Standard Flow Enabled** - Set to `Enabled`
* **Implicit Flow Enabled** - Set to `Disabled`
* **Root URL** - The root location of StackState \(the same value configured in as base URL of the StackState configuration
* **Valid redirect URIs** - This should be `/loginCallback/*`
* **Base URL** - This should point to the root location of StackState

## Configure StackState

### Kubernetes

To configure StackState to authenticate using KeyCloak, KeyCloak details and user role mapping needs to be added to the file `authentication.yaml`. For example:

{% tabs %}
{% tab title="authentication.yaml" %}
```yaml
stackstate:
  authentication:
    keycloak:
      url: "https://keycloak.acme.com/auth"
      realm: acme
      authenticationMethod: client_secret_basic
      clientId: stackstate
      secret: "8051a2e4-e367-4631-a0f5-98fc9cdc564d"
      jwsAlgorithm: RS256
      # jwtClaims:
      #   usernameField: preferred_username
      #   groupsField: roles

    # map the roles from Keycloak to the
    # 4 standard subjects in StackState (guest, powerUser, admin and platformAdmin)
    roles:
      guest: ["keycloak-guest-role-for-stackstate"]
      powerUser: ["keycloak-power-user-role-for-stackstate"]
      admin: ["keycloak-admin-role-for-stackstate"]
      platformAdmin: ["keycloak-platformadmin-role-for-stackstate"]
```
{% endtab %}
{% endtabs %}

Follow the steps below to configure StackState to authenticate using KeyCloak:

1. In `authentication.yaml` - add details of the KeyCloak authentication provider \(see the example above\). The KeyCloak specific values can be obtained from the client configuration in KeyCloak:
   * **url** - The base URI for the KeyCloak instance
   * **realm** - The KeyCloak realm to connect to
   * **authenticationMethod** - Set to `client_secret_basic`, this is currently the only supported value.
   * **clientId** - The ID of the KeyCloak client as configured in KeyCloak
   * **secret** - The secret attached to the KeyCloak client, which is used to authenticate this client to KeyCloak
   * **redirectUri** - Optional: The URI where the login callback endpoint of StackState is reachable. Populated by default using the `stackstate.baseUrl`, but can be overridden \(must be a fully qualified URL that points to the `/loginCallback` path\)
   * **jwsAlgorithm** - Set this to `RS256`, this is currently the only supported value.
   * **jwtClaims** - Optional: The roles or username can be retrieved from a different attribute than the Keycloak default behavior
     * **usernameField** - Optional: The field in the OIDC user profile that should be used as the username. By default this will be the `preferred_username`.
     * **groupsField** - Optional: StackState will always, and by default only, use the `roles` Keycloak provides. But it can also add roles from the field specified here. This is mainly useful when Keycloak is mapping roles/groups from a third-party system.
2. In `authentication.yaml` - map user roles from KeyCloak to the correct StackState subjects using the `roles.guest`, `roles.powerUser`, `roles.platformAdmin` or `roles.admin` settings \(see the example above\). For details, see the [default StackState roles](../rbac/rbac_permissions.md#predefined-roles). More StackState roles can also be created, see the [RBAC documentation](../rbac/).
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

To configure StackState to use a KeyCloak authentication provider on Linux, KeyCloak details and user role mapping needs to be added to the file `application_stackstate.conf`. This should replace the existing `authentication` section that is nested in `stackstate.api`. For example:

{% tabs %}
{% tab title="application\_stackstate.conf" %}
```javascript
authorization {
  // map the roles from Keycloak to the
  // 4 standard subjects in StackState (guest, powerUser, admin and platformAdmin)
  // Please note! you have to use the syntax
  // `<group>Groups = ${stackstate.authorization.<group>Groups} ["keycloak-role"]`
  // to extend the list of standard roles (stackstate-admin, stackstate-platform-admin, stackstate-guest, stackstate-power-user)
  // with the ones from Keycloak
  guestGroups = ${stackstate.authorization.guestGroups} ["keycloak-guest-role-for-stackstate"]
  powerUserGroups = ${stackstate.authorization.powerUserGroups} ["keycloak-power-user-role-for-stackstate"]
  adminGroups = ${stackstate.authorization.adminGroups} ["keycloak-admin-role-for-stackstate"]  
  platformAdminGroups = ${stackstate.authorization.platformAdminGroups} ["keycloak-platform-admin-role-for-stackstate"]  
}

authentication {
  authServer {
    authServerType = [ "keycloakAuthServer" ]

    keycloakAuthServer {
      clientId = stackstate
      secret = "8051a2e4-e367-4631-a0f5-98fc9cdc564d"
      keycloakBaseUri = "https://keycloak.acme.com/auth"
      realm = acme
      redirectUri = "https://stackstate.acme.com/loginCallback"
      authenticationMethod = "client_secret_basic"
      jwsAlgorithm = "RS256"
    }
  }
}
```
{% endtab %}
{% endtabs %}

Follow the steps below to configure StackState to authenticate using KeyCloak:

1. In `application_stackstate.conf` - add details of the KeyCloak authentication provider \(see the example above\). This should replace the existing `authentication` section that is nested in `stackstate.api`. The KeyCloak specific values can be obtained from the client configuration in KeyCloak:
   * **clientId** - The ID of the KeyCloak client as configured in KeyCloak.
   * **secret** - The secret attached to the KeyCloak client, which is used to authenticate this client to KeyCloak.
   * **keycloakBaseUri** - The base URI for the KeyCloak instance.
   * **realm** - The KeyCloak realm to connect to.
   * **redirectUri** - The URI where the login callback endpoint of StackState is reachable \(must be a fully qualified URL that points to the `/loginCallback` path\).
   * **authenticationMethod** - Set this to `client_secret_basic` which is the only supported value for now.
   * **jwsAlgorithm** - Set this to `RS256`, which is the only supported value for now.
   * **jwtClaims** - Optional \(not in example\): The roles or username can be retrieved from a different attribute than the Keycloak default behavior.

     -. **usernameField** - Optional: The field in the OIDC user profile that should be used as the username. By default this will be the `preferred_username`.

     * **groupsField** - Optional: StackState will always, and by default only, use the `roles` Keycloak provides. But it can also add roles from the field specified here. This is mainly useful when Keycloak is mapping roles/groups from a third-party system.
2. In `application_stackstate.conf` - map user roles from KeyCloak to the correct StackState subjects using the `guestGroups`, `powerUserGroups`, `adminGroups` or `platformAdminGroups` settings \(see the example above\). For details, see the [default StackState roles](../rbac/rbac_permissions.md#predefined-roles). More StackState roles can also be created, see the [RBAC documentation](../rbac/).
3. Restart StackState to apply the changes.

## See also

* [Authentication options](authentication_options.md)
* [Permissions for pre-defined StackState roles](../rbac/rbac_permissions.md#predefined-roles)
* [Create RBAC roles](../rbac/rbac_roles.md)

