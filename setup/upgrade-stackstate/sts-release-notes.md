---
description: StackState Self-hosted v5.0.x
---

# StackState release notes

## Overview

This page includes release notes for the StackState self-hosted product. 

* For StackPack release notes, see the page [StackPack versions](stackpack-versions.md).
* For StackState Agent release notes, see [StackState Agent on GitHub \(github.com\)](https://github.com/StackVista/stackstate-agent/blob/master/stackstate-changelog.md).

## StackState v5.0.x

Before you upgrade, [check the version specific upgrade instructions](/setup/upgrade-stackstate/version-specific-upgrade-instructions.md).

### v5.0.0

**Features**

**Improvements**

**Bug fixes**

**StackPack upgrades**


## StackState v4.6.x

Before you upgrade, [check the version specific upgrade instructions](/setup/upgrade-stackstate/version-specific-upgrade-instructions.md).

### v4.6.1

**Bug fixes**

- Fixed issue that incorrectly showed an error message when displaying a log stream. STAC-16222
- If the OIDC configuration is wrongly configured to obtain a username, the logging will show all fields that can be selected to obtain the username from. STAC-16027
- Security fixes for CVE-2022-24407. STAC-15939

### v4.6.0

The StackState v4.6 release brings powerful new capabilities:

* Important improvements in topology visualization to accelerate troubleshooting.
* Support for OpenTelemetry traces, specifically for serverless AWS Lambda applications built with Node.js. This new low-latency data requires no integration, and will immediately enrich your topology with additional relationships and telemetry.
* Expanded Autonomous Anomaly Detection capabilities to automatically analyze the golden signals of throughput, latency and error rate. Automatic health checks can then run on this data and alert you as soon as anomalies are found. This will help you to get to the root cause of incidents more quickly and proactively prevent problems before they occur.

Details of the included improvements, bug fixes and StackPack updates can be found below.

**Improvements**

- Topology synchronization progress counters have been moved from individual synchronizations to the `stackstate.log` file for Linux-based distributions. Errors for topology mapping and templates remain in the synchronization-specific logs. STAC-15529
- The MinIO chart now allows the registry to be configured separately from the repository. Also, the chart will now use any [globally configured pull secrets](/setup/install-stackstate/kubernetes_install/image_configuration.md) to fetch Docker images. STAC-15180
- The component context menu now displays the preview of the [three top priority metrics](/use/metrics-and-events/top-metrics.md). STAC-15076
- `PodDisruptionBudget` and `PodSecurityPolicy` now use the updated apiVersion (policy/v1) for newer Kubernetes versions. STAC-14968
- The MinIO Helm chart has been updated to specify both a requests and limits for the memory resource. STAC-14771
- All PodDisruptionBudget(s) can be configured through the Helm Values. STAC-14770
- In the StackState Helm chart, the Ingress path can now be configured through the value `ingress.path`. STAC-14769
- All pods in the StackState Helm charts can now be configured to use a pullSecret to pull protected images. STAC-14767
- Non-propagating unhealthy components are marked as problem root causes. STAC-13618

**Bug fixes**

- Increased performance of network connections correlation by better data scheduling and by adjusting CPU limits in the Helm chart (default from 0.6 to 2). STAC-15822
- Fixed an issue that caused custom Kafka producer configuration to be disregarded by the correlator and receiver. STAC-15795
- Clears the following CVEs STAC-15733:
  - CVE-2022-23852 
  - CVE-2022-23990. 
- The limit of problems visible in the StackState UI has been increased to 999. STAC-15688
- Remediation for CVE-2022-23307 by removing Log4J dependencies from StackGraph. STAC-15655
- Fixed an issue that caused several pods to be stuck in Pending mode after an API key update. STAC-15525
- Fixed bug when major part of Kubernetes topology is missing when a big element is reported (such as big ConfigMap). STAC-15458
- Fixed receiver out of memory issue appearing under load preventing processes from appearing on topology. STAC-15431
- Fixed an issue that caused the StackState UI to crash occasionally due to a misconfiguration of the Prometheus nginx exporter. STAC-15167
- Fixed an issue that caused component properties to not display correctly when a component is merged from two of the same synchronization sources. STAC-15147
- Fixed an issue that caused StackState to stop receiving health synchronization data after Kafka has rebalanced partitions to consumers. STAC-14676
- Fixed an issue that caused the anomaly event chart to not display full metric data. STAC-14630
- The `backup-stackgraph` Kubernetes CronJob now correctly checks whether the StackGraph export exists before copying it. STAC-14532
- Fixed error on the Traces Perspective stemming from server and browser clocks not being synchronized. STAC-12832

**StackPack updates**

* [StackState Agent \(v4.5.0\)](../../stackpacks/integrations/agent.md):
  - Feature: Automatically add Open Telemetry HTTP health checks
    - Error count (sum) check
    - Request count (sum) check
    - Response Time (milliseconds) check
  - Feature: Add Container integration DataSource and Sync
  - Note that the previous release of StackState (v4.5.x) shipped with StackState Agent StackPack v4.4.12. [Read release notes for all versions](../../stackpacks/integrations/agent.md#release-notes).

* [AWS \(v1.2.0\)](../../stackpacks/integrations/aws/aws.md):
  - Improvement: Add OpenTelemetry information STAC-15902

* [Kubernetes \(v3.9.9\)](../../stackpacks/integrations/kubernetes.md):
  - Improvement: Documentation for `agent.containerRuntime.customSocketPath` option.

* [OpenShift \(v3.7.10\)](../../stackpacks/integrations/openshift.md):
  - Improvement: Documentation for `agent.containerRuntime.customSocketPath` option.

## StackState v4.5.x

Before you upgrade, [check the version specific upgrade instructions](/setup/upgrade-stackstate/version-specific-upgrade-instructions.md).

### v4.5.5

**Bug fixes**

- Clears the following CVEs:
  - CVE-2022-23852 
  - CVE-2022-23990. STAC-15733
- Fixed timeline health state not showing up properly on views with trailing whitespace in the query. STAC-15662
- Fixed issue that incorrectly calculates Problem Clusters in certain circumstances. STAC-15657
- Remediation for CVE-2022-23307 by removing Log4J dependencies from StackGraph. STAC-15655
- Fixed issue that caused several pods to be stuck in Pending mode after an API key update. STAC-15525

### v4.5.4

**Improvements**

- Internal Playground optimization. STAC-15393

### v4.5.3

**Bug fixes**

- Fixed issue that caused AAD to fail to authenticate with StackState. STAC-15278

### v4.5.2

**Improvements**

- Added configuration options to Azure StackPack that allow specification of the Azure function name and the StackPack instance URL. STAC-14694

**Bug fixes**

- Fixed issue that caused a redirect to the Views Dashboard page when clicking on a component in a view that contains a slash in the identifier. STAC-15443
- Added missing documentation in Slack StackPack. STAC-15103
- Fixed issue that caused transaction logs to consume excessive storage space on Kubernetes. STAC-13922

### v4.5.1

**Improvements**

- Adds compatibility with StackState Agent v2.15.0. Read how to [upgrade StackState Agent](/setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2).
- The MinIO chart has been internalized to StackState to ensure its continuity. STAC-14977
- The MinIO Helm chart has been updated to specify both a requests and limits for the memory resource. STAC-14771

**Bug fixes**

- Removed vulnerable JNDI lookup feature from log4j2 library (CVE-2021-44228 and CVE-2021-45046). STAC-15200
- Fixed issue that caused the stackstate-ui to crash occasionally due to a misconfiguration of the Prometheus nginx exporter. STAC-15167
- Set sync counters back to 0 after a sync reset operation. STAC-15088
- Fixed issue that caused incorrect metric data to create spurious indices in ElasticSearch. STAC-14978
- Fixed issue that caused Kubernetes synchronization to fail when processing specific data. STAC-14811
- Resolved several vulnerabilities in `stackstate-ailab` docker image. STAC-14760
- Fixed issue that caused long anomalies to be reported with severity HIGH instead of MEDIUM. STAC-14756
- Fixed issue that caused StackState to stop receiving health synchronization data after Kafka has rebalanced partitions to consumers. STAC-14676

### v4.5.0

{% hint style="warning" %}
This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. [Resolved in version v4.5.1](#v4.5.1).
{% endhint %}

**Features**

- The ability to create manual topology from the StackState UI has been removed. Please use the Static Topology StackPack in order to [create components manually](/configure/topology/how_to_create_manual_topology.md). STAC-14377
- Improved feedback from the topology synchronization service by exposing synchronization metrics via the CLI. STAC-13318
- Improved root cause analysis using subviews: modify your view to include additional components, show indirect relations and paths, [show grouped relations](/use/concepts/relations.md), save changed views even when timetravelling. STAC-13142
- Start anomaly detection on new streams after two hours.  Adapt to changing streams in real-time. STAC-12996

**Improvements**

- Time travel directly to the start of a problem from the View and Problem details pane. STAC-14746
- AWS CloudWatch metrics can now be retrieved via an HTTPS proxy. STAC-14608
- The HBase minReplicationFactor is now automatically adjusted if it's higher than the replicaCount of the datanodes. STAC-14551
- Improve performance of view health state calculations under load. STAC-14056
- Support extra [custom request parameters for OIDC](/configure/security/authentication/oidc.md#configure-stackstate-for-oidc). STAC-13999
- Link directly to possible root causes from Slack problem notifications. STAC-13802
- Check state changes always invoke auto propagation even if a CRITICAL state has been propagated before. STAC-13656
- Highlight exact changes when displaying Version Change, Health State Change or Run State Change events. STAC-13117
- Retain timeline settings when switching views. STAC-12745
- Component drag&drop functionality has been removed from the topology visualizer. Please use the Static Topology StackPack in order to [create components manually](/configure/topology/how_to_create_manual_topology.md). STAC-12718
- Support [querying for problems in the Script API](/develop/reference/scripting/script-apis/view.md). STAC-12506
- Support [problem notifications](/use/problem-analysis/problem_notifications.md) to Slack. STAC-12496
- Prevent StackPacks requiring an incompatible version of StackState from being installed. STAC-9311
- Retain Topology visualizer zoom level and panning when switching perspectives or changing the time range. STAC-14389
- The time jumpers now jump to the next and previous timestamp at which interesting events took place. STAC-12781

**Bug fixes**

- Fixed issue that prevented increase of the CloudWatch integration connection pool. STAC-14607
- Fixed issue that caused problems to incorrectly merge or resolve under certain circumstances. STAC-14411
- Fixed issue that caused a loop when logging in with OIDC when 'stackstate.baseUrl' contained a trailing '/'. STAC-13964
- Fixed issue that caused corrupt data in StackGraph under certain circumstances. STAC-13860
- Fixed issue that caused the health synchronization to occasionally keep restarting. STAC-13829
- Security improvement for handling credentials on the StackPack pages. STAC-13658
- Fixed issue that caused incorrect service metric aggregation under certain circumstances. STAC-13591
- Fixed issue that caused the process manager logs to be truncated. STAC-12875


## Unsupported versions

The versions below have reached End of Life \(EOL\) and are no longer be supported.

{% hint style="warning" %}
These releases are susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046.
{% endhint %}

### StackState v4.4.x (EOL)

#### v4.4.3 (EOL)

**Bug fixes**

- The StackState Helm chart now depends on an internalised version of the MinIO Helm chart. STAC-15194
- Removed vulnerable JNDI lookup feature from log4j2 library (CVE-2021-44228). STAC-15179

#### v4.4.2 (EOL)

{% hint style="warning" %}
This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. [Resolved in version v4.4.3](#v4.4.3).
{% endhint %}

**Improvements**

- Support extra custom request parameters for OIDC. STAC-13999
- Security improvement for handling credentials on the StackPack pages. STAC-13658

**Bug fixes**

- Fixed issue that caused the AWS CloudWatch plugin to fail to assume the correct IAM role under certain circumstances. STAC-14252
- Fix the issue that caused the AWS StackPack installation to fail to verify the passed in AWS credentials on the StackState Kubernetes installation. STAC-14014
- Fixed issue that caused a loop when logging in with OIDC when 'stackstate.baseUrl' contained a trailing '/'. STAC-13964
- Fixed issue that caused backup functionality to fail on OpenShift. STAC-13772

#### v4.4.1 (EOL)

{% hint style="warning" %}
This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. [Ressolved in version v4.4.3](#v4.4.3).
{% endhint %}

**Improvements**

- Added tolerations and affinity configuration to the anomaly-detector Helm Chart. STAC-13824
- Added tolerations, nodeSelector and affinity configuration to the kafkaTopicCreate job in the StackState Helm Chart. STAC-13822

**Bug fixes**

- Fixed issue that caused corrupt data in StackGraph under certain circumstances. STAC-13860
- Fixed issue that caused the health synchronization to occasionally keep restarting. STAC-13829
- Fixed issue that occasionally caused auto propagation to enter a loop and fail to terminate. STAC-13725

#### v4.4.0 (EOL)

{% hint style="warning" %}
This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. [Resolved in version v4.4.3](#v4.4.3).
{% endhint %}

**Features**

* Integrate network monitoring information from [SolarWinds](../../stackpacks/integrations/solarwinds.md). STAC-13360
* Signficantly [improved Topology navigation](../../use/stackstate-ui/perspectives/topology-perspective.md): 
  * Improved component popover with direct links to contextual actions. STAC-12909
  * Double clicking on a topology element \(group, component or relation\) "zooms into" that element in the Topology Perspective
  * Use the Plus button to expand a view with connected components, link from a trace span to the service. STAC-13359
* Improved propagation functions to reduce noise. Alpha release. Not enabled by default. STAC-13107
* Simplified installation and configuration of [AWS integration](../../stackpacks/integrations/aws/aws.md) including coverage of Step Functions and VPC FlowLog. STAC-12395
* Support fast and low-overhead direct [synchronization of health states from external \(monitoring\) tools](../../configure/health/health-synchronization.md). STAC-11290

**Improvements**

* The API-Integration StackPack has been removed. STAC-13346
* [Support BCrypt](../../configure/security/authentication/file.md) next to md5 for file based passwords. STAC-13246
* Configuration of authorization for various StackState APIs can now be [defined in one central location](version-specific-upgrade-instructions.md#upgrade-to-v44x). STAC-12968
* Completed removal of deprecated baseline functions. Baseline functions should be removed from all templates. [See upgrade documentation for more details](version-specific-upgrade-instructions.md#upgrade-to-v-4-4-x). STAC-12602
* The HDFS OpenShift SecurityContextConfiguration is not necessary and has been removed from the documentation. STAC-12573
* [Timeline improvements](../../use/stackstate-ui/timeline-time-travel.md):
  * It is now possible to zoom out of a time range. STAC-12533
  * Added support for navigating to the next and previous time range. STAC-12531
* Indirect relations for "Show root cause only" are now always shown when there is at least one invisible dependency that leads to the root cause. In previous versions of StackState an indirect relation for a root cause was only shown if there was no visible path to the root cause. STAC-11621
* [Relations to component groups are shown as solid lines](/use/concepts/relations.md). In StackState v4.3 a grouped relation was displayed as a dashed line when the group of relations was not complete in the sense that each component in the group received that relation \(this is also called surjective\). STAC-11621
* Improve how component names are displayed in the Topology Perspective. STAC-13063
* The component finder modal can now be invoked using the [keyboard shortcut](../../use/stackstate-ui/keyboard-shortcuts.md) `CTRL`+`SHIFT`+`F`. STAC-12957

**Bug fixes**

* Fixed issue that caused an import via the CLI to fail. STAC-13481
* The deprecated elasticsearch-exporter Helm chart has been replaced with the prometheus-elasticsearch-exporter Helm chart in order to make it OpenShift compatible. STAC-13473
* Fixed issue that prevented Keycloak authentication from working after expiry of a refresh token. STAC-13268
* Fixed issue that prevented certain views from opening from the View Overview page. STAC-13244
* Fixed crash when accessing the logs API. STAC-13149
* Backup PVC is created on installation of StackState chart to prevent Helm hanging. STAC-12696

### StackState v4.3.x (EOL)

#### v4.3.6 (EOL)

**Bug fixes**

- The StackState Helm chart now depends on an internalised version of the MinIO Helm chart. STAC-15193
- Removed vulnerable JNDI lookup feature from log4j2 library (CVE-2021-44228). STAC-15179

#### v4.3.5 (EOL)

{% hint style="warning" %}
This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. [Resolved in version v4.3.6](#v4.3.6).
{% endhint %}

**Improvements**

- Added tolerations and affinity configuration to the anomaly-detector Helm Chart. STAC-13824
- Added tolerations, nodeSelector and affinity configuration to the kafkaTopicCreate job in the StackState Helm Chart. STAC-13822

**Bug fixes**

- Fixed issue that caused corrupt data in StackGraph under certain circumstances. STAC-13860

#### v4.3.4 (EOL)

{% hint style="warning" %}
This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. [Resolved in version v4.3.6](#v4.3.6).
{% endhint %}

**Bug fixes**

* Fixed issue that prevented Keycloak authentication from working after expiry of a refresh token. STAC-13268

#### v4.3.3 (EOL)

{% hint style="warning" %}
This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. [Resolved in version v4.3.6](#v4.3.6).
{% endhint %}

**Bug fixes**

* Fixed issue that prevented certain views from opening from the View Overview page. STAC-13244

#### v4.3.2 (EOL)

{% hint style="warning" %}
This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. [Resolved in version v4.3.6](#v4.3.6).
{% endhint %}

**Bug fixes**

* Fix crash when accessing the logs api. STAC-13149

#### v4.3.1 (EOL)

{% hint style="warning" %}
This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. [Resolved in version v4.3.6](#v4.3.6).
{% endhint %}

**Improvements**

* The CLI will now issue a deprecation warning when not using the new API token based authentication. For details, see the [CLI authentication docs](/setup/cli-install.md#authentication). STAC-12567
* Any change to a check will update the check state data and fire a change event. STAC-12472

**Bug fixes**

* Fixed issue that caused the Autonomous Anomaly Detector to fail to authenticate with StackState. STAC-12742
* Fixed issue that caused the browser to free when selecting a large group of components. STAC-12016

#### v4.3.0 (EOL)

{% hint style="warning" %}
This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. [Resolved in version v4.3.6](#v4.3.6).
{% endhint %}

**Features**

* [Show configuration changes](../../use/problem-analysis/problem_investigation.md#element-properties-changed-events) for faster root cause analysis. STAC-12441
* [Alert on anomalies](../../use/checks-and-monitors/anomaly-health-checks.md) detected by the Autonomous Anomaly Detector. STAC-11798
* [Drill down on Problems](../../use/problem-analysis/about-problems.md) for faster investigation. STAC-10481

**Improvements**

* Introduced [check functions that alert on anomalies](../../use/checks-and-monitors/anomaly-health-checks.md) detected by the Autonomous Anomaly Detector. Previous anomaly detection functions and baseline streams and functions are deprecated and will be removed in StackState v4.4. STAC-12256
* The [Autonomous Anomaly Detector \(AAD\)](../../stackpacks/add-ons/aad.md) is now enabled by default in the Kubernetes distribution. STAC-12024
* It is now possible to [configure whether ClusterRoles and ClusterRoleBindings need to be installed](../install-stackstate/kubernetes_install/required_permissions.md#disable-automatic-creation-of-cluster-wide-resources) by the StackState Helm chart using the flag `cluster-role.enabled`. STAC-11749
* StackState HDFS pods now run without privileges in Kubernetes. STAC-11741
* Added support for interacting with external systems using [self-signed certificates](../../configure/security/self-signed-cert.md). STAC-11738
* The field specifying the [role to use for Keycloak authentication](../../configure/security/authentication/keycloak.md) \(default field name: `roles`\) is now configurable using the `groupsField` configuration parameter. STAC-11609
* StackState now supports [API tokens for authentication of the StackState CLI](../cli-install.md#authentication). This allows the StackState CLI to work with Keycloak or OIDC as an authentication provider. STAC-11608
* The CLI will now issue a deprecation warning when not using the new API token based authentication. STAC-12567
* Added support for [backup and restore procedure for self-hosted Kubernetes](../data-management/backup_restore/kubernetes_backup.md) setup. STAC-11548
* It is now possible to use component actions when time-traveling. STAC-11462
* Introduced auto-grouping to automatically choose the correct grouping level for views. STAC-11396
* Authentication settings are now directly configurable on the Helm chart. STAC-11237
* Added permission `manage-event-handlers` to [protect creation of event handlers](../../configure/security/rbac/rbac_permissions.md#view-management). STAC-11172
* Allow [filtering Events](../../use/stackstate-ui/filters.md#filter-events) by source. STAC-10644
* Allow [filtering Events](../../use/stackstate-ui/filters.md#filter-events) by category. STAC-10643
* Events of type Anomaly now display a [metric chart including the anomaly](../../use/problem-analysis/problem_investigation.md#anomaly-check-functions) in the Event Details pane. STAC-10031
* Added permission `execute-restricted-scripts` to [protect usage of `Http` and `Graph` script APIs](../../configure/security/rbac/rbac_permissions.md#analytics-environment) in Analytics. STAC-9834
* Added ability to filter on labels in the Component Details pane. STAC-11824
* Added ability to search and filter components in the Topology perspective List mode. STAC-11413
* Added ability to [export component list as a CSV file](../../use/stackstate-ui/perspectives/topology-perspective.md#export-as-csv) in the Topology perspective List mode. STAC-3593
* Added ability to search telemetry streams on the Component Details pane. STAC-3194

**Bug fixes**

* Fixed issue that prevented view event handlers from being updated. STAC-12296
* Fixed issue that prevented proxy settings from being picked up in asynchronous event handlers. STAC-12097
* Fixed memory consumption issue in slicer pod that caused intermittent out of memory errors. Any custom memory settings for the slicer pod can be removed. STAC-11841
* Fixed issue that caused the Slack event handler to fail when sending a notification of a view health state change event. STAC-11831
* Fixed issue that caused the StackState helm chart to fail with custom image registries. STAC-11717
* Fixed issue that prevented copy\_images.sh script from working with containers without a docker.io prefix. STAC-11697
* Fixed issue that caused the old and new state to disappear for certain health state changes in the Event Perspective. STAC-11691
* Fixed issue that prevented exports produced by the CLI on Windows from being imported. STAC-11096
* Fixed issue that caused incorrect anomalies to be detected on CloudWatch metrics by introducing two new aggregation methods: COUNT\_NO\_ZEROS and SUM\_NO\_ZEROS. Aggregation methods COUNT and SUM keep the existing behavior of filling gaps in metrics with zeroes, with a configurable delay. STAC-11079

### StackState v4.2.x (EOL)

#### v4.2.4 (EOL)

**Improvements**

* It is now possible to configure whether ClusterRoles and ClusterRoleBindings need to be installed by the Helm chart using the `cluster-role.enabled` flag. STAC-11749
* Added support for interacting with external systems using self-signed certificates. STAC-11738
* Added documentation and support for backup and restore for self-hosted Kubernetes setup. STAC-11548

**Bugfixes**

* Fix issue blocking the sync service and not letting process topology any more. STAC-12116
* Fixed problem where LDAP users with a special character in their DN could not be authorized. STAC-12059
* Fixed issue that caused filtering on a domain containing an ampersand to redirect to the Views page. STAC-11797

#### v4.2.3 (EOL)

**Improvements**

* StackState's HDFS pods now run without privileges in Kubernetes. STAC-11741
* Adding an additional role field for Keycloak authentication. STAC-11609
* StackState now supports API tokens for authentication of the StackState CLI, making it possible to use the CLI with Keycloak or OIDC as authentication provider. STAC-11608
* Authentication settings are now directly configurable on the helm chart. STAC-11237

**Bug fixes**

* Fixed issue that prevented traces from being ingested into StackState. STAC-11733
* Fixed issue that caused the StackState helm chart to fail with custom image registries. STAC-11717
* Fixed issue that prevented `copy_images.sh` script from working with containers without a docker.io prefix. STAC-11697
* Fixed issue that caused the old and new state to disappear for certain health state changes in the Event Perspective. STAC-11691

#### v4.2.2 (EOL)

**Bug fixes**

* Fix for StackState helm chart to include correct version of the AAD sub chart. STAC-11654

#### v4.2.1 (EOL)

**Improvements**

* Add support for running StackState on an OpenShift Kubernetes cluster. STAC-11549

**Bug fixes**

* Fixed issue that prevents StackState distributed Kubernetes installation from starting when the database initialisation process fails due to a pod restart. STAC-11618

#### v4.2.0 (EOL)

**Features**

* Display external events in the Events Perspective. Improve Event Detail panel and event filtering. STAC-10638
* Alert on Problem Clusters in Slack. STAC-10567
* Ingest events from external systems related to topology in StackState. STAC-8183

**Improvements**

* Support OpenID Connect \(OIDC\) authentication provider. STAC-10083

**Bug fixes**

* Fixed issue where duplicate negative IDs in a component template leads to `lastUpdateTimstampField` missing. STAC-11495
* Fix issue where kafkaToES would not log when it is dropping data. STAC-11434
* Fixed issue where kafkaToES would not adhere to the index size boundaries when historic data is stored. STAC-11433
* Upload of a new StackPack now returns more details on why an uploaded StackPack is not valid. STAC-11094
* Fixed issue that caused a baseline stream to disappear if the associated stream's filter was changed. STAC-10872
* Fixed issue that caused incoming telemetry data to be rejected due to incorrect interpretation of telemetry data end timestamp. STAC-10777
* Fixed bug where a non-existing datasource in a synchronization template would cause the synchronization to stop processing. STAC-10774
* Fixed issue that disregarded filters when populating the selection field name dropdown. STAC-10759
* Fixed issue that caused checks to ignore a change to a streams filter under certain circumstances. STAC-10733
* Fixed issue that caused an error when StackState attempted to connect to an LDAP server using LDAPS on certain versions of the JVM. STAC-10606
* Fixed issue that made it impossible to save changes to functions in the Settings screen. STAC-10180
* Next to the admin and guest roles StackState now has a standard power user role. It has the same permissions as an admin user except it is not allowed to grant permissions or to upload stackpacks. STAC-10170
* UPGRADE NOTE: It is strongly advised to review the roles your users have and limit the number of admin users. Users that need to configure StackState can be given the role of power user instead. STAC-10170
* Fixed issue that caused a security exception to occur when using a groovy regex in the Analytics environment. STAC-9947
* Fixed issue that caused an error when showing the Component Details pane for a component or relation originating from a removed synchronization. STAC-8165

### StackState v4.1.x (EOL)

{% hint style="info" %}
With the release of StackState v4.4, StackState v4.1 reached End of Life \(EOL\) and is no longer supported.
{% endhint %}

#### v4.1.3 (EOL)

**Bug fixes**

* Fixed issue that caused the CLI to fail to run on systems with an older GLIBC library. STAC-10609
* Fixed issue that prevented historical data from displaying in the Health Forecast Report. STAC-11207

#### v4.1.2 (EOL)

**Bug fixes**

* Fixed issue that caused event handlers to produce a security error on specific OpenJDK 8 versions. STAC-10893
* Fixed issue that prevented Slack event handler from working in certain circumstances. STAC-10797
* Fixed issue that caused opening of certain Azure telemetry streams to show an error in the GUI. STAC-10778

**Improvements**

* Introduced configuration setting `stackstate.topologyQueryService.maxLoadedElementsPerQuery` configuration to tweak the amount of loaded elements we allow during query execution. STAC-11009

#### v4.1.1 (EOL)

**Bug fixes**

* Fixed issue that prevented users from deleting certain metric streams. STAC-10623
* Fixed issue that caused an error when StackState attempted to connect to an LDAP server using LDAPS on certain versions of the JVM. STAC-10606

#### v4.1.0 (EOL)

**Features**

* Introduced Traces Perspective to identify root causes of down-time and performance issues. STAC-7646
* Introduced the Autonomous Anomaly Detector \(AAD\) \[beta\] that identifies anomalies in metric streams with zero configuration. STAC-7403
* Introduced the ability to deploy StackState on the OpenShift, AKS and EKS Kubernetes platforms. STAC-7328

**Improvements**

* Improved navigation in the StackState UI. STAC-9448
* Added support for Splunk token-based authentication for Splunk versions 7.3 and later. STAC-9032
* Added ability to star views for easy access. STAC-8805
* StackState shows a warning when a license key is about to expire or an error when it is invalid or has expired. This includes the option to update the license key from that screen directly. STAC-7453
* StackState CLI is now shipped as a standalone binary for Linux and Windows. STAC-5614

**Bug fixes**

* Added eager short circuit while loading elements on a query. STAC-10354
* Fixed issue that prevented suggestions from showing up when filtering the component type list. STAC-9822
* Fixed issue that prevented synchronization statistics from being displayed on the Synchronization settings page. STAC-9815
* Fixed issue with Kubernetes deployment that redirects users to the webuiconfig instead of StackState application. STAC-9811
* Fixed issue where check updating would retry indefinitely when an element is already gone. STAC-9323
* Fixed issue that redirected users to a stream URL instead of the StackState application. STAC-9186
* Fixed issue where component version information was not properly merged during synchronization. STAC-8624
* Fixed issue where state service could not find some elements due to querying with an incomplete time slice. STAC-8195
* Propagation function will be re evaluated for all related components when the body of the function changes. STAC-4114

### StackState v4.0.x (EOL)

{% hint style="info" %}
StackState v4.0 is End of Life \(EOL\) and is no longer supported.
{% endhint %}

#### v4.0.4 (EOL)

**Bug fixes**

* Fix issue where the readcache sometimes produces the wrong data, causing intermittent failures in state and view calculation. STAC-10328

#### v4.0.3 (EOL)

**Bug fixes**

* Fixed issue that prevented time travel under certain circumstances. STAC-9551

#### v4.0.2 (EOL)

**Bug fixes**

* Support Splunk token-based authentication for Splunk versions 7.3 and later. STAC-9032
* Fixed bug that prevented the health check metric chart from opening. STAC-9251
* Fixed bug that caused multi param propagation function values to be lost after a component update. STAC-9582
* Fixed bug that caused the log to be spammed with messages for a deleted checkstate. STAC-9323

#### v4.0.1 (EOL)

**Bug fixes**

* Fix transaction boundaries while running legacy propagation function. STAC-9161
* Fix some cases when checks on new or updated components would fail to start and remain in an "Unknown" state. STAC-7949
* Fix an issue that in some cases prevented properly storing security subjects from CLI. STAC-7569

#### v4.0.0 (EOL)

**Features**

* Metrics Perspective to see all Telemetry streams for a set of components. This first release is limited to 5 components at a time. In later releases this will be improved with a larger set of components which will be supported.

**Improvements**

* Ability to find components in the topology perspective. STAC-7764
* Performance enhancements for views

**Bug fixes**

* This release deprecates the `withCauseOf` stql construct. STAC-7884.
* The groovy sandboxing has been improved to cover a number of edge cases.
* The groovy sandbox is stricter and favors security at the cost of flexibility

  All accessible classes and packages are listed in the `<stackstate dir>/etc/sandbox.conf`. STAC-5032

* Proper handling for trailing slash in a receiver URL configuration. STAC-7817
* Upgrade the requirement and documentation of Static Topology to use AgentV2. STAC-8640
* `processmanager-properties.conf` was merged into `processmanager.conf` for both StackState and StackGraph. If you have changes to either one of those configuration files, you changes will need to be reaplied after upgrade. STAC-8473
* The authentication for the admin API \(port 7071 by default\) is now configured separately from the normal authentication and, for new installations, it is enabled by default. If authentication was enabled for this api \(by default not\) this requires a change in the StackState configuration file. If it was not enabled it is strongly advised to enable it now and change the password. See the `application_stackstate.conf.example` file for an explanation on how to do both. STAC-7993
* It is now possible to configure a proxy for event handlers, see [how to set this up](../../configure/topology/proxy-for-event-handlers.md). STAC-7784
* Allow STS process manager to perform HTTPS health check. STAC-7718

