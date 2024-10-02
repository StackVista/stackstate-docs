---
description: SUSE Observability Self-hosted
---

# Permissions

## Overview

Permissions in SUSE Observability allow Administrators to manage the actions that each user or user group can perform inside SUSE Observability and the information that will be shown in their SUSE Observability UI. Only the feature set relevant to each user's active role will be presented. The actions, information and pages that a user doesn't have access to are simply not displayed in their SUSE Observability UI.

{% hint style="info" %}
Permissions are stored in StackGraph. This means that:

* If you perform an upgrade with "clear all data", permission setup will also be removed.
* To completely remove a user, they must also be manually removed from StackGraph.
{% endhint %}

## SUSE Observability permissions

There are two types of permission in SUSE Observability. **System permissions** scope user capabilities, such as access to settings, query execution and scripting. **View permissions** allow for CRUD operations on SUSE Observability Views, these can be granted for a specific view or for all views. For details of the permissions attached to each predefined role in SUSE Observability, see [predefined roles](/setup/security/rbac/rbac_roles.md#predefined-roles)

The following permissions are available in SUSE Observability:

* `access-admin-api` -Access the administrator API.
* `access-analytics` - Access the Analytics page in the SUSE Observability UI.
* `access-cli` - Access the CLI page. This provides the API key to use for authentication with the SUSE Observability CLI.
* `access-explore` - Access the Explore page in the SUSE Observability UI.
* `access-log-data` - Access SUSE Observability logs using the CLI.
* `access-synchronization-data` - Access SUSE Observability synchronization status and data using the CLI.
* `access-topic-data` - Access SUSE Observability Receiver data using the CLI.
* `access-view` - A **View permission**. Access a specific view \(when granted on a view\) or all views \(when granted on `everything`\). Granted on the following views for predefined SUSE Observability roles:
  * Administrator: `everything` (all views)
  * Platform Administrator: `everything` (all views)
  * Power User: `everything` (all views)
  * Guest: `everything` (all views)
* `create-views` - [Create views](/use/views/k8s-custom-views.md) in the SUSE Observability UI.
* `delete-view` - A **view permission**. Delete a specific view \(when granted on a view\) or all views \(when granted on `everything`\). Granted on the following views for predefined SUSE Observability roles:
  * Administrator: `everything` (all views)
  * Platform Administrator: -
  * Power User: `everything` (all views)
  * Guest: -
* `execute-component-actions` - Execute [component actions](/use/views/k8s-topology-perspective.md#actions).
* `execute-component-templates` - Invoke a component template API extension \(internal use only\).
* `execute-node-sync` - Reset or delete a synchronization.
* `execute-restricted-scripts` - Execute scripts using the HTTP script API in the SUSE Observability UI analytics environment. Also requires `execute-scripts`.
* `execute-scripts` - Execute a query in the SUSE Observability UI Analytics environment. The `execute-restricted-scripts` permission is also required to execute scripts using the HTTP script API.
* `export-settings` - Export settings.
* `import-settings` - Import settings.
* `manage-annotations` - Persist and fetch Anomaly annotations in SUSE Observability.
* `manage-ingestion-api-keys` - Manage [API keys](/use/security/k8s-ingestion-api-keys.md) for data ingestion.
* `manage-metric-bindings` - Create, delete and change [metric bindings](/use/metrics/k8s-add-charts.md)
* `manage-monitors` - Create, delete and change [monitors](/use/alerting/k8s-monitors.md).
* `manage-notifications` - Create, delete, and modify [notifications](/use/alerting/notifications/configure.md).
* `manage-service-tokens`- Create/delete [Service Tokens](/use/security/k8s-service-tokens.md) in SUSE Observability.
* `manage-stackpacks` - Install/upgrade/uninstall StackPacks.
* `manage-star-view` - Add and remove stars from views in the SUSE Observability UI.
* `manage-topology-elements` - Create/update/delete topology elements.
* `perform-custom-query` - Access the [topology filter](/use/views/k8s-filters.md#filter-topology).
* `read-agents` - List connected agents with the cli `agent list` command
* `read-permissions` - List all granted permissions across the entire system using the CLI.
* `read-settings` - Access the Settings page in the SUSE Observability UI.
* `read-stackpacks`
* `read-system-notifications` - Access the system notifications in the UI
* `read-telemetry-streams` - Access the telemetry data for components in the StackState UI
* `read-traces` - Read and access trace data.
* `run-monitors` - Execute a [monitor](/use/alerting/k8s-monitors.md) and make it run periodically.
* `save-view`- A **view permission**. Update a specific view \(when granted on a view\) or all views \(when granted on `everything`\). Granted on the following views for predefined StackState roles:
  * Administrator: `everything` (all views)
  * Platform Administrator: -
  * Power User: `everything` (all views)
  * Guest: -
* `unlock-node` - Unlock [locked configuration items](/stackpacks/about-stackpacks.md#locked-configuration-items).
* `update-permissions` - Grant/revoke permissions or change subjects.
* `update-settings` - Update settings.
* `update-visualization` - Change [visualization settings](/use/views/k8s-topology-perspective.md#visualization-settings).
* `upload-stackpacks` - Upload new \(versions of\) StackPacks.
* `view-metric-bindings` - View [metric bindings](/use/metrics/k8s-add-charts.md) (via the cli)
* `view-monitors` - View monitor configurations.
* `view-notifications` - View notification settings.

## Manage permissions

SUSE Observability permissions can be managed using the `sts` CLI.

{% hint style="info" %}
**Important note:** All permissions in SUSE Observability are case sensitive.
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

#### Allow a user to check SUSE Observability settings

Give a subject with the system permission to check SUSE Observability settings:


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

## SUSE Observability UI with no permissions

Below is an example of how the SUSE Observability UI would look for a user without any permissions:

![No permissions](../../../.gitbook/assets/noperm.png)
