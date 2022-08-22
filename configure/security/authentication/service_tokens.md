---
description: StackState Self-hosted v5.0.x
---

# Service tokens

## Overview

Using Service tokens it is possible to authenticate to StackState without having configured a user account. This is useful for situations where you want to use StackState from headless services like a CI server. In such a scenario you typically do not want to provision a user account in your identity provider.

## Manage service tokens

Service tokens can be managed via the [new `sts` CLI](../../../setup/cli/cli-sts.md). The following commands are available:

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

It is also possible to [set up a bootstrap service token](#set-up-a-bootstrap-service-token) when installing StackState.

### Create service tokens

To create a service token for an installed instance of StackState, you can use the new `sts` CLI.

{% tabs %}
{% tab title="CLI: sts (new)" %}
```commandline
sts service-token create
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI has been renamed to`stac` and there is a new `sts` CLI. This command is for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endtab %}
{% tab title="CLI: stac" %}

Command not available in the `stac` CLI, use the new `sts` CLI.


⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% endtabs %}


{% hint style="info" %}
Note that the service token will only be displayed once. It is not possible to see the token again.
{% endhint %}

This command takes the following command line arguments:

| Flag | Description |
| :--- |:--- |
| `--name` | The name of the service token |
| `--expiration` | The expiration date of the service token, the format is yyyy-MM-dd. The expiration is optional. |
| `--roles` | A comma separated list of roles to assign to the service token |

For example, the command below will create a service token with the name `my-service-token` and the role `stackstate-power-user`:

{% tabs %}
{% tab title="CLI: sts (new)" %}
```commandline
> sts service-token create --name my-service-token --roles stackstate-power-user
✅ Service token created: svctok-aaaaa-bbbb-ccccc-ddddd
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI has been renamed to`stac` and there is a new `sts` CLI. This command is for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endtab %}
{% tab title="CLI: stac" %}

Command not available in the `stac` CLI, use the new `sts` CLI.

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% endtabs %}

### Set up a bootstrap service token

When installing StackState, it is possible to bootstrap it with a (temporary) service token. This allows for using the CLI without first interacting with StackState and obtaining an API token from the UI. In order to set this up, you can add the following snippet to the StackState configuration file:

{% tabs %}
{% tab title="Kubernetes" %}

To configure StackState to create a bootstrap service token on Kubernetes, The following values need to be added to the file `authentication.yaml`. For example

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

Follow the steps below to configure StackState to create a bootstrap service token:

1. In `authentication.yaml` - add the bootstrap token:
   * **token** - The token that will be created on (initial) start of StackState.
   * **roles** - An array of roles that will be assigned to the bootstrap token.
   * **ttl** - Optional. The time-to-live for the service token, expressed as a duration string.
2. Store the file `authentication.yaml` together with the `values.yaml` from the StackState installation instructions.
3. Run a Helm upgrade to apply the changes.
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

{% endtab %}
{% tab title="Linux" %}

To configure StackState to create a bootstrap service token on Linux, the following settings need to be added to the file `application_stackstate.conf`:

```javascript
authentication {
  authServer {
    authServerType = [ "serviceTokenAuthServer", ... ]

    ...

    serviceTokenAuthServer {
      bootstrap {
        token = "<random token>"
        roles = [ "stackstate-power-user" ]
        ttl = "24h"
      }
    }
  }
}
```

Follow the steps below to configure StackState to create a bootstrap service token:

1. In `application_stackstate.conf` - add the bootstrap token:
   * **token** - The token that will be created on the (initial) start of StackState.
   * **roles** - An array of roles that will be assigned to the bootstrap token.`
   * **ttl** - Optional. The time-to-live for the token, expressed as a duration string.
2. Restart StackState to apply the changes.

{% endtab %}
{% endtabs %}

### List service tokens

The ID, name, expiration date and roles of all created service tokens can be seen using the new `sts` CLI. For example:

{% tabs %}
{% tab title="CLI: sts (new)" %}
```bash
> sts service-token list
ID              | NAME             | EXPIRATION | ROLES
107484341630693 | my-service-token |            | [stackstate-power-user]
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI has been renamed to`stac` and there is a new `sts` CLI. This command is for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endtab %}
{% tab title="CLI: stac" %}

Command not available in the `stac` CLI, use the new `sts` CLI.

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% endtabs %}

### Delete service tokens

A service token can be deleted using the new `sts` CLI. Pass the ID of the service token as an argument. For example:

{% tabs %}
{% tab title="CLI: sts (new)" %}
```bash
> sts service-token delete 107484341630693
✅ Service token deleted: 107484341630693
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI has been renamed to`stac` and there is a new `sts` CLI. This command is for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endtab %}
{% tab title="CLI: stac" %}

Command not available in the `stac` CLI, use the new `sts` CLI.


⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% endtabs %}

## Use service tokens

Once created, a service token can be used to authenticate to StackState from a headless service. To do this you can either use the CLI or directly talk to the API.


### StackState `sts` CLI

A service token can be used for authentication with the new `sts` CLI. It is not possible to authenticate with service tokens using the `stac` CLI. For details, see the CLI documentation:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
* New `sts` CLI: [Authentication](/setup/cli/cli-sts.md#authentication)

### StackState APIs

To use a service token to talk directly to the StackState Base API or the StackState Admin API, add it to the header of the request in one of the following ways:

* In the `Authorization` header:
    ```bash
    > curl -X GET -H "Authorization: ApiKey <TOKEN>" http://localhost:8080/api/server/status
    ```

* In the `X-API-Key` header:
    ```bash
    > curl -X GET -H "X-API-Key: <TOKEN>" http://localhost:8080/api/server/status
    ```

➡️ [Learn more about the StackState APIs](/setup/cli/cli-stac.md#authentication)
