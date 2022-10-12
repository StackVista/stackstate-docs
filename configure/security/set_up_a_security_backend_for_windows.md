---
description: StackState Self-hosted v5.1.x 
---

# Set up a security backend for Windows

This document explains the process of setting up a security backend on a Windows system. You can find more information in the [Secrets Management section](secrets_management.md).

## Security agent requirements

The Agent V2 runs the `secret_backend_command` executable as a sub-process. On Windows, the executable set as `secret_backend_command` is required to:

* Have read/exec for `stsagentuser` \(the user used to run the Agent\).
* Have no rights for any user or group except `Administrator` or `LocalSystem`.
* Be a valid Win32 application so the Agent can execute it.

**Note:** The executable shares the same environment variables as the Agent V2.

Do not output sensitive information on `stderr`. If the binary exits with a different status code than 0, the Agent V2 logs the standard error output of the executable to ease troubleshooting.

## How to use the executable API

The executable respects a simple API that reads JSON structures from the standard input, and outputs JSON containing the decrypted secrets to the standard output. If the exit code is anything other than 0, then the integration configuration that is being decrypted is considered faulty and is dropped.

### Input

The executable receives a JSON payload from the standard input, containing the list of secrets to fetch:

```text
{
  "version": "1.0",
  "secrets": ["secret1", "secret2"]
}
```

* `version`: is a string containing the format version.
* `secrets`: is a list of strings; each string is a handle from a configuration file corresponding to a secret to fetch.

### Output

The executable is expected to output to the standard output a JSON payload containing the:

```text
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

The expected payload is a JSON object, where each key is one of the handles requested in the input payload. The value for each handle is a JSON object with two fields:

* `value`: a string; the actual value that is used in the check configurations
* `error`: a string; the error message, if needed. If error is anything other than null, the integration configuration that uses this handle is considered erroneous and is dropped.

### Example

The following is a dummy implementation of the secret reader that is prefixing every secret with `decrypted_`:

```text
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

Above example updates the following configuration \(from the check file\):

```text
instances:
  - server: db_prod
    user: ENC[db_prod_user]
    password: ENC[db_prod_password]
```

into this in the Agent's memory:

```text
instances:
  - server: db_prod
    user: decrypted_db_prod_user
    password: decrypted_db_prod_password
```

## Troubleshooting secrets

### Listing detected secrets

The `secret` command in the Agent CLI shows any errors related to your setup. For example, if the rights on the executable are incorrect. It also lists all handles found, and where they are located.

The command outputs ACL rights for the executable, as in the example from an Administrator PowerShell below:

```text
PS C:\> & '%PROGRAMFILES%\StackState\StackState Agent\embedded\agent.exe' secret
=== Checking executable rights ===
Executable path: C:\path\to\you\executable.exe
Check Rights: OK, the executable has the correct rights

Rights Detail:
Acl list:
stdout:


Path   : Microsoft.PowerShell.Core\FileSystem::C:\path\to\you\executable.exe
Owner  : BUILTIN\Administrators
Group  : WIN-ITODMBAT8RG\None
Access : NT AUTHORITY\SYSTEM Allow  FullControl
         BUILTIN\Administrators Allow  FullControl
         WIN-ITODMBAT8RG\stsagentuser Allow  ReadAndExecute, Synchronize
Audit  :
Sddl   : O:BAG:S-1-5-21-2685101404-2783901971-939297808-513D:PAI(A;;FA;;;SY)(A;;FA;;;BA)(A;;0x1200
         a9;;;S-1-5-21-2685101404-2783901971-939297808-1001)

=== Secrets stats ===
Number of secrets decrypted: 3
Secrets handle decrypted:
- api_key: from stackstate.yaml
- db_prod_user: from sqlserver.yaml
- db_prod_password: from sqlserver.yaml
```

### Debugging `secret_backend_command`

#### Rights related errors

1. If any other group or user than needed has rights on the executable, a similar error to the following is logged:

   ```text
      error while decrypting secrets in an instance: Invalid executable 'C:\decrypt.exe': other users/groups than LOCAL_SYSTEM, Administrators or stsagentuser have rights on it
   ```

2. If `stsagentuser` does not have read and execute right on the file, a similar error logged:

   ```text
      error while decrypting secrets in an instance: could not query ACLs for C:\decrypt.exe
   ```

3. Your executable needs to be a valid Win32 application. If not, the following error is logged:

   ```text
      error while running 'C:\decrypt.py': fork/exec C:\decrypt.py: %1 is not a valid Win32 application.
   ```

#### Testing your executable

Your executable is executed by the Agent V2 when fetching your secrets. StackState Agent V2 runs using the stsagentuser. This user has no specific rights, but it is part of the Performance Monitor Users group. The password for this user is randomly generated at install time and is never saved anywhere.

This means that your executable might work with your default user or development user — but not when it is run by the Agent, since stsagentuser has more restricted rights.

To test your executable in the same conditions as the Agent V2, update the password of the stsagentuser on your dev box. This way, you can authenticate as stsagentuser and run your executable in the same context the Agent would.

To do so, follow steps below:

1. Remove `stsagentuser` from the `Local Policies/User Rights Assignement/Deny Log on locally` list in the `Local Security Policy`.
2. Set a new password for `stsagenuser` \(as the one generated during install is not saved anywhere\). In Powershell, run:

   ```text
      $user = [ADSI]"WinNT://./stsagentuser";
      $user.SetPassword("a_new_password")
   ```

3. Update the password to be used by StackStateAgent service in the Service Control Manager. In PowerShell, run:

   ```text
      sc.exe config StackStateAgent password= "a_new_password"
   ```

You can now log in as stsagentuser to test your executable. StackState has a PowerShell script to help you test your executable as another user. It switches user contexts and mimics how the Agent runs your executable. Usage example:

```text
.\secrets_tester.ps1 -user stsagentuser -password a_new_password -executable C:\path\to\your\executable.exe -payload '{"version": "1.0", "secrets": ["secret_ID_1", "secret_ID_2"]}'
Creating new Process with C:\path\to\your\executable.exe
Waiting a second for the process to be up and running
Writing the payload to Stdin
Waiting a second so the process can fetch the secrets
stdout:
{"secret_ID_1":{"value":"secret1"},"secret_ID_2":{"value":"secret2"}}
stderr: None
exit code:
0
```

#### Agent V2 is refusing to start

The first thing the Agent V2 does on startup is to load `stackstate.yaml` and decrypt any secrets in it. This is done before setting up the logging. This means that on platforms like Windows, errors occurring when loading `stackstate.yaml` are not written in the logs, but on `stderr`. This can occur when the executable given to the Agent for secrets returns an error.

If you have secrets in `stackstate.yaml` and the Agent refuses to start:

* Try to start the Agent manually to be able to see `stderr`.
* Remove the secrets from `stackstate.yaml` and test with secrets in a check configuration file.

