---
description: StackState Self-hosted v4.5.x
---

# Version specific upgrade instructions

{% hint style="info" %}
[Go to the StackState SaaS docs site](https://docs.stackstate.com/v/stackstate-saas/).
{% endhint %}

## Overview

{% hint style="warning" %}
**Review the instructions provided on this page before you upgrade!**

This page provides specific instructions and details of any required manual steps to upgrade to each supported version of StackState. Any significant change that may impact how StackState runs after upgrade will be described here, such as a change in memory requirements or configuration.

**Read all instructions from the version that you are currently running up to the version that you will upgrade to.**
{% endhint %}

## Upgrade instructions

### Upgrade to v4.5.x

{% tabs %}
{% tab title="Kubernetes" %}
#### v4.5.1

* Adds compatibility with StackState Agent v2.15.0. Read how to [upgrade StackState Agent](/setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2).

#### v4.5.0

* ⚠️ This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.5.1.
* ⚠️ StackState v4.5.0 is not compatible with StackState Agent v2.15.0.
* Change in supported platforms:
  * Support for Kubernetes 1.17 was dropped.
  * Support for Amazon Elastic Kubernetes Service (EKS) 1.20 and 1.21 was added.
  * Support for Azure Kubernetes Service (AKS) 1.20 and 1.21 was added.
  * Support for OpenShift 4.4, 4.5 and 4.6 was dropped.
  * Support for OpenShift 4.7 and 4.8 was added.
  * See the [requirements](/setup/install-stackstate/requirements.md) for an up-to-date list of supported platforms.

{% endtab %}

{% tab title="Linux" %}
#### v4.5.1

* Adds compatibility with StackState Agent v2.15.0. Read how to [upgrade StackState Agent](/setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2).

#### v4.5.0

* ⚠️ This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.5.1.
* ⚠️ StackState v4.5.0 is not compatible with StackState Agent v2.15.0.

{% endtab %}
{% endtabs %}

### Upgrade to v4.4.x

{% tabs %}
{% tab title="Kubernetes" %}
#### v4.4.3

No manual action needed.

#### v4.4.1 - v4.4.2

* ⚠️ These releases are susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.4.3.

#### v4.4.0

* ⚠️ This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.4.3.
* The CPU and memory [requirements to run StackState 4.4 on Kubernetes](/setup/install-stackstate/requirements.md#node-sizing) have been reassessed:
  * The requirements for the recommended highly available setup have grown \(from 5\) to 6 nodes with 32 GB of memory and 8 vCPUS.
  * The requirements for a minimal highly available setup have grown \(from 4\) to 5 nodes with 32 GB of memory and 8 vCPUS.
  * A [non-high availability setup](../install-stackstate/kubernetes_install/non_high_availability_setup.md) has been added, the requirements for which are 3 nodes with 32 GB of memory and 8 vCPUS.
* Baselines have been disabled in v4.4. The `BaselineFunction` and `Baseline` objects are still available, but they do not serve any purpose other than smooth transition to the Autonomous Anomaly Detector \(AAD\) framework. If you have custom StackPacks that auto-create baselines, this is the last opportunity to remove baselines from templates and make transition to AAD. In release v4.5 baselines will be removed completely and templates using them will break.
* Transparent propagation has been renamed to **Auto propagation**. The behavior remains the same.
* The ElasticSearch Helm subchart `elasticsearch-exporter` has been renamed to `prometheus-elasticsearch-exporter`. This means that any configuration for that subchart needs to use the new subchart key `elasticsearch.prometheus-elasticsearch-exporter.*`
* The `passwordMd5` field in the [file based authentication](../../configure/security/authentication/file.md) has been renamed to `passwordHash` as it is now possible to use `bcrypt` type passwords.
* Security improvement for Authentication and Authorization. There is a single configuration for groups to roles mappings and a single authentication provider used for both the Base API and Admin API. The default StackState roles are now always available, these could previously be overridden - `stackstate-admin`, `stackstate-power-user`, `stackstate-guest`. Additionally, a new default role `stackstate-platform-admin` has been introduced.

  ```text
  stackstate {
    authorization {
      adminGroups = ${stackstate.authorization.adminGroups} ["custom-admin-role-from-ldap-or-oidc-or-keycloak"]
      platformAdminGroups = ${stackstate.authorization.platformAdminGroups} ["custom-platform-admin-role-from-ldap-or-oidc-or-keycloak"]
      powerUserGroups = ${stackstate.authorization.powerUserGroups} ["custom-power-user-role-from-ldap-or-oidc-or-keycloak"]
      guestGroups = ${stackstate.authorization.guestGroups} ["custom-guest-role-from-ldap-or-oidc-or-keycloak"]
    }
  }
  ```

  Platform management and platform content management permissions have been separated into two groups - `platformAdminGroup` and `adminGroup`. Users in the group `platformAdminGroup` are limited to only platform management tasks, such as change database retention, clear database, clear caches and view logs. Users in the group `adminGroup` no longer have platform management permissions.

  **How you should proceed with upgrade**

  * **File based authentication:** Use the `platformadmin` username for platform management instead of `admin`. The `admin` user remains functional and has full content management rights as before.
  * **External authentication \(LDAP/OIDC/Keycloak\):** An additional role/group should be created in the external authentication system and mapped to the new StackState `platformAdmin` group.

    ```text
    stackstate:
      authentication:
        roles:
          ...
          platformAdmin: ["new-external-platform-admin-role"]
          ...
    ```

    Users who are assigned this group/role will get platform management permissions. If you wish for one user to manage both the content and the platform, you will still need to configure the external authentication provider with two separate roles/groups and then assign both of those to a single user in the settings of the external authentication system. You should not map the same external role/group to different StackState authorization groups.

  If you are still not sure what you need to do, contact [StackState support](https://support.stackstate.com/hc/en-us).
{% endtab %}

{% tab title="Linux" %}
#### v4.4.3

No manual action needed.

#### v4.4.1 - v4.4.2

* ⚠️ These releases are susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.4.3.

#### v4.4.0

* ⚠️ This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.4.3.
* Baselines have been disabled in v4.4. The `BaselineFunction` and `Baseline` objects are still available, but they do not serve any purpose other than smooth transition to the Autonomous Anomaly Detector \(AAD\) framework. If you have custom StackPacks that auto-create baselines, this is the last opportunity to remove baselines from templates and make transition to AAD. In release v4.5 baselines will be removed completely and templates using them will break.
* Transparent propagation has been renamed to **Auto propagation**. The behavior remains the same.
* Security improvement for Authentication and Authorization. There is a single configuration for groups to roles mappings and a single authentication provider used for both the Base API and Admin API. The default StackState roles are now always available, these could previously be overridden - `stackstate-admin`, `stackstate-power-user`, `stackstate-guest`. Additionally, a new default role `stackstate-platform-admin` has been introduced.

  ```text
  stackstate {
    authorization {
      adminGroups = ${stackstate.authorization.adminGroups} ["custom-admin-role-from-ldap-or-oidc-or-keycloak"]
      platformAdminGroups = ${stackstate.authorization.platformAdminGroups} ["custom-platform-admin-role-from-ldap-or-oidc-or-keycloak"]
      powerUserGroups = ${stackstate.authorization.powerUserGroups} ["custom-power-user-role-from-ldap-or-oidc-or-keycloak"]
      guestGroups = ${stackstate.authorization.guestGroups} ["custom-guest-role-from-ldap-or-oidc-or-keycloak"]
    }
  }
  ```

  Platform management and platform content management permissions have been separated into two groups - `platformAdminGroup` and `adminGroup`. Users in the group `platformAdminGroup` are limited to only platform management tasks, such as change database retention, clear database, clear caches and view logs. Users in the group `adminGroup` no longer have platform management permissions.

  **How you should proceed with upgrade?**

  This impacts you if you have a customized `authentication` section in the file `application_stackstate.conf`. If your `authentication` section has `adminGroups`, `powerUserGroups`, `guestGroups` definitions like in the example below:

  ```text
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

  The subject-role mappings must be moved to a centralized authorization configuration using the syntax `xxxGroups = ${stackstate.authorization.xxxGroups} ["custom-role"]` as shown in the example below.

  ```text
  stackstate {
    authorization {
      adminGroups = ${stackstate.authorization.adminGroups} ["your-custom-oidc-or-ldap-or-keycloak-admin-role"]
      platformAdminGroups = ${stackstate.authorization.platformAdminGroups} ["your-custom-oidc-or-ldap-or-keycloak-platform-admin-role"]
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

  The list of roles will be extended to include the new, custom roles. The default roles will remain available \(stackstate-admin, stackstate-platform-admin, stackstate-guest and stackstate-power-user\).

  **Provider Specific Instructions**

  * **File based authentication:** Use the `platformadmin` username for platform management instead of `admin`. The `admin` user remains functional and has full content management rights as before.
  * **External authentication \(LDAP/OIDC/Keycloak\):** An additional role/group should be created in the external authentication system and mapped to the new StackState `platformAdmin` group.

    ```text
    stackstate {
      authorization {
        ...
        platformAdminGroups = ${stackstate.authorization.platformAdminGroups} ["your-custom-oidc-or-ldap-or-keycloak-platform-admin-role"]
        ...
      }
      ...
    }
    ```

    Users who are assigned this group/role will get platform management permissions. If you wish for one user to manage both the content and the platform, you will still need to configure the external auth provider with two separate roles/groups and then assign both of those to a single user in the settings of the external auth provider. You should not map the same external role/group to different StackState authorization groups.

  If you are still not sure what you need to do, contact [StackState support](https://support.stackstate.com/hc/en-us).
{% endtab %}
{% endtabs %}

### Upgrade to v4.3.x

{% tabs %}
{% tab title="Kubernetes" %}
#### v4.3.6

No manual action needed.

#### v4.3.1 - v4.3.5

* ⚠️ These releases are susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.3.6.

#### v4.3.0

* ⚠️ This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.3.6.
* StackState is tested to run on Kubernetes v1.17, v1.18 and v1.19, or the equivalent OpenShift release \(version 4.4, 4.5 or 4.6\).
* CPU limits have been added to all pods. If you have customized any of the CPU requests in your `values.yaml`, you will most likely need to also set the CPU limit for the same pod\(s\).
* CPU limits and requests have been re-evaluated and increased where needed for stable operation resulting in a change in the number and size of [required nodes](/setup/install-stackstate/requirements.md#node-sizing).
* Two new [permissions](../../configure/security/rbac/rbac_permissions.md) have been added - `manage-event-handlers` and `execute-restricted-scripts`:
  * Guest users will no longer be able to create or edit event handlers.
  * Power Users will no longer be able to execute scripts using the HTTP script API.
  * Admin users will not be affected.
* Baselines have been deprecated and will be removed in v4.4. To reflect this, baseline functions and check functions that use baselines have been renamed. Templates that resolve these functions by name will stop working after upgrade to StackState 4.3. The function identifiers have not changed and can still be used to reference functions, however, it is advised that you migrate to using the [Autonomous Anomaly Detector](../../use/health-state/anomaly-health-checks.md).
* A Slack integration StackPack is now available that includes a new Slack event handler. Existing Slack event handlers will continue to run in StackState v4.3, however, the old Slack event handler has been deprecated and will be removed in a future release of StackState. To continue using Slack event notifications, it is advised to install the Slack StackPack and [configure view event handlers](/use/stackstate-ui/views/manage-event-handlers.md) to use the new Slack event handler in place of the old `Notify via slack for component health state change. (deprecated)` and `Notify via slack for view health state change.(deprecated)`.
* Dynatrace StackPack - The location of the Dynatrace check config file has moved. If you choose to upgrade to the version of the Dynatrace StackPack shipped with StackState v4.3, the Agent check configuration file should also be moved. The new location is `/etc/sts-agent/conf.d/dynatrace.d/conf.yaml` the previous location was `/etc/sts-agent/conf.d/dynatrace_topology.d/conf.yaml`.
{% endtab %}

{% tab title="Linux" %}
#### v4.3.6

No manual action needed.

#### v4.3.1 - v4.3.5

* ⚠️ These releases are susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.3.6.

#### v4.3.0

* ⚠️ This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.3.6.
* Two new [permissions](../../configure/security/rbac/rbac_permissions.md) have been added - `manage-event-handlers` and `execute-restricted-scripts`:
  * Guest users will no longer be able to create or edit event handlers.
  * Power Users will no longer be able to execute scripts using the HTTP script API.
  * Admin users will not be affected.
* Baselines have been deprecated and will be removed in v4.4. To reflect this, baseline functions and check functions that use baselines have been renamed. Templates that resolve these functions by name will stop working after upgrade to StackState 4.3. The function identifiers have not changed and can still be used to reference functions, however, it is advised that you migrate to using the [Autonomous Anomaly Detector](../../use/health-state/anomaly-health-checks.md).
* A Slack integration StackPack is now available that includes a new Slack event handler. Existing Slack event handlers will continue to run in StackState v4.3, however, the old Slack event handler has been deprecated and will be removed in a future release of StackState. To continue using Slack event notifications, it is advised to install the Slack StackPack and [configure view event handlers](/use/stackstate-ui/views/manage-event-handlers.md) to use the new Slack event handler in place of the old `Notify via slack for component health state change. (deprecated)` and `Notify via slack for view health state change.(deprecated)`.
* Dynatrace StackPack - The location of the Dynatrace check config file has moved. If you choose to upgrade to the version of the Dynatrace StackPack shipped with StackState v4.3, the Agent check configuration file should also be moved. The new location is `/etc/sts-agent/conf.d/dynatrace.d/conf.yaml` the previous location was `/etc/sts-agent/conf.d/dynatrace_topology.d/conf.yaml`.
{% endtab %}
{% endtabs %}

## Unsupported versions

The versions below have reached End of Life \(EOL\) and are no longer be supported.

### Upgrade to v4.2.x

{% tabs %}
{% tab title="Kubernetes" %}
#### v4.2.4

No manual action needed.

#### v4.2.3

Authentication configuration for the Kubernetes Helm chart has been made easier for this release. If your StackState authentication was customized, it will need to be updated. To verify this, check if there is a `stackstate.server.config` or `stackstate.api.config` value that contains an `authentication` section in the `values.yaml` file\(s\) used for installation.

Refer to the [Authentication configuration documentation](../../configure/security/authentication/) to configure the same settings directly in the `values.yaml` file. After that, the `authentication` section can be completely removed. If this results in an empty `config` value it can be removed as well.

#### v4.2.0

* [Node sizing requirements](/setup/install-stackstate/requirements.md#node-sizing) have been increased.
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

