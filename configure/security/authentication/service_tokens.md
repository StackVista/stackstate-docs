---
description: StackState Self-hosted v5.0.x
---

# Service tokens

## Overview

Using Service tokens it is possible to authenticate to StackState without having configured a user account. This is useful for situations where you want to use StackState from headless services like a CI server. In such a scenario you typically do not want to provision a user account in your identity provider.

## Manage service tokens

Service tokens can be managed via the new [StackState CLI](../../../setup/cli/cli-sts.md). The following commands are available:

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

### Create service tokens

To create a service token you can use the `sts service-token create` command. 

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

```bash
> sts service-token create --name my-service-token --roles stackstate-power-user
✅ Service token created: svctok-aaaaa-bbbb-ccccc-ddddd
```

### List service tokens

The ID, name, expiration date and roles of all created service tokens can be seen using the `sts service-token list` command. For example:

```bash
> sts service-token list
ID              | NAME             | EXPIRATION | ROLES
107484341630693 | my-service-token |            | [stackstate-power-user]
```

### Delete service tokens

A service token can be deleted using the `sts service-token delete` command. Pass the ID of the service token as an argument. For example:

```bash
> sts service-token delete 107484341630693
✅ Service token deleted: 107484341630693
```

## Use service tokens

Once created, a service token can be used to authenticate to StackState from a headless service. To do this you can either use the CLI or directly talk to the API.


### StackState CLI

A service token can be used for authentication with the new `sts` CLI. It is not possible to authenticate with service tokens using the `stac` CLI. For details, see the CLI documentation:

* [Which version of the CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
* `sts`(new) CLI: [Authentication](/setup/cli/cli-sts.md#authentication)

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