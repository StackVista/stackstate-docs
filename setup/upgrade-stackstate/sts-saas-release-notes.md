---
description: StackState SaaS
---

# SaaS release notes

{% hint style="info" %}
Note that the release notes may include details of functionality that is currently only available in the StackState Self-Hosted product. 
{% endhint %}

### StackState v5.1.2 (2022-12-06) 

**Improvements**

- Charts now support units of measurements defined at the end of a stream name. STAC-18305
 
**Bug fixes**

- Fixed an issue that prevented the retrieval of CloudWatch metrics for global AWS resources. STAC-18460
- Fixed an issue that caused header for markdown messages to be missing. STAC-18434
- Fixed an issue that prevented users with certain permissions from adding checks to a component. STAC-18307
- Fixed an issue that caused numbers on graph Y-axes to be displayed using scientific notation. STAC-16984

### StackState v5.1.1 (2022-11-16)

**Bug fixes**

- Fixed bug that caused markdown emitted by component actions to appear unstyled. STAC-18222
- Fixed issue that stops the Topology Sync from making progress when using a non default cache store. STAC-18085
- Fixed a bug in the autocomplete to first show all label keys and only after the ':' autocomplete on the values. STAC-17914
- 
## StackState v5.1.0 (2022-10-14)

The StackState v5.1 release delivers brand-new features and enhancements that help your team troubleshoot faster.

* Improvements to our probable cause calculation
* Many additions to the right panel to always have information in the context of where you are looking.


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

## StackState v5.0.x

### v5.0.6 (2022-09-30)

**Improvements**

- The Minio pod in the StackState Helm chart has default CPU requests and limits set. STAC-17882

**Bug fixes**

- Fixed an issue that prevented StackState from using MS Edge as a browser. STAC-17848

### v5.0.5 (2022-09-13)

**Bug fixes**

- Fixed issue that caused problems to display without contributing components in some cases. STAC-17731

### v5.0.4 (2022-09-08)

**Improvements**

- Added a time context on Component Actions accessible by default via the variables `telemetryTimeStart`, `telemetryTimeEnd` and `topologyTime`. STAC-16936

### v5.0.3 (2022-08-29)

**Bug fixes**

* Fixed a template issue that prevented the AAD from authenticating with StackState. STAC-17554

**Security**

* Removed curl executable from UI Docker container resolving CVE-2022-32207. STAC-17319

### v5.0.2 (2022-08-13)

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

### v5.0.0 (2022-06-24)

The StackState v5.0 release delivers brand-new features and enhancements that help your team troubleshoot faster. Here are some highlights:

* **[New 4T® Monitors](/use/checks-and-monitors/monitors.md)** – adds a new, first-in-the-industry dimension to observability monitoring – the ability to now monitor topology and to set validation rules that span topology and multiple other parameters
* **Improved Topology Visualizer and Right Panel** – substantially enhances user experience and increases productivity with a more modern, focused, easy-to-learn UI and more in-depth troubleshooting capabilities.
* **New StackState CLI** – lets you instantly configure StackState, run queries, create monitors and more, directly from your command line, while sending output directly to other systems for GitOps integration.
* **[Accuracy Feedback for Anomalies](/stackpacks/add-ons/aad.md#anomaly-feedback)** – gives users the ability to provide feedback about the usefulness of the anomalies reported by StackState, so we can continuously improve the accuracy of our algorithms.

Details of the included features, improvements, bug fixes and updated StackPacks can be found below.

**Features**

- Introduced a new monitoring feature - 4T Monitors. STAC-14693
- Part of the API of StackState 5.0.0 has been released with an OpenAPI specification to allow for easier consumption by API clients of StackState. The OpenAPI specification can be browsed at [https://dl.stackstate.com/stackstate-openapi/v5.0/openapi-v5.0.0.html](https://dl.stackstate.com/stackstate-openapi/v5.0/openapi-v5.0.0.html) STAC-16693
- The topology visualizer has been revamped. It now features much cleaner user experience and multiple helpful navigation improvements including a [legend](/use/stackstate-ui/perspectives/topology-perspective.md#legend) that describes the components and relations displayed. STAC-16191
- First release of a completely new, easier to install CLI, supporting the new features of StackState such as 4T Monitors and Service Tokens. STAC-15281
- Anomalies can now be marked with a [thumbs-up or thumbs-down](/stackpacks/add-ons/aad.md#anomaly-feedback). This feedback can be exported via the CLI and sent to StackState to help further develop test sets and algorithms for the AAD. STAC-15270
- The right panel in the StackState UI has been revamped. It now supports multiple tabs and chaining of selected elements. STAC-14808

**Improvements**

- Introduced service tokens as a means of authenticating to StackState. Service tokens aren't tied to a principal, but instead to a set of roles, allowing for service authentication. More information on creating and managing these can be found in the StackState documentation. STAC-15016
- Introduced optional View access logging. When enabled, a new access log for StackState views is created under `logs/access/`. This log allows you to track how often specific views are accessed and by which user. To enable this feature, you need to enable the feature flag `featureSwitches.viewAccessLogs` in the StackState Api config. STAC-16369
- The OIDC `refresh_token` is now cached to prevent re-authenticating the user if the OIDC server doesn't return a new `refresh_token` when the old one hasn't expired yet. STAC-16158
- Updated the telemetry script API to stream results. More information can be found in the StackState documentation. STAC-16801
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
* [Kubernetes v3.9.12](/stackpacks/integrations/kubernetes.md#release-notes)
* [OpenShift v3.7.12](/stackpacks/integrations/openshift.md#release-notes)
* Dynatrace v1.4.2
* ServiceNow v5.3.3
* VMware vSphere v2.3.3

## StackState v4.6.x

### v4.6.1 (2022-04-05)

**Bug fixes**

- Fixed issue that incorrectly showed an error message when displaying a log stream. STAC-16222
- If the OIDC configuration is wrongly configured to obtain a username, the logging will show all fields that can be selected to obtain the username from. STAC-16027
- Security fixes for CVE-2022-24407. STAC-15939

### v4.6.0 (2022-03-04)

The StackState v4.6 release brings powerful new capabilities:

* Important improvements in topology visualization to accelerate troubleshooting.
* Support for OpenTelemetry traces, specifically for serverless AWS Lambda applications built with Node.js. This new low-latency data requires no integration, and will immediately enrich your topology with additional relationships and telemetry.
* Expanded Autonomous Anomaly Detection capabilities to automatically analyze the golden signals of throughput, latency and error rate. Automatic health checks can then run on this data and alert you as soon as anomalies are found. This will help you to get to the root cause of incidents more quickly and proactively prevent problems before they occur.

Details of the included improvements and bug fixes can be found below.

**Improvements**

- Topology synchronization progress counters have been moved from individual synchronizations to the `stackstate.log` file for Linux-based distributions. Errors for topology mapping and templates remain in the synchronization-specific logs. STAC-15529
- The MinIO chart now allows the registry to be configured separately from the repository. Also, the chart will now use any globally configured pull secrets to fetch Docker images. STAC-15180
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

## StackState v4.5.x

### v4.5.4 (2022-02-09)

**Bug fixes**

- Clears the following CVEs:
  - CVE-2022-23852 
  - CVE-2022-23990. STAC-15733
- Fixed timeline health state not showing up properly on views with trailing whitespace in the query. STAC-15662
- Fixed issue that incorrectly calculates Problem Clusters in certain circumstances. STAC-15657
- Remediation for CVE-2022-23307 by removing Log4J dependencies from StackGraph. STAC-15655
- Fixed issue that caused several pods to be stuck in Pending mode after an API key update. STAC-15525

### v4.5.4 (2022-02-01)

**Improvements**

- Internal Playground optimization. STAC-15393

### v4.5.3 (2022-01-21)

**Bug fixes**

- Fixed issue that caused the AAD to fail to authenticate with StackState. STAC-15278

### v4.5.2 (2022-01-14)

**Improvements**

- Added configuration options to Azure StackPack that allow specification of the Azure function name and the StackPack instance URL. STAC-14694

**Bug fixes**

- Fixed issue that caused a redirect to the Views Dashboard page when clicking on a component in a view that contains a slash in the identifier. STAC-15443
- Added missing documentation in Slack StackPack. STAC-15103
- Fixed issue that caused transaction logs to consume excessive storage space on Kubernetes. STAC-13922

### v4.5.1 (2021-12-17)

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

### v4.5.0 (2021-11-19)

**Features**

- The ability to create manual topology from the StackState UI has been removed. Please use the Static Topology StackPack to create components manually. STAC-14377
- Improved feedback from the topology synchronization service by exposing synchronization metrics via the CLI. STAC-13318
- Improved root cause analysis using subviews: modify your view to include additional components, show indirect relations and paths, [show grouped relations](/use/concepts/relations.md), save changed views even when timetravelling. STAC-13142
- Start anomaly detection on new streams after two hours. Adapt to changing streams in real-time. STAC-12996

**Improvements**

- Time travel directly to the start of a problem from the View and Problem details pane. STAC-14746
- AWS CloudWatch metrics can now be retrieved via an HTTPS proxy. STAC-14608
- The HBase minReplicationFactor is now automatically adjusted if it's higher than the replicaCount of the datanodes. STAC-14551
- Improve performance of view health state calculations under load. STAC-14056
- Support extra custom request parameters for OIDC. STAC-13999
- Link directly to possible root causes from Slack problem notifications. STAC-13802
- Check state changes always invoke auto propagation even if a CRITICAL state has been propagated before. STAC-13656
- Highlight exact changes when displaying Version Change, Health State Change or Run State Change events. STAC-13117
- Retain timeline settings when switching views. STAC-12745
- Component drag&drop functionality has been removed from the topology visualizer. Please use the Static Topology StackPack to create components manually. STAC-12718
- Support querying for problems in the Script API. STAC-12506
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