---
description: StackState Self-hosted v5.0.x 
---

# Embedded cluster management

## Overview

This page describes a number of advanced cluster administration scenarios.

## Longhorn

Storage within a kURL embedded cluster is [managed by Longhorn \(kurl.sh\)](https://kurl.sh/docs/add-ons/longhorn). [Longhorn \(longhorn.io\)](https://longhorn.io) is a storage manager originally developed by Rancher and now a CNCF incubating project. By default, Longhorn will keep 3 replicas of each volume within the cluster so that the failure of a single node does not cause data to be lost. For the backend services of StackState, we've configured Longhorn to use 2 replicas for each volume to reduce disk space requirements.

### Access the Longhorn UI

To manage the Longhorn storage cluster, expose the Longhorn UI as follows:

1. From your local machine, SSH into the first node and start a port-forward to an open port on your local machine:
    ```
    ssh -L 30881:localhost:30881 USER@HOST
    ```

1. Start the Longhorn UI by scaling up its deployment:
    ```
    kubectl scale -n longhorn-system deployment longhorn-ui --replicas=1
    ```

1. Start a port-forward to the longhorn-frontend service using the port number chosen in step 1, 30881 in this case:
    ```
    kubectl port-forward -n longhorn-system service/longhorn-frontend 30881:80
    ```

1. On your local machine, connect to the Longhorn UI at [http://localhost:30881/](http://localhost:30881/)

The UI should look something like this:

![Longhorn UI dashboard](/.gitbook/assets/kurl-longhorn-ui-dashboard.png)

### Stop the Longhorn UI

To stop the Longhorn UI, scale down its deployment:

```
kubectl scale -n longhorn-system deployment longhorn-ui --replicas=0
```

### Use kubectl to get Longhorn information

The `kubectl` command can be used to get more information about the Longhorn storage system. For example:

* View all nodes:
    ```
    kubectl get -n longhorn-system nodes.v1beta1.longhorn.io
    ```

* View detailed information for a node:
    ```
    kubectl describe -n longhorn-system node.v1beta1.longhorn.io NODENAME
    ```

* View all volumes:
    ```
    kubectl get -n longhorn-system volumes.v1beta1.longhorn.io
    ```

* View all replicas:
    ```
    kubectl get -n longhorn-system replicas.v1beta1.longhorn.io
    ```

It is also possible to change settings with kubectl. For example, the following script can be used to set the reserved space for all nodes to 10Gi:
```
#!/usr/bin/env bash
set -Exo pipefail

NODE_TYPE="nodes.v1beta1.longhorn.io"
LONGHORN_NAMESPACE="longhorn-system"
STORAGE_RESERVED=10737418240 # 10 Gi

NODES=$(kubectl get ${NODE_TYPE} -n ${LONGHORN_NAMESPACE} -o name)

kubectl patch -n ${LONGHORN_NAMESPACE} ${NODES} --type='json'  -p "[{\"op\": \"replace\", \"path\": \"/spec/disks/default-disk-ca1000000000/storageReserved\", \"value\": ${STORAGE_RESERVED}}]"
```

### Change the number of replicas for Longhorn persistent volumes

1. Scale down all the Stackstate deployments and delete all statefulsets. The deletion is required since the immutable fields of the statefulsets have to be changed. The data stored on the persistent volumes won't be deleted:

```
kubectl scale -n default deployment -l kots.io/app-slug=stackstate --replicas=0
kubectl delete -n default statefulsets -l kots.io/app-slug=stackstate
```

2. Select the required storage class in the [Persistent volume settings](/setup/install-stackstate/kots-install/kots_configuration_screen.md#persistent-volume-settings) section of the KOTS Config UI.

3. Redeploy the application via the KOTS Config UI.

4. Change the number of replicas for the following persistent volumes on the **Volume** tab of the Longhorn UI:
    * 1 - for the `longhorn-single-replica` storage class.
    * 2 - for the `longhorn-stackstate (two-replicas volumes)`

![](/.gitbook/assets/kots-persistent-volumes.png)

## Node management

### Restart a node

To restart a node:

1. Log in to the node

1. Run the following command to drain the node. Note that this can cause the StackState application to not function correctly while pods are rescheduled on other nodes:
    ```
    sudo /opt/ekco/shutdown.sh
    ```

2. Restart the node

### Add a node

When the embedded Kubernetes cluster is installed on the first node, two commands are generated at the end of the installation procedure:

* Use the first command to join a new machine as a worker node (valid for 24 hours).

* Use the second command to join a new machine as another master node (valid for 2 hours).

If those commands have expired:

1. Log in to the KOTS console.

1. Select **Cluster Management** in the top bar.

1. Scroll down to the **Add a Node** section.

1. Select either **Primary Node** (for a master node) or **Secondary Node** (for a worker node).

1. Run the generated command on the machine you wish to join the cluster.

More information about adding a node can be found in the kURL documentation on [adding nodes \(kurl.sh\)](https://kurl.sh/docs/install-with-kurl/adding-nodes).

### Remove a node

{% hint style="warning" %}
* To prevent data loss, ensure that the data has been replicated to another node before removing a node from the cluster.

* **Master nodes cannot be removed safely**. The kurl documentation on [etcd cluster health \(kurl.sh\)](https://kurl.sh/docs/install-with-kurl/adding-nodes#etcd-cluster-health) mentions that it is important to maintain quorum, however, StackState has so far been unable to remove a master node without breaking the cluster.
{% endhint %}

To remove a node, follow these steps:

1. [Add another node](#add-a-node) so that the data that will be removed from this node can be replicated somewhere.

1. [Access the Longhorn UI](#access-the-longhorn-ui).

1. In the Longhorn UI, navigate to the **Node** tab.

1. Select the node you want to remove.

1. Click the **Edit Node** button at the top of the list.

1. In the modal dialog box, select **Disable** under **Node Scheduling** and **True** under **Eviction Requested**:  \
![Disable Node Scheduling and Request Eviction](/.gitbook/assets/kurl-longhorn-ui-remove-node-1.png)

1. Click the **Save** button.

1. The **Node** tab should now show that the new node is being assigned volume replicas:  \
![New node (at the bottom) being assigned replicas](/.gitbook/assets/kurl-longhorn-ui-remove-node-2.png)

1. Navigate to the **Volume** tab to see the volumes being copied over:  \
![Replication progress in volume tab](/.gitbook/assets/kurl-longhorn-ui-remove-node-3.png)

1. Navigate back to the **Node** tab and wait until the node to remove has no more replicas assigned to it:  \
![To be removed node (at the top) has no more replicas assigned to it](/.gitbook/assets/kurl-longhorn-ui-remove-node-4.png)

1. Log in to the node to be removed.

1. Run the following command to drain the node. Note that this can cause the StackState application to not function correctly while pods are rescheduled on other nodes:
    ```
    sudo /opt/ekco/shutdown.sh
    ```

1. Stop the node.

1. On one of the master nodes, run the following command to completely remove the stopped node from the cluster:
    ```
    ekco-purge-node NODENAME
    ```

For more information about removing a node, see the kurl and Longhorn documentation:

* [Removing a node \(kurl.sh\)](https://kurl.sh/docs/install-with-kurl/adding-nodes#removing-a-node) 
* [Removing a node \(longhorn.io\)](https://longhorn.io/docs/1.2.4/volumes-and-nodes/maintenance/#removing-a-node)
