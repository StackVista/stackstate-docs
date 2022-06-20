---
description: StackState Self-hosted v5.0.x
---

# Service Tokens

## Overview

Using Service Tokens it is possible to authenticate to StackState without having configured a user account. This is useful for situations where you want to use StackState from headless services like a CI server. In such a scenario you typically do not want to provision a user account in your identity provider.

### Managing Service Tokens

Service Tokens can be managed via the new [StackState CLI](../../../setup/cli/cli-sts.md). The following commands are available:

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

To create a service token you can use the `create` command. This takes the following command line arguments:

| Flag | Description |
| :--- |:--- |
| `--name` | The name of the service token |
| `--expiration` | The expiration date of the service token, the format is yyyy-MM-dd. The expiration is optional. |
| `--roles` | A comma separated list of roles to assign to the service token |

So to create a service token with the name `my-service-token` and the role `stackstate-power-user` you can use the following command:

```bash
> sts service-token create --name my-service-token --roles stackstate-power-user
✅ Service token created: svctok-aaaaa-bbbb-ccccc-ddddd
```

{% hint style="info" %}
The Service Token will only be displayed once. It is not possible to see the token again.
{% endhint %}


If you would now `list` the Service Tokens using the StackState CLI you will see the following output:

```bash
> sts service-token list
ID              | NAME             | EXPIRATION | ROLES
107484341630693 | my-service-token |            | [stackstate-power-user]
```

Deleting the Service Token is now possible using the `delete` command, and passing the ID of the Service Token as an argument:

```bash
> sts service-token delete 107484341630693
✅ Service token deleted: 107484341630693
```

## Using Service Tokens

Once you have created a Service Token it can be used to authenticate to StackState from a headless service. To do this you can either use the CLI, or directly talk to the API.

For the CLI please refer to the [StackState CLI Authentication](../../../setup/cli/cli-sts.md#authentication) and [StackState CLI Configuration Options](../../../setup/cli/cli-sts.md#configuration-options) sections.

If you want to talk directly to the Rest API, you can send the Service Token in the following ways:

1. In the `Authorization` header of the request:
```bash
> curl -X GET -H "Authorization: ApiKey <TOKEN>" http://localhost:8080/api/server/status
```
2. Using the `X-API-Key` header:
```bash
> curl -X GET -H "X-API-Key: <TOKEN>" http://localhost:8080/api/server/status
```

