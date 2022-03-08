---
description: >-
  Required manual steps for upgrade to each supported StackState version. Read
  this before you upgrade!
---

# Version specific upgrade instructions

{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

This page provides specific instructions for upgrading to each currently supported version of StackState. The instructions detail any significant changes that may impact how StackState runs after upgrade, such as a change in memory requirements or configuration.

{% hint style="warning" %}
**Review the instructions provided below before you upgrade!**
{% endhint %}

## Upgrade instructions

### Upgrade to v4.3.x

{% tabs %}
{% tab title="Kubernetes" %}
#### v4.3.5

No manual action needed.

#### v4.3.4

No manual action needed.

#### v4.3.3

No manual action needed.

#### v4.3.2

No manual action needed.

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
#### v4.3.5

No manual action needed.

#### v4.3.4

No manual action needed.

#### v4.3.3

No manual action needed.

#### v4.3.2

No manual action needed.

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

### Upgrade to v4.1.0

{% hint style="info" %}
Go to the [StackState v4.1 docs site](https://docs.stackstate.com/v/4.1/).
{% endhint %}

There are several changes to the `processmanager.conf` file that must be manually processed if you are using a customized version of this file:

* The `sts-healthcheckuri` has been moved from port 7071 to 7080
* The `startup-check` block has been removed completely

### Upgrade to v4.0.0

{% hint style="info" %}
Go to the [StackState v4.0 docs site](https://docs.stackstate.com/v/4.0/).
{% endhint %}

* With this version the minimal system requirements for the StackState node of the production setup raised from 16GB to 20GB
* The configuration `processmanager-properties.conf` was merged into `processmanager.conf` for both StackState and StackGraph. If you have changes to either one of those configuration files, you changes will need to be reapplied after upgrade.
* For trace processing StackState Agent needs an upgrade to version 2.5.0.
* This release deprecates the `withCauseOf` topology query filter, in favor of the \`Root

  Cause Analysis\` topology visualization setting. Stored views

  which require make use of the `withCauseOf` construct will need to be manually adapted.

  New versions of StackPacks already contain these changes, for custom views, the following

  script can be used in the StackState Analytics panel to list the views that need

  migrating.

  `Graph.query { it.V().hasLabel("QueryView").forceLoadBarrier().filter(__.has("query", TextP.containing('withCauseOf'))).properties("name").value() }`

* In this release a new way of scripting [propagation functions](https://docs.stackstate.com/v/4.0/configure/propagation#propagation-function) has been introduced so that the script APIs can be used. Propagation functions using the old script style will still work, but have been made read-only via the UI. Old style propagation functions can still be created via StackPacks, the CLI and API.

## See also

* [How to upgrade a StackPack](../../stackpacks/about-stackpacks.md#upgrade-a-stackpack)
* [Steps to upgrade StackState](steps-to-upgrade.md)
* [StackPack versions shipped with each StackState release](stackpack-versions.md)

