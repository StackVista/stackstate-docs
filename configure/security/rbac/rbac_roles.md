---
description: StackState Self-hosted v4.5.x
---

# Roles

{% hint style="warning" %}
This page describes StackState v4.5.x.
The StackState 4.5 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.5 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/configure/security/rbac/rbac_roles).
{% endhint %}

Every user in StackState needs to have a subject and a set of [permissions](rbac_permissions.md) assigned; this combination is called a role. A role describes a group of users that can access a specific data set. This instruction will take you through the process of setting up a new group called “StackState Manager”.

1. Subjects need two pieces of information: a subject name and a subject scope. Create a new subject - set it’s name to `stackstateManager` and set the scope to `'label = "StackState" AND type = "Business Application”’` as in the following example:

   ```text
      sts subject save stackstateManager 'label = "StackState" AND type = "Business Application"'
   ```

   Please note that when passing an STQL query in a CLI command, all operators \(like `=`, `<`,`AND`, and so on\) need to be surrounded by spaces, as in the above example.

   Also, please note that the subject's name is case sensitive.

2. Configured subjects need permissions to access parts of the UI and to execute actions in it. StackState Manager role requires access to the specific view of business applications, and there is no need to grant any CRUD, or StackPack permissions - they will not be used in day-to-day work by any Manager. To grant permission to view the `Business Applications` view, follow the below example:

   ```text
   sts permission grant stackstateManager access-view "Business Applications"
   ```

   Please note that the subject's name, as well as permissions, are case sensitive.

## Finalize setting up roles for the file-based authentication

If your StackState instance is configured with a file-based authentication, then you need to add newly created subjects to the config file and enable authentication.

1. In the `application_stackstate.conf` file locate the `authentication` block and change `enabled = false` to `enabled = true` as in the below example:

   ```text
      authentication {
        enabled  = true
        ...
      }
   ```

2. Add new users and subjects to the logins table in the `application_stackstate.conf` as shown in the example below. Note that the default roles are always available \(`stackstate-admin`, `stackstate-platform-admin`, `stackstate-power-user` and `stackstate-guest`\)

   ```text
    authentication {
      enabled  = true

      basicAuth = false

      # Amount of time to keep a session when a user does not log in
      sessionLifetime = 7d

      authServer {
        authServerType = "stackstateAuthServer"

        stackstateAuthServer {
          # echo -n "password" | md5sum
          # Open http://www.md5.net/md5-generator/
          # Enter your password and press submit, you will get an MD5 Hash
          # Set the MD5 Hash into `auth.password`
          logins = [
          { username = "admin", password: "5f4dcc3b3mn765d61d8327deb882cd78", roles = ["stackstate-admin"] }
          { username = "guest", password: "5f4dcc3b5aa765d61d8327deb882cf99", roles = ["stackstate-guest"] }
          { username = "manager", password: "3g4dcc3b5aa765d61g5537deb882cf99", roles = ["stackstateManager"] }
          ]
        }
      }
    }
   ```

