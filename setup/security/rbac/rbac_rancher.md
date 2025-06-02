---
description: SUSE Observability Self-hosted
---

## Overview

The SUSE Rancher Prime Observability Extension allows RBAC configuration of users access in SUSE Observability.

Two kinds of roles are used for accessing SUSE Observability:
* A *scope role* (Observer) grants access to data - either all data in a SUSE Observability instance, data coming from a cluster, or just the data for a namespace.  This role is provisioned in a cluster to be observed.
* An *instance role* grants permissions to access or modify functionality of SUSE Observability itself.

A number of `RoleTemplate`s are available to achieve this, with common groupings of permissions.  Binding these templates to users or groups on a cluster or namespace will trigger roles and role-bindinds to be provisioned on the target cluster.  The default templates are described below.  Note that it is possible to define your own combinations of permissions in a custom RoleTemplate.

### Observer role

The observer role grants a user the permission to read topology, metrics, logs and trace data for a namespace or a cluster.  There are three `RoleTemplate`s that grant access to observability data:

* **Observer** - grants access to data coming from namespaces in a Project.  This can be used in the "Project Membership" section of the cluster configuration.
* **Cluster Observer** - grants access to all data coming from a Cluster.  This template can be used in the "Cluster Membership" section of the cluster configuration.
* **Instance Observer** - grants access to all data in a SUSE Observability instance.  This template can be used on the Project that includes SUSE Observability itself.

### Instance roles

There are four roles predefined in SUSE Observability:

* **Recommended Access** - has recommended permissions for using SUSE Observability.
* **Instance Troubleshooter** - has all permissions required to use SUSE Observability for troubleshooting, including the ability to enable/disable monitors, create custom views and use the Cli.  This role includes access to all data in an observability instance.
* **Instance Administrator** - has full access to all views and has all permissions.  This role includes access to all data in an observability instance.

The permissions assigned to each predefined SUSE Observability role can be found below. For details of the different permissions and how to manage them using the `sts` CLI, see [Role based access control (RBAC) permissions](/setup/security/rbac/rbac_permissions.md)

{% tabs %}
{% tab title="Recommended Access" %}
Recommended access grants permissions that are not strictly necessary, but that make SUSE Observability a lot more useful.

| Resource | Verbs |
| --- | --- |
| apitokens | get |
| favoritedashboards | create, delete |
| favoriteviews | create, delete |
| stackpacks | get |
| visualizationsettings | update |

{% endtab %}

{% tab title="Troubleshooter" %}
The Troubleshooter role has access to all data available in SUSE Observability and the ability to create views and enable/disable monitors.

| Resource | Verbs |
| --- | --- |
| agents | get |
| apitokens | get |
| componentactions | execute |
| dashboards | get, create, update, delete |
| favoritedashboards | create, delete |
| favoriteviews | create, delete |
| metricbindings | get |
| metrics | get |
| monitors | get, create, update, delete, execute |
| notifications | get, create, update, delete |
| settings | get |
| stackpackconfigurations | get, create, update, delete |
| stackpacks | get |
| systemnotifications | get |
| topology | get |
| traces | get |
| views | get, create, update, delete |
| visualizationsettings | get |

{% endtab %}

{% tab title="Administrator" %}
The Administrator role has all permissions assigned.

| Resource | Verbs |
| --- | --- |
| agents | get |
| apitokens | get |
| componentactions | execute |
| dashboards | get, create, update, delete |
| favoritedashboards | create, delete |
| favoriteviews | create, delete |
| ingestionapikeys | get, create, update, delete |
| metricbindings | get |
| metrics | get |
| monitors | get, create, update, delete, execute | 
| notifications | get, create, update, delete |
| permissions | get, create, update, delete |
| restrictedscripts | execute |
| servicetokens | get, create, update, delete |
| settings | get, create, update, delete, unlock |
| stackpackconfigurations | get, create, update, delete |
| stackpacks | get, create |
| syncdata | get, update, delete |
| systemnotifications | get |
| topicmessages | get |
| topology | get |
| traces | get |
| views | get, create, update, delete |
| visualizationsettings | update |

{% endtab %}


### Resource details

These resources correspond to data collected by the SUSE Observability agent and access should typically be limited on a cluster or a namespace level.  The following resources are available in the `scope.observability.cattle.io` API Group:

* `topology` - components (deployments, pods, etcetera) from the cluster or namespace
* `traces` - spans from the cluster or namespace
* `metrics` - metric data originating from the cluster or namespace

These resources can only be read, so the only applicable verb is `get`.

Apart from these RBAC resources controlling access to observability data, "instance" resources define user capabilities for executing and configuring SUSE Observability:

| Resource                  | Verbs | Description |
| --- | --- | --- |
| `agents`                  | `get`   |  List connected agents with the cli `agent list` command |
| `apitokens`               | `get`   | Access the CLI page. This provides the API key to use for authentication with the SUSE Observability CLI |
| `componentactions`        | `execute` | Execute [component actions](/use/views/k8s-topology-perspective.md#actions) |
| `dashboards`              | `get`, `create`, `update`, `delete` | View, create, delete and change dashboards |
| `favoritedashboards`      | `create`, `delete` | Manage a personal shortlist of dashboards |
| `favoriteviews`           | `create`, `delete` | Manage a personal shortlist of views |
| `ingestionapikeys`        | `get`, `create`, `delete` | Manage [API keys](/use/security/k8s-ingestion-api-keys.md) for data ingestion |
| `metricbindings`          | `get`, `create`, `update`, `delete` | Create, delete and change [metric bindings](/use/metrics/k8s-add-charts.md) |
| `monitors`                | `get`, `create`, `update`, `delete` | Create, delete and change [monitors](/use/alerting/k8s-monitors.md) |
| `notifications`           | `get`, `create`, `update`, `delete` | Create, delete and change [notifications](/use/alerting/notifications/configure.md) |
| `restrictedscripts`       | `execute` | Execute scripts using the HTTP script API in the SUSE Observability UI analytics environment. Also requires `scripts` |
| `scripts`                 | `execute` | Execute a query in the SUSE Observability UI Analytics environment. The `restrictedscripts` resource is also required to execute scripts using the HTTP script API |
| `servicetokens`           | `get`, `create`, `delete` | Create/delete [Service Tokens](/use/security/k8s-service-tokens.md) in SUSE Observability |
| `settings`                | `get`, `create`, `update`, `delete`, `unlock` | Export, import, delete, change and unlock settings |
| `stackpackconfigurations` | `create`, `update`, `delete` | Create, delete and change Stackpack conigurations |
| `stackpacks`              | `get`, `create` | List and upload Stackpacks |
| `syncdata`                | `get`, `delete` | Access SUSE Observability synchronization status and data using the CLI, reset and delete a synchronization |
| `systemnotifications`     | `get` | Access the system notifications in the UI |
| `topicmessages`           | `get` | Access SUSE Observability Receiver data using the CLI |
| `views`                   | `get`, `create`, `update`, `delete` | Access, create, delete and change [views](/use/views/k8s-custom-views.md) in the SUSE Observability UI |
| `visualizationsettings`   | `update` | Change [visualization settings](/use/views/k8s-topology-perspective.md#visualization-settings). |

