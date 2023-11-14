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
* [Customize](use/alerting/k8s-customize.md)
  * [Add a monitor using the CLI](use/alerting/k8s-add-monitors-cli.md)
  * [Override monitor arguments](use/alerting/k8s-override-monitor-arguments.md)

## 📈 Metrics

* [Explore Metrics](use/metrics/k8sTs-explore-metrics.md)
* [Custom charts](use/metrics/k8s-custom-charts.md)
  * [Adding custom charts to components](use/metrics/k8s-add-charts.md)
  * [Writing PromQL queries for representative charts](use/metrics/k8s-writing-promql-for-charts.md)
  * [Troubleshooting custom charts](/use/metrics/k8sTs-metrics-troubleshooting.md)
* [Advanced Metrics](use/metrics/k8s-advanced.md)
  * [Grafana Datasource](use/metrics/k8s-stackstate-grafana-datasource.md)
  * [Prometheus remote_write](use/metrics/k8s-prometheus-remote-write.md)
  * [OpenMetrics](use/metrics/open-metrics.md)


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
* [Timeline and time travel](use/stackstate-ui/k8sTs-timeline-time-travel.md)

## 🕵️ Agent
* [Network configuration](setup/k8s-network-configuration-saas.md)
* [Using a custom registry](setup/agent/k8s-custom-registry.md)
* [Request tracing](setup/agent/k8sTs-agent-request-tracing.md)
  * [Certificates for sidecar injection](setup/agent/k8sTs-agent-request-tracing-certificates.md)

## CLI
* [StackState CLI](setup/cli/k8sTs-cli-sts.md)

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
  * [Initial run guide](setup/install-stackstate/initial_run_guide.md)
  * [Troubleshooting](setup/install-stackstate/troubleshooting.md)
* [Upgrade StackState](setup/upgrade-stackstate/README.md)
  * [Steps to upgrade](setup/upgrade-stackstate/steps-to-upgrade.md)
  * [Version-specific upgrade instructions](setup/upgrade-stackstate/version-specific-upgrade-instructions.md)
* [Uninstall StackState](setup/install-stackstate/kubernetes_openshift/uninstall.md)
* [Air-gapped](setup/install-stackstate/kubernetes_openshift/no_internet/README.md)
  * [StackState air-gapped](setup/install-stackstate/kubernetes_openshift/no_internet/stackstate_installation.md)
  * [StackState Kubernetes Agent air-gapped](setup/install-stackstate/kubernetes_openshift/no_internet/agent_install.md)
* [Data management](setup/data-management/README.md)
  * [Backup and Restore](setup/data-management/backup_restore/README.md)
    * [Kubernetes backup](setup/data-management/backup_restore/kubernetes_backup.md)
    * [Configuration backup](setup/data-management/backup_restore/configuration_backup.md)
  * [Data retention](setup/data-management/data_retention.md)
  * [Clear stored data](setup/data-management/clear_stored_data.md)
* [Security](setup/security/README.md)
  * [Authentication](setup/security/authentication/README.md)
    * [Authentication options](setup/security/authentication/authentication_options.md)
    * [File-based](setup/security/authentication/file.md)
    * [LDAP](setup/security/authentication/ldap.md)
    * [Open ID Connect \(OIDC\)](setup/security/authentication/oidc.md)
    * [KeyCloak](setup/security/authentication/keycloak.md)
    * [Service tokens](setup/security/authentication/service_tokens.md)
  * [RBAC](setup/security/rbac/README.md)
    * [Role-based Access Control](setup/security/rbac/role_based_access_control.md)
    * [Permissions](setup/security/rbac/rbac_permissions.md)
    * [Roles](setup/security/rbac/rbac_roles.md)
    * [Scopes](setup/security/rbac/rbac_scopes.md)
  * [Self-signed certificates](setup/security/self-signed-certificates.md)


## 🔐 Security

* [Service Tokens](use/security/k8s-service-tokens.md)

## Reference
* [StackState Query Language \(STQL\)](/develop/reference/k8sTs-stql_reference.md)
* [Chart units](/develop/reference/k8sTs-chart-units.md)
