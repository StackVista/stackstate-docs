# Open ID Connect (OIDC)

In order to configure StackState to authenticate using an OIDC authentication provider, you will need to configure both of them to be able to talk to each other. The following sections describe the respective setups.

First go the your OIDC provider and create a client for StackState using the following settings (if required):
* Use the OIDCAuthoirzation Flow
* Set the Redirect URI to the base URL of StackState suffixed with `/loginCallback. For example https://stackstate.acme.com/loginCallback. For some OIDC providers (for example Google) it is needed that the Redirect URI matches exactly, including query parameters. In that case configure the URI like this https://stackstate.acme.com/loginCallback?client_name=StsOidcClient
* Give StackState access to at least the `openid` and `email` scopes (or the equivalent of those for your OIDC provider

The result of this configuration should produce a clientId and a secret. Copy those and keep them around for configuring StackState. Also write down the discoveryUri of the provider. Usually this is either in the same screen or can be found in the documentation.

## Configuring StackState

{% tabs %}
{% tab title="Kubernetes" %}

Here is an example of an `authentication.yaml` file for OIDC:

```yaml
stackstate:
  authentication:
    oidc:
      clientId: "<client-id-from-oidc-provider>"
      secret: "<secret-from-oidc-provider>"
      discoveryUri: "https://oidc-provider.acme.com/.well-known/openid-configuration"
      jwsAlgorithm: RS256
      scope: ["openid", "email"]
      jwtClaims:
        usernameField: email
        groupsField: groups

    # map the groups from OIDC provider to the 3 standard subjects in StackState (guest, powerUser and admin)
    roles:
      guest: ["oidc-guest-role-for-stackstate"]
      powerUser: ["oidc-power-user-role-for-stackstate"]
      admin: ["oidc-admin-role-for-stackstate"]
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

{% hint style="info" %}
* Running the helm upgrade command for the first time will result in restarting of pods possibly causing a short interruption of availability.
* The authentication configuration is stored as a Kubernetes secret.
{% endhint %}
{% endtab %}


{% tab title="Linux" %}
Here is an example of an authentication configuration that uses an OIDC provider. Replace the existing `authentication` section (nested in `stackstate.api`) in the configuration file with the example and edit it to match your OIDC settings. Restart StackState to make the change take effect.

```javascript
authentication {
  enabled  = true

  authServer {
    authServerType = [ "oidcAuthServer" ]

    oidcAuthServer {
      clientId = "<client-id-from-oidc-provider>"
      secret = "<secret-from-oidc-provider>"
      discoveryUri = "https://oidc-provider.acme.com/.well-known/openid-configuration"
      jwsAlgorithm = RS256
      scope = ["openid", "email"]
      redirectUri = "https://stackstate.acme.com/loginCallback"
      jwtClaims {
        usernameField = email
        groupsField = groups
      }
    }
  }

  // map the groups from the OIDC provider to the 3 standard subjects in StackState (guest, powerUser and admin)
  guestGroups = ["oidc-guest-role-for-stackstate"]
  powerUserGroups = ["oidc-power-user-role-for-stackstate"]
  adminGroups = ["oidc-admin-role-for-stackstate"]
}
```
{% endtab %}
{% endtabs %}

Configuration field explanation:

1. **clientId** - The ID of the OIDC client from the first step
2. **secret** - The secret for the OIDC client from the first step
3. **discoveryUri** - URI that can be used to discover the OIDC provider. Normally also documented or returned when creating the client in the OIDC provider.
4. **jwsAlgorithm** - The default for OIDC is `RS256`. If your OIDC provider uses a different one it can be changed here
5. **scope** - Should match (or be a subset of) the scope provided in the OIDC provider configuration. StackState uses this to request access to these parts of a user profile in the OIDC provider.
6. **redirectUri** - The URI where the login callback endpoint of StackState is reachable (for Kuberentes this can be overriden but is by default populated based on the `stackstate.baseUrl` setting)
7. **jwtClaims** - 
   1. **usernameField** - The field in the OIDC user profile that should be used as the username. By default this will be the `preferred_username`, however many providers omit this field. A good alternative is `email`.
   2. **groupsField** - The field from which StackState will read the role/group for a user. 

Finally make sure that the roles users can have in Keycloak are mapped to the correct subjects in StackState using the `guestGroups`, `powerUserGroups` or `adminGroups` settings; see also the [default roles](../rbac/rbac_permissions.md#predefined-roles). More roles can be created as well. See the [RBAC](../rbac/role_based_access_control.md) documentation for the details.
