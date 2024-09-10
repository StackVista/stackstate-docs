---
description: SUSE Observability Self-hosted
---

# Clear stored data

The data in SUSE Observability is divided into four different sets:

* Elasticsearch data
* Kafka Topic data
* StackGraph data
* Metrics data

With this much data to store, it's important to have the means to manage it. There is a standard 30 days data retention period set in SUSE Observability. This can be configured according to your needs using the SUSE Observability CLI. Find out more about [SUSE Observability data retention](data_retention.md).

## Clear data manually

To clear stored data in SUSE Observability running on Kubernetes, it's recommended to run a clean install:

1. [Uninstall SUSE Observability](../install-stackstate/kubernetes_openshift/uninstall.md#un-install-the-helm-chart)
2. [Remove all PVC's](../install-stackstate/kubernetes_openshift/uninstall.md#remove-remaining-resources)
3. Install SUSE Observability again using the same configuration as before, on [Kubernetes](../install-stackstate/kubernetes_openshift/kubernetes_install.md#deploy-suse-observability-with-helm) or [OpenShift](../install-stackstate/kubernetes_openshift/openshift_install.md#deploy-suse-observability-with-helm). 
