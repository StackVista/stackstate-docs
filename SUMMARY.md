# Table of contents

* [StackState for K8s troubleshooting docs!](README.md)
* [Docs for all StackState products](classic.md)

## 🚀 Get started

* [Quick start guide](k8s-quick-start-guide.md)
* [StackState walk-through](k8s-getting-started.md)

## 🦮 Guided troubleshooting

* [What is guided troubleshooting?](use/troubleshooting/k8s-guided-troubleshooting.md)
* [YAML Configuration](use/troubleshooting/k8s-configuration.md)
* [Changes](use/troubleshooting/k8s-changes.md)
* [Logs](use/troubleshooting/k8s-logs.md)

## 🚨 Monitors and alerts

* [Monitors](use/alerting/k8s-monitors.md)
* [Out of the box monitors for Kubernetes](use/alerting/kubernetes-monitors.md)
* [Alerts](use/alerting/event-handlers.md)

## 📈 Metrics

* [Advanced](use/metrics/k8s-advanced.md)
  * [Grafana Datasource](use/metrics/k8s-stackstate-grafana-datasource.md)
  * [Prometheus remote_write](use/metrics/k8s-prometheus-remote-write.md)

## 🔍 Views

* [Kubernetes views](use/views/k8s-views.md)
* [Custom views](use/views/k8s-custom-views.md)
* [Component views](use/views/k8s-component-views.md)
* [Explore views](use/views/k8s-explore-views.md)
* [View structure](use/views/k8s-view-structure.md)
  * [Filters](use/views/k8s-filters.md)
  * [Overview perspective](use/views/k8s-overview-perspective.md)
  * [Highlights perspective](use/views/k8s-highlights-perspective.md)
  * [Topology perspective](use/views/k8s-topology-perspective.md)
  * [Events perspective](use/views/k8s-events-perspective.md)
  * [Metrics perspective](use/views/k8s-metrics-perspective.md)
  * [Traces perspective](use/views/k8s-traces-perspective.md)
* [Timeline and time travel](use/stackstate-ui/k8sTs-timeline-time-travel.md)

## 🕵️ Agent
* [Network configuration](setup/k8s-network-configuration-saas.md)
* [Using a custom registry](setup/agent/k8s-custom-registry.md)

## 🚀 Self-hosted setup
* [Install StackState](setup/install-stackstate/README.md)
  * [Requirements](setup/install-stackstate/requirements.md)
  * [Kubernetes / OpenShift](setup/install-stackstate/kubernetes_openshift/README.md)
    * [Kubernetes install](setup/install-stackstate/kubernetes_openshift/kubernetes_install.md)
    * [OpenShift install](setup/install-stackstate/kubernetes_openshift/openshift_install.md)
    * [Required Permissions](setup/install-stackstate/kubernetes_openshift/required_permissions.md)
    * [Non-high availability setup](setup/install-stackstate/kubernetes_openshift/non_high_availability_setup.md)
    * [Override default configuration](setup/install-stackstate/kubernetes_openshift/customize_config.md)
    * [Configure storage](setup/install-stackstate/kubernetes_openshift/storage.md)
    * [Exposing StackState outside of the cluster](setup/install-stackstate/kubernetes_openshift/ingress.md)
    * [Migrate from Linux install](setup/install-stackstate/kubernetes_openshift/migrate_from_linux.md)
  * [Initial run guide](setup/install-stackstate/initial_run_guide.md)
  * [Troubleshooting](setup/install-stackstate/troubleshooting.md)
* [Upgrade StackState](setup/upgrade-stackstate/README.md)
  * [Steps to upgrade](setup/upgrade-stackstate/steps-to-upgrade.md)
  * [Version specific upgrade instructions](setup/upgrade-stackstate/version-specific-upgrade-instructions.md)
* [StackState CLI](setup/cli/k8sTs-cli-sts.md)
* [Data management](setup/data-management/README.md)
  * [Backup and Restore](setup/data-management/backup_restore/README.md)
    * [Kubernetes backup](setup/data-management/backup_restore/kubernetes_backup.md)
    * [Linux backup](setup/data-management/backup_restore/linux_backup.md)
    * [Configuration backup](setup/data-management/backup_restore/configuration_backup.md)
  * [Data retention](setup/data-management/data_retention.md)
  * [Clear stored data](setup/data-management/clear_stored_data.md)

## 🔐 Security

* [Service Tokens](use/security/k8s-service-tokens.md)
