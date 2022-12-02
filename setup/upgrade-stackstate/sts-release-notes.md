---
description: StackState Self-hosted v5.1.x
---

# StackState release notes

## Overview

This page includes release notes for the StackState self-hosted product.

* For StackPack release notes, see the page [StackPack versions](stackpack-versions.md).
* For StackState Agent release notes, see [StackState Agent on GitHub \(github.com\)](https://github.com/StackVista/stackstate-agent/blob/master/stackstate-changelog.md).

## StackState v5.1.0

### v5.1.1

**Bug fixes**

- Fixed bug that caused markdown emitted by component actions to appear unstyled. STAC-18222
- Fixed issue that stops the Topology Sync from making progress when using a non default cache store. STAC-18085
- Fixed a bug in the autocomplete to first show all label keys and only after the ':' autocomplete on the values. STAC-17914

### v5.1.0

The StackState v5.1 release delivers brand-new features and enhancements that help your team troubleshoot faster.

* Improvements to our probable cause calculation
* Many additions to the right panel to always have information in the context of where you are looking.

The StackState v5.1 release is the last release containing the `stac` CLI. The new `sts` CLI replaces the `stac` CLI in all upcoming versions of StackState. For details see [Comparison between the CLIs](/setup/cli/cli-comparison.md).

**Improvements**

- The Minio pod in the StackState Helm chart has default CPU requests and limits set. STAC-17882
- Added rootCause getter to ProblemResolved and ProblemSubsumed type events. STAC-17869
- The kube-state-metrics Helm chart dependency of the stackstate-agent Helm chart has been upgraded to version 3.2.2. STAC-17830
- Introduced a new `ReadTelemetryStreams` permission to allow more fine-grained access control to telemetry streams. STAC-17744
- Improved problem analysis: better causing events discovery algorithm and more event types can be discovered including the user defined types. STAC-17620
- The total number of stored topology components and total number of stored topology relations are now exposed as metrics. STAC-17607
- The total amount of login attempts is now exposed as a metric. STAC-17517
- The right panel in the topology explorer now shows when health checks have warnings. STAC-17591
- The "+" button displayed on the visualizer (to show a component's hidden connections) now shows the number of hidden connections on hover. STAC-17430
- The StackState Kubernetes Service Account authenticator now only accepts RoleBindings that have been defined in the current namespace. STAC-17400
- Add support to OpenAPI for the Kubernetes Service Account authentication method. STAC-16951
- Include a time context on Component Actions accessible by default via the `telemetryTimeStart`, `telemetryTimeEnd` and `topologyTime` variables. STAC-16936
- The way in which [Top metrics](/use/metrics/top-metrics.md) values are displayed in the Component Context Menu] has been improved to bypass polling delays. STAC-16771
- In the StackState UI right panel, the previous "Selection" tab shown when an element was selected has been renamed to dynamically reflect the specific type of element selected. STAC-16595
- The header of the StackState UI right panel will now stick to the top when scrolling. STAC-16588
- The "Probable causes" section on the Problem details tab in the right panel now groups together consecutive events of the same type, happening on the same component. STAC-15832
- Health checks have more informative preview items in the right-hand side panel. STAC-14845
- In the StackState UI, Event handlers have been redesigned and relocated from the left panel to the "View summary" tab on the right panel. STAC-14815
- Added the ability to enable and disable monitors. This is helpful while you are developing your monitor, so as to not having it immediately running on its configured schedule. Monitors can be enabled on-demand via the CLI command `sts monitor enable -i`. STAC-14719
- The relations section in the "Component details" tab indicates which side of the relation the selected component is. STAC-17371
- All the "tag" looking properties (for example,, identifiers, labels and sources), active or disabled, now have a direct "copy-to-clipboard" option added on hover. STAC-16967
- The right panel Component details tab now features a "Relations" section to showcase all the direct relations that particular component has, inside or outside the current view. STAC-16682
- The "Component details" and "Direct relation details" tabs in the right panel now feature a "Problems" section to highlight the problems that are caused by or affect the selected component or direct relation. STAC-11526
- The "Component details" and "Direct relation details" tabs in the right panel now feature an "Events" section to highlight the latest events happening on the selected component or direct relation. Events are listed based on the telemetry interval selected on the timeline and event filters set on the view. STAC-11522

**Bug fixes**

- Fixed an issue where the guest user got logged out when hovering a component. STAC-17953
- Fixed an issue where deleting a view would redirect the user to an empty page. STAC-17855
- Fixed an issue that prevented StackState from using MS Edge as a browser. STAC-17848
- Fixed an issue that prevented expanding a view to include a relation. STAC-17842
- Fixed issue that prevented the context menu from being displayed for subviews. STAC-17835
- Fixed an issue where a user would get logged out if they did not have permissions for a certain part of the StackState UI. STAC-17745
- Fixed a bug where, by default, internal ES indexes were also attempted to be restored during a backup/ restore. (affects Kubernetes deployment only). STAC-17742
- Fixed issue that caused problems to display without contributing components in some cases. STAC-17731
- Fixed an issue where a broken telemetry stream would break all other telemetry streams. STAC-17709
- Fixed issue that caused an incorrect timestamp to be displayed in the Problem Contributors view. STAC-17487
- Fixed issue that caused improperly encoded URLs to display a blank screen. STAC-17477
- Fixed issue that caused the Problem producer to crash in certain circumstances. STAC-17361
- The StackState Helm chart now has a configurable replicaCount for all resources. STAC-17313
- Fixed race-condition in updating the OIDC refresh_token. STAC-17261
- Fixed multi-level tags not working correctly when used for telemetry grouping. STAC-17201
- Fix memory leak due to excessive storing of sessions when using token based authentication. STAC-17136
- Fixed an issue causing the problem producer to crash in a loop. STAC-17028
- Pagination has been removed from all "Settings" pages in the StackState UI. STAC-16982
- Fixed an issue that caused an invalid relation type to be displayed in the "Direct relation details" tab in the right panel. STAC-16969
- Fixed performance degradation that was experienced when repeatedly expanding using the '+' show neighbors functionality. STAC-16863
- Fixed issue that caused groups with big names to be displayed outside of the visualizer canvas. STAC-16844
- Ensure that HBase is respecting the STACKSTATE_TMP_DIR environment variable. STAC-16785
- Long view queries and view descriptions are now properly truncated in the "Properties" section of the View summary tab in the right panel. STAC-15928
- StackState now correctly reads the Kubernetes RoleBinding(s) when using a Kubernetes ServiceAccount token to authenticate. STAC-15814
- Fixed STQL query generation for relation-based problems. STAC-13333

**Security**

- Removed curl executable from UI Docker container resolving CVE-2022-32207. STAC-17319
- Upgraded libssl/libcrypto to 1.1.1q-r0, patching the CVE-2022-2097 vulnerability. STAC-17145
- Upgraded ncurses-terminfo and ncurses-libs to 6.2_p20210612-r1, patching the CVE-2022-29458 vulnerability. STAC-17144
- Upgraded tmpl to 1.0.5, patching the CVE-2021-3777 vulnerability. STAC-17085
- Upgraded shelljs to 0.8.5, patching the CVE-2022-0144 vulnerability. STAC-17079
- Upgraded shell-quote to 1.7.3, patching the CVE-2021-42470 vulnerability. STAC-17078
- Upgraded ini to 1.3.6 patching the CVE-2020-7780 vulnerability. STAC-17070
- Upgraded jmx-exporter to v0.17, patching the CVE-2017-18640 vulnerability. STAC-17027

**StackPack updates:**

- [Kubernetes](../../stackpacks/integrations/kubernetes.md)
- [OpenShift](../../stackpacks/integrations/openshift.md)
- [SAP](../../stackpacks/integrations/sap.md)   
- [SolarWinds](../../stackpacks/integrations/solarwinds.md)  
- [Splunk](../../stackpacks/integrations/splunk/splunk_stackpack.md)

## StackState v5.0.x

Before you upgrade, [check the version specific upgrade instructions](/setup/upgrade-stackstate/version-specific-upgrade-instructions.md).

### v5.0.8

**Bug fixes**

- Fixed issue that prevented the retrieval of CloudWatch metrics for global AWS resources. STAC-18460

### v5.0.7

**Bug fixes**

- Fixed an issue that stopped the Topology Sync from making progress when using a non default cache store. STAC-18085

### v5.0.6

**Improvements**

- The Minio pod in the StackState Helm chart has default CPU requests and limits set. STAC-17882

**Bug fixes**

- Fixed an issue that prevented StackState from using MS Edge as a browser. STAC-17848

### v5.0.5

**Bug fixes**

- Fixed issue that caused problems to display without contributing components in some cases. STAC-17731

### v5.0.4

**Improvements**

- Added a time context on Component Actions accessible by default via the variables `telemetryTimeStart`, `telemetryTimeEnd` and `topologyTime`. STAC-16936

### v5.0.3

**Bug fixes**

* Fixed a template issue that prevented the AAD from authenticating with StackState. STAC-17554

**Security**

* Removed curl executable from UI Docker container resolving CVE-2022-32207. STAC-17319

### v5.0.2

**Improvements**

* Made creation of the ClusterRoleBinding in the anomaly detection Helm chart optional to allow non-privileged installation. STAC-17061

**Bug fixes**

* Fixed race-condition in updating the OIDC refresh_token. STAC-17261
* Fixed multi-level tags not working correctly when used for telemetry grouping. STAC-17201
* Fixed memory leak due to excessive storing of sessions when using token based authentication. STAC-17136
* Exposed the pod securityContext in the anomaly-detection Helm chart. STAC-17036
* Fixed an issue causing the problem producer to crash in a loop. STAC-17028
* Upgraded jmx-exporter to v0.17, patching the CVE-2017-18640 vulnerability. STAC-17027
* Included prometheus-elasticsearch-exporter as Helm chart dependency of the elasticsearch chart. STAC-16995
* Fixed issue where the problem producer would crash with a NullPointerException. STAC-17361

**Security**

Upgraded:

* libssl/libcrypto to 1.1.1q-r0, patching the CVE-2022-2097 vulnerability. STAC-17145
* ncurses-terminfo and ncurses-libs to 6.2_p20210612-r1, patching the CVE-2022-29458 vulnerability. STAC-17144
* execa to 2.0..0, patching the Gemnasium-05cfa2e8-2d0c-42c1-8894-638e2f12ff3d vulnerability. STAC-17100
* url-parse to 1.5.9, patching the CVE-2022-0686 vulnerability. STAC-17098
* tmpl to 1.0.5, patching the CVE-2021-3777 vulnerability. STAC-17085
* shelljs to 0.8.5, patching the CVE-2022-0144 vulnerability. STAC-17079
* shell-quote to 1.7.3, patching the CVE-2021-42470 vulnerability. STAC-17078
* json-schema to 0.4.0, patching the CVE-2021-3918 vulnerability. STAC-17071
* ini to 1.3.6 patching the CVE-2020-7780 vulnerability. STAC-17070
* eventsource to 1.1.1, patching the CVE-2022-1650 vulnerability. STAC-17067
* curl and libcurl to 7.79.1-r2, patching the CVE-2022-27781 and CVE-2022-27782 vulnerabilities. STAC-17003

### v5.0.1

[See v5.0.2](#v5.0.2).

### v5.0.0

The StackState v5.0 release delivers brand-new features and enhancements that help your team troubleshoot faster. Here are some highlights:

* **[New 4T® Monitors](/use/checks-and-monitors/monitors.md)** – adds a new, first-in-the-industry dimension to observability monitoring – the ability to now monitor topology and to set validation rules that span topology and many other parameters
* **Improved Topology Visualizer and Right Panel** – substantially enhances user experience and increases productivity with a more modern, focused, easy-to-learn UI and more in-depth troubleshooting capabilities.
* **[New StackState CLI](/setup/cli/cli-comparison.md)** – lets you instantly configure StackState, run queries, create monitors and more, directly from your command line, while sending output directly to other systems for GitOps integration.
* **[Accuracy Feedback for Anomalies](/stackpacks/add-ons/aad.md#anomaly-feedback)** – gives users the ability to provide feedback about the usefulness of the anomalies reported by StackState, so we can continuously improve the accuracy of our algorithms.

Details of the included features, improvements, bug fixes and updated StackPacks can be found below.

**Features**

- Introduced a new monitoring feature - 4T Monitors. STAC-14693
- Part of the API of StackState 5.0.0 has been released with an OpenAPI specification to allow for easier consumption by API clients of StackState. The OpenAPI specification can be browsed at [https://dl.stackstate.com/stackstate-openapi/v5.0/openapi-v5.0.0.html](https://dl.stackstate.com/stackstate-openapi/v5.0/openapi-v5.0.0.html) STAC-16693
- The topology visualizer has been revamped. It now features much cleaner user experience and many helpful navigation improvements including a [legend](/use/stackstate-ui/perspectives/topology-perspective.md#legend) that describes the components and relations displayed. STAC-16191
- First release of a [completely new, easier to install CLI](/setup/cli/cli-sts.md), supporting the new features of StackState such as 4T Monitors and Service Tokens. STAC-15281
- Anomalies can now be marked with a [thumbs-up or thumbs-down](/stackpacks/add-ons/aad.md#anomaly-feedback). This feedback can be exported via the CLI and sent to StackState to help further develop test sets and algorithms for the AAD. STAC-15270
- The right panel in the StackState UI has been revamped. It now supports multiple tabs and chaining of selected elements. STAC-14808


**Improvements**

- Introduced [service tokens](/configure/security/authentication/service_tokens.md) as a means of authenticating to StackState. Service tokens aren't tied to a principal, but instead to a set of roles, allowing for service authentication. More information on creating and managing these can be found in the StackState documentation. STAC-15016
- Introduced optional View access logging. When enabled, a new access log for StackState views is created under `logs/access/`. You can use this log to track how often specific views are accessed and by which user. To enable this feature, you need to enable the feature flag `featureSwitches.viewAccessLogs` in the StackState Api config. STAC-16369
- The OIDC `refresh_token` is now cached to prevent re-authenticating the user if the OIDC server doesn't return a new `refresh_token` when the old one hasn't expired yet. STAC-16158
- Updated the [telemetry script API](/develop/reference/scripting/script-apis/telemetry.md) to stream results. More information can be found in the StackState documentation. STAC-16801
- kafkaup-operator Helm chart: Added a configurable SecurityContext so that the container no longer requires privileged mode. STAC-16664
- StackState Helm chart: Added configurable resource requests and limits for all containers. STAC-16443
- Improved indexing speed for messages coming in on Kafka topics. STAC-15998


**Bug fixes**

- Fixed issue that incorrectly showed an error message when displaying a log stream. STAC-16222
- Added more error context when JSON deserialization fails. STAC-16733
- Fixed issue that prevented relation details being displayed in the right panel when a link was clicked in the full event details. STAC-16264
- Fixed DNS lookup errors by explicitly setting a short DNS lookup cache timeout on the internal JDK DNS cache. This ensures that service lookups don't fail in containerized environments. STAC-15983
- Fixed issue that caused groups with big names to be displayed outside of the visualizer canvas. STAC-16844
- StackState Helm Chart: The `backup-scripts` ConfigMap now has a label so that it can be easily retrieved in the backup/restore scripts STAC-16447
- Fixed scroll position after changing group. STAC-16284
- Fixed error handling of expired sessions for OIDC and Keycloak authentication methods, especially in combination with API token. STAC-15781
- Fixed suggestions in telemetry inspector for values with multiple dots (domains, IPs). STAC-15764
- Fixed STQL query generation for relation based problems. STAC-13333
- If the OIDC configuration is wrongly configured to obtain a username, the logging will now show all fields that can be selected to obtain the username from. STAC-16027


**Security**

- Upgraded ssl_client to 1.33.1-r7, patching the CVE-2022-28391 vulnerability. STAC-16426
- Upgraded Log4j-over-slf4j to version 2.12.1, patching the CVE-2020-9493 vulnerability. STAC-16233
- Upgraded libcrypto1.1 to 1.1.1n-r0, patching the CVE-2022-0778 vulnerability. STAC-16135
- Upgraded libssl1.1 to 1.1.1l-r0 (Alpine) and 1.1.1f-1ubuntu2.12 (Ubuntu), patching the CVE-2022-0778 vulnerability. STAC-16134
- Upgraded zlib to 1.2.12-r0, patching the CVE-2018-25032 vulnerability. STAC-16214
- Upgraded libretls to 3.3.3p1-r3, patching the CVE-2022-0778 vulnerability. STAC-16153
- Upgraded ElasticSearch to 7.17.2. STAC-16418

**StackPack updates:**

* [StackState Agent StackPack v4.5.2](/stackpacks/integrations/agent.md#release-notes)
* [AWS v1.2.1](/stackpacks/integrations/aws/aws.md#release-notes)
* [Dynatrace v1.4.2](/stackpacks/integrations/dynatrace.md#release-notes)
* [Kubernetes v3.9.12](/stackpacks/integrations/kubernetes.md#release-notes)
* [OpenShift v3.7.12](/stackpacks/integrations/openshift.md#release-notes)
* [ServiceNow v5.3.3](/stackpacks/integrations/servicenow.md#release-notes)
* [VMware vSphere v2.3.3](/stackpacks/integrations/vsphere.md#release-notes)

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
- The MinIO chart now allows the registry to be configured separately from the repository. Also, the chart will now use any [globally configured pull secrets](/setup/install-stackstate/kubernetes_openshift/install-from-custom-image-registry.md) to fetch Docker images. STAC-15180
- The component context menu now displays the preview of the [three top priority metrics](/use/metrics/top-metrics.md). STAC-15076
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

## Unsupported versions

The versions below have reached End of Life \(EOL\) and are no longer be supported.

{% hint style="warning" %}
These releases are susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046.
{% endhint %}

### StackState v4.5.x (EOL)

Before you upgrade, [check the version specific upgrade instructions](/setup/upgrade-stackstate/version-specific-upgrade-instructions.md).

#### v4.5.6

**Improvements**

- Added support for base64 encoded trust stores. STAC-16004

**Bug fixes**

- If the OIDC configuration is wrongly configured to obtain a username, the logging will show all fields that can be selected to obtain the username from. STAC-16027
- Security fixes for CVE-2022-24407. STAC-15939

#### v4.5.5

**Bug fixes**

- Clears the following CVEs:
  - CVE-2022-23852
  - CVE-2022-23990. STAC-15733
- Fixed timeline health state not showing up properly on views with trailing whitespace in the query. STAC-15662
- Fixed issue that incorrectly calculates Problem Clusters in certain circumstances. STAC-15657
- Remediation for CVE-2022-23307 by removing Log4J dependencies from StackGraph. STAC-15655
- Fixed issue that caused several pods to be stuck in Pending mode after an API key update. STAC-15525

#### v4.5.4

**Improvements**

- Internal Playground optimization. STAC-15393

#### v4.5.3

**Bug fixes**

- Fixed issue that caused AAD to fail to authenticate with StackState. STAC-15278

#### v4.5.2

**Improvements**

- Added configuration options to Azure StackPack that allow specification of the Azure function name and the StackPack instance URL. STAC-14694

**Bug fixes**

- Fixed issue that caused a redirect to the Views Dashboard page when clicking on a component in a view that contains a slash in the identifier. STAC-15443
- Added missing documentation in Slack StackPack. STAC-15103
- Fixed issue that caused transaction logs to consume excessive storage space on Kubernetes. STAC-13922

#### v4.5.1

**Improvements**

- Adds compatibility with StackState Agent V2.15.0. Read how to [upgrade StackState Agent](/setup/agent/about-stackstate-agent.md#deployment).
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

#### v4.5.0

{% hint style="warning" %}
This release is susceptible to the Apache log4j2 vulnerabilities CVE-2021-44228 and CVE-2021-45046. [Resolved in version v4.5.1](#v4.5.1).
{% endhint %}

**Features**

- The ability to create manual topology from the StackState UI has been removed. Please use the Static Topology StackPack in order to [create components manually](/configure/topology/how_to_create_manual_topology.md). STAC-14377
- Improved feedback from the topology synchronization service by exposing synchronization metrics via the CLI. STAC-13318
- Improved root cause analysis using subviews: modify your view to include additional components, show indirect relations and paths, [show grouped relations](/use/concepts/relations.md), save changed views even when timetravelling. STAC-13142
- Start anomaly detection on new streams after two hours. Adapt to changing streams in real-time. STAC-12996

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
  * Double-clicking on a topology element \(group, component or relation\) "zooms into" that element in the Topology Perspective
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
  * it's now possible to zoom out of a time range. STAC-12533
  * Added support for navigating to the next and previous time range. STAC-12531
* Indirect relations for "Show root cause only" are now always shown when there is at least one invisible dependency that leads to the root cause. In earlier versions of StackState an indirect relation for a root cause was only shown if there was no visible path to the root cause. STAC-11621
* [Relations to component groups are shown as solid lines](/use/concepts/relations.md). In StackState v4.3 a grouped relation was displayed as a dashed line when the group of relations wasn't complete in the sense that each component in the group received that relation \(this is also called surjective\). STAC-11621
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

* The CLI will now issue a deprecation warning when not using the new API token based authentication. For details, see the [CLI authentication docs](/setup/cli/README.md). STAC-12567
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
* it's now possible to [configure whether ClusterRoles and ClusterRoleBindings need to be installed](../install-stackstate/kubernetes_openshift/required_permissions.md#disable-automatic-creation-of-cluster-wide-resources) by the StackState Helm chart using the flag `cluster-role.enabled`. STAC-11749
* StackState HDFS pods now run without privileges in Kubernetes. STAC-11741
* Added support for interacting with external systems using [self-signed certificates](/configure/security/self-signed-certificates.md). STAC-11738
* The field specifying the [role to use for Keycloak authentication](../../configure/security/authentication/keycloak.md) \(default field name: `roles`\) is now configurable using the `groupsField` configuration parameter. STAC-11609
* StackState now supports [API tokens for authentication of the StackState CLI](../cli/README.md). This allows the StackState CLI to work with Keycloak or OIDC as an authentication provider. STAC-11608
* The CLI will now issue a deprecation warning when not using the new API token based authentication. STAC-12567
* Added support for [backup and restore procedure for self-hosted Kubernetes](../data-management/backup_restore/kubernetes_backup.md) setup. STAC-11548
* it's now possible to use component actions when time-traveling. STAC-11462
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

* it's now possible to configure whether ClusterRoles and ClusterRoleBindings need to be installed by the Helm chart using the `cluster-role.enabled` flag. STAC-11749
* Added support for interacting with external systems using self-signed certificates. STAC-11738
* Added documentation and support for backup and restore for self-hosted Kubernetes setup. STAC-11548

**Bugfixes**

* Fix issue blocking the sync service and not letting process topology anymore. STAC-12116
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
* Fix issue where kafkaToES would not log when it's dropping data. STAC-11434
* Fixed issue where kafkaToES would not adhere to the index size boundaries when historic data is stored. STAC-11433
* Upload of a new StackPack now returns more details on why an uploaded StackPack is not valid. STAC-11094
* Fixed issue that caused a baseline stream to disappear if the associated stream's filter was changed. STAC-10872
* Fixed issue that caused incoming telemetry data to be rejected due to incorrect interpretation of telemetry data end timestamp. STAC-10777
* Fixed bug where a non-existing datasource in a synchronization template would cause the synchronization to stop processing. STAC-10774
* Fixed issue that disregarded filters when populating the selection field name dropdown. STAC-10759
* Fixed issue that caused checks to ignore a change to a streams filter under certain circumstances. STAC-10733
* Fixed issue that caused an error when StackState attempted to connect to an LDAP server using LDAPS on certain versions of the JVM. STAC-10606
* Fixed issue that made it impossible to save changes to functions in the Settings screen. STAC-10180
* Next to the admin and guest roles StackState now has a standard power user role. It has the same permissions as an admin user except it isn't allowed to grant permissions or to upload stackpacks. STAC-10170
* UPGRADE NOTE: it's strongly advised to review the roles your users have and limit the number of admin users. Users that need to configure StackState can be given the role of power user instead. STAC-10170
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
* StackState shows a warning when a license key is about to expire or an error when it's invalid or has expired. This includes the option to update the license key from that screen directly. STAC-7453
* StackState CLI is now shipped as a standalone binary for Linux and Windows. STAC-5614

**Bug fixes**

* Added eager short circuit while loading elements on a query. STAC-10354
* Fixed issue that prevented suggestions from showing up when filtering the component type list. STAC-9822
* Fixed issue that prevented synchronization statistics from being displayed on the Synchronization settings page. STAC-9815
* Fixed issue with Kubernetes deployment that redirects users to the webuiconfig instead of StackState application. STAC-9811
* Fixed issue where check updating would retry indefinitely when an element is already gone. STAC-9323
* Fixed issue that redirected users to a stream URL instead of the StackState application. STAC-9186
* Fixed issue where component version information wasn't properly merged during synchronization. STAC-8624
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
* `processmanager-properties.conf` was merged into `processmanager.conf` for both StackState and StackGraph. If you have changes to either one of those configuration files, your changes will need to be reaplied after upgrade. STAC-8473
* The authentication for the admin API \(port 7071 by default\) is now configured separately from the normal authentication and, for new installations, it's enabled by default. If authentication was enabled for this api \(by default not\) this requires a change in the StackState configuration file. If it wasn't enabled it's strongly advised to enable it now and change the password. See the `application_stackstate.conf.example` file for an explanation on how to do both. STAC-7993
* it's now possible to configure a proxy for event handlers, see [how to set this up](../../configure/topology/proxy-for-event-handlers.md). STAC-7784
* Allow STS process manager to perform HTTPS health check. STAC-7718
