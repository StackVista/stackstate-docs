---
description: StackState for Kubernetes troubleshooting Self-hosted
---

# Networking configuration

StackState for K8s Troubleshooting is a SaaS offering that is hosted in the cloud. To be able to communicate from your premises/cloud to our SaaS, the StackState Agent needs to be able to connect to the StackState SaaS Receiver API.
When your cluster is running in a private network, you might need to configure your network to allow the StackState Agent to connect to the StackState Receiver API, because your network configuration might disallow egress traffic to the internet. This page describes how to configure your network to allow to install the StackState Agent, as well as to allow the StackState Agent to communicate with the StackState Receiver API.

{% hint style="info" %}
Traffic between the StackState Agent and the StackState Receiver API is always initiated by the StackState Agent. The StackState Receiver API doesn't initiate any traffic to the StackState Agent.
{% endhint %}

## StackState Agent installation

The installation of the StackState Agent is done through Helm. By default the Helm Chart is configured to pull the StackState Agent container images from the Quay.io docker registry. If your network configuration disallows egress traffic to the internet, you have a number of options to install the StackState Agent:

1. Configure your network to allow egress traffic to the Quay.io container registry from your Kubernetes cluster.
2. Proxy the Quay.io container registry through your own container registry.
3. Pull the Docker images into your own container registry.

For option 2 and 3, you need to configure the Helm Chart to pull the StackState Agent container images from your own container registry. A guide to configure the StackState Agent Helm Chart to pull images from your own container registry can be found [here](/setup/agent/k8s-custom-registry.md).


## StackState Agent communication

The StackState Agent communicates with the StackState Receiver API over HTTPS. The different parts of the StackState Agent connect to the StackState Receiver API, hosted in your tenant in, see the following diagram:

![StackState Agent communication](../.gitbook/assets/k8s/k8s-agent-communication.png)

All communication is done over HTTPS, using the standard HTTPS port 443. The StackState Agent uses the following endpoints to communicate with the StackState Receiver API:

* **https://&lt;tenant&gt;.app.stackstate.io/receiver/stsAgent** - the StackState Agent sends metrics, events and topology data to the StackState Receiver API.

In order to allow the StackState Agent to communicate with the StackState Receiver API, you need to configure your network to allow egress traffic to the StackState Receiver API. The StackState Receiver API is hosted in the cloud and has an specific IP specific for your tenant. You need to allow egress traffic to the internet. In order to obtain the correct IP addresses to allow egress traffic to, you can use the following command:

```bash
$ dig +short <tenant>.app.stackstate.io
```

Alternatively, you can visit the following URL in your browser: `https://www.nslookup.io/domains/<tenant>.app.stackstate.io/dns-records/`
