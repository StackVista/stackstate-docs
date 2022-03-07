---
description: StackState SaaS
---

# SaaS release notes

{% hint style="info" %}
Note that the release notes may include details of functionality that is currently only available in the StackState Self-Hosted product. 
{% endhint %}

## StackState v4.6.x

### 4.6.0 (04-03-2022)

The StackState 4.6 release brings powerful new capabilities:

* Important improvements in topology visualization to accelerate troubleshooting.
* Support for OpenTelemetry traces, specifically for serverless AWS Lambda applications built with Node.js. This new low-latency data requires no integration, and will immediately enrich your topology with additional relationships and telemetry.
* Expanded Autonomous Anomaly Detection capabilities to automatically analyze the golden signals of throughput, latency and error rate. Automatic health checks can then run on this data and alert you as soon as anomalies are found. This will help you to get to the root cause of incidents more quickly and proactively prevent problems before they occur.

Details of the included improvements and bug fixes can be found below.

**Improvements**

- Topology synchronization progress counters have been moved from individual synchronizations to the `stackstate.log` file for Linux-based distributions. Errors for topology mapping and templates remain in the synchronization-specific logs. STAC-15529
- The MinIO chart now allows the registry to be configured separately from the repository. Also, the chart will now use any globally configured pull secrets to fetch Docker images. STAC-15180
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

## StackState v4.5.x

### 4.5.4 (2022-02-09)

**Bug fixes**

- Clears the following CVEs:
  - CVE-2022-23852 
  - CVE-2022-23990. STAC-15733
- Fixed timeline health state not showing up properly on views with trailing whitespace in the query. STAC-15662
- Fixed issue that incorrectly calculates Problem Clusters in certain circumstances. STAC-15657
- Remediation for CVE-2022-23307 by removing Log4J dependencies from StackGraph. STAC-15655
- Fixed issue that caused several pods to be stuck in Pending mode after an API key update. STAC-15525

### 4.5.4 (2022-02-01)

**Improvements**

- Internal Playground optimization. STAC-15393

### 4.5.3 (2022-01-21)

**Bug fixes**

- Fixed issue that caused AAD to fail to authenticate with StackState. STAC-15278

### v4.5.2 (2022-14-01)

**Improvements**

- Added configuration options to Azure StackPack that allow specification of the Azure function name and the StackPack instance URL. STAC-14694

**Bug fixes**

- Fixed issue that caused a redirect to the Views Dashboard page when clicking on a component in a view that contains a slash in the identifier. STAC-15443
- Added missing documentation in Slack StackPack. STAC-15103
- Fixed issue that caused transaction logs to consume excessive storage space on Kubernetes. STAC-13922

### v4.5.1 (2021-12-17)

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

### v4.5.0 (2021-11-19)

**Features**

- The ability to create manual topology from the StackState UI has been removed. Please use the Static Topology StackPack in order to create components manually. STAC-14377
- Improved feedback from the topology synchronization service by exposing synchronization metrics via the CLI. STAC-13318
- Improved root cause analysis using subviews: modify your view to include additional components, show indirect relations and paths, [show grouped relations](/use/concepts/relations.md), save changed views even when timetravelling. STAC-13142
- Start anomaly detection on new streams after two hours.  Adapt to changing streams in real-time. STAC-12996

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
- Component drag&drop functionality has been removed from the topology visualizer. Please use the Static Topology StackPack in order to create components manually. STAC-12718
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