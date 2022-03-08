---
description: StackState SaaS
---

# KOTS/Stackstate Configuration Screen

## Overview

Kubernetes Off The Shelf (KOTS) allows embedded Kubernetes to run clusters on VMs and similar. This can be coupled with StackState to allow easier installation than a Helm-based install. Within the KOTS environment, a number of items can be configured to customise the installation of StackState

## Configuration options

### Configure StackState

The configuration screen has a number of options that allow the installation of StackState to be configured.

Configure the fields as required and then click **Continue**.
 
### HA vs Non HA

High Availability (HA) allows for protection against a failure of a single node, but will require more resources. An HA setup is recommended for production environments.

![](/.gitbook/assets/kots-ha-non-ha.png)

### Network settings

StackState can be accessed via HTTP and/or HTTPS.  The hostname should be the IP or URL to the master server without `http://` or `https://`.

![](/.gitbook/assets/kots-network-settings.png)

### Add-ons

* The StackState [Autonomous Anomaly Detector](/stackpacks/add-ons/aad.md) will be installed by default.
* The [StackState Agent](/setup/agent/kubernetes.md) sends metrics to StackState from the Kubernetes cluster that it is running on.
* StackState Agent can optionally be configured to use [cluster-checks](/setup/agent/kubernetes.md#enable-cluster-checks).

![](/.gitbook/assets/kots-addons.png)

### Credentials

These are the passwords that should be used to log in to the StackState UI and the Admin API, and the API Key used by StackState Agents.

Once these are all configured, click **Save Config** and follow the prompts to deploy the app.

![](/.gitbook/assets/kots-creds.png)

### Pre-flight checks

The cluster will perform a number of pre-flight checks to make sure that it has enough resources. Once these have completed, a results screen similar to that shown below will be displayed. Click **Continue** to deploy StackState. 

Once the Status shows green, StackState can be accessed at the URL provided on the [configuration screen](#configure-stackstate).

![](/.gitbook/assets/kots-Pre-flight-checks.png)

## Automatic Kubernetes support

StackState has built-in support for Kubernetes by means of the [Kubernetes StackPack](../../../stackpacks/integrations/kubernetes.md). To get started quickly, select to install this on the KOTS configuration screen. This will automatically install the Kubernetes StackPack, a Daemonset for the Agent and a deployment for the Cluster Agent. For full details, read the page [Kubernetes StackPack](../../../stackpacks/integrations/kubernetes.md).

## Next Steps

* Install [StackPacks](../../../stackpacks/about-stackpacks.md) to start receiving data in StackState.
* Give your [co-workers access](../../../configure/security/authentication/) to StackState.
* For more information on KOTS, visit [KOTS.io](https://kots.io).