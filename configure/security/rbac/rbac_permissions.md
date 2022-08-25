---
description: StackState Self-hosted v5.0.x 
---

# Permissions

## Overview

Permissions in StackState allow Administrators to manage the actions that each user or user group can perform inside StackState and the information that will be shown in their StackState UI. Only the feature set relevant to each user's active role will be presented. The actions, information and pages that a user does not have access to are simply not displayed in their StackState UI.

{% hint style="info" %}
Permissions are stored in StackGraph. This means that:

* If you perform an upgrade with "clear all data", permission setup will also be removed.
* To completely remove a user, they must also be manually removed from StackGraph.
{% endhint %}

There are two types of permission in StackState:

* [System permissions](rbac_permissions.md#system-permissions) - Scope user capabilities, such as access to settings, query execution and scripting.
* [View permissions](rbac_permissions.md#view-permissions) - Allow for CRUD operations on StackState Views.

## Predefined roles

StackState comes with four predefined roles:

* **Administrator** \(`stackstate-admin`\): Has full access to all views and has all permissions, except for platform management.
* **Platform Administrator** \(`stackstate-platform-admin`\): Has platform management permissions and access to all views.
* **Power User** \(`stackstate-power-user`\): This role is typically granted to users that need to configure StackState for their team\(s\), but will not manage the entire StackState installation.
* **Guest** \(`stackstate-guest`\): Has read access to StackState. 

### Default permissions

The permissions assigned to each predefined StackState role can be found below.

{% tabs %}
{% tab title="Administrator" %}

The Administrator role has all permissions assigned, except for `access-admin-api`, which is assigned only to the Platform Administrator predefined role.

Permissions assigned to the predefined Administrator role (`stackstate-admin`), retrieved using the `stac` CLI:

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

Platform Administrator is the only predefined role that is assigned the permission `access-admin-api`.

Permissions assigned to the predefined Platform Administrator role (`stackstate-platform-admin`), retrieved using the `stac` CLI:

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

The Power User role has all Administrator permissions, except for:
* `execute-restricted-scripts`
* `update-permissions`
* `upload-stackpacks`

Permissions assigned to the predefined Power User role (`stackstate-power-user`), retrieved using the `stac` CLI:

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

The Guest role has read only access to StackState.

Permissions assigned to the predefined Guest role, retrieved using the `stac` CLI:

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

### Custom role names

The default predefined role names \(`stackstate-admin`, `stackstate-platform-admin`, `stackstate-power-user`, `stackstate-guest`\) are always available. Additional custom role names can be added that have the same permissions. Below is an example of how to do this for both Kubernetes and Linux installations.

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

## All permissions in StackState

There are two types of permission in StackState:

* System permissions - Scope user capabilities, such as access to settings, query execution and scripting.
* View permissions - Allow for CRUD operations on StackState Views.

The permissions included in StackState v5.0:

* `access-admin-api` -Access the administrator API. 
* `access-analytics` - Access the [Analytics](/use/stackstate-ui/analytics.md) page in the StackState UI.
* `access-cli` - Access the CLI page. This provides the API key to use for authentication with the StackState CLI.
* `access-explore` - Access the [**Explore]**(/use/stackstate-ui/explore_mode.md) page in the StackState UI.
* `access-log-data` - Access StackState logs using the CLI.
* `access-synchronization-data` - Access StackState synchronization status and data using the CLI.
* `access-topic-data` - Access StackState Receiver data using the CLI.
* `access-view` - A **View permission**. Access a specific view \(when granted on a view\) or all views \(when granted on `everything`\). Granted on the following views for predefined StackState roles:
  * Administrator: `everything` (all views)
  * Platform Administrator: `everything` (all views)
  * Power User: `everything` (all views)
  * Guest: `everything` (all views)
* `create-views` - [Create views](/use/stackstate-ui/views/create_edit_views.md) in the StackState UI. 
* `delete-view` - A **view permission**. Delete a specific view \(when granted on a view\) or all views \(when granted on `everything`\). Granted on the following views for predefined StackState roles:
  * Administrator: `everything` (all views)
  * Platform Administrator: -
  * Power User: `everything` (all views)
  * Guest: -
* `execute-component-actions` - Execute [component actions](/use/stackstate-ui/perspectives/topology-perspective.md#actions).
* `execute-component-templates` - Invoke a component template API extension \(internal use only\).
* `execute-node-sync` - Reset or delete a synchronization.
* `execute-restricted-scripts` - Execute scripts using the [HTTP script API](/develop/reference/scripting/script-apis/http.md) in the StackState UI analytics environment. Also requires `execute-scripts`.
* `execute-scripts` - Execute a query in the StackState UI Analytics environment. The `execute-restricted-scripts` permission is also required to execute scripts using the HTTP script API.
* `export-settings` - Export settings.
* `import-settings` - Import settings.
* `manage-annotations` - Persist and fetch Anomaly annotations in StackState.
* `manage-event-handlers` - Create or edit [event handlers](/use/stackstate-ui/views/manage-event-handlers.md).
* `manage-monitors` - Create, delete and modify [monitors](/use/checks-and-monitors/monitors.md).
* `manage-service-tokens`- Create/delete [Service Tokens](/configure/security/authentication/service_tokens.md) in StackState.
* `manage-stackpacks` - Install/upgrade/uninstall StackPacks.
* `manage-star-view` - Add and remove [stars](/use/stackstate-ui/views/about_views.md#starred-views) from views in the StackState UI. 
* `manage-telemetry-streams` - [Create or edit new telemetry streams](/use/metrics-and-events/add-telemetry-to-element.md) for components in the StackState UI.
* `manage-topology-elements` - Create/update/delete topology elements.
* `perform-custom-query` - Access the [topology filter](/use/stackstate-ui/filters.md#filter-topology).
* `read-permissions` - List all granted permissions across the entire system using the CLI.
* `read-settings` - Access the **Settings** page in the StackState UI.
* `read-stackpacks`
* `run-monitors` - Execute a [monitor](/use/checks-and-monitors/monitors.md) and make it run periodically.
* `save-view`- A **view permission**. Update a specific view \(when granted on a view\) or all views \(when granted on `everything`\). Granted on the following views for predefined StackState roles:
  * Administrator: `everything` (all views)
  * Platform Administrator: -
  * Power User: `everything` (all views)
  * Guest: -
* `update-permissions` - Grant/revoke permissions or modify subjects.
* `update-settings` - Update settings.
* `update-visualization` - Change [visualization settings](/use/stackstate-ui/views/visualization_settings.md).
* `upload-stackpacks` - Upload new \(versions of\) StackPacks.

## Permissions by action

### Page access

The permissions in the table below are required to access specific pages in the StackState UI. Without these permissions, the associated page will be hidden in the StackState UI and will not be accessible via its URL.

![Main menu with all permissions granted](../../../.gitbook/assets/v50_main_menu.png)

| Page | Description | Permission | Guest | Power user | Admin | Platform admin |
| :--- | :--- | :--- | :---: | :---: | :---: | :---: |
| **Explore Mode** | Explore the unfiltered topology. | `access-explore` | ✅ | ✅ | ✅ | - |
| **Views** | Access can be granted either for a specific view using the view ID or for all views using the `everything` resource. See [view management permissions](rbac_permissions.md#view-management).  | `access-view` | ✅  `everything` | ✅  `everything` | ✅  `everything` | ✅  `everything` |
| **Analytics** | See [analytics environment permissions](rbac_permissions.md#analytics-environment). | `access-analytics` | - | ✅ | ✅ | - |
| **CLI** | The CLI page provides the API key to use for authentication with the StackState CLI. | `access-cli` | ✅ | ✅ | ✅ | ✅ |
| **StackPacks** | Browse, install and uninstall StackPacks. | `manage-stackpacks` | - | ✅ | ✅ | - |
| **Settings** | See [settings page permissions](rbac_permissions.md#settings-page). | `read-settings` | - | ✅ | ✅ | - |
| **Settings** &gt; **Export Settings** | Allows the export of settings from Settings Menu. See [settings page permissions](rbac_permissions.md#settings-page). | `export-settings` and `read-settings` | - | ✅ | ✅ | - |
| **Settings** &gt; **Import Settings** | Allows the import of settings from Settings Menu. See [settings page permissions](rbac_permissions.md#settings-page). | `import-settings` and `read-settings`   | - | ✅ | ✅ | - |

See the full list of [permissions for predefined roles](rbac_permissions.md#all-permissions-in-stackstate) \(above\).

### Topology

The permissions listed below are required to work with topology in StackState:

| Action | Permission | Guest | Power user | Admin | Platform admin |
| :--- | :--- | :---: | :---: | :---: | :---: |
| Access and edit the view visualization settings. Adds the **visualization settings** button. | `update-visualization` | ✅ | ✅ | ✅ | - |
| Basic and Advanced filtering. Adds filtering options. | `perform-custom-query` | ✅ | ✅ | ✅ | - |
| Execute actions from the component context menu. | `execute-component-actions` | ✅ | ✅ | ✅ | - |
| Drag and drop components. | `manage-topology-elements` | - | ✅ | ✅ | - |
| Add components button. Create relations between topology elements. | `manage-topology-elements` and `perform-custom-query` and `read-settings` | - | ✅ | ✅ | - |

See the full list of [permissions for predefined roles](rbac_permissions.md#all-permissions-in-stackstate) \(above\).

### Detailed information about components and relations

The permissions listed below are required to carry out specific actions in the right panel **Selection details** tab when detailed information about an element is displayed.

| Action | Permission | Guest | Power user | Admin | Platform admin |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **Telemetry** Add a new telemetry stream. Without this permission, only the **Inspect** action is available in the **...** menu and the **ADD NEW STREAM** button is hidden. | `manage-topology-elements` | - | ✅ | ✅ | - |
| **Health** Add a new StackState health check. Edit / delete an existing health check. Without this permission, the **...** menu and the **ADD NEW HEALTH CHECK** button are hidden. | `manage-topology-elements` | - | ✅ | ✅ | - |
| **Elements** Delete an element or element template. | `manage-topology-elements` | - | ✅ | ✅ | - |
| **Elements** Edit an element or element template. | `manage-topology-elements` and `perform-custom-query` and `read-settings` | - | ✅ | ✅ | - |

See the full list of [permissions for predefined roles](rbac_permissions.md#all-permissions-in-stackstate) \(above\).

### View management

The permissions listed below can be set to access and work with views:

| Action | Permission | Guest | Power user | Admin | Platform admin |
| :--- | :--- | :---: | :---: | :---: | :---: |
| Access a specific view or all views \(`everything`\). Example: [Grant permissions to open a view](rbac_permissions.md#allow-a-user-to-open-a-view). | `access-view` | ✅  `everything` | ✅  `everything` | ✅  `everything` | ✅  `everything` |
| Add and remove stars from views. | `manage-star-view` | ✅ | ✅ | ✅ | ✅ | 
| Access and edit the view visualization settings. Adds the **visualization settings** button. | `update-visualization` | ✅ | ✅ | ✅ | - |
| Add or edit event handlers. Adds the **ADD NEW EVENT HANDLER** button. Without this permission, users will only be able to view details of existing event handlers. Example: [Grant permissions to add and edit event handlers](rbac_permissions.md#allow-a-user-to-add-or-edit-event-handlers). | `manage-event-handlers` | - | ✅ | ✅ | - |
| Create views. Example: [Grant permissions to create views](rbac_permissions.md#allow-a-user-to-create-save-views). | `create-views` | - | ✅ | ✅ | - |
| Save updates to a specific view or all views \(`everything`\). | `save-view` | - | ✅  `everything` | ✅  `everything` | - |
| Delete a view. For a specific view or all views \(`everything`\). | `delete-view` | - | ✅  `everything` | ✅  `everything` | - |

See the full list of [permissions for predefined roles](rbac_permissions.md#all-permissions-in-stackstate) \(above\).

### Analytics environment

The permissions listed below are required to access and execute scripts in the StackState UI analytics environment:

| Action | Permission | Guest | Power user | Admin | Platform admin |
| :--- | :--- | :---: | :---: | :---: | :---: |
| Access the **Analytics** page in the StackState UI. Without this permission, the analytics environment will be hidden from the main menu, and it will not be accessible via its URL. | `access-analytics` | - | ✅ | ✅ | - |
| Execute scripts in the StackState UI analytics environment. Adds the **Execute** button. | `execute-scripts` and `access-analytics` | - | ✅ | ✅ | - |
| Execute scripts that use the [HTTP script API](../../../develop/reference/scripting/script-apis/http.md). Also requires `access-analytics` and `execute-scripts`. | `execute-restricted-scripts` | - | - | ✅ | - |

See the full list of [permissions for predefined roles](rbac_permissions.md#all-permissions-in-stackstate) \(above\).

### Settings page

The permissions listed below are required to access and manage settings in the StackState UI:

| Action | Permission | Guest | Power user | Admin | Platform admin |
| :--- | :--- | :---: | :---: | :---: | :---: |
| Access the **Settings** pages in the StackState UI. Without this permission, the settings section will be hidden from the main menu and it will not be accessible via its URL. | `read-settings` | - | ✅ | ✅ | - |
| Add / Edit / Delete capabilities. This permission unlocks the **...** menu and the **ADD** buttons on all Settings Pages. | `update-settings` | - | ✅ | ✅ | - |
| Export capability. Adds checkboxes to export individual items from the settings pages and the page **Export Settings**. | `export-settings` | - | ✅ | ✅ | - |
| Import capability. Adds the page **Import Settings**. | `import-settings` | - | ✅ | ✅ | - |
| Delete and Reset synchronization capabilities. | `execute-node-sync` | - | ✅ | ✅ | - |

See the full list of [permissions for predefined roles](rbac_permissions.md#all-permissions-in-stackstate) \(above\).

### Platform Management

The permissions listed below are required to access and manage StackState platform:

| Action | Permission | Guest | Power user | Admin | Platform Admin |
| :--- | :--- | :---: | :---: | :---: | :---: |
| Access the administrator API. | `access-admin-api` | - | - | - | ✅ |
| Access StackState logs using the CLI. | `access-log-data` | - | ✅ | ✅ | ✅ |

See the full list of [permissions for predefined roles](rbac_permissions.md#all-permissions-in-stackstate) \(above\).

## Example CLI commands

{% hint style="info" %}
**Important note:** All permissions in StackState are case sensitive.
{% endhint %}

### List all permissions

List all permissions:

{% tabs %}
{% tab title="CLI: stac" %}

```text
stac permission list
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="CLI: sts (new)" %}

Command not currently available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% endtabs %}

### Show granted permissions

Show the permissions granted to a specific role.

{% tabs %}
{% tab title="CLI: stac" %}

```text
stac permission show [role-name]
```


⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="CLI: sts (new)" %}

Command not currently available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% endtabs %}

### Grant permissions

#### Allow a user to open a view

Provide a subject with permission to open a view:

{% tabs %}
{% tab title="CLI: stac" %}

```text
stac permission grant [subject-handle] access-view [view-name]
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`. 

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="CLI: sts (new)" %}

Command not currently available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% endtabs %}

#### Allow a user to create \(save\) views

Provide a subject with the system permission to create \(save\) views:

{% tabs %}
{% tab title="CLI: stac" %}

```text
stac permission grant [subject-handle] create-views system
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="CLI: sts (new)" %}

Command not currently available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% endtabs %}

#### Allow a user to check StackState settings

Provide a subject with the system permission to check StackState settings:

{% tabs %}
{% tab title="CLI: stac" %}

```text
stac permission grant [subject-handle] read-settings system
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="CLI: sts (new)" %}

Command not currently available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% endtabs %}

#### Allow a user to add or edit event handlers

Provide a subject with the system permission to add new event handlers and edit existing event handlers:

{% tabs %}
{% tab title="CLI: stac" %}

```text
stac permission grant [subject-handle] manage-event-handlers system
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="CLI: sts (new)" %}

Command not currently available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% endtabs %}

### Revoke permissions

Revoke permissions for a subject to open a view:

{% tabs %}
{% tab title="CLI: stac" %}

```text
stac permission revoke [subject-handle] access-view [view-name]
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="CLI: sts (new)" %}

Command not currently available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% endtabs %}

## StackState UI with no permissions

Below is an example of how the StackState UI would look for a user without any permissions:

![No permissions](../../../.gitbook/assets/noperm.png)

