---
description: StackState for Kubernetes troubleshooting Self-hosted
---

# Troubleshooting

## Quick troubleshooting guide

Here is a quick guide for troubleshooting the startup of StackState:

1. Check that the install completed successfully and the release is listed:

   ```text
   helm list --namespace stackstate
   ```

2. Check that all pods in the StackState namespace are running:

   ```text
   kubectl get pods
   ```
   
   In a first deployment it can be that containers in several pods restart a few times, because they are waiting for other pods to start up and be in the `ready` state. This can be delayed due to scheduling and docker image pulling delays.

   Pods that are in `pending` state are usually an indication of a problem:
   * The pod is unschedulable due to lack of resources in the cluster. If a cluster auto-scaler is active it will often be able to resolve this automatically, otherwise manual intervention is needed to add more nodes to the cluster
   * The pod is unschedulable, there are nodes it would fit on, but those nodes have `taints` that the pod doesn not tolerate. To solve this more nodes can be added that don't have the taints, but StackState can also be [configured](kubernetes_openshift/customize_config.md#override-default-configuration) to tolerate certain taints and run on the tainted nodes.
   * The pod is waiting for the Persistent Volumes (PVs) to be mounted. A cause can be that the StackState Helm chart doesn't specify a `storageClassName` but relies on the cluster having a default storage class. When there is no default for the cluster it's required to [specify a storage class](./kubernetes_openshift/storage.md) via the Helm values of StackState.

   For pods with state `ImagePullBackOff` also check the exact error message, common causes are:
   * An incorrect username/password used to pull the images
   * Connecting to the docker registry failed, this can be due to authentication issues or connectivity issues (firewalls, air-gapped installations)
   * A typo in the overriden docker image registry URL

   To find out a more detailed cause for the `Pending`, `ImagePullBackOff` or `CrashLoopBackOff` states use this command:
   
   ```text
   kubectl describe pod<pod-name>
   ```
   
   The output contains an `event` section at the end which usually contains the problem. It also has a `State` section for each container that has more details for termination of the container.

3. [Check the logs](/configure/logging/README.md) for errors.
4. Check the Knowledge base on the [StackState Support site](https://support.stackstate.com/).

## Known issues

Check the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/sections/360004684540-Known-issues) to find troubleshooting steps for all known issues.

