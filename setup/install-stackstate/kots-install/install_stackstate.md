---
description: StackState Self-hosted v4.6.x
---

# Install StackState

## Before you start

KOTS is short  Kubernetes off the Shelf and provides an embedded Kubernetes clusters on standard VMs. StackState is then installed as an application within the cluster. This guide takes you through installing KOTS, which in turn then allows you to install StackState.

Before you start the installation of KOTS & StackState:

* Check the [requirements](/setup/install-stackstate/requirements.md#kots) to make sure that your VM environment fits the setup that you will use (HiA, Non-HA, Online Install, air gapped install).
* In addition to the requirements you need to make sure that your disks in your VM's are configured correctly. These requirements are to have one large single partition or setup as follows:-

  - Ensure a 100GB / partition
  - Ensure 50GB of space is available for /var/lib
  - Ensure a separate disk of 500GB is mounted at /var/lib/longhorn
  - If you are doing an offline/airgap install make sure /tmp is at least 25GB

## Install KOTS

### Prerequisites
  - You have the correct number of VM's setup for your installation.
  - If your machines have full internet connectivity then an online install is recommended otherwise an air gap install is required
  - You have a license provided by StackState for your KOTS installation
  - If running HA you have 3 nodes allocated to be masters and 5 nodes to be workers

### Install KOTS (Online Install)


  1. Connect to the master node of your cluster via SSH and run. 
      
      `curl -sSL https://k8s.kurl.sh/stackstate-beta | sudo bash`

      This command will download and setup the embedded Kubernetes cluster
      This will take 15-20 minutes to run after which the system will show some commands to allow you to connect the other nodes. It will also output information required later. 

        - The commands needed to setup worker and master nodes
        - A password that you need to save for later for accessing the KOTS console
 
  2. Once the master install is complete you need to copy/paste the commands provided to add the extra workers and, if running HA, optional master nodes as appropriate. The command will be similar to
   
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
  
     If you don't see these commands please complete the following steps but then go to "Cluster Management" within the KOTS Admin Panel (e.g. [http://1.2.3.4:8800/cluster/manager](http://1.2.3.4:8800/cluster/manager)) to generate new commands to add extra nodes

  3. Login to the URL provided for KOTS Admin Panel which will be of the form [http://1.2.3.4:8800](http://1.2.3.4:8800). Use the password generated in step 1.

  4. Skip/setup the TLS cert as needed following the onscreen prompts in your browswer.

  5. Upload your license file to the UI. If you do not have a license file, or the incorrect type please contact your sales person or <support@stackstate.com>

  6. The UI will then direct you to the admin screen to configure StackState
   


