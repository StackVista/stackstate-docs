---
description: SUSE Observability
---

# Installing SUSE Observability in Air-Gapped Mode

This document provides a step-by-step guide for installing SUSE Observability using Helm charts in an air-gapped environment. The process involves preparing the necessary Docker images and Helm charts on a host with internet access, transferring them to a host within a private network, copying Docker images to a private registry, and then deploying the Helm charts.

## Prerequisites

### On the Local Host (Internet Access)

- **Operating System**: Linux or MacOS
- **Tools Installed**:
  - [Docker](https://www.docker.com/products/docker-desktop/)
  - [Helm cli](https://helm.sh/docs/intro/install/)
  - Scripts for downloading Docker images from the source registry (links will be provided later in this guide).
- **Internet Access**: Required to pull Docker images from Quay.io and Helm charts from ChartMuseum.


### On the Private Network Host

- **Access**: SSH access to the host.
- **Tools Installed**:
  - [Docker](https://www.docker.com/products/docker-desktop/)
  - [Helm cli](https://helm.sh/docs/intro/install/)
  - Scripts for downloading Docker images from the source registry (links will be provided later in this guide).
  - Network access and credentials to upload images to a private Docker registry.
  - A configured Kubeconfig to install the Helm charts on the target clusters.

## Preparing the Docker Images and Helm Charts

Run the following commands on the local host to obtain the required Docker images and Helm charts:


**Adding Helm repositories to the local Helm cache:**

```bash
# Adding the Helm repository for SUSE Observability
helm repo add suse-observability https://charts.rancher.com/server-charts/prime/suse-observability
helm repo update
```

**Fetching the latest versions of the charts. These commands will download TGZ archives of the charts:**

```bash
# Downloading the chart for SUSE Observability
# The file will be named suse-observability-k8s-A.B.C.tgz
helm fetch suse-observability/suse-observability

# Downloading the helper chart that generates values for SUSE Observability
# The file will be named suse-observability-values-L.M.N.tgz
helm fetch suse-observability/suse-observability-values
```

**Downloading the Bash scripts to save Docker images:**

```bash
# o11y-get-images.sh
curl -LO https://raw.githubusercontent.com/StackVista/helm-charts/master/stable/suse-observability/installation/o11y-get-images.sh
# o11y-save-images.sh
curl -LO https://raw.githubusercontent.com/StackVista/helm-charts/master/stable/suse-observability/installation/o11y-save-images.sh

# Make the scripts executable
chmod a+x o11y-get-images.sh o11y-save-images.sh
```

**Extracting and Saving Docker Images:**

```bash
# Extract the list of images from the Helm chart and save it to a file.
./o11y-get-images.sh -f suse-observability-A.B.C.tgz > o11y-images.txt
```
{% hint style="info" %}
Replace `suse-observability-A.B.C.tgz` with the actual filename of the chart archive downloaded earlier.*
{% endhint %}


```bash
# Save Docker images to an archive.
# The script expects the file o11y-images.txt to contain the list of images used by SUSE Observability.
# The Docker images will be saved to o11y-images.tar.gz.
./o11y-save-images.sh -i o11y-images.txt -f o11y-images.tar.gz
```

## Copying the Required Files to the Remote Host

Copy the following files from the local host to the host in the private network:
- o11y-images.txt (List of images required by the SUSE Observability chart)
- o11y-images.tar.gz (An archive with the SUSE Observability's Docker images)
- [o11y-load-images.sh](https://raw.githubusercontent.com/StackVista/helm-charts/master/stable/suse-observability/installation/o11y-load-images.sh) (Bash script to upload Docker images to a registry)
- Helm charts downloaded earlier:
  - suse-observability-A.B.C.tgz
  - suse-observability-values-L.M.N.tgz

## Restoring Docker Images from the Archive to the Private Registry

**Upload the images to the private registry:**

```bash
# Load Docker images from the archive and push them to the private registry.
# Replace <private-registry> with your private registry's URL.
export DST_REGISTRY_USERNAME="..."
export DST_REGISTRY_PASSWORD="..."
./o11y-load-images.sh -d registry.example.com:5043 -i o11y-images.txt -f o11y-images.tar.gz
```

{% hint style="info" %}
If the destination registry doesn't use authentication the environment variables, `DST_REGISTRY_USERNAME` and `DST_REGISTRY_PASSWORD` must not be configured or have to be set to empty values.*
{% endhint %}

## Installing SUSE Observability

**Custom Helm values**

Installing SUSE Observability Helm charts in an air-gapped environment requires overriding the registries used in Docker image URLs. This can be achieved by customizing Helm values.

Create a private-registry.yaml file with the following content:

```yaml
global:
  imageRegistry: registry.example.com:5043
elasticsearch:
  prometheus-elasticsearch-exporter:
    image:
      repository: registry.example.com:5043/suse-observability/elasticsearch-exporter
victoria-metrics-0:
  server:
    image:
      repository: registry.example.com:5043/suse-observability/victoria-metrics
victoria-metrics-1:
  server:
    image:
      repository: registry.example.com:5043/suse-observability/victoria-metrics
```

This guide follows the [Installing a default HA setup for up to 250 Nodes](https://docs.stackstate.com/get-started/k8s-suse-rancher-prime#installing-a-default-ha-setup-for-up-to-250-nodes) setup, but instead of using publicly available Helm and Docker repositories/registries, it uses pre-downloaded Helm archives and private Docker registries.


**Command to Generate Helm Chart Values File:**

{% code title="helm_template.sh" lineNumbers="true" %}
```text
helm template \
    --set license='<licenseKey>' \
    --set baseUrl='<baseURL>' \
    --set pullSecret.username='trial' \
    --set pullSecret.password='trial' \
    suse-observability-values suse-observability-values-L.M.N.tgz\
     > values.yaml
```
{% endcode %}

**Deploying the SUSE Observability Helm Chart:**

{% code title="helm_deploy.sh" lineNumbers="true" %}
```text
helm upgrade --install \
    --namespace suse-observability \
    --create-namespace \
    --values values.yaml \
    --values private-registry.yaml \
    suse-observability \
    suse-observability-A.B.C.tgz
```
{% endcode %}

**Validating the Deployment:**

```bash
kubectl get pod -n suse-observability
```
