---
description: Rancher Observability Self-hosted
---

# Permissions

## Overview

Permissions in Rancher Observability allow Administrators to manage the actions that each user or user group can perform inside Rancher Observability and the information that will be shown in their Rancher Observability UI. Only the feature set relevant to each user's active role will be presented. The actions, information and pages that a user doesn't have access to are simply not displayed in their Rancher Observability UI.

{% hint style="info" %}
Permissions are stored in StackGraph. This means that:

* If you perform an upgrade with "clear all data", permission setup will also be removed.
* To completely remove a user, they must also be manually removed from StackGraph.
{% endhint %}

## Rancher Observability permissions

There are two types of permission in Rancher Observability. **System permissions** scope user capabilities, such as access to settings, query execution and scripting. **View permissions** allow for CRUD operations on Rancher Observability Views, these can be granted for a specific view or for all views. For details of the permissions attached to each predefined role in Rancher Observability, see [predefined roles](/setup/security/rbac/rbac_roles.md#predefined-roles)

The following permissions are available in Rancher Observability:

* `access-admin-api` -Access the administrator API.
* `access-analytics` - Access the Analytics page in the Rancher Observability UI.
* `access-cli` - Access the CLI page. This provides the API key to use for authentication with the Rancher Observability CLI.
* `access-explore` - Access the Explore page in the Rancher Observability UI.
* `access-log-data` - Access Rancher Observability logs using the CLI.
* `access-synchronization-data` - Access Rancher Observability synchronization status and data using the CLI.
* `access-topic-data` - Access Rancher Observability Receiver data using the CLI.
* `access-view` - A **View permission**. Access a specific view \(when granted on a view\) or all views \(when granted on `everything`\). Granted on the following views for predefined Rancher Observability roles:
  * Administrator: `everything` (all views)
  * Platform Administrator: `everything` (all views)
  * Power User: `everything` (all views)
  * Guest: `everything` (all views)
* `create-views` - [Create views](/use/views/k8s-custom-views.md) in the Rancher Observability UI.
* `delete-view` - A **view permission**. Delete a specific view \(when granted on a view\) or all views \(when granted on `everything`\). Granted on the following views for predefined Rancher Observability roles:
  * Administrator: `everything` (all views)
  * Platform Administrator: -
  * Power User: `everything` (all views)
  * Guest: -
* `execute-component-actions` - Execute [component actions](/use/views/k8s-topology-perspective.md#actions).
* `execute-component-templates` - Invoke a component template API extension \(internal use only\).
* `execute-node-sync` - Reset or delete a synchronization.
* `execute-restricted-scripts` - Execute scripts using the HTTP script API in the Rancher Observability UI analytics environment. Also requires `execute-scripts`.
* `execute-scripts` - Execute a query in the Rancher Observability UI Analytics environment. The `execute-restricted-scripts` permission is also required to execute scripts using the HTTP script API.
* `export-settings` - Export settings.
* `import-settings` - Import settings.
* `manage-annotations` - Persist and fetch Anomaly annotations in Rancher Observability.
* `manage-ingestion-api-keys` - Manage [API keys](/use/security/k8s-ingestion-api-keys.md) for data ingestion.
* `manage-monitors` - Create, delete and change [monitors](/use/alerting/k8s-monitors.md).
* `manage-notifications` - Create, delete, and modify [notifications](/use/alerting/notifications/configure.md).
* `manage-service-tokens`- Create/delete [Service Tokens](/use/security/k8s-service-tokens.md) in Rancher Observability.
* `manage-stackpacks` - Install/upgrade/uninstall StackPacks.
* `manage-star-view` - Add and remove stars from views in the Rancher Observability UI.
* `manage-topology-elements` - Create/update/delete topology elements.
* `perform-custom-query` - Access the [topology filter](/use/views/k8s-filters.md#filter-topology).
* `read-permissions` - List all granted permissions across the entire system using the CLI.
* `read-settings` - Access the Settings page in the Rancher Observability UI.
* `read-stackpacks`
* `read-telemetry-streams` - Access the telemetry data for components in the Rancher Observability UI
* `read-traces` - Read and access trace data.
* `run-monitors` - Execute a [monitor](/use/alerting/k8s-monitors.md) and make it run periodically.
* `save-view`- A **view permission**. Update a specific view \(when granted on a view\) or all views \(when granted on `everything`\). Granted on the following views for predefined Rancher Observability roles:
  * Administrator: `everything` (all views)
  * Platform Administrator: -
  * Power User: `everything` (all views)
  * Guest: -
* `unlock-node` - Unlock [locked configuration items](/stackpacks/about-stackpacks.md#locked-configuration-items).
* `update-permissions` - Grant/revoke permissions or change subjects.
* `update-settings` - Update settings.
* `update-visualization` - Change [visualization settings](/use/views/k8s-topology-perspective.md#visualization-settings).
* `upload-stackpacks` - Upload new \(versions of\) StackPacks.
* `view-monitors` - View monitor configurations.
* `view-notifications` - View notification settings.

## Manage permissions

Rancher Observability permissions can be managed using the `sts` CLI.

{% hint style="info" %}
**Important note:** All permissions in Rancher Observability are case sensitive.
{% endhint %}

### List all permissions

List all permissions:


```text
sts rbac list-permissions
```

### Show granted permissions

Show the permissions granted to a specific role.

```text
sts rbac describe-permissions --subject [role-name]
```

### Grant permissions

#### Allow a user to open a view

Give a subject with permission to open a view:


```text
sts rbac grant --subject [role-name] --permission access-view --resource [view-name]
```

#### Allow a user to create \(save\) views

Give a subject with the system permission to create \(save\) views:

```text
sts rbac grant --subject [role-name] --permission create-views
```

#### Allow a user to check Rancher Observability settings

Give a subject with the system permission to check Rancher Observability settings:


```text
sts rbac grant --subject [role-name] --permission read-settings
```

#### Allow a user to add or edit event handlers

Give a subject with the system permission to add new event handlers and edit existing event handlers:


```text
sts rbac grant --subject [role-name] --permission manage-event-handlers
```

### Revoke permissions

Revoke permissions for a subject to open a view:


```text
sts rbac revoke --subject [role-name] --permission access-view --resource [view-name]
```

## Rancher Observability UI with no permissions

Below is an example of how the Rancher Observability UI would look for a user without any permissions:

![No permissions](../../../.gitbook/assets/noperm.png)
