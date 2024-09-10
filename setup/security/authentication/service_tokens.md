---
description: SUSE Observability Self-hosted
---

# Service tokens

## Overview

Using Service tokens it's possible to authenticate to SUSE Observability without having configured a user account. This is useful for situations where you want to use SUSE Observability from headless services like a CI server. In such a scenario you typically don't want to provision a user account in your identity provider.

## Manage service tokens

Service tokens can be managed via the [`sts` CLI](/setup/cli/cli-sts.md). The following commands are available:

```bash
> sts service-token --help
Manage service tokens.

Usage:
  sts service-token [command]

Available Commands:
  create      Create a service token
  delete      Delete a service token
  list        List service tokens

Use "sts service-token [command] --help" for more information about a command.
```

It's also possible to [set up a bootstrap service token](#set-up-a-bootstrap-service-token) when installing SUSE Observability.

### Create service tokens

To create a service token for an installed instance of SUSE Observability, you can use the new `sts` CLI.

```sh
sts service-token create
```

{% hint style="info" %}
Note that the service token will only be displayed once. It isn't possible to see the token again.
{% endhint %}

This command takes the following command line arguments:

| Flag | Description |
| :--- |:--- |
| `--name` | The name of the service token |
| `--expiration` | The expiration date of the service token, the format is yyyy-MM-dd. The expiration is optional. |
| `--roles` | A comma separated list of roles to assign to the service token |

For example, the command below will create a service token with the name `my-service-token` and the role `stackstate-power-user`:


```sh
> sts service-token create --name my-service-token --roles stackstate-power-user
✅ Service token created: svctok-aaaaa-bbbb-ccccc-ddddd
```

### Set up a bootstrap service token

When installing SUSE Observability, it's possible to bootstrap it with a (temporary) service token. This allows for using the CLI without first interacting with SUSE Observability and obtaining an API token from the UI. In order to set this up, you can add the following snippet to the SUSE Observability configuration file:

To configure SUSE Observability to create a bootstrap service token on Kubernetes, The following values need to be added to the file `authentication.yaml`. For example

```yaml
stackstate:
  authentication:
    servicetoken:
      bootstrap:
        token: <token>
        roles:
          - stackstate-power-user
        ttl: 24h
```

Follow the steps below to configure SUSE Observability to create a bootstrap service token:

1. In `authentication.yaml` - add the bootstrap token:
   * **token** - The token that will be created on (initial) start of SUSE Observability.
   * **roles** - An array of roles that will be assigned to the bootstrap token.
   * **ttl** - Optional. The time-to-live for the service token, expressed as a duration string.
2. Store the file `authentication.yaml` together with the `values.yaml` from the SUSE Observability installation instructions.
3. Run a Helm upgrade to apply the changes.
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

### List service tokens

The ID, name, expiration date and roles of all created service tokens can be seen using the new `sts` CLI. For example:


```bash
> sts service-token list
ID              | NAME             | EXPIRATION | ROLES
107484341630693 | my-service-token |            | [stackstate-power-user]
```

### Delete service tokens

A service token can be deleted using the new `sts` CLI. Pass the ID of the service token as an argument. For example:

```bash
> sts service-token delete 107484341630693
✅ Service token deleted: 107484341630693
```

## Use service tokens

Once created, a service token can be used to authenticate to SUSE Observability from a headless service. To do this you can either use the CLI or directly talk to the API.


### SUSE Observability `sts` CLI

A service token can be used for authentication with the `sts` CLI. For details, see [the CLI documentation](/setup/cli/cli-sts.md#authentication).

### SUSE Observability APIs

To use a service token to talk directly to the SUSE Observability Base API or the SUSE Observability Admin API, add it to the header of the request in one of the following ways:

* In the `Authorization` header:
    ```bash
    > curl -X GET -H "Authorization: ApiKey <TOKEN>" http://localhost:8080/api/server/status
    ```

* In the `X-API-Key` header:
    ```bash
    > curl -X GET -H "X-API-Key: <TOKEN>" http://localhost:8080/api/server/status
    ```

➡️ [Learn more about the SUSE Observability APIs](/setup/cli/cli-sts.md#authentication)
