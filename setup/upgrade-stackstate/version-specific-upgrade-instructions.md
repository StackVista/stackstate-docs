---
description: >-
  Required manual steps for upgrade to each supported StackState version. Read
  this before you upgrade!
---

# Version specific upgrade instructions

## Overview

This page provides specific instructions for upgrading to each currently supported version of StackState. The instructions detail any significant changes that may impact how StackState runs after upgrade, such as a change in memory requirements or configuration.

{% hint style="warning" %}
**Review the instructions provided below before you upgrade!**
{% endhint %}

## Upgrade instructions

### Upgrade to v4.4.x

{% tabs %}
{% tab title="Kubernetes" %}
#### v4.4.0

* Baselines have been disabled in v4.4. The `BaselineFunction` and `Baseline` objects are still available, but they do not serve any purpose other than smooth transition to the Autonomous Anomaly Detector (AAD) framework. If you have custom StackPacks that auto-create baselines, this is the last opportunity to remove baselines from templates and make transition to AAD. In release v4.5 baselines will be removed completely and templates using them will break.
* Authorization configuration for Base API and Admin API has been centralized. This means that there is a single location in the configuration for groups to roles mappings. The three default StackState roles could previously be overridden, but are now always available.
```
stackstate {
  authorization {
    adminGroups = ${stackstate.authorization.adminGroups} ["custom-admin-role-from-ldap-or-oidc-or-keycloak"]
    powerUserGroups = ${stackstate.authorization.powerUserGroups} ["custom-power-user-role-from-ldap-or-oidc-or-keycloak"]
    guestGroups = ${stackstate.authorization.guestGroups} ["custom-guest-role-from-ldap-or-oidc-or-keycloak"]
  }
}
```

  If you have configured API role overrides for specific services these will need to be updated. In most cases, it will not be necessary to make any changes.
  The helm properties where you can find those overrides are below:
   ```
   stackstate.components.api.config = ...
   stackstate.components.checks.config = ...
   stackstate.components.healthSync.config = ...
   stackstate.components.initializer.config = ...
   stackstate.components.server.config = ...
   stackstate.components.state.config = ...
   stackstate.components.sync.config = ...
   stackstate.components.slicing.config = ...
   stackstate.components.viewHealth.config = ...
   stackstate.components.problemProducer.config = ...
   ```

   If you have role overrides configured with those properties, the roles should be moved to a single location as shown below:

   ```yaml
   stackstate:
     authentication:
       roles:
         guest: ["custom-guest-role"]
         powerUser: ["custom-power-user-role"]
         admin: ["custom-admin-role"]
   ```
   For details, see the section [default and custom role names](../../configure/security/rbac/rbac_permissions.md#default-and-custom-role-names).

   If you are still not sure what you need to do, contact [StackState support](https://support.stackstate.com/hc/en-us).
{% endtab %}

{% tab title="Linux" %}
#### v4.4.0

* Baselines have been disabled in v4.4. The `BaselineFunction` and `Baseline` objects are still available, but they do not serve any purpose other than smooth transition to the Autonomous Anomaly Detector (AAD) framework. If you have custom StackPacks that auto-create baselines, this is the last opportunity to remove baselines from templates and make transition to AAD. In release v4.5 baselines will be removed completely and templates using them will break.
* Authorization configuration for Base API and Admin API has been centralized. This means that there is a single location in the configuration for groups to roles mappings. The three default StackState roles could previously be overridden, but are now always available.
```
stackstate {
  authorization {
    adminGroups = ${stackstate.authorization.adminGroups} ["custom-admin-role-from-ldap-or-oidc-or-keycloak"]
    powerUserGroups = ${stackstate.authorization.powerUserGroups} ["custom-power-user-role-from-ldap-or-oidc-or-keycloak"]
    guestGroups = ${stackstate.authorization.guestGroups} ["custom-guest-role-from-ldap-or-oidc-or-keycloak"]
  }
}
```

  This impacts you if you have a customized `authentication` section in the file `application_stackstate.conf`.
  If your `authentication` section has `adminGroups`, `powerUserGroups`, `guestGroups` definitions like in the example below:
  ```
  stackstate {
    api {
      authentication {
        ...
        adminGroups = ["your-custom-oidc-or-ldap-or-keycloak-admin-role"]
        powerUserGroups = ["your-custom-oidc-or-ldap-or-keycloak-power-user-role"]
        guestGroups = ["your-custom-oidc-or-ldap-or-keycloak-guest-role"]
        ...
      }
    }
  }
  ```

  You have to move subject-role mappings to centralized authorization configuration, as in example below.

  ```
  stackstate {
    authorization {
      adminGroups = ${stackstate.authorization.adminGroups} ["your-custom-oidc-or-ldap-or-keycloak-admin-role"]
      powerUserGroups = ${stackstate.authorization.powerUserGroups} ["your-custom-oidc-or-ldap-or-keycloak-power-user-role"]
      guestGroups = ${stackstate.authorization.guestGroups} ["your-custom-oidc-or-ldap-or-keycloak-guest-role"]      
    }
    api {
      authentication {
        ...
        // no subject-role mappings here
        ...
      }
    }
  }
  ```

  {% hint style="info" %}
  The list of roles will be extended to include the new, custom roles. The default roles will remain available (stackstate-admin, stackstate-guest and stackstate-power-user).
  {% endhint %}

  If you are still not sure what you need to do, contact [StackState support](https://support.stackstate.com/hc/en-us).

{% endtab %}
{% endtabs %}

### Upgrade to v4.3.x

{% tabs %}
{% tab title="Kubernetes" %}
#### v4.3.1

No manual action needed.

#### v4.3.0

* StackState is tested to run on Kubernetes v1.17, v1.18 and v1.19, or the equivalent OpenShift release \(version 4.4, 4.5 or 4.6\).
* CPU limits have been added to all pods. If you have customized any of the CPU requests in your `values.yaml`, you will most likely need to also set the CPU limit for the same pod\(s\).
* CPU limits and requests have been re-evaluated and increased where needed for stable operation resulting in a change in the number and size of [required nodes](../requirements.md#node-sizing).
* Two new [permissions](../../configure/security/rbac/rbac_permissions.md) have been added - `manage-event-handlers` and `execute-restricted-scripts`:
  * Guest users will no longer be able to create or edit event handlers.
  * Power Users will no longer be able to execute scripts using the HTTP script API.
  * Admin users will not be affected.
* Baselines have been deprecated and will be removed in v4.4. To reflect this, baseline functions and check functions that use baselines have been renamed. Templates that resolve these functions by name will stop working after upgrade to StackState 4.3. The function identifiers have not changed and can still be used to reference functions, however, it is advised that you migrate to using the [Autonomous Anomaly Detector](../../use/health-state-and-event-notifications/anomaly-health-checks.md).
* A Slack integration StackPack is now available that includes a new Slack event handler. Existing Slack event handlers will continue to run in StackState v4.3, however, the old Slack event handler has been deprecated and will be removed in a future release of StackState. To continue using Slack event notifications, it is advised to install the Slack StackPack and [configure view event handlers](../../use/health-state-and-event-notifications/send-event-notifications.md) to use the new Slack event handler in place of the old `Notify via slack for component health state change. (deprecated)` and `Notify via slack for view health state change.(deprecated)`.
* Dynatrace StackPack - The location of the Dynatrace check config file has moved. If you choose to upgrade to the version of the Dynatrace StackPack shipped with StackState v4.3, the Agent check configuration file should also be moved. The new location is `/etc/sts-agent/conf.d/dynatrace.d/conf.yaml` the previous location was `/etc/sts-agent/conf.d/dynatrace_topology.d/conf.yaml`.
{% endtab %}

{% tab title="Linux" %}
#### v4.3.1

No manual action needed.

#### v4.3.0

* Two new [permissions](../../configure/security/rbac/rbac_permissions.md) have been added - `manage-event-handlers` and `execute-restricted-scripts`:
  * Guest users will no longer be able to create or edit event handlers.
  * Power Users will no longer be able to execute scripts using the HTTP script API.
  * Admin users will not be affected.
* Baselines have been deprecated and will be removed in v4.4. To reflect this, baseline functions and check functions that use baselines have been renamed. Templates that resolve these functions by name will stop working after upgrade to StackState 4.3. The function identifiers have not changed and can still be used to reference functions, however, it is advised that you migrate to using the [Autonomous Anomaly Detector](../../use/health-state-and-event-notifications/anomaly-health-checks.md).
* A Slack integration StackPack is now available that includes a new Slack event handler. Existing Slack event handlers will continue to run in StackState v4.3, however, the old Slack event handler has been deprecated and will be removed in a future release of StackState. To continue using Slack event notifications, it is advised to install the Slack StackPack and [configure view event handlers](../../use/health-state-and-event-notifications/send-event-notifications.md) to use the new Slack event handler in place of the old `Notify via slack for component health state change. (deprecated)` and `Notify via slack for view health state change.(deprecated)`.
* Dynatrace StackPack - The location of the Dynatrace check config file has moved. If you choose to upgrade to the version of the Dynatrace StackPack shipped with StackState v4.3, the Agent check configuration file should also be moved. The new location is `/etc/sts-agent/conf.d/dynatrace.d/conf.yaml` the previous location was `/etc/sts-agent/conf.d/dynatrace_topology.d/conf.yaml`.
{% endtab %}
{% endtabs %}

### Upgrade to v4.2.x

{% tabs %}
{% tab title="Kubernetes" %}
#### v4.2.4

No manual action needed.

#### v4.2.3

Authentication configuration for the Kubernetes Helm chart has been made easier for this release. If your StackState authentication was customized, it will need to be updated. To verify this, check if there is a `stackstate.server.config` or `stackstate.api.config` value that contains an `authentication` section in the `values.yaml` file\(s\) used for installation.

Refer to the [Authentication configuration documentation](../../configure/security/authentication/) to configure the same settings directly in the `values.yaml` file. After that, the `authentication` section can be completely removed. If this results in an empty `config` value it can be removed as well.

#### v4.2.0

* [Node sizing requirements](../requirements.md#node-sizing) have been increased.
* The old `stackstate-server` pod has been replaced by a number of separate pods. Custom configuration in `values.yaml` should be updated:
  * Configured email details in `stackstate.components.server.config` should be moved to `stackstate.components.viewHealth.config`.
  * Other custom configuration in `stackstate.components.server.config` should be moved to `stackstate.components.api.config`.
* A new mandatory parameter `stackstate.baseUrl` has been added. This is the public URL of StackState \(how StackState is reachable from external machines\) and is exposed via the [UI script API](../../develop/reference/scripting/script-apis/ui.md#function-baseurl). The file `values.yaml` should be updated to include the new `stackstate.baseUrl` parameter. The old `stackstate.receiver.baseUrl` parameter has been deprecated and will be removed in a future release, however, when no `stackstate.baseUrl` is provided in StackState v4.2, the configured `stackstate.receiver.baseUrl` will be used instead.
{% endtab %}

{% tab title="Linux" %}
#### v4.2.4

No manual action needed.

#### v4.2.3

No manual action needed.

#### v4.2.0

The following configuration must be manually added after upgrade:

* **etc/application\_stackstate.conf**
  * New mandatory parameter `stackstate.web.baseUrl`. This is the public URL of StackState \(how StackState is reachable from external machines\) and is exposed via the [UI script API](../../develop/reference/scripting/script-apis/ui.md#function-baseurl). You can manually create a system environment variable called `STACKSTATE_BASE_URL` or add the value manually as a string in the file `application_stackstate.conf`.

The following configuration changes must be manually processed if you are using a customized version of a file:

* **etc/stackstate-receiver/application.conf**
  * Renamed the namespace `stackstate`. This is now `stackstate.receiver`.
  * Renamed the parameter `apiKey`. This is now named `apiKeys` and should be a list in the format `[${stackstate.receiver.key}, ${?EXTRA_API_KEY}]`.
* **processmanager.conf**
  * Added new parameter `processes.kafkaToElasticsearch.topology-events`.
* **processmanager/kafka-topics.conf\`**
  * Added new section `kafka.topics.sts_topology_events`.
{% endtab %}
{% endtabs %}

## See also

* [How to upgrade a StackPack](../../stackpacks/about-stackpacks.md#upgrade-a-stackpack)
* [Steps to upgrade StackState](steps-to-upgrade.md)
* [StackPack versions shipped with each StackState release](stackpack-versions.md)
