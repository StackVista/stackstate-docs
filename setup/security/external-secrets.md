---
description: SUSE Observability External Secrets
---

# External Secrets

## Overview

SUSE Observability can take secrets like license key, api key and authentication keys through the helm install, but can also take those from already provisioned secrets.

Here is described how to configure this.

## Getting the license key from an external secret

Create a secret in the namespace SUSE Observability is installed in, of the following form, filling in the blanks:

```yaml
kind: Secret
metadata:
   name: "<custom-secret-name>"
type: Opaque
data:
  LICENSE_KEY: "<base64 of the license key>"
```

Add the following to your helm install command to use the secret:

```bash
  --set 'stackstate.license.fromExternalSecret'='<custom-secret-name>'
```

## Getting username and password for email notifications from an external secret

Create a secret in the namespace SUSE Observability is installed in, of the following form, filling in the blanks:

```yaml
kind: Secret
metadata:
   name: "<custom-secret-name>"
type: Opaque
data:
  SMTP_USER_NAME: "<base64 of the smtp username>"
  SMTP_PASSWORD: "<base64 of the smtp password>"
```

Add the following to your helm install command to use the secret:

```bash
  --set 'stackstate.email.server.auth.fromExternalSecret'='<custom-secret-name>'
```

## Getting the api key from an external secret

Create a secret in the namespace SUSE Observability is installed in, of the following form, filling in the blanks:

```yaml
kind: Secret
metadata:
   name: "<custom-secret-name>"
type: Opaque
data:
  API_KEY: "<base64 of the API key>"
```

Add the following to your helm install command to use the secret:

```bash
  --set 'stackstate.apiKey.fromExternalSecret'='<custom-secret-name>'
```

## Getting authentication data from an external secret

Create a secret in the namespace SUSE Observability is installed in, of the following form.

```yaml
kind: Secret
metadata:
   name: "<custom-secret-name>"
type: Opaque
data:
   default_password: <base64 of bcrypted password>
```

Depending on the authentication method chosen, the `default_password` field gets replaced with different data. See the [authentication options](/setup/security/authentication/authentication_options.md) for more info. In this example the [Single password](/setup/security/authentication/single_password.md) setup is used.

Add the following to your helm install command to use the secret:

```bash
  --set 'stackstate.authentication.fromExternalSecret'='<custom-secret-name>'
```
