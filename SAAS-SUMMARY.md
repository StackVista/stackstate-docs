# Table of contents

* [Welcome to the StackState Docs!](README.md)

## 🚀 Get started

* [Quick start guide](saas-quick-start-guide.md)
* [StackState walk-through](getting_started.md)
* [Concepts](use/concepts/README.md)
  * [The 4T data model](use/concepts/4t_data_model.md)
  * [Components](use/concepts/components.md)
  * [Health state](use/concepts/health-state.md)
  * [Relations](use/concepts/relations.md)
  * [Layers, Domains and Environments](use/concepts/layers_domains_environments.md)
  * [Perspectives](use/concepts/perspectives.md)
  * [Anomaly detection](use/concepts/anomaly-detection.md)
* [Glossary](use/glossary.md)

## 👤 StackState UI

* [Explore mode](use/stackstate-ui/explore_mode.md)
* [Filters](use/stackstate-ui/filters.md)
* [Views](use/stackstate-ui/views/README.md)
  * [About views](use/stackstate-ui/views/about_views.md)
  * [Create and edit views](use/stackstate-ui/views/create_edit_views.md)
  * [Configure the view health](use/stackstate-ui/views/configure-view-health.md)
  * [Manage event handlers](/use/stackstate-ui/views/manage-event-handlers.md)
  * [Visualization settings](use/stackstate-ui/views/visualization_settings.md)
* [Perspectives](use/stackstate-ui/perspectives/README.md)
  * [Topology Perspective](use/stackstate-ui/perspectives/topology-perspective.md)
  * [Events Perspective](use/stackstate-ui/perspectives/events_perspective.md)
  * [Traces Perspective](use/stackstate-ui/perspectives/traces-perspective.md)
  * [Metrics Perspective](use/stackstate-ui/perspectives/metrics-perspective.md)
* [Timeline and time travel](use/stackstate-ui/timeline-time-travel.md)
* [Keyboard shortcuts](use/stackstate-ui/keyboard-shortcuts.md)

## 🚦 Checks and monitors

* [Checks](use/checks-and-monitors/checks.md)
* [Add a health check](use/checks-and-monitors/add-a-health-check.md)
* [Anomaly health checks](use/checks-and-monitors/anomaly-health-checks.md)
* [Monitors](use/checks-and-monitors/monitors.md)
* [Add a custom monitor](develop/developer-guides/monitors/create-custom-monitors.md)
* [Manage monitors](use/checks-and-monitors/manage-monitors.md)
* [Monitor STJ format](develop/developer-guides/monitors/monitor-stj-file-format.md)

## 🛑 Problem analysis

* [About problems](use/problem-analysis/about-problems.md)
* [Investigate a problem](use/problem-analysis/problem_investigation.md)
* [Problem notifications](use/problem-analysis/problem_notifications.md)

## 📈 Metrics and events

* [Telemetry streams](use/metrics-and-events/telemetry_streams.md)
* [Golden signals](use/metrics-and-events/golden_signals.md)  
* [Top metrics](use/metrics-and-events/top-metrics.md)
* [Add a telemetry stream](use/metrics-and-events/add-telemetry-to-element.md)      
* [Browse telemetry](use/metrics-and-events/browse-telemetry.md)
* [Event notifications](use/metrics-and-events/event-notifications.md)
* [Set telemetry stream priority](use/metrics-and-events/set-telemetry-stream-priority.md)
* [Set up traces](configure/traces/set-up-traces.md)

## 🧩 StackPacks

* [About StackPacks](stackpacks/about-stackpacks.md)
* [Add-ons](stackpacks/add-ons/README.md)
  * [Autonomous Anomaly Detector](stackpacks/add-ons/aad.md)
  * [Health Forecast](stackpacks/add-ons/health-forecast.md)
* [Integrations](stackpacks/integrations/README.md)
  * [StackState Agent](setup/agent/README.md)
    * [About the StackState Agent](setup/agent/about-stackstate-agent.md)
    * [Agent V2 StackPack](stackpacks/integrations/agent.md)
    * [Agent V2 on Docker](setup/agent/docker.md)
    * [Agent V2 on Kubernetes](setup/agent/kubernetes.md)
    * [Agent V2 on Linux](setup/agent/linux.md)
    * [Agent V2 on OpenShift](setup/agent/openshift.md)
    * [Agent V2 on Windows](setup/agent/windows.md)
    * [Use an HTTP/HTTPS proxy](setup/agent/agent-proxy.md)
    * [Advanced Agent configuration](setup/agent/advanced-agent-configuration.md)
  * [AWS](stackpacks/integrations/aws/README.md)
    * [AWS](stackpacks/integrations/aws/aws.md)
    * [StackState/Agent IAM role: EC2](stackpacks/integrations/aws/aws-sts-ec2.md)
    * [StackState/Agent IAM role: EKS](stackpacks/integrations/aws/aws-sts-eks.md)
    * [AWS ECS](stackpacks/integrations/aws/aws-ecs.md)
    * [AWS X-ray](stackpacks/integrations/aws/aws-x-ray.md)
    * [OpenTelemetry - NodeJS](stackpacks/integrations/aws/opentelemetry-nodejs.md)
    * [Policies for AWS](stackpacks/integrations/aws/aws-policies.md)
  * [Kubernetes](stackpacks/integrations/kubernetes.md)
  * [OpenShift](stackpacks/integrations/openshift.md)
  * [Slack](stackpacks/integrations/slack.md)

## 📖 Reference

* [StackState Query Language \(STQL\)](develop/reference/stql_reference.md)
* [StackState Template JSON \(STJ\)](develop/reference/stj/README.md)
  * [Using STJ](develop/reference/stj/using_stj.md)
  * [Template functions](develop/reference/stj/stj_reference.md)
* [StackState CLI](setup/cli/cli-sts.md)
* [StackState SaaS release notes](setup/upgrade-stackstate/sts-saas-release-notes.md)
