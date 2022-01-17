---
description: StackState SaaS
---

# SaaS release notes

{% hint style="info" %}
Note that the release notes may include details of functionality that is currently only available in the StackState Self-Hosted product. 
{% endhint %}

## StackState v4.5.1

**Improvements**

- Adds compatibility with StackState Agent v2.15.0.
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

## StackState v4.5.x

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

**Features**

- The ability to create manual topology from the StackState UI has been removed. Please use the Static Topology StackPack in order to create components manually. STAC-14377
- Improved feedback from the topology synchronization service by exposing synchronization metrics via the CLI. STAC-13318
- Improved root cause analysis using subviews: modify your view to include additional components, show indirect relations and paths, [show grouped relations](/use/concepts/components_relations.md#relation-types), save changed views even when timetravelling. STAC-13142
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