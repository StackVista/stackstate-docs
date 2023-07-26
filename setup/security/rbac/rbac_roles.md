---
description: StackState for Kubernetes troubleshooting Self-hosted
---

# Roles

## Overview

Every user in StackState needs to have a subject and a set of [permissions](rbac_permissions.md) assigned; this combination is called a role. A role describes a group of users that can access a specific data set. StackState ships with a set of predefined roles and you can also create roles to match your needs.

## Predefined roles

There are four roles predefined in StackState:

* **Administrator** - has full access to all views and has all permissions, except for platform management.
* **Platform Administrator** - has platform management permissions and access to all views.
* **Power User** - typically granted to a user that needs to configure StackState for a team\(s\), but won't manage the entire StackState installation.
* **Kubernetes Troubleshooter** - has all permissions required to use StackState for troubleshooting, including the ability to enable/disable monitors, create custom views and use the Cli.
* **Guest** - has read-only access to StackState.

The permissions assigned to each predefined StackState role can be found below. For details of the different permissions and how to manage them using the `stac` CLI, see [Role based access control (RBAC) permissions](/setup/security/rbac/rbac_permissions.md)

{% tabs %}
{% tab title="Administrator" %}

The Administrator role \(`stackstate-admin`\): has all permissions assigned, except for `access-admin-api`, which is assigned only to the Platform Administrator predefined role.

Permissions assigned to the predefined Administrator role (`stackstate-admin`) are listed below, these were retrieved using the `sts` CLI. For details of the different permissions and how to manage them using the `sts` CLI, see [RBAC permissions](/setup/security/rbac/rbac_permissions.md).

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
read-metrics                | system    
read-permissions            | system    
read-settings               | system    
read-stackpacks             | system    
read-telemetry-streams      | system    
run-monitors                | system    
update-permissions          | system    
update-settings             | system    
update-visualization        | system    
upload-stackpacks           | system    
view-monitors               | system
```
{% endtab %}
{% tab title="Platform Administrator" %}

Platform Administrator \(`stackstate-platform-admin`\) is the only predefined role assigned the permission `access-admin-api`.

Permissions assigned to the predefined Platform Administrator role (`stackstate-platform-admin`) are listed below, these were retrieved using the `sts` CLI. For details of the different permissions and how to manage them using the `sts` CLI, see [RBAC permissions](/setup/security/rbac/rbac_permissions.md).

```text
❯ ./sts rbac describe-permissions --subject stackstate-platform-admin
access-view      | everything
access-admin-api | system    
access-cli       | system    
access-log-data  | system    
manage-star-view | system    
unlock-node      | system 
```
{% endtab %}
{% tab title="Power User" %}

The Power User role \(`stackstate-power-user`\) has all Administrator permissions, except for:
* `execute-restricted-scripts`
* `update-permissions`
* `upload-stackpacks`

Permissions assigned to the predefined Power User role (`stackstate-power-user`) are listed below, these were retrieved using the `sts` CLI. For details of the different permissions and how to manage them using the `sts` CLI, see [RBAC permissions](/setup/security/rbac/rbac_permissions.md).

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
read-metrics                | system    
read-permissions            | system    
read-settings               | system    
read-stackpacks             | system    
read-telemetry-streams      | system    
run-monitors                | system    
update-settings             | system    
update-visualization        | system    
view-monitors               | system 
```
{% endtab %}
{% tab title="Troubleshooter" %}

The Troubleshooter role \(`stackstate-k8s-troubleshooter`\) has access to all data available in StackState and the ability to create views and enable/disable monitors.

Permissions assigned to the predefined troubleshooter role are listed below, these were retrieved using the `sts` CLI. For details of the different permissions and how to manage them using the `sts` CLI, see [RBAC permissions](/setup/security/rbac/rbac_permissions.md).

```text
❯ ./sts rbac describe-permissions --subject stackstate-k8s-troubleshooter
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
read-metrics                | system    
read-permissions            | system    
read-settings               | system    
read-stackpacks             | system    
read-telemetry-streams      | system    
run-monitors                | system    
update-settings             | system    
update-visualization        | system    
view-monitors               | system 
```
{% endtab %}
{% tab title="Guest" %}

The Guest role \(`stackstate-guest`\) has read-only access to StackState.

Permissions assigned to the predefined Guest role are listed below, these were retrieved using the `sts` CLI. For details of the different permissions and how to manage them using the `sts` CLI, see [RBAC permissions](/setup/security/rbac/rbac_permissions.md).

```text
❯ ./sts rbac describe-permissions --subject stackstate-guest
PERMISSION                | RESOURCE                                    
access-view               | everything
access-cli                | system    
access-explore            | system    
execute-component-actions | system    
manage-star-view          | system    
perform-custom-query      | system    
read-metrics              | system    
read-permissions          | system    
read-settings             | system    
read-telemetry-streams    | system    
update-visualization      | system    
view-monitors             | system 
```
{% endtab %}
{% endtabs %}

## Custom roles

In addition to the predefined roles \(`stackstate-admin`, `stackstate-platform-admin`, `stackstate-power-user`, `stackstate-k8s-troubleshooter`, `stackstate-guest`\), which are always available, custom roles can be added. There are multiple ways to add custom roles:

1. via the configuration file, with the same permission as the predefined roles
2. via the configuration file, with a custom scope and custom system and view permissions
3. using the `sts` CLI, the subjects and their permissions are stored in the database and can be modified during runtime

Roles added via the configuration file require a restart and therefore result in a short period of downtime. Roles created using the CLI are stored in the database and can be modified at runtime.

### Custom names for predefined roles

Use this option when the predefined StackState roles are a good fit but the external authentication provider has different names for the roles. For example when the LDAP authentication provider has similar but differently named roles include this YAML snippet in an `authentication.yaml` to give the roles from LDAP the same permissions and scopes as the predefined, equivalent, roles.

```yaml
stackstate:
  authentication:
    roles:
      guest: ["ldap-guest-role"]
      powerUser: ["ldap-power-user-role"]
      admin: ["ldap-admin-role"]
      troubleshooter: ["ldap-troubleshooter-role"] # not yet supported in the helm chart
      platformAdmin: ["ldap-platform-admin-role"]
```

To use it in for your StackState installation \(or already running instance, note that it will restart the API\):

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values authentication.yaml \
stackstate \
stackstate/stackstate-k8s
```

### Custom roles with custom scopes and permissions via the configuration file

To set up a new role called `development-troubleshooter`, which will allow the same permissions as the predefined troubleshooter role, but only for the `dev-test` cluster, include this YAML snippet in an `authentication.yaml`:

```yaml
stackstate:
  authentication:
    roles:
      custom:
        development-troubleshooter:
          systemPermissions:
          - create-views
          - access-analytics
          - execute-scripts
          - read-settings
          - update-settings
          - import-settings
          - export-settings
          - manage-topology-elements
          - access-cli
          - access-explore
          - update-visualization
          - perform-custom-query
          - read-permissions
          - manage-star-view
          - read-stackpacks
          - manage-stackpacks
          - execute-component-templates
          - access-topic-data
          - access-log-data
          - access-synchronization-data
          - execute-node-sync
          - read-telemetry-streams
          - manage-telemetry-streams
          - execute-component-actions
          - manage-annotations
          - manage-event-handlers
          - manage-monitors
          - run-monitors
          - view-monitors
          - read-metrics
          viewPermissions:
          - access-view
          - save-view
          - delete-view
          query: "label = 'kube_cluster_name:dev-test'" # Optional, leave out when the scope should be all topology, not yet supported in the Helm chart
```

To use it in for your StackState installation \(or already running instance, note that it will restart the API\):

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values authentication.yaml \
stackstate \
stackstate/stackstate-k8s
```

### Custom roles via the CLI

To set up a new role called `development-troubleshooter`, which will allow the same permissions as the normal troubleshooter role, but only for the `dev-test` cluster, a new subject needs to be created. Further more this subject needs to be assigned the required set of permissions:

1. Create the subject (with the same name as the role, the role-subject matching is name based and case-sensitive):

   ```text
   sts rbac create-subject --subject development-troubleshooter --scope 'label = "kube_cluster_name:dev-test"'
   ```

   Please note that when passing an topology query in a CLI command, all operators \(like `=`, `<`,`AND`, and so on\) need to be surrounded by spaces, as in the above example.

2. Configured subjects need permissions to access parts of the UI and to execute actions in it. To grant the same permissions as the troubleshooter role, follow the below example:

    ```text
    # To grant permission to access any view use the special view name 'everything'
    sts rbac grant --subject development-troubleshooter --permission access-view --resource "everything"
    sts rbac grant --subject development-troubleshooter --permission save-view --resource "everything"
    sts rbac grant --subject development-troubleshooter --permission delete-view --resource "everything"
    
    sts rbac grant --subject development-troubleshooter --permission access-analytics
    sts rbac grant --subject development-troubleshooter --permission access-cli
    sts rbac grant --subject development-troubleshooter --permission access-explore
    sts rbac grant --subject development-troubleshooter --permission access-log-data
    sts rbac grant --subject development-troubleshooter --permission access-synchronization-data
    sts rbac grant --subject development-troubleshooter --permission access-topic-data
    sts rbac grant --subject development-troubleshooter --permission create-views
    sts rbac grant --subject development-troubleshooter --permission execute-component-actions
    sts rbac grant --subject development-troubleshooter --permission execute-component-templates
    sts rbac grant --subject development-troubleshooter --permission execute-node-sync
    sts rbac grant --subject development-troubleshooter --permission execute-scripts
    sts rbac grant --subject development-troubleshooter --permission export-settings
    sts rbac grant --subject development-troubleshooter --permission import-settings
    sts rbac grant --subject development-troubleshooter --permission manage-annotations
    sts rbac grant --subject development-troubleshooter --permission manage-event-handlers
    sts rbac grant --subject development-troubleshooter --permission manage-monitors
    sts rbac grant --subject development-troubleshooter --permission manage-stackpacks
    sts rbac grant --subject development-troubleshooter --permission manage-star-view
    sts rbac grant --subject development-troubleshooter --permission manage-telemetry-streams
    sts rbac grant --subject development-troubleshooter --permission manage-topology-elements
    sts rbac grant --subject development-troubleshooter --permission perform-custom-query
    sts rbac grant --subject development-troubleshooter --permission read-metrics
    sts rbac grant --subject development-troubleshooter --permission read-permissions
    sts rbac grant --subject development-troubleshooter --permission read-settings
    sts rbac grant --subject development-troubleshooter --permission read-stackpacks
    sts rbac grant --subject development-troubleshooter --permission read-telemetry-streams
    sts rbac grant --subject development-troubleshooter --permission run-monitors
    sts rbac grant --subject development-troubleshooter --permission update-settings
    sts rbac grant --subject development-troubleshooter --permission update-visualization
    sts rbac grant --subject development-troubleshooter --permission view-monitors
    ```

  Please note that the subject's name, as well as permissions, are case-sensitive.
