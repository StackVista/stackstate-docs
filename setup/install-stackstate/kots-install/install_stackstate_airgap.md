---
description: StackState SaaS
---

## Install StackState Airgap

## Overview

For VMs that are not able to connect to the Internet, we provide an offline (Airgapped) install. This requires a number of files to be downloaded and copied to the servers that will make up your cluster.

## Install KOTS (Airgap install)

{% hint style="info" %}
If full internet connectivity is available, an [online install](/setup/install-stackstate/kots-install/install_stackstate.md) is recommended.
{% endhint %}

### Prerequisites

To install KOTS and StackState, you need to have:

- The correct number of VMs.
- A StackState KOTS installation license.
- If running HA, 3 nodes allocated to be masters and 5 nodes to be workers.


### Installation

1. Log in to the Replicated Vendor portal and select **Embedded Cluster**.
2. Download the **Latest Embedded Kubernetes Installer**. Copy the link or download the files as required.
3. Put this on every server that will be in the cluster, both workers and the master node(s).
4. Unpack the **Latest Embedded Kubernetes Installer** file .
   ```
   tar -zxf stackstate-beta.tar.gz
   ```

5. To install the master, run the command:
   ```
   cat install.sh | sudo bash -s airgap
   ```

   This will take 15-20 minutes to run, after which the system will show some commands to allow you to connect the other nodes. It will also output the following information that will be required later:
   - The commands needed to set up worker and master nodes.
   - A password that should be saved. This will be used later to access the KOTS console.
     
6. Once the install has completed on the master node, copy/paste the commands provided to add the extra workers and, if running HA, optional master nodes as appropriate. The command will be similar to this:
     ```
     # Example command
     cat ./join.sh | sudo bash -s airgap kubernetes-master-address=172.31.30.34:6444 kubeadm-token=vrok9z.0w9asdfadd9mzxqm kubeadm-token-ca-hash=sha256:58bddb14126e82377f29ab606dc62d9854af169b6290e05b2a1f310ed1e75d38 kubernetes-version=1.21.9 docker-registry-ip=10.96.2.220 primary-host=172.31.30.34
     ```

     **If you do not see these commands**, continue to complete the steps described below. New commands to add extra nodes can be generated later from **Cluster Management** in the KOTS Admin Panel. For example, [http://1.2.3.4:8800/cluster/manager](http://1.2.3.4:8800/cluster/manager).

7. From the Vendor Portal: 
   - Download **StackState Airgap Bundle** and place it on the master server. 
   - Download the license file and place it on the master server.
8. Install the Airgap bundle with the command:

   ```
   kubectl kots install stackstate --airgap=true -n default --airgap-bundle=airgap_file.tgz --license-file=license_file.yaml
   ```
  
10. Log in to the URL provided for KOTSADM which will be of the form [http://1.2.3.4:8800](http://1.2.3.4:8800). Use the password generated in step 1.

11. Skip/set up the TLS certificate as needed following the onscreen prompts.

12. The KOTS UI will then direct you to the KOTS Admin screen to configure StackState.
   
### Upgrade KOTS

1. To upgrade a KOTS Airgap install, download the updated Airgap file and copy it to your master server.
2. Run the command:

   ```
   kubectl kots upstream upgrade stackstate --airgap-bundle stackstate.airgap -n default
   ```
3. Log in to the KOTS admin screen to configure and deploy the new version.