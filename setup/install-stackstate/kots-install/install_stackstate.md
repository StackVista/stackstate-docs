---
description: StackState SaaS
---

# Install StackState


## Overview 

Kubernetes Off The Shelf (KOTS) provides an embedded Kubernetes cluster on standard VMs. StackState can then be installed as an application within this cluster. This guide explains how to install KOTS, which then allows you to install StackState.

## Before you start

Before you start the installation of KOTS and StackState:

* Check the [requirements](/setup/install-stackstate/requirements.md#kots) to make sure that your VM environment fits the setup that you will use (HA, Non-HA, Online Install, Airgapped install).
* In addition to the standard requirements, make sure that all disks in the VMs are configured with one large single partition or set up as follows:

  - A 100GB partition.
  - 50GB of space available for `/var/lib`.
  - A separate disk of 500GB mounted at `/var/lib/longhorn`.
  - For an offline/Airgap install, at least 25GB available for `/tmp`.

## Install KOTS (online install)

{% hint style="info" %}
If full internet connectivity is available, an online install is recommended, otherwise an [Airgap install](/setup/install-stackstate/kots-install/install_stackstate_airgap.md) is required.
{% endhint %}

### Prerequisites

To install KOTS and StackState, you need to have:

- The correct number of VMs set up as described in [before you start](#before-you-start).
- A StackState KOTS installation license.
- If running HA, 3 nodes allocated to be masters and 5 nodes to be workers.

### Installation

  1. Connect to the master node of your cluster via SSH and run the command:
      
      ```
      curl -sSL https://k8s.kurl.sh/stackstate-beta | sudo bash
      ```

      This command will download and set up the embedded Kubernetes cluster. It will take 15-20 minutes to run, after which the system will show some commands to allow you to connect the other nodes. It will also output the following information that will be required later:
        - The commands needed to set up worker and master nodes.
        - A password that should be saved. This will be used later to access the KOTS console.
 
  2. Once the install has completed on the master node, copy/paste the commands provided to add the extra workers and, if running HA, optional master nodes as appropriate. The command will be similar to this:
   
     ```
     # Example Command
     curl -sSL https://kurl.sh/stackstate-beta/join.sh | sudo bash -s \
     kubernetes-master-address=1.2.3.4:6444 \
     kubeadm-token=asdfasdfasdf \
     kubeadm-token-ca-hash=sha256:a1b10bc55692dfa88c53odkdd69698fdec03009c9cd96d472851cf43f0a \
     docker-registry-ip=10.1.2.3.4 \
     kubernetes-version=v1.21.9 \
     secondary-host=172.31.1.1 \
     secondary-host=172.31.1.2 \
     primary-host=172.31.3.4 \
     primary-host=172.31.5.6 \
     secondary-host=172.31.5.7 \
     primary-host=172.31.9.10 \
     secondary-host=172.31.11.12 \
     secondary-host=172.31.12.13
     ```  
  
     **If you do not see these commands**, continue to complete the steps described below. New commands to add extra nodes can be generated later from **Cluster Management** in the KOTS Admin panel. For example, [http://1.2.3.4:8800/cluster/manager](http://1.2.3.4:8800/cluster/manager).

  3. Log in to the URL provided for the KOTS Admin Panel. This will be of the form [http://1.2.3.4:8800](http://1.2.3.4:8800). Use the password generated in step 1.

  4. Skip/set up the TLS certificate as needed following the onscreen prompts.

  5. Upload the StackState KOTS license file to the KOTS UI. If you do not have a license file, or the incorrect type please contact your StackState sales person or [StackState support](https://support.stackstate.com/).

  6. The KOTS UI will then direct you to the KOTS Admin screen to configure StackState.


   


