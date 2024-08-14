---
description: Rancher Observability
---

# Certificates for request tracing sidecar injection

The [sidecar injection mechanism](/setup/agent/k8sTs-agent-request-tracing.md#enabling-the-trace-header-injection-sidecar), which gets enabled when using `--set httpHeaderInjectorWebhook.enabled=true` when installing the agent, creates a self-signed certificate and uses a `ClusterRole` which grants write access to `Secret` and `MutatingWebhookConfiguration` objects in the Kubernetes cluster.

If for security purposes it is undesirable to create `ClusterRoles` which grant cluster-wide write rights, or there are alternative ways to provide a certificate:

1. Generate a self-signed certificate [locally](#generate-a-certificate-locally).
1. Use the k8s [cert-manager](https://cert-manager.io/) (if it already on the cluster) [with a `ClusterIssuer`](#generate-a-certificate-using-the-cert-manager).

## Generate a certificate locally

To generate a certificate locally, take the following steps:

1. Download the certificate generation script and run it to produce a helm values (`tls_values.yaml`) file with the right certificate:
```
wget https://raw.githubusercontent.com/StackVista/http-header-injector/main/scripts/generate_ca_cert.sh
chmod +x generate_ca_cert.sh
./generate_ca_cert.sh <helm-agent-release-name> <helm-agent-namespace>
```
Be sure to use the release name that will be used in the helm command and the namespace, otherwise the certificate will be invalid.
2. Install the agent adding the additional configuration by adding `--set httpHeaderInjectorWebhook.enabled=true -f tls_values.yaml` to the helm invocation command

## Generate a certificate using the cert-manager

If your cluster has the [cert-manager](https://cert-manager.io/) installed, and a `ClusterIssuer` configured, it is possible to use the certificate issued by the `ClusterIssuer` in the agent for the sidecar injector. To do this, add the following command line arguments to install the agent: `--set httpHeaderInjectorWebhook.enabled=true --set-string httpHeaderInjectorWebhook.webhook.tls.mode="cert-manager" --set-string httpHeaderInjectorWebhook.webhook.tls.certManager.issuer="<my-cluster-issuer>"`. Be sure to replace my-cluster-issuer with the name of the issuer in your cluster.