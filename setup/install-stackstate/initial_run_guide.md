---
description: SUSE Observability Self-hosted
---

# Initial run guide

## Overview

This page provides all the information you need to install and run SUSE Observability.

## Installation instructions

{% tabs %}
{% tab title="Kubernetes" %}
Install SUSE Observability on [Kubernetes](kubernetes_openshift/).
{% endtab %}

{% tab title="OpenShift" %}
Install SUSE Observability on [OpenShift](kubernetes_openshift/openshift_install.md).
{% endtab %}
{% endtabs %}

## Address and port

{% tabs %}
{% tab title="Kubernetes" %}
To access the SUSE Observability UI:

1. [Enable a port-forward](kubernetes_openshift/kubernetes_install.md#access-the-suse-observability-ui).
2. Access the SUSE Observability UI at: [https://localhost:8080](https://localhost:8080)
{% endtab %}

{% tab title="OpenShift" %}
To access the SUSE Observability UI:

1. [Enable a port-forward](kubernetes_openshift/openshift_install.md#access-the-suse-observability-ui).
2. Access the SUSE Observability UI at: [https://localhost:8080](https://localhost:8080)
{% endtab %}
{% endtabs %}

## Default username and password

{% tabs %}
{% tab title="Kubernetes" %}
SUSE Observability is configured by default with the following administrator account:

* **username:** `admin`
* **password:** Set during installation. This is collected by the `generate_values.sh` script and stored in MD5 hash format in `values.yaml`
{% endtab %}

{% tab title="OpenShift" %}
SUSE Observability is configured by default with the following administrator account:

* **username:** `admin`
* **password:** Set during installation. This is collected by the `generate_values.sh` script and stored in MD5 hash format in `values.yaml`
{% endtab %}
{% endtabs %}

## Troubleshooting

If you run into any problems during the installation of SUSE Observability or first run, check the [SUSE Observability installation troubleshooting guide](troubleshooting.md).

## Next steps

Once you have SUSE Observability up and running, you can get started setting up integrations

* [Install StackPacks to integrate with external systems](../../k8s-quick-start-guide.md)
* [Explore your Kubernetes cluster](../../use/views/k8s-views.md)

