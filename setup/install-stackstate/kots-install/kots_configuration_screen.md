---
description: StackState Self-hosted v4.6.x
---

# KOTS/Stackstate Configuration Screen

{% hint style="warning" %}
**This page describes StackState version 4.6.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/setup/install-stackstate/kots-install/kots_configuration_screen).
{% endhint %}

## Overview

Kubernetes Off The Shelf (KOTS) allows embedded Kubernetes to run clusters on VMs and similar. This can be coupled with StackState to allow easier installation than a Helm-based install. Within the KOTS environment, a number of items can be configured to customise the installation of StackState

## Configuration options

### Configure StackState

The configuration screen has a number of options that allow the installation of StackState to be configured.

Configure the fields as required and then click **Continue**.

### CPU/memory settings

High Availability (HA) allows for protection against a failure of a single node, but will require more resources. An HA setup is recommended for production environments.

![](/.gitbook/assets/kots-ha-non-ha.png)

### Network settings

StackState can be accessed via HTTP and/or HTTPS. The hostname should be the IP or URL to the master server without `http://` or `https://`.
If needed, HTTP proxy can be used for event handlers. The HTTP proxy hostname should be either FQDN or IP-address.

### Persistent volume settings

By default, the Stackstate application uses a single-replica persistent volumes backed up by [Longhorn \(longhorn.io\)](https://longhorn.io/docs/). The data redundancy for StackState components like Kafka, Zookeper, HDFS, and Elasticsearch can be achieved by switching to two-replicas volumes.

Be aware that changing these settings after Stackstate is installed requires manual operations described in [Changing the number of replicas for Longhorn persistent volumes](/setup/install-stackstate/kots-install/cluster_management.md#changing-the-number-of-replicas-for-Longhorn-persistent-volumes).

![](/.gitbook/assets/kots-persistent-volume-settings.png)

### Add-ons

* The StackState [Autonomous Anomaly Detector](/stackpacks/add-ons/aad.md) will be installed by default.
* The [StackState Agent](/setup/agent/kubernetes.md) sends metrics to StackState from the Kubernetes cluster that it is running on.
* StackState Agent can optionally be configured to use [cluster-checks](/setup/agent/kubernetes.md#enable-cluster-checks).

![](/.gitbook/assets/kots-addons.png)

### Credentials

These are the passwords that should be used to log in to the StackState UI and the Admin API, and the API Key used by StackState Agents.

Once these are all configured, click **Save Config** and follow the prompts to deploy the app.

![](/.gitbook/assets/kots-creds.png)

### Authentication

Stackstate supports different authentication backends: File-based (default), LDAP, OIDC, and Keycloak. For more information on how to configure them refer to [Authentication options](https://docs.stackstate.com/configure/security/)

![](/.gitbook/assets/kots-authn.png)

### Automated backup

This section explains how to set up an automatic Cronjob backup for Elasticsearch and StackGraph.
A number of storage options are available for the backups: AWS S3, Azure Blob Storage, and NFS.

The backup needs a Kubernetes persistent volume. This can be configured as a single- or two-replicas Longhorn volume. Keep in mind that it is not possible to switch between the replicas mode without removing the backup persistent volume.

#### AWS
AWS backup requires AWS user credentials (AWS access and secret keys) with the read/write permissions on S3 buckets. The backups for Elasticsearch and StackGraph can be stored in different S3 buckets.

![](/.gitbook/assets/kots-backup-aws.png)

#### Azure Blob Storage
Azure backup requires setting the Azure storage account name, storage account key and Blob containers for both Elasticsearch and StackGraph backups.

![](/.gitbook/assets/kots-backup-azure.png)

#### NFS
NFS backup requires the NFS server's FQDN or IP-address, the NFS path to mount and paths within the server for Elasticsearch and StackGraph backups. If needed low-level NFS parameters like *mount options* and *uid*/*gid* can be set. For this type of backup a Kubernetes persistent volume of type NFS is provisioned.

![](/.gitbook/assets/kots-backup-nfs.png)

### SSL Settings

StackState has several points of interaction with external systems. For example, event handlers can call out to webhooks in other systems and plugins can retrieve data from external systems such as AWS or Elasticsearch. With the default configuration, StackState will not be able to communicate with these systems when they are secured with TLS using a self-signed certificate or a certificate that is not by default trusted by the JVM.
To mitigate this, StackState allows configuration of a custom Java trust store. For more information refer to [Create a custom trust store](https://docs.stackstate.com/configure/security/self-signed-certificates#create-a-custom-trust-store)


![](/.gitbook/assets/kots-ssl-settings.png)

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
