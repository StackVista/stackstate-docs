---
description: StackState Self-hosted v5.1.x 
---

# About the StackState Agent

## Overview

The StackState Agent functions as a collector and gateway. It connects to external systems to retrieve data and pushes this to StackState.

## About the Agent

### Architecture

StackState Agent V2 can be run on Linux or Windows systems or inside a Docker container. It is not necessary to deploy the StackState Agent on every machine to retrieve data. Each deployed StackState Agent can run multiple checks to collect data from different external systems.

![StackState Agent architecture](../../.gitbook/assets/stackstate-agent.svg)

* In [Docker Swarm mode](docker.md#docker-swarm-mode), the Cluster Agent is deployed on the manager node and one Agent on each node.
* On [Kubernetes or OpenShift](kubernetes.md) clusters, a single Cluster Agent is deployed per cluster and one Agent on each node. The Checks Agent runs checks that are configured on the Cluster Agent.

{% hint style="success" "self-hosted info" %}

The [Agent V1 \(Legacy\)](agent-v1.md) can be run on Linux.
{% endhint %}

### Integrations

In StackState, the [StackState Agent V2 StackPack](../../stackpacks/integrations/agent.md) includes all the settings required to integrate with a number of external systems. Data from other external systems can be retrieved by installing additional StackPacks in StackState.

To integrate with an external system, an Agent must be deployed in a location that can connect to both the external system and StackState. An Agent check configured on the Agent can then connect to the external system to retrieve data.

Documentation for the available StackState integrations, including how to configure the associated Agent checks, can be found on the [StackPacks &gt; Integrations pages](../../stackpacks/integrations/).

### Open source

StackState Agent V2 is open source and can be found on GitHub at: [https://github.com/StackVista/stackstate-agent](https://github.com/StackVista/stackstate-agent).

### Processes and overhead

StackState Agent V2 consists of up to four different processes - `stackstate-agent`, `trace-agent`, `process-agent` and `cluster-agent`. To run the basic Agent, the resources named below are required. These were observed running StackState Agent V2 v2.13.0 on a c5.xlarge instance with 4 vCPU cores and 8GB RAM. They give an indication of the overhead for the most simple set up. Actual resource usage will increase based on the Agent configuration running. This can be impacted by factors such as the Agent processes that are enabled, the number and nature of checks running, whether network connection tracking and protocol inspection are enabled, and the number of Kubernetes pods from which metrics are collected on the same host as the Agent.

{% tabs %}
{% tab title="stackstate-agent" %}
| Resource | Usage |
| :--- | :--- |
| CPU | ~0.18% |
| Memory | 95-100MB RAM |
| Disk space | 416MB \(includes `stackstate-agent`, `process-agent` and `trace-agent`\) |
{% endtab %}

{% tab title="process-agent" %}
| Resource | Usage |
| :--- | :--- |
| CPU | up to 0.96% |
| Memory | 52-56MB |
| Disk space | 416MB \(includes `stackstate-agent`, `process-agent` and `trace-agent`\) |
{% endtab %}

{% tab title="trace-agent" %}
| Resource | Usage |
| :--- | :--- |
| CPU | less than 0.04% |
| Memory | less than 16.8MB |
| Disk space | 416MB \(includes `stackstate-agent`, `process-agent` and `trace-agent`\) |
{% endtab %}
{% endtabs %}

On Kubernetes, limits are placed on CPU and memory usage of the Agent, Cluster Agent and Cluster checks. These can be configured in the [Agent Helm chart \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/cluster-agent).

## Running the Agent

### Deployment

Deployment instructions, commands to work with StackState Agent V2 and other platform-specific details can be found on the pages listed below:

* [StackState Agent V2 on Docker](docker.md)
* [StackState Agent V2 on Kubernetes](kubernetes.md)
* [StackState Agent V2 on Linux](linux.md)
* [StackState Agent V2 on Windows](windows.md)

### Connect to StackState

#### Receiver API address

StackState Agent connects to the StackState Receiver API at the configured address.

{% tabs %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="Kubernetes" %}[](http://not.a.link "StackState Self-Hosted only")
For StackState running on Kubernetes, the Receiver API is hosted by default at:[](http://not.a.link "StackState Self-Hosted only")

`https://<STACKSTATE_BASE_URL>/receiver/stsAgent`[](http://not.a.link "StackState Self-Hosted only")

The `<STACKSTATE_BASE_URL>` is set during StackState installation. For details see [Kubernetes install - configuration parameters](../../setup/install-stackstate/kubernetes_install/install_stackstate.md#generate-valuesyaml "StackState Self-Hosted only").
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")

{% tab title="Linux" %}[](http://not.a.link "StackState Self-Hosted only")
For StackState running on Linux, the Receiver API is hosted by default at:[](http://not.a.link "StackState Self-Hosted only")

`https://<STACKSTATE_RECEIVER_BASE_URL>/stsAgent`[](http://not.a.link "StackState Self-Hosted only")

The `<STACKSTATE_RECEIVER_BASE_URL>` is set during StackState installation. For details see [Linux install - configuration parameters](../../setup/install-stackstate/linux_install/install_stackstate.md#configuration-options-required-during-install "StackState Self-Hosted only").

{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="StackState SaaS" %}[](http://not.a.link "StackState Self-Hosted only")
For the StackState SaaS product, the StackState Receiver API address will be provided on the StackState UI Agent StackPack page after the StackPack has been installed.

[➡️ Go to the StackState SaaS product documentation](https://docs.stackstate.com/v/stackstate-saas/ "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}[](http://not.a.link "StackState Self-Hosted only")

#### Receiver API key

StackState Agent requires the StackState Receiver API key to communicate with the StackState Receiver API.

{% tabs %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="Kubernetes" %}[](http://not.a.link "StackState Self-Hosted only")
For StackState running on Kubernetes, the Receiver API Key is set during installation. For details see [StackState Kubernetes install - configuration parameters](../install-stackstate/kubernetes_install/install_stackstate.md#generate-values-yaml "StackState Self-Hosted only")

{% endtab %}[](http://not.a.link "StackState Self-Hosted only")

{% tab title="Linux" %}[](http://not.a.link "StackState Self-Hosted only")
For StackState running on Linux, the Receiver API Key is set during installation. For details see [StackState Linux install - configuration parameters](../install-stackstate/linux_install/install_stackstate.md#configuration-options-required-during-install "StackState Self-Hosted only") 

{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% tab title="StackState SaaS" %}[](http://not.a.link "StackState Self-Hosted only")
For the StackState SaaS product, the StackState Receiver API key will be provided on the StackState UI Agent StackPack page after the StackPack has been installed.

[➡️ Go to the StackState SaaS product documentation](https://docs.stackstate.com/v/stackstate-saas/ "StackState Self-Hosted only")
{% endtab %}[](http://not.a.link "StackState Self-Hosted only")
{% endtabs %}

### Troubleshooting

#### Log files and debug mode

For details of how to set the Agent log level to debug and access the Agent logs, see the platform-specific Agent pages:

* [StackState Agent V2 on Docker](docker.md#troubleshooting)
* [StackState Agent V2 on Kubernetes](kubernetes.md#troubleshooting)
* [StackState Agent V2 on Linux](linux.md#troubleshooting)
* [StackState Agent V2 on Windows](windows.md#troubleshooting)

#### Support knowledge base

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).


## Release notes

Release notes for StackState Agent V2 can be found on GitHub at: [https://github.com/StackVista/stackstate-agent/blob/master/stackstate-changelog.md](https://github.com/StackVista/stackstate-agent/blob/master/stackstate-changelog.md)

## See also

* [StackState Agent V2 StackPack](../../stackpacks/integrations/agent.md)
* [StackState integrations](../../stackpacks/integrations/)
* [StackState Agent V1 \(Legacy\)](agent-v1.md "StackState Self-Hosted only")
