---
description: StackState Self-hosted v4.6.x
---

# KOTS/Stackstate Configuration Screen

### Configure Stackstate

The configuration screen has a number of options that allow you to configure the install of StackState

Configure the fields as required and then press continue
 
### HA vs Non HA

  - ![](/images/kots/ha-non-ha.png)

HA allows for protection against a failure of a single node, but will require more resources. By default we recommend HA for production environments

### Network settings

 - ![](/images/kots/network-settings.png)

The hostname should be the IP or URL to the master server without http or https
You can also choose if you want to access StackState via HTTP and/or HTTPS. 

### Add-ons

 - ![](/images/kots/addons.png)

By default, StackState will install its Autonomous Anomaly Detector. For more details please see https://docs.stackstate.com/stackpacks/add-ons/aad

The StackState Agent sends metrics to StackState from the Kubernetes cluster it is running on. For more details please see https://docs.stackstate.com/setup/agent/kubernetes

For more details on cluster-checks see https://docs.stackstate.com/setup/agent/kubernetes#enable-cluster-checks

### Credentials

 - ![](/images/kots/creds.png)

Here you set the password used to login to the UI, the password for the API as well as the API

Once these are all configured click "Save Config" and follow the prompts to deploy the app 

### Pre-flight checks

The cluster will perform a number of pre-flight checks to make sure that the cluster has enough resources. 


Once the preflights have configured you should see a screen similar to the following

![](/images/kots/Pre-flight-checks.png)

Click Continue 

The system will deploy Stackstate. Once the Status shows green you can access Stackstate at the URL you entered on the config screen

For more information on kots you can visit [KOTS.io](https://kots.io)

## Next Steps

* Install a [StackPack](../../../stackpacks/about-stackpacks.md) or two
* Give your [co-workers access](../../../configure/security/authentication/)

## Automatic Kubernetes support

StackState has built-in support for Kubernetes by means of the [Kubernetes StackPack](../../../stackpacks/integrations/kubernetes.md). To get started quickly, you can select to install this on the configuration screen within KOTS. This will then automatically install the StackPack and install a Daemonset for the agent and a deployment for the so called cluster agent. For the full details, read the [Kubernetes StackPack](../../../stackpacks/integrations/kubernetes.md) page.
