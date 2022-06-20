---
description: StackState Self-hosted v5.0.x
---

# Service Tokens

## Overview

Using Service Tokens it is possible to authenticate to StackState without having configured a user account. This is useful for situations where you want to use StackState from headless services like a CI server. In such a scenario you typically do not want to provision a user account in your identity provider.

## Manage Service Tokens

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

### Create service tokens

To create a service token you can use the `sts service-token create` command. This takes the following command line arguments:

| Flag | Description |
| :--- |:--- |
| `--name` | The name of the service token |
| `--expiration` | The expiration date of the service token, the format is yyyy-MM-dd. The expiration is optional. |
| `--roles` | A comma separated list of roles to assign to the service token |

To create a service token with the name `my-service-token` and the role `stackstate-power-user`, use the following command:

```bash
> sts service-token create --name my-service-token --roles stackstate-power-user
✅ Service token created: svctok-aaaaa-bbbb-ccccc-ddddd
```

{% hint style="info" %}
Note that the Service Token will only be displayed once. It is not possible to see the token again.
{% endhint %}

### List service tokens

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

## Use Service Tokens

Once created, a Service Token can be used to authenticate to StackState from a headless service. To do this you can either use the CLI or directly talk to the API.

To use the CLI, refer to the CLI documentation:

➡️ [Which version of the CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)

{% tabs %}
{% tab title="`stac` CLI" %}
[`stac` CLI Authentication](../../../setup/cli/cli-sts.md#authentication)
{% endtab %}
{% tab title="`sts` CLI" %}
[`sts` CLI Configuration Options](../../../setup/cli/cli-sts.md#configuration-options) 
{% endtab %}
{% endtabs %}

To talk directly to the StackState Rest API, you can send the Service Token in the following ways:

* In the `Authorization` header of the request:
    ```bash
    > curl -X GET -H "Authorization: ApiKey <TOKEN>" http://localhost:8080/api/server/status
    ```
 
* In the `X-API-Key` header of the request:
    ```bash
    > curl -X GET -H "X-API-Key: <TOKEN>" http://localhost:8080/api/server/status
    ```

