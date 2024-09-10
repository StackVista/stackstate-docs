---
description: SUSE Observability
---

# Networking configuration

SUSE Observability is a SaaS offering that's hosted in the cloud. To be able to communicate from your premises/cloud to the SUSE Observability SaaS, the SUSE Observability Agent needs to be able to connect to the SUSE Observability SaaS Receiver API.
When your cluster is running in a private network, you might need to configure your network to allow the SUSE Observability Agent to connect to the SUSE Observability Receiver API, because your network configuration might disallow egress traffic to the internet. This page describes how to configure your network to allow to install the SUSE Observability Agent, as well as to allow the SUSE Observability Agent to communicate with the SUSE Observability Receiver API.

{% hint style="info" %}
Traffic between the SUSE Observability Agent and the SUSE Observability Receiver API is always initiated by the SUSE Observability Agent. The SUSE Observability Receiver API doesn't initiate any traffic to the SUSE Observability Agent.
{% endhint %}

## SUSE Observability Agent installation

The installation of the SUSE Observability Agent is done through Helm. By default the Helm Chart is configured to pull the SUSE Observability Agent container images from the Quay.io docker registry. If your network configuration disallows egress traffic to the internet, you have a number of options to install the SUSE Observability Agent:

1. Configure your network to allow egress traffic to the Quay.io container registry from your Kubernetes cluster.
2. Proxy the Quay.io container registry through your own container registry.
3. Pull the Docker images into your own container registry.

For option 2 and 3, you need to configure the Helm Chart to pull the SUSE Observability Agent container images from your own container registry. A guide to configure the SUSE Observability Agent Helm Chart to pull images from your own container registry can be found [here](/k8s-suse-rancher-prime-agent-air-gapped.md).


## SUSE Observability Agent communication

The SUSE Observability Agent communicates with the SUSE Observability Receiver API over HTTPS. The different parts of the SUSE Observability Agent connect to the SUSE Observability Receiver API, hosted in your tenant in, see the following diagram:

![SUSE Observability Agent communication](../.gitbook/assets/k8s/k8s-agent-communication.png)

All communication is done over HTTPS, using the standard HTTPS port 443. The SUSE Observability Agent uses the following endpoints to communicate with the SUSE Observability Receiver API:

* **https://&lt;tenant&gt;.app.stackstate.io/receiver/stsAgent** - the SUSE Observability Agent sends metrics, events and topology data to the SUSE Observability Receiver API.

In order to allow the SUSE Observability Agent to communicate with the SUSE Observability Receiver API, you need to configure your network to allow egress traffic to the SUSE Observability Receiver API. The SUSE Observability Receiver API is hosted in the cloud and has an specific IP specific for your tenant. You need to allow egress traffic to the internet. In order to obtain the correct IP addresses to allow egress traffic to, you can use the following command:

```bash
$ dig +short <tenant>.app.stackstate.io
```

Alternatively, you can visit the following URL in your browser: `https://www.nslookup.io/domains/<tenant>.app.stackstate.io/dns-records/`
