---
description: StackState Self-hosted v4.6.x
---

# KOTS/Stackstate Configuration Screen

## Overview

KOTS (Kubernetes off the Shelf) allow you to run embedded Kubernetes clusters on VM's and similar. This is coupled with StackState to allow easier installation than Helm based installs. Within the KOTS environment we allow you to configure a number of items to customise your install of StackState

## Configuration options

### Configure StackState

The configuration screen has a number of options that allow you to configure the install of StackState

Configure the fields as required and then click **Continue**.
 
### HA vs Non HA

High Availability (HA) allows for protection against a failure of a single node, but will require more resources. A HA setup is recommended for production environments

![](/.gitbook/assets/kots-ha-non-ha.png)

### Network settings

You can also choose to access StackState via HTTP and/or HTTPS.  The hostname should be the IP or URL to the master server without `http://` or `https://`.

![](/.gitbook/assets/kots-network-settings.png)

### Add-ons

* The StackState [Autonomous Anomaly Detector](/stackpacks/add-ons/aad.md) will be installed by default.
* The [StackState Agent](/setup/agent/kubernetes.md) sends metrics to StackState from the Kubernetes cluster it is running on.
* The StackState Agent can optionally be configured to use [cluster-checks](/setup/agent/kubernetes.md#enable-cluster-checks).

![](/.gitbook/assets/kots-addons.png)

### Credentials

The passwords that should be used to log in to the StackState UI and the Admin API, and the API Key used by StackState Agents.

Once these are all configured, click **Save Config** and follow the prompts to deploy the app.

![](/.gitbook/assets/kots-creds.png)

### Pre-flight checks

The cluster will perform a number of pre-flight checks to make sure that it has enough resources. Once these have completed, a results screen similarwill be displayed. Click **Continue** to deploy Stackstate. 

Once the Status shows green, StackState can be accessed at the URL provided on the [configuration screen](#configure-stackstate).

![](/.gitbook/assets/kots-Pre-flight-checks.png)

## Automatic Kubernetes support

StackState has built-in support for Kubernetes by means of the [Kubernetes StackPack](../../../stackpacks/integrations/kubernetes.md). To get started quickly, select to install this on the KOTS configuration screen. This will automatically install the Kubernetes StackPack, a Daemonset for the Agent and a deployment for the Cluster Agent. For the full details, read the [Kubernetes StackPack](../../../stackpacks/integrations/kubernetes.md) page.

## Next Steps

* Install [StackPacks](../../../stackpacks/about-stackpacks.md) to start receiving data in StackState.
* Give your [co-workers access](../../../configure/security/authentication/) to StackState.
* For more information on KOTS, visit [KOTS.io](https://kots.io).