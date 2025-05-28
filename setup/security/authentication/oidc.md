---
description: SUSE Observability Self-hosted
---

# Open ID Connect \(OIDC\)

## Overview

SUSE Observability can authenticate using an OIDC authentication provider. To enable this, you will need to configure both SUSE Observability and the OIDC provider to be able to talk to each other. The following sections describe the respective setups.

## Configure the OIDC provider

Before you can configure SUSE Observability to authenticate using OIDC, you need to create a client for SUSE Observability on your OIDC provider. Use the following settings for the client \(if needed by the OIDC provider\):

* Use the OIDC Authorization Flow, it is also often called the Authorization code flow. SUSE Observability does not support the Implicit grant and hybrid flows, so there is no need to enable support for them.
* Set the **Redirect URI** to the base URL of SUSE Observability suffixed with `/loginCallback`. For example `https://stackstate.acme.com/loginCallback`. For some OIDC providers, such as Google and Azure Entra ID, the Redirect URI must match exactly, including any query parameters. In that case, you should configure the URI like this `https://stackstate.acme.com/loginCallback?client_name=StsOidcClient`.
* Give SUSE Observability access to at least the scopes `openid` and `email` or the equivalent of these for your OIDC provider. Depending on the provider more scopes may be required, if a separate `profile` exists include it as well.
* SUSE Observability needs OIDC offline access. For some identity providers, this requires an extra scope, usually called `offline_access`.

The result of this configuration should produce a **clientId** and a **secret**. Copy those and keep them around for configuring SUSE Observability. Also write down the **discoveryUri** of the provider. Usually this is either in the same screen or can be found in the documentation.

### Configuring Rancher as OIDC provider

In order for SUSE Observability to authenticate with Rancher, an OIDC Client needs to be created for it.  This can be provisioned as a Kubernetes resource in the Rancher "local" cluster:
```
apiVersion: management.cattle.io/v3
kind: OIDCClient
metadata:
  name: oidc-observability
spec:
  tokenExpirationSeconds: 600
  refreshTokenExpirationSeconds: 3600
  redirectURIs:
    - "https://<suse-observability-url>/loginCallback?client_name=StsOidcClient"
```
After creation, Rancher will add a `status` field:
```
status:
  clientID: <oidc-client-id>
```
This will lead to the creation of a secret with name `<oidc-client-id>` in the `cattle-oidc-client-secrets` namespace.

## Configure SUSE Observability for OIDC

### Rancher

To configure Rancher as the OIDC provider for SUSE Observability, the OIDC details need to be added to the authentication values:
```yaml
stackstate:
  authentication:
    oidc:
      clientId: "<oidc-client-id>"
      secret: "<oidc-secret>"
      baseUrl: "<rancher-url>"
```
You can override and extend some of the OIDC config for Rancher with the following fields:
- `discoveryUri`
- `redirectUri`
- `customParams`

If you need to disable TLS verification due to a setup not using verifiable SSL certificates, you can disable SSL checks with some application config (don't use in production):
```yaml
stackstate:
  components:
    server:
      extraEnv:
        open:
          CONFIG_FORCE_stackstate_misc_sslCertificateChecking: false
```

### Kubernetes

To configure SUSE Observability to use an OIDC authentication provider on Kubernetes, OIDC details and user role mapping needs to be added to the file `authentication.yaml`. For example:

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
        displayNameField: name
        groupsField: groups
      customParameters:
        access_type: offline

    # map the groups from OIDC provider
    # to the 4 standard roles in SUSE Observability (guest, powerUser, k8sTroubleshooter and admin)
    roles:
      guest: ["guest-group-in-oidc-provider"]
      powerUser: ["powerUser-group-in-oidc-provider"]
      admin: ["admin-group-in-oidc-provider"]
      k8sTroubleshooter: ["troubleshooter-group-in-oidc-provider"]
```

Follow the steps below to configure SUSE Observability to authenticate using OIDC:

1. In `authentication.yaml` - add details of the OIDC authentication provider \(see the example above\):
   * **clientId** - The ID of the [OIDC client you created for SUSE Observability](oidc.md#configure-the-oidc-provider).
   * **secret** - The secret for the [OIDC client you created for SUSE Observability](oidc.md#configure-the-oidc-provider)
   * **discoveryUri** - URI that can be used to discover the OIDC provider. Normally also documented or returned when creating the client in the OIDC provider.
   * **jwsAlgorithm** - The default for OIDC is `RS256`. If your OIDC provider uses a different one, it can be set here.
   * **scope** - Should match, or be a subset of, the scope provided in the OIDC provider configuration. SUSE Observability uses this to request access to these parts of a user profile in the OIDC provider.
   * **redirectUri** - Optional \(not in the example\): The URI where the login callback endpoint of SUSE Observability is reachable. Populated by default using the `stackstate.baseUrl`, but can be overridden. This must be a fully qualified URL that points to the `/loginCallback` path.
   * **customParameters** - Optional map of key/value pairs that are sent to the OIDC provider as custom request parameters. Some OIDC providers require extra request parameters not sent by default.
   * **jwtClaims** -
     * **usernameField** - The field in the OIDC user profile that should be used as the username. By default, this will be the `preferred_username`, however, many providers omit this field. A good alternative is `email`.
     * **displayNameField** - The field in the OIDC user profile that should be used as the displayName. By default, this will be the `name`.
     * **groupsField** - The field from which SUSE Observability will read the role/group for a user.
2. In `authentication.yaml` - map user roles from OIDC to the correct SUSE Observability subjects using the `roles.guest`, `roles.powerUser`, `roles.admin` or `roles.platformAdmin` settings \(see the example above\). For details, see the [default SUSE Observability roles](../rbac/rbac_permissions.md#predefined-roles). More SUSE Observability roles can also be created, see the [RBAC documentation](../rbac/).
3. Store the file `authentication.yaml` together with the `values.yaml` file from the SUSE Observability installation instructions.
4. Run a Helm upgrade to apply the changes:

   ```text
    helm upgrade \
      --install \
      --namespace suse-observability \
      --values values.yaml \
      --values authentication.yaml \
    suse-observability \
    suse-observability/suse-observability
   ```

{% hint style="info" %}
**Note:**

* The first run of the helm upgrade command will result in pods restarting, which may cause a short interruption of availability.
* Include `authentication.yaml` on every `helm upgrade` run.
* The authentication configuration is stored as a Kubernetes secret.
{% endhint %}

## Setup guides

* [Microsoft Entra ID](./oidc/microsoft-entra-id.md)

## Using an external secret

When the oidc secrets should come from an external secret, follow [these steps](/setup/security/external-secrets.md#getting-authentication-data-from-an-external-secret) but fill in the following data:

```yaml
kind: Secret
metadata:
   name: "<custom-secret-name>"
type: Opaque
data:
  oidc_client_id: <base64 of client id>
  oidc_secret: <base64 of secret>
```

## See also

* [Troubleshooting authentication and authorization](troubleshooting.md)
* [Authentication options](authentication_options.md)
* [Permissions for predefined SUSE Observability roles](../rbac/rbac_permissions.md#predefined-roles)
* [Create RBAC roles](../rbac/rbac_roles.md)
* [External Secrets](/setup/security/external-secrets.md#getting-authentication-data-from-an-external-secret)
