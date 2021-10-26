---
description: Release notes up to v4.4.x of StackState
---

# StackState release notes

{% hint style="info" %}
StackPack release notes can be found on each StackPack page. See [StackPack versions](stackpack-versions.md).
{% endhint %}

## StackState v4.4.x

### v4.4.2

**Improvements**

- Support extra custom request parameters for OIDC. STAC-13999
- Security improvement for handling credentials on the StackPack pages. STAC-13658

**Bug fixes**

- Fixed issue that caused the AWS CloudWatch plugin to fail to assume the correct IAM role under certain circumstances. STAC-14252
- Fix the issue that caused the AWS StackPack installation to fail to verify the passed in AWS credentials on the StackState Kubernetes installation. STAC-14014
- Fixed issue that caused a loop when logging in with OIDC when 'stackstate.baseUrl' contained a trailing '/'. STAC-13964
- Fixed issue that caused backup functionality to fail on OpenShift. STAC-13772

### v4.4.1

**Improvements**

- Added tolerations and affinity configuration to the anomaly-detector Helm Chart. STAC-13824
- Added tolerations, nodeSelector and affinity configuration to the kafkaTopicCreate job in the StackState Helm Chart. STAC-13822

**Bug fixes**

- Fixed issue that caused corrupt data in StackGraph under certain circumstances. STAC-13860
- Fixed issue that caused the health synchronization to occasionally keep restarting. STAC-13829
- Fixed issue that occasionally caused auto propagation to enter a loop and fail to terminate. STAC-13725

### v4.4.0

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
* Configuration of authorization for various StackState APIs can now be [defined in one central location](version-specific-upgrade-instructions.md#upgrade-to-v-4-4-x). STAC-12968
* Completed removal of deprecated baseline functions. Baseline functions should be removed from all templates. [See upgrade documentation for more details](version-specific-upgrade-instructions.md#upgrade-to-v-4-4-x). STAC-12602
* The HDFS OpenShift SecurityContextConfiguration is not necessary and has been removed from the documentation. STAC-12573
* [Timeline improvements](../../use/stackstate-ui/timeline-time-travel.md):
  * It is now possible to zoom out of a time range. STAC-12533
  * Added support for navigating to the next and previous time range. STAC-12531
* Indirect relations for "Show root cause only" are now always shown when there is at least one invisible dependency that leads to the root cause. In previous versions of StackState an indirect relation for a root cause was only shown if there was no visible path to the root cause. STAC-11621
* [Relations to component groups are shown as solid lines](../../use/stackstate-ui/perspectives/topology-perspective.md#direct-and-indirect-relations). In StackState 4.3 a grouped relation was displayed as a dashed line when the group of relations was not complete in the sense that each component in the group received that relation \(this is also called surjective\). STAC-11621
* Improve how component names are displayed in the Topology Perspective. STAC-13063
* The component finder modal can now be invoked using the [keyboard shortcut](../../use/stackstate-ui/keyboard-shortcuts.md) `CTRL`+`SHIFT`+`F`. STAC-12957

**Bug fixes**

* Fixed issue that caused an import via the CLI to fail. STAC-13481
* The deprecated elasticsearch-exporter Helm chart has been replaced with the prometheus-elasticsearch-exporter Helm chart in order to make it OpenShift compatible. STAC-13473
* Fixed issue that prevented Keycloak authentication from working after expiry of a refresh token. STAC-13268
* Fixed issue that prevented certain views from opening from the View Overview page. STAC-13244
* Fixed crash when accessing the logs API. STAC-13149
* Backup PVC is created on installation of StackState chart to prevent Helm hanging. STAC-12696

## StackState v4.3.x

### v4.3.5

**Improvements**

- Added tolerations and affinity configuration to the anomaly-detector Helm Chart. STAC-13824
- Added tolerations, nodeSelector and affinity configuration to the kafkaTopicCreate job in the StackState Helm Chart. STAC-13822

**Bug fixes**

- Fixed issue that caused corrupt data in StackGraph under certain circumstances. STAC-13860

### v4.3.4

**Bug fixes**

* Fixed issue that prevented Keycloak authentication from working after expiry of a refresh token. STAC-13268

### v4.3.3

**Bug fixes**

* Fixed issue that prevented certain views from opening from the View Overview page. STAC-13244

### v4.3.2

**Bug fixes**

* Fix crash when accessing the logs api. STAC-13149

### v4.3.1

**Improvements**

* The CLI will now issue a deprecation warning when not using the new API token based authentication. For details, see the [CLI authentication docs](../installation/cli-install.md#authentication). STAC-12567
* Any change to a check will update the check state data and fire a change event. STAC-12472

**Bug fixes**

* Fixed issue that caused the Autonomous Anomaly Detector to fail to authenticate with StackState. STAC-12742
* Fixed issue that caused the browser to free when selecting a large group of components. STAC-12016

### v4.3.0

**Features**

* [Show configuration changes](../../use/problem-analysis/problem_investigation.md#element-properties-changed-events) for faster root cause analysis. STAC-12441
* [Alert on anomalies](../../use/health-state/anomaly-health-checks.md) detected by the Autonomous Anomaly Detector. STAC-11798
* [Drill down on Problems](../../use/problem-analysis/problems.md) for faster investigation. STAC-10481

**Improvements**

* Introduced [check functions that alert on anomalies](../../use/health-state/anomaly-health-checks.md) detected by the Autonomous Anomaly Detector. Previous anomaly detection functions and baseline streams and functions are deprecated and will be removed in StackState 4.4. STAC-12256
* The [Autonomous Anomaly Detector \(AAD\)](../../stackpacks/add-ons/aad.md) is now enabled by default in the Kubernetes distribution. STAC-12024
* It is now possible to [configure whether ClusterRoles and ClusterRoleBindings need to be installed](../installation/kubernetes_install/required_permissions.md#disable-automatic-creation-of-cluster-wide-resources) by the StackState Helm chart using the flag `cluster-role.enabled`. STAC-11749
* StackState HDFS pods now run without privileges in Kubernetes. STAC-11741
* Added support for interacting with external systems using [self-signed certificates](../../configure/security/self-signed-cert.md). STAC-11738
* The field specifying the [role to use for Keycloak authentication](../../configure/security/authentication/keycloak.md) \(default field name: `roles`\) is now configurable using the `groupsField` configuration parameter. STAC-11609
* StackState now supports [API tokens for authentication of the StackState CLI](../installation/cli-install.md#authentication). This allows the StackState CLI to work with Keycloak or OIDC as an authentication provider. STAC-11608
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

## StackState v4.2.x

### v4.2.4

**Improvements**

* It is now possible to configure whether ClusterRoles and ClusterRoleBindings need to be installed by the Helm chart using the `cluster-role.enabled` flag. STAC-11749
* Added support for interacting with external systems using self-signed certificates. STAC-11738
* Added documentation and support for backup and restore for self-hosted Kubernetes setup. STAC-11548

**Bugfixes**

* Fix issue blocking the sync service and not letting process topology any more. STAC-12116
* Fixed problem where LDAP users with a special character in their DN could not be authorized. STAC-12059
* Fixed issue that caused filtering on a domain containing an ampersand to redirect to the Views page. STAC-11797

### v4.2.3

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

### v4.2.2

**Bug fixes**

* Fix for StackState helm chart to include correct version of AAD sub chart. STAC-11654

### v4.2.1

**Improvements**

* Add support for running StackState on an OpenShift Kubernetes cluster. STAC-11549

**Bug fixes**

* Fixed issue that prevents StackState distributed Kubernetes installation from starting when the database initialisation process fails due to a pod restart. STAC-11618

### v4.2.0

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

## Unsupported versions

The versions below are have reached End of Life \(EOL\) and are no longer be supported

### StackState v4.1.x

{% hint style="info" %}
With the release of StackState v4.4, StackState v4.1 reached End of Life \(EOL\) and is no longer supported.
{% endhint %}

#### v4.1.3

**Bug fixes**

* Fixed issue that caused the CLI to fail to run on systems with an older GLIBC library. STAC-10609
* Fixed issue that prevented historical data from displaying in the Health Forecast Report. STAC-11207

#### v4.1.2

**Bug fixes**

* Fixed issue that caused event handlers to produce a security error on specific OpenJDK 8 versions. STAC-10893
* Fixed issue that prevented Slack event handler from working in certain circumstances. STAC-10797
* Fixed issue that caused opening of certain Azure telemetry streams to show an error in the GUI. STAC-10778

**Improvements**

* Introduced configuration setting `stackstate.topologyQueryService.maxLoadedElementsPerQuery` configuration to tweak the amount of loaded elements we allow during query execution. STAC-11009

#### v4.1.1

**Bug fixes**

* Fixed issue that prevented users from deleting certain metric streams. STAC-10623
* Fixed issue that caused an error when StackState attempted to connect to an LDAP server using LDAPS on certain versions of the JVM. STAC-10606

#### v4.1.0

**Features**

* Introduced Traces Perspective to identify root causes of down-time and performance issues. STAC-7646
* Introduced Autonomous Anomaly Detector \(AAD\) \[beta\] that identifies anomalies in metric streams with zero configuration. STAC-7403
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

### StackState v4.0.x

{% hint style="info" %}
StackState v4.0 is End of Life \(EOL\) and is no longer supported.
{% endhint %}

#### v4.0.4

**Bug fixes**

* Fix issue where the readcache sometimes produces the wrong data, causing intermittent failures in state and view calculation. STAC-10328

#### v4.0.3

**Bug fixes**

* Fixed issue that prevented time travel under certain circumstances. STAC-9551

#### v4.0.2

**Bug fixes**

* Support Splunk token-based authentication for Splunk versions 7.3 and later. STAC-9032
* Fixed bug that prevented the health check metric chart from opening. STAC-9251
* Fixed bug that caused multi param propagation function values to be lost after a component update. STAC-9582
* Fixed bug that caused the log to be spammed with messages for a deleted checkstate. STAC-9323

#### v4.0.1

**Bug fixes**

* Fix transaction boundaries while running legacy propagation function. STAC-9161
* Fix some cases when checks on new or updated components would fail to start and remain in an "Unknown" state. STAC-7949
* Fix an issue that in some cases prevented properly storing security subjects from CLI. STAC-7569

#### v4.0.0

**Features**

* Telemetry Perspective to see all Telemetry streams for a set of components. This first release is limited to 5 components at a time. In later releases this will be improved with a larger set of components which will be supported.

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

