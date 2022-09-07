---
description: StackState Self-hosted v5.0.x 
---

# Roles

{% hint style="warning" %}
**This page describes StackState version 5.0.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/configure/security/rbac/rbac_roles).
{% endhint %}

## Overview

Every user in StackState needs to have a subject and a set of [permissions](rbac_permissions.md) assigned; this combination is called a role. A role describes a group of users that can access a specific data set. StackState ships with four predefined roles and you can also create custom names and groups to match your needs.

## Predefined roles

There are four roles predefined in StackState:

* **Administrator** - has full access to all views and has all permissions, except for platform management.
* **Platform Administrator** - has platform management permissions and access to all views.
* **Power User** - typically granted to a user that needs to configure StackState for a team\(s\), but will not manage the entire StackState installation.
* **Guest** - has read-only access to StackState. 

The permissions assigned to each predefined StackState role can be found below. For details of the different permissions and how to manage them using the `stac` CLI, see [RBAC permissions](/configure/security/rbac/rbac_permissions.md)

{% tabs %}
{% tab title="Administrator" %}

The Administrator role \(`stackstate-admin`\): has all permissions assigned, except for `access-admin-api`, which is assigned only to the Platform Administrator predefined role.

Permissions assigned to the predefined Administrator role (`stackstate-admin`) are listed below, these were retrieved using the `stac` CLI. For details of the different permissions and how to manage them using the `stac` CLI, see [RBAC permissions](/configure/security/rbac/rbac_permissions.md).

```text
$ stac permission show stackstate-admin         
subject           permission                   resource
----------------  ---------------------------  ----------
stackstate-admin  manage-annotations           system
stackstate-admin  execute-scripts              system
stackstate-admin  read-settings                system
stackstate-admin  access-cli                   system
stackstate-admin  run-monitors                 system
stackstate-admin  access-explore               system
stackstate-admin  access-analytics             system
stackstate-admin  access-synchronization-data  system
stackstate-admin  access-log-data              system
stackstate-admin  execute-node-sync            system
stackstate-admin  manage-event-handlers        system
stackstate-admin  access-topic-data            system
stackstate-admin  manage-topology-elements     system
stackstate-admin  import-settings              system
stackstate-admin  export-settings              system
stackstate-admin  execute-restricted-scripts   system
stackstate-admin  perform-custom-query         system
stackstate-admin  read-stackpacks              system
stackstate-admin  update-permissions           system
stackstate-admin  read-permissions             system
stackstate-admin  manage-telemetry-streams     system
stackstate-admin  execute-component-templates  system
stackstate-admin  update-visualization         system
stackstate-admin  upload-stackpacks            system
stackstate-admin  create-views                 system
stackstate-admin  update-settings              system
stackstate-admin  manage-stackpacks            system
stackstate-admin  manage-star-view             system
stackstate-admin  manage-monitors              system
stackstate-admin  execute-component-actions    system
stackstate-admin  manage-service-tokens        system
stackstate-admin  access-view                  everything
stackstate-admin  save-view                    everything
stackstate-admin  delete-view                  everything
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="Platform Administrator" %}

Platform Administrator \(`stackstate-platform-admin`\) is the only predefined role that is assigned the permission `access-admin-api`.

Permissions assigned to the predefined Platform Administrator role (`stackstate-platform-admin`) are listed below, these were retrieved using the `stac` CLI. For details of the different permissions and how to manage them using the `stac` CLI, see [RBAC permissions](/configure/security/rbac/rbac_permissions.md).

```text
$ stac permission show stackstate-platform-admin
subject                    permission        resource
-------------------------  ----------------  ----------
stackstate-platform-admin  access-admin-api  system
stackstate-platform-admin  access-cli        system
stackstate-platform-admin  access-log-data   system
stackstate-platform-admin  manage-star-view  system
stackstate-platform-admin  access-view       everything
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="Power User" %}

The Power User role \(`stackstate-power-user`\) has all Administrator permissions, except for:
* `execute-restricted-scripts`
* `update-permissions`
* `upload-stackpacks`

Permissions assigned to the predefined Power User role (`stackstate-power-user`) are listed below, these were retrieved using the `stac` CLI. For details of the different permissions and how to manage them using the `stac` CLI, see [RBAC permissions](/configure/security/rbac/rbac_permissions.md).

```text
$ stac permission show stackstate-power-user    
subject                permission                   resource
---------------------  ---------------------------  ----------
stackstate-power-user  manage-annotations           system
stackstate-power-user  execute-scripts              system
stackstate-power-user  read-settings                system
stackstate-power-user  access-cli                   system
stackstate-power-user  run-monitors                 system
stackstate-power-user  access-explore               system
stackstate-power-user  access-analytics             system
stackstate-power-user  access-synchronization-data  system
stackstate-power-user  access-log-data              system
stackstate-power-user  execute-node-sync            system
stackstate-power-user  manage-event-handlers        system
stackstate-power-user  access-topic-data            system
stackstate-power-user  manage-topology-elements     system
stackstate-power-user  import-settings              system
stackstate-power-user  export-settings              system
stackstate-power-user  perform-custom-query         system
stackstate-power-user  read-stackpacks              system
stackstate-power-user  read-permissions             system
stackstate-power-user  manage-telemetry-streams     system
stackstate-power-user  execute-component-templates  system
stackstate-power-user  update-visualization         system
stackstate-power-user  create-views                 system
stackstate-power-user  update-settings              system
stackstate-power-user  manage-stackpacks            system
stackstate-power-user  manage-star-view             system
stackstate-power-user  manage-monitors              system
stackstate-power-user  execute-component-actions    system
stackstate-power-user  access-view                  everything
stackstate-power-user  save-view                    everything
stackstate-power-user  delete-view                  everything
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="Guest" %}

The Guest role \(`stackstate-guest`\) has read-only access to StackState.

Permissions assigned to the predefined Guest role are listed below, these were retrieved using the `stac` CLI. For details of the different permissions and how to manage them using the `stac` CLI, see [RBAC permissions](/configure/security/rbac/rbac_permissions.md).

```text
$ stac permission show stackstate-guest
subject           permission                 resource
----------------  -------------------------  ----------
stackstate-guest  access-cli                 system
stackstate-guest  access-explore             system
stackstate-guest  perform-custom-query       system
stackstate-guest  read-permissions           system
stackstate-guest  update-visualization       system
stackstate-guest  manage-star-view           system
stackstate-guest  execute-component-actions  system
stackstate-guest  access-view                everything
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

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
   # Command not currently available in the new `sts` CLI. Use the `stac` CLI.
   ```

   Please note that when passing an STQL query in a `stac` CLI command, all operators \(like `=`, `<`,`AND`, and so on\) need to be surrounded by spaces, as in the above example.

   Also, please note that the subject's name is case-sensitive.

2. Configured subjects need permissions to access parts of the UI and to execute actions in it. StackState Manager role requires access to the specific view of business applications, and there is no need to grant any CRUD, or StackPack permissions - they will not be used in day-to-day work by any Manager. To grant permission to view the `Business Applications` view, follow the below example:

   ```text
   # `stac` CLI:
   stac permission grant stackstateManager access-view "Business Applications"
   
   # new `sts` CLI:
   # Command not currently available in the new `sts` CLI. Use the `stac` CLI.   
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

