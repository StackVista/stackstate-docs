---
description: StackState Self-hosted v5.1.x 
---

# Permissions

## Overview

Permissions in StackState allow Administrators to manage the actions that each user or user group can perform inside StackState and the information that will be shown in their StackState UI. Only the feature set relevant to each user's active role will be presented. The actions, information and pages that a user does not have access to are simply not displayed in their StackState UI.

{% hint style="info" %}
Permissions are stored in StackGraph. This means that:

* If you perform an upgrade with "clear all data", permission setup will also be removed.
* To completely remove a user, they must also be manually removed from StackGraph.
{% endhint %}

## StackState permissions

There are two types of permission in StackState. **System permissions** scope user capabilities, such as access to settings, query execution and scripting. **View permissions** allow for CRUD operations on StackState Views, these can be granted for a specific view or for all views. For details of the permissions attached to each predefined role in StackState, see [RBAC roles - predefined roles](/configure/security/rbac/rbac_roles.md#predefined-roles)

The following permissions are included in StackState v5.0:

* `access-admin-api` -Access the administrator API. 
* `access-analytics` - Access the [Analytics](/use/stackstate-ui/analytics.md) page in the StackState UI.
* `access-cli` - Access the CLI page. This provides the API key to use for authentication with the StackState CLI.
* `access-explore` - Access the [Explore](/use/stackstate-ui/explore_mode.md) page in the StackState UI.
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
* `manage-event-handlers` - Create or edit [event handlers](/use/events/manage-event-handlers.md).
* `manage-monitors` - Create, delete and modify [monitors](/use/checks-and-monitors/monitors.md).
* `manage-service-tokens`- Create/delete [Service Tokens](/configure/security/authentication/service_tokens.md) in StackState.
* `manage-stackpacks` - Install/upgrade/uninstall StackPacks.
* `manage-star-view` - Add and remove [stars](/use/stackstate-ui/views/about_views.md#starred-views) from views in the StackState UI. 
* `manage-telemetry-streams` - [Create or edit new telemetry streams](/use/metrics/add-telemetry-to-element.md) for components in the StackState UI.
* `manage-topology-elements` - Create/update/delete topology elements.
* `perform-custom-query` - Access the [topology filter](/use/stackstate-ui/filters.md#filter-topology).
* `read-permissions` - List all granted permissions across the entire system using the CLI.
* `read-settings` - Access the Settings page in the StackState UI.
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

## Manage permissions

StackState permissions can be managed using the `stac` CLI.

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

