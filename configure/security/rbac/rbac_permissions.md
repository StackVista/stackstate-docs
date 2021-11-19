# Permissions

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Permissions in StackState

Permissions in StackState are twofold: System permissions and View permissions. These two sets of permissions are prepared to allow Administrators to take control over actions that users can perform inside StackState, as well as adjusting a user's UI to fit their role. This means that StackState can present a completely different interface and feature set according to the user's active role. UI elements that users don't have access to are simply not displayed in their UI.

Please note that permissions are stored in StackGraph, so performing an upgrade with clear all data will also remove permission setup. Because permissions exist in StackGraph, in order to completely remove the user it needs to be removed from LDAP and from StackGraph manually.

## Views permissions and system permissions

Views permissions are a set of permissions that allow for CRUD operations with Views in StackState. System permissions are scoping user capabilities like access to settings, query execution or scripting.

## Predefined roles

StackState comes with three predefined roles - `stackstate-admin` (Adminstrator), `stackstate-power-user` (Power user) and `stackstate-guest` (Guest user).

* Administrators have all permissions and access to all views. 
* Power Users have all Administrator permissions _except_ update-permissions and upload-stackpacks. This role is typically granted to users that are not managing the entire StackState installation, but do need to configure StackState for their team\(s\).
* Guests have access to view, as you can see below:

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

The default names for these roles as mentioned above can be overriden, this mechanism can also be used to add extra roles that will have the same permissions. Here an example of how to do this for both Kubernetes and Linux instalaltions.

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

Of course it is also possible to leave the defaults in place, for example the `guestGroups` would then have an array with 2 entries: `["stackstate-guest", "custom-guest-role"]`.

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

## List of all permissions in StackState

| Permission | Purpose | Guest | Power-user | Administrator |
| :--- | :--- | :---: | :---: | :---: |
| access-explore | Access the Explore page | ✅ | ✅ | ✅ |
| update-visualization | Change visualization settings | ✅ | ✅ | ✅ |
| perform-custom-query | Access the topology filter | ✅ | ✅ | ✅ |
| read-permissions | List all granted permissions across the entire system via the CLI | ✅ | ✅ | ✅ |
| execute-component-actions | Execute component actions | ✅ | ✅ | ✅ |
| create-views | Create views | - | ✅ | ✅ |
| access-analytics | Access the Analytics page | - | ✅ | ✅ |
| execute-scripts | Execute a query in the Analytics page | - | ✅ | ✅ |
| read-settings | Access the Settings page | - | ✅ | ✅ |
| update-settings | Update settings | - | ✅ | ✅ |
| import-settings | Import settings | - | ✅ | ✅ |
| export-settings | Export settings | - | ✅ | ✅ |
| manage-topology-elements | Create/update/delete topology elements | - | ✅ | ✅ |
| manage-stackpacks | Install/upgrade/uninstall StackPacks | - | ✅ | ✅ |
| manage-annotations | Persist and fetch Anomaly annotations in StackState | - | ✅ | ✅ |
| save-view | Save views | - | ✅ | ✅ |
| access-view | Access a specific view \(when granted on a view\) or all views \(when granted on the `everything` subject\) | - | ✅ | ✅ |
| delete-view | Delete views | - | ✅ | ✅ |
| manage-telemetry-streams | Edit or create new streams for components via the UI | - | ✅ | ✅ |
| access-log-data | Access StackState logs via the CLI | - | ✅ | ✅ |
| access-topic-data | Access StackState receiver data via the CLI | - | ✅ | ✅ |
| execute-component-templates | Invoke a component template API extension \(**internal use only**\) | - | ✅ | ✅ |
| execute-node-sync | Reset or delete a synchronization | - | ✅ | ✅ |
| access-admin-api | Access the administrator API | - | ✅ | ✅ |
| update-permissions | Grant/revoke permissions or modify subjects | - | - | ✅ |
| upload-stackpacks | Upload new \(versions of\) StackPacks | - | - | ✅ |

## UI elements and permissions

### Pages permissions

1. Analytics page - requires `access-analytics` permission. Without this permission, Analytics section is hidden in the UI, and it is not accessible via URL.
2. StackPacks page - requires `manage-stackpacks` system permission. Without this permission, StackPacks section is hidden in the UI and it is not accessible via URL.
3. Settings page - requires `read-settings` system permission. Without this permission, Settings section is hidden in the UI and it is not accessible via URL.
4. Explore Mode page - requires `access-explore` system permission. Without this permission, Explore Mode section is hidden in the UI and it is not accessible via URL.
5. Saved views page - Requires `access-view` permission and a resource. It is possible to grant access for specific views by adding `accesss-view` permission with a specific view ID or \(as it is for the Administrator role\) with `Everything` resource, allowing to see all views.
6. Import Settings Page - requires `import-settings` system permission. Without this permission, Import Settings is removed from Settings Menu.
7. Export Settings page - requires `export-settings` system permission. Without this permission, Export Settings is removed from Settings Menu.
8. Admin API - requires `access-admin-api` system permission. Without this permission, Admin API is removed from Settings Menu.

![Pages1](../../../.gitbook/assets/pages1.png) ![Pages2](../../../.gitbook/assets/pages2.png)

### Navigation Bar permissions

1. Create a view - requires `create-views` system permission. If not granted, save buttons are not present for the user.  
2. Save as... - requires `save-view` permission. It's dependant on `Everything` or the specific view permissions.
3. Edit a view - requires `save-view` permission. It's dependant on `Everything` or the specific view permissions.
4. Delete a view - requires `delete-view` permission. It's dependant on `Everything` or the specific view permissions.
5. Sidebar access - requires `save-view`, `delete-view` or both of them to access these options in the sidebar.

![NavigationBar1](../../../.gitbook/assets/navbar1.png) ![NavigationBar2](../../../.gitbook/assets/navbar2.png)

### Topology capabilities permissions

1. Basic and Advanced filtering - `perform-custom-query` is required to access filtering tools. Filtering options are hidden for users without this permission.
2. Component pane - requires system permissions: `manage-topology-elements`, `perform-custom-query`, and `read-settings`. Component pane is hidden for users without this set of permissions.
3. Visualization Settings - requires `update-visualization` system permission. Visualization settings are hidden for users without this permission.

|  |  |  |
| :---: | :---: | :---: |
| ![TopologyCapabilities1](../../../.gitbook/assets/topocap1.png) | ![TopologyCapabilities2](../../../.gitbook/assets/topocap2.png) | ![TopologyCapabilities3](../../../.gitbook/assets/topocap3.png) |

### Topology views permissions

1. Drag and drop components - requires `manage-topology-elements` system permission.
2. Access to a node actions menu - requires `execute-component-actions` permission.  
3. Create relations between topology elements - requires system permissions: `manage-topology-elements`, `perform-custom-query`, and `read-settings`.

![TopologyView1](../../../.gitbook/assets/v42_topoview1.png) ![TopologyView2](/.gitbook/assets/topoview2.png)

### Analytics Page permissions

1. Executing scripts - requires `execute scripts` system permission. **Execute** button will not be present for users without this permission.

|  |  |  |
| :---: | :---: | :---: |
|  | ![AnalyticsPage1](../../../.gitbook/assets/anpage1.png) |  |

### Element Details permissions

1. Data streams actions - requires `manage-topology-elements` system permission. Without this permission only "Inspect" action is available.
2. Add data streams - requires `manage-topology-elements` system permission. Without this permission, user cannot see the **Add** button.
3. Health check - requires `manage-topology-elements` system permission. Without this permission, user cannot see any actions.
4. Add health check - requires `manage-topology-elements` system permission. Without that permission, user cannot see the **Add** button.
5. Delete element - requires `manage-topology-elements` system permission. **Delete** button is not present if the user does not have this permission.
6. Edit element \(also edit element template\) - requires `manage-topology-elements`, `perform-custom-query`, and `read-settings` system permissions.

|  |  |
| :---: | :---: |
| ![ElementDetails1](../../../.gitbook/assets/eldet1.png) | ![ElementDetails2](/.gitbook/assets/eldet2.png) |

### Settings permissions

Below capabilities are shared across all settings pages.

1. Add New capability - requires `update-settings` system permission. It unlocks **Add...** buttons on all Settings Pages.
2. Edit capability - requires `update-settings` system permission. Three dots menu \(kebab menu\) is not displayed for the users without that permission.
3. Delete capability - requires `update-settings` system permission. Delete option is not displayed for the users without this permission.
4. Export capability - requires `export-settings` system permission. Checkboxes are not available for the user without this permission.
5. Delete and Reset synchronization capabilities - requires `execute-node-sync` system permission.

![SettingsPermissions](../../../.gitbook/assets/settings1.png)

## Examples

Important note: all permissions in StackState are case sensitive.

List all permissions:

```text
sts permission list
```

Provide a subject with permission to open a view:

```text
sts permission grant [subject-handle] access-view [view-name]
```

Revoke permissions for a subject to open a view:

```text
sts permission revoke [subject-handle] access-view [view-name]
```

Provide a subject with system permission to check StackState settings:

```text
sts permission grant [subject-handle] read-settings system
```

Provide a subject with system permission to create \(save\) views:

```text
sts permission grant [subject-handle] create-views system
```

UI of a user without any permissions:

![NoPermissions](../../../.gitbook/assets/noperm.png)
