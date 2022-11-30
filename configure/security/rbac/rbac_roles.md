---
description: StackState Self-hosted v5.1.x
---

# Roles

## Overview

Every user in StackState has a role assigned. Roles combine a subject and a set of [permissions](rbac_permissions.md) and describe a group of users that can access a specific data set. StackState ships with four predefined roles and you can also create custom names and groups to match your needs.

## Predefined roles

There are four roles predefined in StackState:

* **Administrator** - has full access to all views and has all permissions, except for platform management.
* **Platform Administrator** - has platform management permissions and access to all views.
* **Power User** - typically granted to a user that needs to configure StackState for a team\(s\), but won't manage the entire StackState installation.
* **Guest** - has read-only access to StackState.

The permissions assigned to each predefined StackState role can be found below. For details of the different permissions and how to manage them using the `stac` CLI, see [RBAC permissions](/configure/security/rbac/rbac_permissions.md)

{% tabs %}
{% tab title="Administrator" %}

The Administrator role \(`stackstate-admin`\): has all permissions assigned, except for `access-admin-api`, which is assigned only to the Platform Administrator predefined role.

See below for the list of permissions assigned to the predefined Administrator role (`stackstate-admin`), these were retrieved using the `sts` CLI. For details of the different permissions and how to manage them using the `sts` CLI, see [RBAC permissions](/configure/security/rbac/rbac_permissions.md).

```text
$ ./sts rbac describe-permissions --subject stackstate-admin
PERMISSION                  | RESOURCE
access-view                 | everything
delete-view                 | everything
save-view                   | everything
access-analytics            | system
access-cli                  | system
access-explore              | system
access-log-data             | system
access-synchronization-data | system
access-topic-data           | system
create-views                | system
execute-component-actions   | system
execute-component-templates | system
execute-node-sync           | system
execute-restricted-scripts  | system
execute-scripts             | system
export-settings             | system
import-settings             | system
manage-annotations          | system
manage-event-handlers       | system
manage-monitors             | system
manage-service-tokens       | system
manage-stackpacks           | system
manage-star-view            | system
manage-telemetry-streams    | system
manage-topology-elements    | system
perform-custom-query        | system
read-permissions            | system
read-settings               | system
read-stackpacks             | system
run-monitors                | system
update-permissions          | system
update-settings             | system
update-visualization        | system
upload-stackpacks           | system
```
{% endtab %}
{% tab title="Platform Administrator" %}

Platform Administrator \(`stackstate-platform-admin`\) is the only predefined role that's assigned the permission `access-admin-api`.

See below for a list of the permissions assigned to the predefined Platform Administrator role (`stackstate-platform-admin`), these were retrieved using the `sts` CLI. For details of the different permissions and how to manage them using the `sts` CLI, see [RBAC permissions](/configure/security/rbac/rbac_permissions.md).

```text
❯ ./sts rbac describe-permissions --subject stackstate-platform-admin
PERMISSION       | RESOURCE
access-view      | everything
access-admin-api | system
access-cli       | system
access-log-data  | system
manage-star-view | system
```
{% endtab %}
{% tab title="Power User" %}

The Power User role \(`stackstate-power-user`\) has all Administrator permissions, except for:
* `execute-restricted-scripts`
* `update-permissions`
* `upload-stackpacks`

See below for a list of the permissions assigned to the predefined Power User role (`stackstate-power-user`), these were retrieved using the `sts` CLI. For details of the different permissions and how to manage them using the `sts` CLI, see [RBAC permissions](/configure/security/rbac/rbac_permissions.md).

```text
❯ ./sts rbac describe-permissions --subject stackstate-power-user
PERMISSION                  | RESOURCE
access-view                 | everything
delete-view                 | everything
save-view                   | everything
access-analytics            | system
access-cli                  | system
access-explore              | system
access-log-data             | system
access-synchronization-data | system
access-topic-data           | system
create-views                | system
execute-component-actions   | system
execute-component-templates | system
execute-node-sync           | system
execute-scripts             | system
export-settings             | system
import-settings             | system
manage-annotations          | system
manage-event-handlers       | system
manage-monitors             | system
manage-stackpacks           | system
manage-star-view            | system
manage-telemetry-streams    | system
manage-topology-elements    | system
perform-custom-query        | system
read-permissions            | system
read-settings               | system
read-stackpacks             | system
run-monitors                | system
update-settings             | system
update-visualization        | system
```
{% endtab %}
{% tab title="Guest" %}

The Guest role \(`stackstate-guest`\) has read-only access to StackState.

See below for a list of the permissions assigned to the predefined Guest role, these were retrieved using the `sts` CLI. For details of the different permissions and how to manage them using the `sts` CLI, see [RBAC permissions](/configure/security/rbac/rbac_permissions.md).

```text
❯ ./sts rbac describe-permissions --subject stackstate-guest
PERMISSION                | RESOURCE
access-view               | everything
access-cli                | system
access-explore            | system
execute-component-actions | system
manage-star-view          | system
perform-custom-query      | system
read-permissions          | system
read-telemetry-streams    | everything
update-visualization      | system
```
{% endtab %}
{% endtabs %}

## Custom roles

### Custom names for predefined roles

In addition to the default predefined role names \(`stackstate-admin`, `stackstate-platform-admin`, `stackstate-power-user`, `stackstate-guest`\), which are always available, custom role names can be added that have the same permissions. Below is an example of how to do this for both Kubernetes and Linux installations.

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

### Create custom roles and groups

The instructions below will take you through the process of setting up a new group called `StackStateManager`

1. Subjects need two pieces of information: a subject name and a subject scope. Create a new subject - set its name to `stackstateManager` and set the scope to `'label = "StackState" AND type = "Business Application”’` as in the following example:

   ```text
   # `stac` CLI:
   stac subject save stackstateManager 'label = "StackState" AND type = "Business Application"'

   # new `sts` CLI:
   sts rbac create-subject --subject stackstateManager --scope 'label = "StackState" AND type = "Business Application"'
   ```

   Please note that when passing an STQL query in a `stac` or `sts` CLI command, all operators \(like `=`, `<`,`AND`, and so on\) need to be surrounded by spaces, as in the above example.

   Also, please note that the subject's name is case-sensitive.

2. Configured subjects need permissions to access parts of the UI and to execute actions in it. StackState Manager role requires access to the specific view of business applications, and there is no need to grant any CRUD, or StackPack permissions - they won't be used in day-to-day work by any Manager. To grant permission to view the `Business Applications` view, follow the below example:

   ```text
   # `stac` CLI:
   stac permission grant stackstateManager access-view "Business Applications"

   # new `sts` CLI:
   sts rbac grant --subject stackstateManager --resource "Business Applications" --permission access-view
   ```

   Please note that the subject's name, as well as permissions, are case-sensitive.

### File-based authentication

If your StackState instance is configured with a file-based authentication, then you need to add newly created subjects to the config file and enable authentication.

1. In the `application_stackstate.conf` file locate the `authentication` block and change `enabled = false` to `enabled = true` as in the below example:

   ```text
      authentication {
        enabled  = true
        ...
      }
   ```

2. Add new users and subjects to the `logins` table in the `application_stackstate.conf` as shown in the example below. Note that the default roles are always available \(`stackstate-admin`, `stackstate-platform-admin`, `stackstate-power-user` and `stackstate-guest`\)

   ```text
    authentication {
      enabled  = true

      basicAuth = false

      # Amount of time to keep a session when a user doesn't log in
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

