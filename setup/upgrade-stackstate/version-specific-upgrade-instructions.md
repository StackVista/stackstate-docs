---
description: StackState Self-hosted v5.1.x 
---

# Version specific upgrade instructions

## Overview

{% hint style="warning" %}
**Review the instructions provided on this page before you upgrade!**

This page provides specific instructions and details of any required manual steps to upgrade to each supported version of StackState. Any significant change that may impact how StackState runs after upgrade will be described here, such as a change in memory requirements or configuration.

**Read all instructions from the version that you are currently running up to the version that you will upgrade to.**
{% endhint %}

## Upgrade instructions

### Upgrade to v5.1.x

{% tabs %}
{% tab title="Kubernetes" %}

#### v5.1.0
* The node sizing requirements for deploying the StackState platform have changed slightly. Check the [requirements to deploy StackState on Kubernetes or OpenShift](/setup/install-stackstate/requirements.md#node-sizing).
* A new `stackstate/stackstate-agent` helm chart is available to deploy the StackState Agent, Checks Agent, Node Agent and kube_state_metrics on Kubernetes and OpenShift clusters. Some values have been renamed in the new chart.
  * The old `stackstate/cluster-agent` chart is being deprecated and will no longer be supported. 
  * If you were using the old `stackstate/cluster-agent` helm chart, you should [review and update your values.yaml file](/setup/agent/kubernetes-openshift.md#upgrade-helm-chart) before deploying with the new chart.
* All Splunk checks can now run on Agent V2. If you have any Splunk checks running on Agent V1 (legacy) (Splunk Metrics, Splunk Events or Splunk Topology V1), you should [upgrade to Agent V2 and migrate any checks configured to run on Agent V1 \(legacy\)](/setup/agent/migrate-agent-v1-to-v2/).Agent V1 (legacy) and will be deprecated in a future release of StackState.

{% endtab %}
{% tab title="Linux" %}

#### v5.1.0

* The required version of JDK has been updated - StackState now requires OpenJDK 11. This must be the only version of JDK present on the installation machine before upgrading StackState. If a mismatching JDK version is installed, or there are multiple versions installed, StackState will fail to start.
* All Splunk checks can now run on Agent V2. If you have any Splunk checks running on Agent V1 (legacy) (Splunk Metrics, Splunk Events or Splunk Topology V1), you should [upgrade to Agent V2 and migrate any checks configured to run on Agent V1 \(legacy\)](/setup/agent/migrate-agent-v1-to-v2/). Agent V1 (legacy) and will be deprecated in a future release of StackState.

{% endtab %}
{% endtabs %}

### Upgrade to v5.0.x

{% tabs %}
{% tab title="Kubernetes" %}

#### v5.0.2-v5.0.6

No manual action required.

#### v5.0.1

⚠️ Don't use. Please upgrade to StackState v5.0.2.

#### v5.0.0

* With the release of the new `sts` CLI, the CLI released with previous versions of StackState has been renamed to `stac`:
  * If you install the new `sts` CLI, you should [upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade).
  * The commands for the new `sts` CLI have changed. Check that any automation is using the correct CLI command (`sts` or `stac`). [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
* Version 5.0.0 of StackState includes a breaking change to the output of the [Telemetry Script API](/develop/reference/scripting/script-apis/telemetry.md). The output uses the new [StreamingScriptApi](/develop/reference/scripting/streaming-script-result.md) and the data format changed. Any script making use of that API needs to be adapted to deal with the new output format. 
* The versions of Kubernetes and OpenShift that are supported to run StackState have been updated - AKS and EKS 1.19 are no longer supported. Refer to the requirements documentation for details of all supported platforms: [requirements > supported versions](/setup/install-stackstate/requirements.md#supported-versions).
* StackPack updates:
  * [StackState Agent StackPack v4.5.2](/stackpacks/integrations/agent.md#release-notes)
  * [AWS v1.2.1](/stackpacks/integrations/aws/aws.md#release-notes)
  * [Dynatrace v1.4.2](/stackpacks/integrations/dynatrace.md#release-notes)
  * [Kubernetes v3.9.12](/stackpacks/integrations/kubernetes.md#release-notes)
  * [OpenShift v3.7.12](/stackpacks/integrations/openshift.md#release-notes)
  * [ServiceNow v5.3.3](/stackpacks/integrations/servicenow.md#release-notes)
  * [VMware vSphere v2.3.3](/stackpacks/integrations/vsphere.md#release-notes)

{% endtab %}
{% tab title="Linux" %}

#### v5.0.2-v5.0.6

No manual action required.

#### v5.0.1

⚠️ Don't use. Please upgrade to StackState v5.0.2.

#### v5.0.0

* With the release of the new `sts` CLI, the CLI released with previous versions of StackState has been renamed to `stac`:
  * If you install the new `sts` CLI, you should [upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade).
  * The commands for the new `sts` CLI have changed. Check that any automation is using the correct CLI command (`sts` or `stac`). [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
* This version of StackState includes a breaking change to the output of the [Telemetry Script API](/develop/reference/scripting/script-apis/telemetry.md). The output uses the new [StreamingScriptApi](/develop/reference/scripting/streaming-script-result.md) and the data format changed. Any script making use of that API needs to be adapted to deal with the new output format.
* StackPack updates:
  * [StackState Agent StackPack v4.5.2](/stackpacks/integrations/agent.md#release-notes)
  * [AWS v1.2.1](/stackpacks/integrations/aws/aws.md#release-notes)
  * [Dynatrace v1.4.2](/stackpacks/integrations/dynatrace.md#release-notes)
  * [Kubernetes v3.9.12](/stackpacks/integrations/kubernetes.md#release-notes)
  * [OpenShift v3.7.12](/stackpacks/integrations/openshift.md#release-notes)
  * [ServiceNow v5.3.3](/stackpacks/integrations/servicenow.md#release-notes)
  * [VMware vSphere v2.3.3](/stackpacks/integrations/vsphere.md#release-notes)

{% endtab %}
{% endtabs %}

### Upgrade to v4.6.x

{% tabs %}
{% tab title="Kubernetes" %}

#### v4.6.1

No manual action required.

#### v4.6.0

* Change in supported platforms:
  * Support for Kubernetes 1.18 was dropped.
  * Support for OpenShift 4.7 was dropped.
  * See the [requirements](/setup/install-stackstate/requirements.md) for an up-to-date list of supported platforms.

* StackPack updates:
  * [StackState Agent \(v4.5.0\)](../../stackpacks/integrations/agent.md):
    - Feature: Automatically add Open Telemetry HTTP health checks
      - Error count (sum) check
      - Request count (sum) check
      - Response Time (milliseconds) check
    - Feature: Add Container integration DataSource and Sync
    Note that the previous release of StackState (v4.5.x) shipped with StackState Agent StackPack v4.4.12. [Read release notes for all versions](../../stackpacks/integrations/agent.md#release-notes).
  * [AWS \(v1.2.0\)](../../stackpacks/integrations/aws/aws.md):
    - Improvement: Add OpenTelemetry information STAC-15902
  * [Kubernetes \(v3.9.9\)](../../stackpacks/integrations/kubernetes.md):
    - Improvement: Documentation for `agent.containerRuntime.customSocketPath` option.
  * [OpenShift \(v3.7.10\)](../../stackpacks/integrations/openshift.md):
    - Improvement: Documentation for `agent.containerRuntime.customSocketPath` option.

{% endtab %}
{% tab title="Linux" %}

#### v4.6.1

No manual action required.

#### v4.6.0

No manual action required.

StackPack updates:
* [StackState Agent \(v4.5.0\)](../../stackpacks/integrations/agent.md):
  - Feature: Automatically add Open Telemetry HTTP health checks
    - Error count (sum) check
    - Request count (sum) check
    - Response Time (milliseconds) check
  - Feature: Add Container integration DataSource and Sync
  Note that the previous release of StackState (v4.5.x) shipped with StackState Agent StackPack v4.4.12. [Read release notes for all versions](../../stackpacks/integrations/agent.md#release-notes).
* [AWS \(v1.2.0\)](../../stackpacks/integrations/aws/aws.md):
  - Improvement: Add OpenTelemetry information STAC-15902
* [Kubernetes \(v3.9.9\)](../../stackpacks/integrations/kubernetes.md):
  - Improvement: Documentation for `agent.containerRuntime.customSocketPath` option.
* [OpenShift \(v3.7.10\)](../../stackpacks/integrations/openshift.md):
  - Improvement: Documentation for `agent.containerRuntime.customSocketPath` option.

{% endtab %}
{% endtabs %}

## Unsupported versions

The versions below have reached End of Life \(EOL\) and are no longer be supported.

### Upgrade to v4.5.x (EOL)

{% tabs %}
{% tab title="Kubernetes" %}
#### v4.5.2 - v4.5.5

No manual action required.

#### v4.5.1

* Adds compatibility with StackState Agent v2.15.0. Read how to [upgrade StackState Agent](/setup/agent/about-stackstate-agent.md#deployment).

#### v4.5.0

* ⚠️ This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.5.1.
* ⚠️ StackState v4.5.0 isn't compatible with StackState Agent v2.15.0.
* Change in supported platforms:
  * Support for Kubernetes 1.17 was dropped.
  * Support for Amazon Elastic Kubernetes Service (EKS) 1.20 and 1.21 was added.
  * Support for Azure Kubernetes Service (AKS) 1.20 and 1.21 was added.
  * Support for OpenShift 4.4, 4.5 and 4.6 was dropped.
  * Support for OpenShift 4.7 and 4.8 was added.
  * See the [requirements](/setup/install-stackstate/requirements.md) for an up-to-date list of supported platforms.

{% endtab %}

{% tab title="Linux" %}
#### v4.5.3

No manual action required.

#### v4.5.2

No manual action required.

#### v4.5.1

* Adds compatibility with StackState Agent v2.15.0. Read how to [upgrade StackState Agent](/setup/agent/about-stackstate-agent.md#deployment).

#### v4.5.0

* ⚠️ This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.5.1.
* ⚠️ StackState v4.5.0 isn't compatible with StackState Agent v2.15.0.

{% endtab %}
{% endtabs %}

### Upgrade to v4.4.x (EOL)

{% tabs %}
{% tab title="Kubernetes" %}
#### v4.4.3

No manual action required.

#### v4.4.1 - v4.4.2

* ⚠️ These releases are susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.4.3.

#### v4.4.0

* ⚠️ This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.4.3.
* The CPU and memory [requirements to run StackState 4.4 on Kubernetes](/setup/install-stackstate/requirements.md#node-sizing) have been reassessed:
  * The requirements for the recommended highly available setup have grown \(from 5\) to 6 nodes with 32 GB of memory and 8 vCPUS.
  * The requirements for a minimal highly available setup have grown \(from 4\) to 5 nodes with 32 GB of memory and 8 vCPUS.
  * A [non-high availability setup](../install-stackstate/kubernetes_openshift/non_high_availability_setup.md) has been added, the requirements for which are 3 nodes with 32 GB of memory and 8 vCPUS.
* Baselines have been disabled in v4.4. The `BaselineFunction` and `Baseline` objects are still available, but they don't serve any purpose other than smooth transition to the Autonomous Anomaly Detector \(AAD\) framework. If you have custom StackPacks that auto-create baselines, this is the last opportunity to remove baselines from templates and make transition to the AAD. In release v4.5 baselines will be removed completely and templates using them will break.
* Transparent propagation has been renamed to **Auto propagation**. The behavior remains the same.
* The ElasticSearch Helm subchart `elasticsearch-exporter` has been renamed to `prometheus-elasticsearch-exporter`. This means that any configuration for that subchart needs to use the new subchart key `elasticsearch.prometheus-elasticsearch-exporter.*`
* The `passwordMd5` field in the [file based authentication](../../configure/security/authentication/file.md) has been renamed to `passwordHash` as it's now possible to use `bcrypt` type passwords.
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

No manual action required.

#### v4.4.1 - v4.4.2

* ⚠️ These releases are susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.4.3.

#### v4.4.0

* ⚠️ This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.4.3.
* Baselines have been disabled in v4.4. The `BaselineFunction` and `Baseline` objects are still available, but they don't serve any purpose other than smooth transition to the Autonomous Anomaly Detector \(AAD\) framework. If you have custom StackPacks that auto-create baselines, this is the last opportunity to remove baselines from templates and make transition to the AAD. In release v4.5 baselines will be removed completely and templates using them will break.
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

### Upgrade to v4.3.x (EOL)

{% tabs %}
{% tab title="Kubernetes" %}
#### v4.3.6

No manual action required.

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
  * Admin users won't be affected.
* Baselines have been deprecated and will be removed in v4.4. To reflect this, baseline functions and check functions that use baselines have been renamed. Templates that resolve these functions by name will stop working after upgrade to StackState 4.3. The function identifiers haven't changed and can still be used to reference functions, however, it's advised that you migrate to using the [Autonomous Anomaly Detector](../../use/checks-and-monitors/anomaly-health-checks.md).
* A Slack integration StackPack is now available that includes a new Slack event handler. Existing Slack event handlers will continue to run in StackState v4.3, however, the old Slack event handler has been deprecated and will be removed in a future release of StackState. To continue using Slack event notifications, it's advised to install the Slack StackPack and [configure view event handlers](/use/events/manage-event-handlers.md) to use the new Slack event handler in place of the old `Notify via slack for component health state change. (deprecated)` and `Notify via slack for view health state change.(deprecated)`.
* Dynatrace StackPack - The location of the Dynatrace check config file has moved. If you choose to upgrade to the version of the Dynatrace StackPack shipped with StackState v4.3, the Agent check configuration file should also be moved. The new location is `/etc/sts-agent/conf.d/dynatrace.d/conf.yaml` the previous location was `/etc/sts-agent/conf.d/dynatrace_topology.d/conf.yaml`.
{% endtab %}

{% tab title="Linux" %}
#### v4.3.6

No manual action required.

#### v4.3.1 - v4.3.5

* ⚠️ These releases are susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.3.6.

#### v4.3.0

* ⚠️ This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. Resolved in version v4.3.6.
* Two new [permissions](../../configure/security/rbac/rbac_permissions.md) have been added - `manage-event-handlers` and `execute-restricted-scripts`:
  * Guest users will no longer be able to create or edit event handlers.
  * Power Users will no longer be able to execute scripts using the HTTP script API.
  * Admin users won't be affected.
* Baselines have been deprecated and will be removed in v4.4. To reflect this, baseline functions and check functions that use baselines have been renamed. Templates that resolve these functions by name will stop working after upgrade to StackState 4.3. The function identifiers haven't changed and can still be used to reference functions, however, it's advised that you migrate to using the [Autonomous Anomaly Detector](../../use/checks-and-monitors/anomaly-health-checks.md).
* A Slack integration StackPack is now available that includes a new Slack event handler. Existing Slack event handlers will continue to run in StackState v4.3, however, the old Slack event handler has been deprecated and will be removed in a future release of StackState. To continue using Slack event notifications, it's advised to install the Slack StackPack and [configure view event handlers](/use/events/manage-event-handlers.md) to use the new Slack event handler in place of the old `Notify via slack for component health state change. (deprecated)` and `Notify via slack for view health state change.(deprecated)`.
* Dynatrace StackPack - The location of the Dynatrace check config file has moved. If you choose to upgrade to the version of the Dynatrace StackPack shipped with StackState v4.3, the Agent check configuration file should also be moved. The new location is `/etc/sts-agent/conf.d/dynatrace.d/conf.yaml` the previous location was `/etc/sts-agent/conf.d/dynatrace_topology.d/conf.yaml`.
{% endtab %}
{% endtabs %}

### Upgrade to v4.2.x (EOL)

{% tabs %}
{% tab title="Kubernetes" %}
#### v4.2.4

No manual action required.

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

No manual action required.

#### v4.2.3

No manual action required.

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

