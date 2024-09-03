---
description: SUSE Observability Self-hosted
---

# Version specific upgrade instructions

## Overview

{% hint style="warning" %}
**Review the instructions provided on this page before you upgrade!**

This page provides specific instructions and details of any required manual steps to upgrade to each supported version of SUSE Observability. Any significant change that may impact how SUSE Observability runs after upgrade will be described here, such as a change in memory requirements or configuration.

**Read and apply all instructions from the version that you are currently running up to the version that you will upgrade to.**
{% endhint %}

## Upgrade instructions

### Upgrade from 6.0 to 7.0

Version 7.0 includes a major version upgrade for the StackGraph database that is not binary compatible. Therefore it is not possible to upgrade SUSE Observability in-place whiile preserving topology data. To upgrade to 7.0 there are 2 alternate approaches that can be taken:

1. Run 7.0 side-by-side with 6.0 and send data to both, switching over when sufficient history has been collected
2. Uninstall 6.0 and wipe the StackGraph data, before installing 7.0. Metrics, logs and traces are preserved but topology is not.

### Upgrade by running versions side-by-side

{% hint style="info" %}
Make sure the Kubernetes cluster that runs SUSE Observability has sufficient resources available to run 2 installations.
{% endhint %}

1. [Export the StackState configuration](../data-management/backup_restore/configuration_backup.md#export-configuration), so it can be imported in the new version for a quicker setup
2. [Install version 7.0 in a separate namespace](../install-stackstate/README.md)
3. [Import the configuration](../data-management/backup_restore/configuration_backup.md#import-configuration)
4. [Configure agents to send data to both installations](#configure-agents-to-send-data-to-both-installations)
5. Wait for history to build up in 7.0
6. [Uninstall 6.0 and remove its PVCs](../install-stackstate/kubernetes_openshift/uninstall.md)

### Upgrade by un-installing 6.0

1. Optionally make sure [there is a backup](../data-management/backup_restore/kubernetes_backup.md) of all of the telemetry data (note that topology backup will be incompatible between versions 6.0 and 7.0 as well)
2. [Export the StackState configuration](#export), so it can be imported in the new version for a quicker setup
4. [Remove incompatible data](#remove-incompatible-data)
5. [Uninstall 6.0, **but keep PVCs and other resources**](../install-stackstate/kubernetes_openshift/uninstall.md#un-install-the-helm-chart)
6. [Upgrade to version 7.0](./steps-to-upgrade.md#upgrade-rancher-observability)
7. [Import the original configuration](#import)

### Configure agents to send data to both installations
...

### Export

To export configuration, make an export via the UI of all monitor functions and of all other settings: 

1. Open settings
2. In the left bar open the Monitor function setting
3. In the table select all monitor functions with the checkbox in the table header
4. Click export and save as `monitor-functions-backup.sty`.
5. Now open the "Export settings" page via the left bar.
6. Click the `STS-EXPORT-ALL-...` button and save the file as `settings-backup.sty`.

### Remove incompatible data

Due to a major version upgrade incompatible data and metadata has to be removed. Before removing data first all pods need to be stopped to prevent anything from breaking. Note that Zookeeper will need to be running afterwards because it is needed for the removal of metadata.

Run the commands for your specific installation, HA (High Available) or non-HA:
{% tabs %}
{% tab title="HA" %}
```
kubectl scale --replicas=0 deployment --all      
kubectl scale --replicas=0 statefulset --all
kubectl scale --replicas=3 statefulset/stackstate-zookeeper
```
{% endtab %}
{% tab title="HA" %}
For anon-HA, first run:
```
kubectl scale --replicas=0 deployment --all      
kubectl scale --replicas=0 statefulset --all
kubectl scale --replicas=1 statefulset/stackstate-zookeeper
```
{% endtab %}
{% endtabs %}

Check that all pods have stopped, except for zookeeper, for which all pods should be in running state:
```
kubectl get pods
```
If zookeeper is not yet running wait for a short period and check again.

When all Zookeeper pods are in a Running state, remove some of the metadata: 
```
 kubectl exec statefulset/stackstate-zookeeper -- /opt/bitnami/zookeeper/bin/zkCli.sh deleteall /tx.service
 kubectl exec statefulset/stackstate-zookeeper -- /opt/bitnami/zookeeper/bin/zkCli.sh deleteall /hbase
```

Finally remove the data for StackGraph:

```bash
STACKGRAPH=$(kubectl get pvc --selector='app.kubernetes.io/name=hbase' -o jsonpath='{.items[*].metadata.name}')
kubectl delete pvc $STACKGRAPH
```

### Import

{% hint style="warning" %}
Due to the specific arguments required for restoring the backups it is not possible to do this via the UI nor via the CLI.
{% endhint %}

Restoring the settings can be done by importing the 2 backup yaml files made before upgrading, using the `wget` command on the command line:

1. Get an api-token via the main menu `CLI` page
2. Use the api token to restore the monitor functions using `wget` (replace `<stackstate-host>` and `<api-token>`):

  ```
  wget --content-on-error -q -S -O - --post-file=monitor-functions-backup.sty \
    --header="X-Api-Token: <api-token>" \
    --header='Content-Type: plain/text' \
    "https://<stackstate-host>/api/import?timeoutSeconds=15&locked=overwrite" 2>&1
  ```
3. Use the api token to restore the other settings using `wget` (replace `<stackstate-host>` and `<api-token>`):

  ```
  wget --content-on-error -q -S -O - --post-file=settings-backup.sty \
    --header="X-Api-Token: <api-token>" \
    --header='Content-Type: plain/text' \
    "https://<stackstate-host>/api/import?timeoutSeconds=15&locked=overwrite" 2>&1
  ```

## See also

* [Steps to upgrade SUSE Observability](steps-to-upgrade.md)

