---
description: Important details for the first time you run a new StackState installation
---

# Initial run guide

## Overview

This page provides all the information you need to install and run StackState.

## Installation instructions

Instructions to install StackState can be found on the pages linked below.

{% tabs %}
{% tab title="Kubernetes" %}
Install StackState on [Kubernetes](/setup/installation/kubernetes_install).
{% endtab %}

{% tab title="Linux" %}
Install StackState on [Linux](/setup/installation/linux_install).
{% endtab %}

{% tab title="Openshift" %}
Install StackState on [Openshift](/setup/installation/openshift_install.md). 
{% endtab %}
{% endtabs %}

## Address and port

After installation, the StackState UI can be accessed at the address and port below.

{% tabs %}
{% tab title="Kubernetes" %}

1. [Enable a port-forward](/setup/installation/kubernetes_install/install_stackstate.md#access-the-stackstate-ui).
2. Access the StackState UI at: [https://localhost:8080](https://localhost:8080)

{% endtab %}

{% tab title="Linux" %}
`https://STACKSTATE_BASE_URL:7077`
{% endtab %}

{% tab title="Openshift" %}

1. [Enable a port-forward](/setup/installation/openshift_install.md#access-the-stackstate-ui).
2. Access the StackState UI at: [https://localhost:8080](https://localhost:8080)

{% endtab %}
{% endtabs %}

## Default username and password

StackState is configured by default with the following administrator account:

{% tabs %}
{% tab title="Kubernetes" %}
* **username:** `admin`
* **password:** Set during installation. This is collected by the `generate_values.sh` script and stored in MD5 hash format in `values.yaml`
{% endtab %}

{% tab title="Linux" %}
* **username:** `admin`
* **password:** `topology-telemetry-time`
{% endtab %}

{% tab title="Openshift" %}
* **username:** `admin`
* **password:** Set during installation. This is collected by the `generate_values.sh` script and stored in MD5 hash format in `values.yaml`
{% endtab %}
{% endtabs %}

## Troubleshooting

If you run into any problems during the installation of StackState or first run, check the [StackState installation troubleshooting guide](/setup/installation/troubleshooting.md).