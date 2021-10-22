---
description: Release notes up to v4.2.x of StackState
---

# StackState release notes

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

{% hint style="info" %}
StackPack release notes can be found on each StackPack page. See [StackPack versions](/setup/upgrade-stackstate/stackpack-versions.md).
{% endhint %}

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

- StackState's HDFS pods now run without privileges in Kubernetes. STAC-11741
- Adding an additional role field for Keycloak authentication. STAC-11609
- StackState now supports API tokens for authentication of the StackState CLI, making it possible to use the CLI with Keycloak or OIDC as authentication provider. STAC-11608
- Authentication settings are now directly configurable on the helm chart. STAC-11237

**Bug fixes**

- Fixed issue that prevented traces from being ingested into StackState. STAC-11733
- Fixed issue that caused the StackState helm chart to fail with custom image registries. STAC-11717
- Fixed issue that prevented `copy_images.sh` script from working with containers without a docker.io prefix. STAC-11697
- Fixed issue that caused the old and new state to disappear for certain health state changes in the Event Perspective. STAC-11691

### v4.2.2

**Bug fixes**

- Fix for Stackstate helm chart to include correct version of AAD sub chart. STAC-11654

### v4.2.1

**Improvements**

- Add support for running StackState on an OpenShift Kubernetes cluster. STAC-11549

**Bug fixes**

- Fixed issue that prevents StackState distributed Kubernetes installation from starting when the database initialisation process fails due to a pod restart. STAC-11618

### v4.2.0

**Features**

- Display external events in the Events Perspective. Improve Event Detail panel and event filtering. STAC-10638
- Alert on Problem Clusters in Slack. STAC-10567
- Ingest events from external systems related to topology in StackState. STAC-8183

**Improvements**

- Support OpenID Connect (OIDC) authentication provider. STAC-10083

**Bug fixes**

- Fixed issue where duplicate negative ids in a component template leads to `lastUpdateTimstampField` missing. STAC-11495
- Fix issue where kafkaToES would not log when it is dropping data. STAC-11434
- Fixed issue where kafkaToES would not adhere to the index size boundaries when historic data is stored. STAC-11433
- Upload of a new StackPack now returns more details on why an uploaded StackPack is not valid. STAC-11094
- Fixed issue that caused a baseline stream to disappear if the associated stream's filter was changed. STAC-10872
- Fixed issue that caused incoming telemetry data to be rejected due to incorrect interpretation of telemetry data end timestamp. STAC-10777
- Fixed bug where a non-existing datasource in a synchronization template would cause the synchronization to stop processing. STAC-10774
- Fixed issue that disregarded filters when populating the selection field name dropdown. STAC-10759
- Fixed issue that caused checks to ignore a change to a streams filter under certain circumstances. STAC-10733
- Fixed issue that caused an error when StackState attempted to connect to an LDAP server using LDAPS on certain versions of the JVM. STAC-10606
- Fixed issue that made it impossible to save changes to functions in the Settings screen. STAC-10180
- Next to the admin and guest roles StackState now has a standard power user role. It has the same permissions as an admin user except it is not allowed to grant permissions or to upload stackpacks. STAC-10170
- UPGRADE NOTE: It is strongly advised to review the roles your users have and limit the number of admin users. Users that need to configure StackState can be given the role of power user instead. STAC-10170
- Fixed issue that caused a security exception to occur when using a groovy regex in the Analytics environment. STAC-9947
- Fixed issue that caused an error when showing the Component Details pane for a component or relation originating from a removed synchronization. STAC-8165

## StackState v4.1.x

### v4.1.3

**Bug fixes**

- Fixed issue that caused the CLI to fail to run on systems with an older GLIBC library. STAC-10609
- Fixed issue that prevented historical data from displaying in the Health Forecast Report. STAC-11207

### v4.1.2

**Bug fixes**

- Fixed issue that caused event handlers to produce a security error on specific OpenJDK 8 versions. STAC-10893
- Fixed issue that prevented Slack event handler from working in certain circumstances. STAC-10797
- Fixed issue that caused opening of certain Azure telemetry streams to show an error in the GUI. STAC-10778

**Improvements**

- Introduced configuration setting `stackstate.topologyQueryService.maxLoadedElementsPerQuery` configuration to tweak the amount of loaded elements we allow during query execution. STAC-11009

### v4.1.1

**Bug fixes**

- Fixed issue that prevented users from deleting certain metric streams. STAC-10623
- Fixed issue that caused an error when StackState attempted to connect to an LDAP server using LDAPS on certain versions of the JVM. STAC-10606

### v4.1.0

**Features**

- Introduced Traces Perspective to identify root causes of down-time and performance issues. STAC-7646
- Introduced Autonomous Anomaly Detector (AAD) [beta] that identifies anomalies in metric streams with zero configuration. STAC-7403
- Introduced the ability to deploy StackState on the OpenShift, AKS and EKS Kubernetes platforms. STAC-7328

**Improvements**

- Improved navigation in the StackState UI. STAC-9448
- Added support for Splunk token-based authentication for Splunk versions 7.3 and later. STAC-9032
- Added ability to star views for easy access. STAC-8805
- StackState shows a warning when a license key is about to expire or an error when it is invalid or has expired. This includes the option to update the license key from that screen directly. STAC-7453
- StackState CLI is now shipped as a standalone binary for Linux and Windows. STAC-5614

**Bug fixes**

- Added eager short circuit while loading elements on a query. STAC-10354
- Fixed issue that prevented suggestions from showing up when filtering the component type list. STAC-9822
- Fixed issue that prevented synchronization statistics from being displayed on the Synchronization settings page. STAC-9815
- Fixed issue with Kubernetes deployment that redirects users to the webuiconfig instead of StackState application. STAC-9811
- Fixed issue where check updating would retry indefinitely when an element is already gone. STAC-9323
- Fixed issue that redirected users to a stream URL instead of the StackState application. STAC-9186
- Fixed issue where component version information was not properly merged during synchronization. STAC-8624
- Fixed issue where state service could not find some elements due to querying with an incomplete time slice. STAC-8195
- Propagation function will be re evaluated for all related components when the body of the function changes. STAC-4114

## StackState v4.0.x

### v4.0.4

**Bug fixes**

- Fix issue where the readcache sometimes produces the wrong data, causing intermittent failures in state and view calculation. STAC-10328

### v4.0.3

**Bug fixes**

- Fixed issue that prevented time travel under certain circumstances. STAC-9551

### v4.0.2

**Bug fixes**

- Support Splunk token-based authentication for Splunk versions 7.3 and later. STAC-9032
- Fixed bug that prevented the health check metric chart from opening. STAC-9251
- Fixed bug that caused multi param propagation function values to be lost after a component update. STAC-9582
- Fixed bug that caused the log to be spammed with messages for a deleted checkstate. STAC-9323

### v4.0.1

**Bug fixes**

- Fix transaction boundaries while running legacy propagation function. STAC-9161
- Fix some cases when checks on new or updated components would fail to start and remain in an "Unknown" state. STAC-7949
- Fix an issue that in some cases prevented properly storing security subjects from CLI. STAC-7569

### v4.0.0

**Features**

- Telemetry perspective to see all Telemetry streams for a set of components. This first release is limited to 5 components at a time. In later releases this will be improved with a larger set of components which will be supported.

**Improvements**

- Ability to find components in the topology perspective. STAC-7764
- Performance enhancements for views

**Bug fixes**

- This release deprecates the withCauseOf stql construct. See [https://l.stackstate.com/R8opqs](https://l.stackstate.com/R8opqs) for more info on how to migrate existing view. STAC-7884.
- The groovy sandboxing has been improved to cover a number of edge cases.
- The groovy sandbox is stricter and favors security at the cost of flexibility
  All accessible classes and packages are listed in the `<stackstate dir>/etc/sandbox.conf`. STAC-5032
- Proper handling for trailing slash in a receiver URL configuration. STAC-7817
- Upgrade the requirement and documentation of Static Topology to use AgentV2. STAC-8640
- `processmanager-properties.conf` was merged into `processmanager.conf` for both StackState and StackGraph. If you have changes to either one of those configuration files, you changes will need to be reaplied after upgrade. STAC-8473
- The authentication for the admin API (port 7071 by default) is now configured separately from the normal authentication and, for new installations, it is enabled by default. If authentication was enabled for this api (by default not) this requires a change in the StackState configuration file. If it was not enabled it is strongly advised to enable it now and change the password. See the `application_stackstate.conf.example` file for an explanation on how to do both. STAC-7993
- It is now possible to configure a proxy for event handlers, see https://l.stackstate.com/FcUps8 for how to set this up. STAC-7784
- Allow STS process manager to perform HTTPS health check. STAC-7718
