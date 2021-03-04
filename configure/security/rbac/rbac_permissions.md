# Permissions

## Overview

Permissions in StackState allow Administrators to manage the actions that each user or user group can perform inside StackState and the information that will be shown in their StackState UI. Only the feature set relevant to each user's active role will be presented. The actions, information and pages that a user does not have access to are simply not displayed in their StackState UI.

{% hint style="info" %}
Permissions are stored in StackGraph. This means that:

- If you perform an upgrade with "clear all data", permission setup will also be removed. 
- To completely remove a user, they must also be manually removed from StackGraph.
{% endhint %}

There are two types of permission in StackState: 

- [System permissions](#system-permissions) - Scope user capabilities, such as access to settings, query execution and scripting.
- [View permissions](#view-permissions) - Allow for CRUD operations on StackState Views.

## Predefined roles

StackState comes with three predefined roles:

* **Administrators** (`stackstate-admin`): Have all permissions and access to all views. 
* **Power Users** (`stackstate-power-user`): This role is typically granted to users that need to configure StackState for their team\(s\), but will not manage the entire StackState installation. Power users have all Administrator permissions _except_ for: 
    - `execute-restricted-scripts`
    - `update-permissions`
    - `upload-stackpacks`
* **Guests** (`stackstate-guest`): Have read access, as you can see below when we use the StackState CLI to show granted permissions for the role:

    ```text
    subject           permission            resource
    ----------------  --------------------  ----------
    stackstate-guest  read-settings         system
    stackstate-guest  access-explore        system
    stackstate-guest  perform-custom-query  system
    stackstate-guest  read-permissions      system
    stackstate-guest  update-visualization  system
    stackstate-guest  access-view           everything
    ```
    
    ```
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

The default names for the pre-defined roles (`stackstate-admin`, `stackstate-power-user`, `stackstate-guest`) can be overridden. In the same way, extra roles can also be added that have the same permissions. Below is an example of how to do this for both Kubernetes and Linux installations.

{% tabs %}
{% tab title="Kubernetes" %}

Include this YAML snippet in an `authentication.yaml` when customizing the authentication configuration to replace the default role names with these custom role names.

```yaml
stackstate:
  authentication:
    roles:
      guest: ["custom-guest-role"]
      powerUser: ["custom-power-user-role"]
      admin: ["custom-admin-role"]
```

It is also possible to leave the defaults in place, for example the `guestGroups` would then have an array with 2 entries: `["stackstate-guest", "custom-guest-role"]`.

To use it in for your StackState installation (or already running instance, note that it will restart the API):

```
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
Edit the existing keys in the `authentication` section (nested in `stackstate.api`) in the configuration file like in the example to replace the default role names with these custom role names. Restart StackState to make the change take effect.

```javascript
  guestGroups = ["custom-guest-role"]
  powerUserGroups = ["custom-power-user-role"]
  adminGroups = ["custom-admin-role"]
}
```

Of course it is also possible to leave the defaults in place, for example the `guestGroups` would then have an array with 2 entries: `["stackstate-guest", "custom-guest-role"]`.

{% endtab %}
{% endtabs %}

## All permissions in StackState

There are two types of permission in StackState: 

- [System permissions](#system-permissions) - Scope user capabilities, such as access to settings, query execution and scripting.
- [View permissions](#view-permissions) - Allow for CRUD operations on StackState Views.

### System permissions

System permissions scope user capabilities, such as access to settings, query execution and scripting. They are set system wide.

| Permission | Purpose | Guest | Power-user | Admin |
| :--- | :--- | :---: | :---: | :---: |
| `access-explore` | Access the Explore page. | ✅ | ✅ | ✅ |
| `execute-component-actions` | Execute component actions. | ✅ | ✅ | ✅ |
| `perform-custom-query` | Access the topology filter. | ✅ | ✅ | ✅ |
| `read-permissions` | List all granted permissions across the entire system via the CLI. | ✅ | ✅ | ✅ |
| `update-visualization` | Change visualization settings. | ✅ | ✅ | ✅ |
| `access-admin-api` | Access the administrator API. | - | ✅ | ✅ |
| `access-analytics` | Access the Analytics page. | - | ✅ | ✅ |
| `access-log-data` | Access StackState logs via the CLI. | - | ✅ | ✅ |
| `access-topic-data` | Access StackState receiver data via the CLI. | - | ✅ | ✅ |
| `create-views` | Create views. | - | ✅ | ✅ |
| `execute-component-templates` | Invoke a component template API extension \(internal use only\). | - | ✅ | ✅ |
| `execute-node-sync` | Reset or delete a synchronization. | - | ✅ | ✅ |
| `execute-scripts` | Execute a query in the StackState UI Analytics environment. The execute-restricted-scripts is also required to execute scripts using the HTTP script API. | - | ✅ | ✅ |
| `import-settings` | Import settings. | - | ✅ | ✅ |
| `export-settings` | Export settings. | - | ✅ | ✅ |
| `manage-annotations` | Persist and fetch Anomaly annotations in StackState. | - | ✅ | ✅ |
| `manage-event-handlers` | Edit or create event handlers. | - | ✅ | ✅ |
| `manage-telemetry-streams` | Edit or create new streams for components via the UI. | - | ✅ | ✅ |
| `manage-topology-elements` | Create/update/delete topology elements. | - | ✅ | ✅ |
| `manage-stackpacks` | Install/upgrade/uninstall StackPacks. | - | ✅ | ✅ |
| `read-settings` | Access the Settings page. | - | ✅ | ✅ |
| `update-settings` | Update settings. | - | ✅ | ✅ |
| `execute-restricted-scripts` | Execute scripts using the [HTTP script API](/develop/reference/scripting/script-apis/http.md) in the StackState UI analytics environment. Also requires execute-scripts. | - | - | ✅ |
| `update-permissions` | Grant/revoke permissions or modify subjects. | - | - | ✅ |
| `upload-stackpacks` | Upload new \(versions of\) StackPacks. | - | - | ✅ |

### View permissions

View permissions allow for CRUD operations on StackState Views. They can be set for a specific view or all views (`Everything`).

| Permission | Purpose | Guest | Power-user | Admin |
| :--- | :--- | :---: | :---: | :---: |
| `access-view` | Access a specific view \(when granted on a view\) or all views \(when granted on `Everything`\). | - | ✅ | ✅ |
| `delete-view` | Delete a specific view \(when granted on a view\) or all views \(when granted on `Everything`\). | - | ✅ | ✅ |
| `save-view` | Update a specific view \(when granted on a view\) or all views \(when granted on `Everything`\). | - | ✅ | ✅ |

See also the full list of [system permissions](#system-permissions).

## Permissions by action

### Page access

The permissions in the table below are required to access specific pages in the StackState UI. Without these permissions, the associated page will be hidden in the StackState UI and will not be accessible via its URL:

![Main menu with all permissions granted](/.gitbook/assets/v42_main_menu.png)

| Page | Permission | Guest | Power-user | Admin |
|:--- |:--- |:--- |:--- |:---|
| **Explore Mode** | `access-explore` | ✅ | ✅ | ✅ |
| **Views**<br />Access can be granted either for a specific view using the view ID or for all views using the `Everything` resource.<br />For details see the [view management permissions](#view-management). | `access-view`  | - | ✅ | ✅ |
| **Analytics**<br />For details see the [analytics environment permissions](#analytics-environment). | `access-analytics` | - | ✅ | ✅ |
| **StackPacks** | `manage-stackpacks` | - | ✅ | ✅ |
| **Settings**<br />For details see the [settings page permissions](#settings-page). | `read-settings` | - | ✅ | ✅ |
| **Settings** > **Export Settings**<br />Also requires `read-settings`.<br />Without this permission, Export Settings is removed from Settings Menu.<br />For details see the [settings page permissions](#settings-page). | `export-settings`  | - | ✅ | ✅ |
| **Settings** > **Import Settings** <br />Also requires `read-settings`.<br />Without this permission, Import Settings is removed from Settings Menu.<br />For details see the [settings page permissions](#settings-page). | `import-settings`  | - | ✅ | ✅ |
| The **Admin API** page, also requires `read-settings`.<br />Without this permission, Admin API is removed from Settings Menu. | `access-admin-api`  | - | ✅ | ✅ |

See the full list of [permissions for pre-defined roles](rbac_permissions.md#all-permissions-in-stackstate) (above).

### Topology

The permissions listed below are required to work with topology in StackState:

| Action | Permission | Guest | Power-user | Admin |
|:--- |:--- |:--- |:--- |:---|
| Access and edit the view visualization settings.<br />If not granted, the visualization settings button will be hidden. | `update-visualization` | ✅ | ✅ | ✅ |
| Basic and Advanced filtering.<br />If not granted, filtering options will be hidden. | `perform-custom-query` | ✅ | ✅ | ✅ |
| Execute actions from the component context menu. | `execute-component-actions` | ✅ | ✅ | ✅ |
| Drag and drop components. | `manage-topology-elements` | - | ✅ | ✅ |
| Add components button.<br />Create relations between topology elements. | `manage-topology-elements`<br />and<br />`perform-custom-query`<br />and<br />`read-settings` | - | ✅ | ✅ |

See the full list of [permissions for pre-defined roles](rbac_permissions.md#all-permissions-in-stackstate) (above).

### Component/relation details

The permissions listed below are required to carry out specific actions in the component or relation details pane.

| Action | Permission | Guest | Power-user | Admin |
|:--- |:--- |
| **Telemetry streams**<br />Add a new telemetry stream.<br />Edit / delete / add baseline to an existing telemetry stream. <br />Without this permission, only the **Inspect** action is available in the **...** menu and the **ADD** button is hidden. | `manage-topology-elements` | - | ✅ | ✅ |
| **Health checks**<br />Add a new health check.<br />Edit / delete an existing health check. <br />Without this permission, the **...** menu and the **ADD** button are hidden. | `manage-topology-elements` | - | ✅ | ✅ |
| **Elements**<br />Delete an element or element template.<br /> |  `manage-topology-elements` | - | ✅ | ✅ |
| **Elements**<br />Edit an element or element template.<br /> |  `manage-topology-elements`<br />and<br />`perform-custom-query`<br />and<br />`read-settings`  | - | ✅ | ✅ |

See the full list of [permissions for pre-defined roles](rbac_permissions.md#all-permissions-in-stackstate) (above).

### View management

The permissions listed below can be set to access and work with views:

| Action | Permission | Guest | Power-user | Admin |
|:--- |:--- |
| Access a specific view or all views (`Everything`).<br />Example: [Grant permissions to open a view](rbac_permissions.md#allow-a-user-to-open-a-view). | `access-view` | - | ✅ | ✅ |
| Access and edit the view visualization settings.<br />If not granted, the visualization settings button will be hidden. | `update-visualization` | ✅ | ✅ | ✅ |
| Add or edit event handlers for all views.<br />If not granted, the ADD NEW EVENT HANDLER button will not be available.<br />Example: [Grant permissions to manage event handlers](#allow-a-user-to-add-or-edit-event-handlers).| `manage-event-handlers` | - | ✅ | ✅ |
| Create and save views.<br />If not granted, save buttons will not be available.<br />Example: [Grant permissions to create views](rbac_permissions.md#allow-a-user-to-create-save-views). | `create-views` | - | ✅ | ✅ | 
| Edit a view or "save view as".<br />For a specific view or all views (`Everything`).| `save-view` | - | ✅ | ✅ |
| Delete a view.<br />For a specific view or all views (`Everything`).  | `delete-view` | - | ✅ | ✅ |

See the full list of [permissions for pre-defined roles](rbac_permissions.md#all-permissions-in-stackstate) (above).

### Analytics environment

The permissions listed below are required to access and execute scripts in the StackState UI analytics environment:

| Action | Permission | Guest | Power-user | Admin |
|:--- |:--- |
| Access the **Analytics** page in the StackState UI. Without this permission, the analytics environment will be hidden in the StackState UI, and it will not be accessible via its URL. |`access-analytics` | - | ✅ | ✅ |
| Execute scripts in the StackState UI analytics environment. Without this permission, the **Execute** button will not be available.<br />Also requires `access-analytics`. | `execute-scripts` | - | ✅ | ✅ |
| Execute scripts that use the [HTTP script API](/develop/reference/scripting/script-apis/http.md).<br />Also requires `access-analytics` and `execute-scripts`. |`execute-restricted-scripts` | - | - | ✅ |

See the full list of [permissions for pre-defined roles](rbac_permissions.md#all-permissions-in-stackstate) (above).

### Settings page

The permissions listed below are required to access and manage settings in the StackState UI:

| Action | Permission | Guest | Power-user | Admin |
|:--- |:--- |
| Access the **Settings** page in the StackState UI.<br />Without this permission, the settings section will be hidden in the StackState UI main menu, and it will not be accessible via its URL. | `read-settings` | - | ✅ | ✅ |
| Add / Edit / Delete capability.<br />This permission unlocks the **...** menu and the **ADD** buttons on all Settings Pages. | `update-settings` | - | ✅ | ✅ |
| Export capability.<br />Without this permission, checkboxes are not available on the settings page. | `export-settings` | - | ✅ | ✅ |
| Delete and Reset synchronization capabilities. | `execute-node-sync` | - | ✅ | ✅ |

See the full list of [permissions for pre-defined roles](rbac_permissions.md#all-permissions-in-stackstate) (above).

## Example CLI commands

{% hint style="info" %}
**Important note:** All permissions in StackState are case sensitive.
{% endhint %}

### List all permissions

List all permissions:

```text
sts permission list
```

### Show granted permissions

Show the permissions granted to a specific role.

```
sts permission show [role-name]
```

### Grant permissions

#### Allow a user to open a view

Provide a subject with permission to open a view:

```text
sts permission grant [subject-handle] access-view [view-name]
```

#### Allow a user to create (save) views

Provide a subject with system permission to create \(save\) views:

```text
sts permission grant [subject-handle] create-views system
```

#### Allow a user to check StackState settings

Provide a subject with system permission to check StackState settings:

```text
sts permission grant [subject-handle] read-settings system
```

#### Allow a user to add or edit event handlers

Provide a subject with system permission to manage event handlers:

```text
sts permission grant [subject-handle] manage-event-handlers system
```

### Revoke permissions

Revoke permissions for a subject to open a view:

```text
sts permission revoke [subject-handle] access-view [view-name]
```

## StackState UI with no permissions

Below is an example of how the StackState UI would look for a user without any permissions:

![No permissions](../../../.gitbook/assets/noperm.png)

