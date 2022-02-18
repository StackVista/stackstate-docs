---
description: StackState Self-hosted v4.6.x
---

# Secrets management

This document presents the concept of how secrets are managed in StackState using Agent V2 StackPack. You can find more detailed information on how to set up a security backend for [Linux](set_up_a_security_backend_for_windows.md) or [Windows](set_up_a_security_backend_for_linux.md).

## About secrets in StackState

The Agent V2 can leverage the `secrets` package to call a user-provided executable to handle retrieval and decryption of secrets, which are then loaded in memory by the Agent V2. This approach allows users to rely on any secrets management backend \(such as HashiCorp Vault or AWS Secrets Manager\), and select their preferred authentication method to establish initial trust with it.

### Define secrets in StackState configuration

Use the `ENC[]` notation to denote a secret as the value of any YAML field in your configuration. Secrets are supported in any configuration backend \(e.g. file, etcd, consul\) and environment variables.

Secrets are also supported in `stackstate.yaml` - agent check configuration file. The Agent V2 first loads the main configuration and reloads it after decrypting the secrets. This means that secrets cannot be used in the `secret_*` settings.

Secrets are always strings, which means that it is not possible to set them to integer or Boolean type.

Example:

```text
instances:
  - server: db_prod
    # two valid secret handles
    user: "ENC[db_prod_user]"
    password: "ENC[db_prod_password]"

    # The `ENC[]` handle must be the entire YAML value, which means that
    # the following is NOT detected as a secret handle:
    password2: "db-ENC[prod_password]"
```

The above example presents two secrets: `db_prod_user`, and `db_prod_password` - these are the secrets' handles, and each of them uniquely identifies a secret within your secrets management backend.

Between the brackets, any character is allowed as long as the YAML configuration is valid. This means that quotes must be escaped. For example:

```text
"ENC[{\"env\": \"prod\", \"check\": \"postgres\", \"id\": \"user_password\"}]"
```

In the above example, the secret’s handle is the string `{"env": "prod", "check": "postgres", "id": "user_password"}`.

### Provide an executable to retrieve secrets

To retrieve secrets, you need to provide an executable that can authenticate to and fetch secrets from your secrets management backend.

The Agent V2 caches secrets internally in memory to reduce the number of calls \(convenient in a containerized environment\). The Agent calls the executable every time it accesses a check configuration file that contains at least one secret handle for which the secret is not already loaded in memory. In particular, secrets that have already been loaded in memory do not trigger additional calls to the executable. In practice, this means that the Agent calls the user-provided executable once per file that contains a secret handle at startup, and might make additional calls to the executable later, if the Agent V2 or instance is restarted, or if the Agent dynamically loads a new check containing a secret handle.

Relying on a user-provided executable has multiple benefits:

* Guaranteeing that the Agent does not attempt to load in memory parameters for which there isn’t a secret handle.
* The ability for the user to limit the visibility of the Agent to secrets that it needs \(e.g., by restraining the accessible list of secrets in the critical management backend\)
* Freedom and flexibility in allowing users to use any secrets management backend without having to rebuild the Agent.
* It is enabling each user to solve the initial trust problem from the Agent to their secrets management backend. The problem occurs in a way that leverages each user’s preferred authentication method and fits into their continuous integration workflow.

### Configuration

Set the following variable in `stackstate.yaml` configuration file:

```text
secret_backend_command: <EXECUTABLE_PATH>
```

