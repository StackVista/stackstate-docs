---
description: StackState Self-hosted v4.5.x
---

# Roles

## Overview



## Predefined roles

StackState comes with four predefined roles:

* **Administrators**
* **Platform Administrators**
* **Power Users**
* **Guests**

### Administrator

The role StackState administrator has access to all views. All permissions are assigned, except for the platform management permission `access-admin-api`. This means that the administrator can ??? but cannnot ???. 

* **Subject**: `stackstate-admin`
* **Permissions and resources**:
    ```yaml
    $ sts permission show stackstate-admin
    subject           permission                   resource
    ----------------  ---------------------------  ----------
    stackstate-admin  manage-annotations           system
    stackstate-admin  execute-scripts              system
    stackstate-admin  read-settings                system
    stackstate-admin  access-cli                   system
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
    stackstate-admin  execute-component-actions    system
    stackstate-admin  access-view                  everything
    stackstate-admin  save-view                    everything
    stackstate-admin  delete-view                  everything
    ```

➡️ [Learn more about StackState permissions](/configure/security/rbac/rbac_permissions.md)

### Platform Administrator

Have platform management permissions and have access to all views.

* **Subject**: `stackstate-platform-admin`
* **Permissions and resources**:
    ```yaml
    $ sts permission show stackstate-platform-admin
    subject                    permission        resource
    -------------------------  ----------------  ----------
    stackstate-platform-admin  access-admin-api  system
    stackstate-platform-admin  access-cli        system
    stackstate-platform-admin  access-log-data   system
    stackstate-platform-admin  manage-star-view  system
    stackstate-platform-admin  access-view       everything
    ```

➡️ [Learn more about StackState permissions](/configure/security/rbac/rbac_permissions.md)

### Power user

The Power user role is typically granted to users that need to configure StackState for their team\(s\), but will not manage the entire StackState installation. Power users have all Administrator permissions _except_ for `execute-restricted-scripts`, `update-permissions` and `upload-stackpacks`.
  
  * **Subject**: `stackstate-power-user`
  * **Permissions and resources**:
      ```yaml
      $ sts permission show stackstate-power-user    
    
      subject                permission                   resource
      ---------------------  ---------------------------  ----------
      stackstate-power-user  manage-annotations           system
      stackstate-power-user  execute-scripts              system
      stackstate-power-user  read-settings                system
      stackstate-power-user  access-cli                   system
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
      stackstate-power-user  execute-component-actions    system
      stackstate-power-user  access-view                  everything
      stackstate-power-user  save-view                    everything
      stackstate-power-user  delete-view                  everything
      ```

➡️ [Learn more about StackState permissions](/configure/security/rbac/rbac_permissions.md)

### Guest

Guests have read access to the StackState UI and can add/remove stars from a view. They can also perform limited operations using the StackState CLI.

* **Subject**: `stackstate-guest`
* **Permissions and resources**:
    ```yaml
    $ sts permission show stackstate-guest     
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

➡️ [Learn more about StackState permissions](/configure/security/rbac/rbac_permissions.md)

## Default and custom role names

The default pre-defined role names \(`stackstate-admin`, `stackstate-platform-admin`, `stackstate-power-user`, `stackstate-guest`\) are always available. Additional custom role names can be added that have the same permissions. Below is an example of how to do this for both Kubernetes and Linux installations.

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