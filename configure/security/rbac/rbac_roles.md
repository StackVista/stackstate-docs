---
description: StackState Self-hosted v4.5.x
---

# Roles

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

## Predefined roles

StackState comes with four predefined roles:

* **Administrators** \(`stackstate-admin`\): Have access to all views and have all permissions, except for the platform management permission `access-admin-api`.
* **Platform Administrators** \(`stackstate-platform-admin`\): Have platform management permissions and have access to all views.
* **Power Users** \(`stackstate-power-user`\): This role is typically granted to users that need to configure StackState for their team\(s\), but will not manage the entire StackState installation. Power users have all Administrator permissions _except_ for:
  * `execute-restricted-scripts`
  * `update-permissions`
  * `upload-stackpacks`
* **Guests** \(`stackstate-guest`\): Have read access, as you can see below when we use the StackState CLI to show granted permissions for the role:

  ```text
    $ sts permission show stackstate-guest                    
    subject           permission                 resource
    ----------------  -------------------------  ----------
    stackstate-guest  access-explore             system
    stackstate-guest  perform-custom-query       system
    stackstate-guest  read-permissions           system
    stackstate-guest  update-visualization       system
    stackstate-guest  execute-component-actions  system
    stackstate-guest  access-view                everything
  ```

### Default and custom role names

The default pre-defined role names \(`stackstate-admin`, `stackstate-platform-admin`, `stackstate-power-user`, `stackstate-guest`\) are always available. Additional custom role names can be added that have the same permissions. Below is an example of how to do this for both Kubernetes and Linux installations.

{% tabs %}
{% tab title="Kubernetes" %}
Include this YAML snippet in an `authentication.yaml` when customizing the authentication configuration to extend the default role names with these custom role names.

```yaml
stackstate:
  authentication:
    roles:
      guest: ["custom-guest-role"]
      powerUser: ["custom-power-user-role"]
      admin: ["custom-admin-role"]
      platformAdmin: ["custom-platform-admin-role"]
```

To use it in for your StackState installation \(or already running instance, note that it will restart the API\):

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values authentication.yaml \
stackstate \
stackstate/stackstate
```
{% endtab %}

{% tab title="Linux" %}
To extend the default role names with custom role names:

1. Edit the existing keys in the `authorization` section of the configuration file `application_stackstate.conf`.
2. Add custom roles using the syntax `xxxGroups = ${stackstate.authorization.xxxGroups} ["custom-role"]` as shown in the example below.

   ```javascript
   authorization {
    guestGroups = ${stackstate.authorization.guestGroups} ["custom-guest-role"]
    powerUserGroups = ${stackstate.authorization.powerUserGroups} ["custom-power-user-role"]
    adminGroups = ${stackstate.authorization.adminGroups} ["custom-admin-role"]
    platformAdminGroups = ${stackstate.authorization.platformAdminGroups} ["custom-platform-admin-role"]
   }
   ```

3. Restart StackState for changes to take effect.

   The list of roles will be extended to include the new, custom roles. The default roles will remain available \(stackstate-admin, stackstate-platform-admin, stackstate-guest and stackstate-power-user\).
{% endtab %}
{% endtabs %}