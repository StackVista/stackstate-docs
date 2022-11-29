---
description: StackState Self-hosted v5.1.x
---

# Set up a security backend for Linux

This document explains the process of setting up a security backend on a Linux system. You can find more information in the [Secrets Management section](secrets_management.md).

## Security agent requirements

The Agent V2 runs the `secret_backend_command` executable as a sub-process. On Linux, the executable set as `secret_backend_command` is required to:

* Belong to the same user running the Agent \(or `root` inside a container\).
* Have no rights for group or other.
* Have at least exec rights for the owner.

## How to use the executable API

The executable respects a simple API that reads JSON structures from the standard input, and outputs JSON containing the decrypted secrets to the standard output. If the exit code is anything other than 0, then the integration configuration that is being decrypted is considered faulty and is dropped.

### Input

The executable receives a JSON payload from the standard input, containing the list of secrets to fetch:

```json
{
  "version": "1.0",
  "secrets": ["secret1", "secret2"]
}
```

* `version`: is a string containing the format version.
* `secrets`: is a list of strings; each string is a handle from a configuration file corresponding to a secret to fetch.

### Output

The executable is expected to output to the standard output a JSON payload containing the:

{% code lineNumbers="true" %}
```json
{
  "secret1": {
    "value": "secret_value",
    "error": null
  },
  "secret2": {
    "value": null,
    "error": "could not fetch the secret"
  }
}
```
{% endcode %}

The expected payload is a JSON object, where each key is one of the handles requested in the input payload. The value for each handle is a JSON object with two fields:

* `value`: a string; the actual value that is used in the check configurations
* `error`: a string; the error message, if needed. If error is anything other than null, the integration configuration that uses this handle is considered erroneous and is dropped.

### Example

The following is a dummy implementation of the secret reader that is prefixing every secret with `decrypted_`:

{% code lineNumbers="true" %}
```golang
package main

import (
  "encoding/json"
  "fmt"
  "io/ioutil"
  "os"
)

type secretsPayload struct {
  Secrets []string `json:secrets`
  Version int      `json:version`
}

func main() {
  data, err := ioutil.ReadAll(os.Stdin)

  if err != nil {
    fmt.Fprintf(os.Stderr, "Could not read from stdin: %s", err)
    os.Exit(1)
  }
  secrets := secretsPayload{}
  json.Unmarshal(data, &secrets)

  res := map[string]map[string]string{}
  for _, handle := range secrets.Secrets {
    res[handle] = map[string]string{
      "value": "decrypted_" + handle,
    }
  }

  output, err := json.Marshal(res)
  if err != nil {
    fmt.Fprintf(os.Stderr, "could not serialize res: %s", err)
    os.Exit(1)
  }
  fmt.Printf(string(output))
}
```
{% endcode %}

Above example updates the following configuration \(from the check file\):

```yaml
instances:
  - server: db_prod
    user: ENC[db_prod_user]
    password: ENC[db_prod_password]
```

into this in the Agent's memory:

```yaml
instances:
  - server: db_prod
    user: decrypted_db_prod_user
    password: decrypted_db_prod_password
```

## Troubleshooting secrets

### Listing detected secrets

The `secret` command in the Agent CLI shows any errors related to your setup. For example, if the rights on the executable are incorrect. It also lists all handles found, and where they are located.

On Linux, the command outputs file mode, owner and group for the executable. Example:

{% code lineNumbers="true" %}
```sh
$> stackstate-agent secret
=== Checking executable rights ===
Executable path: /path/to/you/executable
Check Rights: OK, the executable has the correct rights

Rights Detail:
file mode: 100700
Owner username: stackstate-agent
Group name: stackstate-agent

=== Secrets stats ===
Number of secrets decrypted: 3
Secrets handle decrypted:
- api_key: from stackstate.yaml
- db_prod_user: from postgres.yaml
- db_prod_password: from postgres.yaml
```
{% endcode %}

### Checking configurations after secrets were injected

To see how the check’s configurations are resolved, you can use the `configcheck` command:

{% code lineNumbers="true" %}
```sh
$ sudo -u stackstate-agent -- stackstate-agent configcheck

=== a check ===
Source: File Configuration Provider
Instance 1:
host: <decrypted_host>
port: <decrypted_port>
password: <decrypted_password>
~
===

=== another check ===
Source: File Configuration Provider
Instance 1:
host: <decrypted_host2>
port: <decrypted_port2>
password: <decrypted_password2>
~
===
```
{% endcode %}

**Note:** The Agent needs to be restarted to pick up changes on configuration files.

### Debugging `secret_backend_command`

To test or debug outside of the Agent, you can mimic how the Agent runs it:

```sh
sudo su stackstate-agent - bash -c "echo '{\"version\": \"1.0\", \"secrets\": [\"secret1\", \"secret2\"]}' | /path/to/the/secret_backend_command"
```

The stackstate-agent user is created when you install StackState Agent V2.

