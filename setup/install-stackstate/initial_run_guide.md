

# Initial run guide

## Overview

This page provides all the information you need to install and run StackState.

## Installation instructions

{% tabs %}
{% tab title="Kubernetes" %}
Install StackState on [Kubernetes](kubernetes_install/).
{% endtab %}

{% tab title="Linux" %}
Install StackState on [Linux](linux_install/).
{% endtab %}

{% tab title="OpenShift" %}
Install StackState on [OpenShift](openshift_install.md).
{% endtab %}
{% endtabs %}

## Address and port

{% tabs %}
{% tab title="Kubernetes" %}
To access the StackState UI:

1. [Enable a port-forward](kubernetes_install/install_stackstate.md#access-the-stackstate-ui).
2. Access the StackState UI at: [https://localhost:8080](https://localhost:8080)
{% endtab %}

{% tab title="Linux" %}
The StackState UI can be accessed using the `STACKSTATE_BASE_URL` specified during installation:

`https://STACKSTATE_BASE_URL:7070`
{% endtab %}

{% tab title="OpenShift" %}
To access the StackState UI:

1. [Enable a port-forward](openshift_install.md#access-the-stackstate-ui).
2. Access the StackState UI at: [https://localhost:8080](https://localhost:8080)
{% endtab %}
{% endtabs %}

## Default username and password

{% tabs %}
{% tab title="Kubernetes" %}
StackState is configured by default with the following administrator account:

* **username:** `admin`
* **password:** Set during installation. This is collected by the `generate_values.sh` script and stored in MD5 hash format in `values.yaml`
{% endtab %}

{% tab title="Linux" %}
StackState is configured by default with the following administrator account:

* **username:** `admin`
* **password:** `topology-telemetry-time`
{% endtab %}

{% tab title="OpenShift" %}
StackState is configured by default with the following administrator account:

* **username:** `admin`
* **password:** Set during installation. This is collected by the `generate_values.sh` script and stored in MD5 hash format in `values.yaml`
{% endtab %}
{% endtabs %}

## Troubleshooting

If you run into any problems during the installation of StackState or first run, check the [StackState installation troubleshooting guide](troubleshooting.md).

## Next steps

Once you have StackState up and running, you can get started setting up integrations

* [Install StackPacks to integrate with external systems](../../stackpacks/about-stackpacks.md)
* [Explore your topology and get to know the StackState UI](../../use/stackstate-ui/explore_mode.md)
* [Identify problems in the topology](../../use/problem-analysis/about-problems.md)

