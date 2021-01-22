# KeyCloak

In order to configure StackState to authenticate using KeyCloak OIDC as an authentication provider, you will need to configure both of them to be able to talk to each other. The following sections describe the respective setups.

## Configuring KeyCloak

In order to connect StackState to KeyCloak, you need to add a new client configuration to the KeyCloak Authentication Server. The necessary settings for the client are:

1. **Client ID** - This is the ID of the client that is connecting, we recommend naming this `stackstate`
2. **Client Protocol** - Set this to `openid-connect`
3. **Access Type** - Set this to `confidential`, so that a secret is used to establish the connection between KeyCloak and StackState
4. **Standard Flow Enabled** - This should be `Enabled`
5. **Implicit Flow Enabled** - This should be `Disabled`
6. **Root URL** - This should point to the root location of StackState (the same value configured in as base URL of the StackState configuration
7. **Valid redirect URIs** - This should be `/loginCallback/*`
8. **Base URL** - This should point to the root location of StackState

## Configuring StackState

{% tabs %}
{% tab title="Kubernetes" %}
Here is an example of a `authentication.yaml` file that uses the Keycloak server you just configured.

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

    # map the roles from Keycloak to the 3 standard subjects in StackState (guest, powerUser and admin)
    roles:
      guest: ["keycloak-guest-role-for-stackstate"]
      powerUser: ["keycloak-power-user-role-for-stackstate"]
      admin: ["keycloak-admin-role-for-stackstate"]

```

Update it with your own values, The KeyCloak specific values can be obtained from the client configuration in KeyCloak, and make sure that the roles users can have in Keycloak are mapped to the correct subjects in StackState using the `roles.guest`, `roles.powerUser` or `roles.admin` settings; see also the [default roles](../rbac/rbac_permissions.md#predefined-roles). More roles can be created as well. See the [RBAC](../rbac/role_based_access_control.md) documentation for the details.

Store the file `authentication.yaml` together with the file `values.yaml` from the StackState installation instructions. To apply the changes run a Helm upgrade:

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
* The file `authentication.yaml` needs to be included on every `helm upgrade` run
* The authentication configuration is stored as a Kubernetes secret.
{% endhint %}

Configuration field explanation:

1. **clientId** - The ID of the KeyCloak client as configured in KeyCloak
2. **secret** - The secret attached to the KeyCloak client, which is used to authenticate this client to KeyCloak
3. **url** - The base URI for the KeyCloak instance
4. **realm** - The KeyCloak realm to connect to
5. **redirectUri** - Optional: The URI where the login callback endpoint of StackState is reachable. Populated by default using the `stackstate.baseUrl`, but can be overriden (must be a fully qualified URL that points to the `/loginCallback` path)
6. **authenticationMethod** - Set this to `client_secret_basic` which is the only supported value for now
7. **jwsAlgorithm** - Set this to `RS256`, which is the only supported value for now
8. **jwtClaims** - Optional (not in example): The roles or username can be retrieved from a different attribute than the Keycloak default behavior
   1. **usernameField** - Optional: The field in the OIDC user profile that should be used as the username. By default this will be the `preferred_username`.
   2.  **groupsField** - Optional: StackState will always, and by default only, use the `roles` Keycloak provides. But it can also add roles from the field specified here. This is mainly useful when Keycloak is mapping roles/groups from a third-party system.

{% endtab %}


{% tab title="Linux" %}
Here is an example of an authentication configuration that uses a KeyCloak server. Replace the existing `authentication` section (nested in `stackstate.api`) in the configuration file with the example and edit it to match your Keycloak settings. Restart StackState to make the change take effect.

```javascript
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

  // map the roles from Keycloak to the 3 standard subjects in StackState (guest, powerUser and admin)
  guestGroups = ["keycloak-guest-role-for-stackstate"]
  powerUserGroups = ["keycloak-power-user-role-for-stackstate"]
  adminGroups = ["keycloak-admin-role-for-stackstate"]
}
```
Configuration field explanation:

1. **clientId** - The ID of the KeyCloak client as configured in KeyCloak
2. **secret** - The secret attached to the KeyCloak client, which is used to authenticate this client to KeyCloak
3. **keycloakBaseUri** - The base URI for the KeyCloak instance
4. **realm** - The KeyCloak realm to connect to
5. **redirectUri** - The URI where the login callback endpoint of StackState is reachable (must be a fully qualified URL that points to the `/loginCallback` path)
6. **authenticationMethod** - Set this to `client_secret_basic` which is the only supported value for now
7. **jwsAlgorithm** - Set this to `RS256`, which is the only supported value for now
8. **jwtClaims** - Optional (not in example): The roles or username can be retrieved from a different attribute than the Keycloak default behavior
   1. **usernameField** - Optional: The field in the OIDC user profile that should be used as the username. By default this will be the `preferred_username`.
   2.  **groupsField** - Optional: StackState will always, and by default only, use the `roles` Keycloak provides. But it can also add roles from the field specified here. This is mainly useful when Keycloak is mapping roles/groups from a third-party system.

The KeyCloak specific values can be obtained from the client configuration in KeyCloak.

Finally make sure that the roles users can have in Keycloak are mapped to the correct subjects in StackState using the `guestGroups`, `powerUserGroups` or `adminGroups` settings; see also the [default roles](../rbac/rbac_permissions.md#predefined-roles). More roles can be created as well. See the [RBAC](../rbac/role_based_access_control.md) documentation for the details.
{% endtab %}
{% endtabs %}
