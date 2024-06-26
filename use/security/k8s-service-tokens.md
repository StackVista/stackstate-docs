---
description: StackState v6.0
---

# Service tokens

## Overview

Using Service tokens it's possible to authenticate to StackState without having an associated a user account. This is useful for situations where you want to use StackState from headless services like a CI server. In such a scenario you typically don't want to provision a user account in your identity provider.

## Manage service tokens

Service tokens can be managed via the `sts` CLI. The following commands are available:

```sh
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

To create a service token in your instance of StackState, you can use the `sts` CLI.

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

For example, the command below will create a service token with the name `my-service-token` and the role `stackstate-k8s-troubleshooter`:

```sh
> sts service-token create --name my-service-token --roles stackstate-k8s-troubleshooter
✅ Service token created: svctok-aaaaa-bbbb-ccccc-ddddd
```

### List service tokens

The ID, name, expiration date and roles of all created service tokens can be seen using the `sts` CLI. For example:

```bash
> sts service-token list
ID              | NAME             | EXPIRATION | ROLES
107484341630693 | my-service-token |            | [stackstate-k8s-troubleshooter]
```

### Delete service tokens

A service token can be deleted using the `sts` CLI. Pass the ID of the service token as an argument. For example:

```sh
> sts service-token delete 107484341630693
✅ Service token deleted: 107484341630693
```

## Authenticating using service tokens

Once created, a service token can be used to authenticate to StackState from a headless service. To do this you can either use the CLI or directly talk to the API.


### StackState `sts` CLI

A service token can be used for authentication with the new `sts` CLI.

```sh
> sts context --name <name> --service-token <TOKEN> --url https://<tenant>.app.stackstate.io
```

### StackState APIs

To use a service token to talk directly to the StackState API, add it to the header of the request in one of the following ways:

* In the `Authorization` header:
    ```sh
    > curl -X GET -H "Authorization: ApiKey <TOKEN>" http://<tenant>.app.stackstate.io/api/server/status
    ```

* In the `X-API-Key` header:
    ```sh
    > curl -X GET -H "X-API-Key: <TOKEN>" http://<tenant>.app.stackstate.io/api/server/status
    ```
