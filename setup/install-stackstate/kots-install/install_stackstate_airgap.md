---
description: StackState Self-hosted v4.6.x
---

## Install KOTS

### Prerequisites
  - You have the correct number of VM's setup for your installation.
  - You have a license provided by StackState for your KOTS installation
  - If running HA you have 3 nodes allocated to be masters and 5 nodes to be workers

### Install KOTS (Airgap Install)

  1. Login to the Replicated Vendor portal and select "Embedded Cluster"
  2. Download the "Latest Embedded Kubernetes Installer". You can copy the link or download the files as required.
  3. Put this on every server that will be in the cluster, both workers and the master node(s)
  4. Unpack the "Latest Embedded Kubernetes Installer" file 

     `tar -zxf stackstate-beta.tar.gz`

  5. To install the master run 

     `cat install.sh | sudo bash -s airgap`

       This will take 15-20 minutes to run after which the system will show some commands to allow you to connect the other nodes. It will also output information required later. 
        - The commands needed to setup worker and master nodes
        - A password that you need to save for later for accessing the KOTS console
 
  6. Once the master install is complete you need to copy/paste the commands provided to add the extra workers, and if running HA the optional other master nodes. The command will be similar to
     
    ```
    # Example command
    cat ./join.sh | sudo bash -s airgap kubernetes-master-address=172.31.30.34:6444 kubeadm-token=vrok9z.0w9asdfadd9mzxqm kubeadm-token-ca-hash=sha256:58bddb14126e82377f29ab606dc62d9854af169b6290e05b2a1f310ed1e75d38 kubernetes-version=1.21.9 docker-registry-ip=10.96.2.220 primary-host=172.31.30.34
    ```
  
  If you don't see these commands please complete the following steps but then goto "Cluster Management" (e.g. [http://1.2.3.4:8800/cluster/manager](http://1.2.3.4:8800/cluster/manager)) to generate new commands to add extra nodes

  7. From the Vendor Portal Download "StackState Airgap Bundle" and place it on the master server.
  8. From the Vendor Portal Download the license file and place it on the master server 
  9. Install the airgap bundle with the command

   `kubectl kots install stackstate --airgap=true -n default --airgap-bundle=airgap_file.tgz --license-file=license_file.yaml`

  
  10. Login to the URL provided for KOTSADM which will be of the form [http://1.2.3.4:8800](http://1.2.3.4:8800). Use the password generated in step 1.

  11. Skip/setup the TLS cert as needed following the onscreen prompts

  12. The UI will then direct you to the admin screen to configure StackState
   


