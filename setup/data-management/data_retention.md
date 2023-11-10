---
description: StackState for Kubernetes troubleshooting Self-hosted
---

# Data retention

## Overview

StackState imposes data retention limits to save storage space and improve performance. You can configure the data retention period to balance the amount of data stored with StackState performance and data availability.

## Retention of topology graph data

By default, topology graph data will be retained for 30 days. This works in a way that the latest state of topology graph will always be retained; only history older than 30 days will be removed. You can check and alter the configured retention period this using the StackState CLI.

```shell
$ sts graph retention
```

In some cases, it may be useful to keep historical data for more than 30 days or to reduce it to less than 30 days to save on disk space.

```shell
$ sts graph retention --set 10d
```

\(note that the duration can be specified as a duration string\)

Note that by adding more time to the data retention period, the amount of data stored is also going to grow and need more storage space. This may also affect the performance of the Views.

After changing the retention period to a smaller window, you may end up with some data that's already expired and will wait there until the next scheduled cleanup. To schedule a cleanup soon after the new retention window is applied use this command:

```shell
$ sts graph retention --set 10d --schedule-removal
```

In some cases, for example a disk running full, it can be needed to force removal of data immediately. This will have an impact on performance and current activity on StackState so is better avoided. 

Note that this may take some time to have an effect.

```shell
$ sts graph delete-expired-data --immediately
```

## Retention of events, traces and logs

### StackState data store

If you are using the event/logs store provided with StackState, your data will by default be retained for 30 days. In most cases, the default settings will be sufficient to store all indices for this amount of time.

#### Configure disk space for Elasticsearch

In some circumstances it may be necessary to adjust the disk space available to Elasticsearch and how it's allocated to logs, events and traces, for example if you anticipate a lot of data to arrive for a specific data type. 

Here is a snippet with the complete disk space and retention config for Elasticsearch, including the default values.

```yaml
elasticsearch:
  volumeClaimTemplate:
    resources:
      requests:
        storage: 250Gi
stackstate:
  components:
    receiver:
      esDiskSpaceShare: 70
      # Number of days to keep the logs data on Es
      retention: 7
    e2es:
      esDiskSpaceShare: 30
      # Number of days to keep the events data on Es
      retention: 30
    trace2es:
      esDiskSpaceShare: 0
      # Number of days to keep the traces data on Es
      retention: 7
      enabled: false
```

The disk space available for Elasticsearch is configured via the `elasticsearch.volumeClaimTemplate.resources.requests.storage` key. To change this value after the initial installation some [extra steps are required](data_retention.md#resizing-storage).

**Note**: this is the disk space for each instance of ElasticSearch. For non-HA this is the total available disk space, but for HA there are 3 instances and a replication factor of 1. The end result is that the total available Elasticsearch storage will be `(250Gi * 3) / 2 = 375Gi`.
Based on the `esDiskSpaceShare` and `retention` a portion of the Elasticsearch disk space is reserved for each data type.

## Retention of metrics

StackState uses VictoriaMetrics to store metrics. It's configured with a default retention of 30 days. The helm chart allocates disk space and configures the retention period for the 1 or 2 Victoria metrics instances like this:

```
victoria-metrics-0:
  server:
    persistentVolume:
      size: 250Gi
    retentionPeriod: 1 # month
# For HA setups:
victoria-metrics-1:
  server:
    persistentVolume:
      size: 250Gi
    retentionPeriod: 1 # month
```

To change the volume size after the initial installation some [extra steps are required](data_retention.md#resizing-storage).

To change the retention period override both `retentionPeriod` keys with the same value in your custom values.yaml and [update StackState](./data_retention.md#update-stackstate):

* The following optional suffixes are supported: h (hour), d (day), w (week), y (year). If no suffix is set the duration is in months.
* Minimum retention period is 24h or 1 day.

## Update StackState

After making changes to the values.yaml StackState needs to be updated to apply those changes to the runtime. This may cause some short downtime while the services restart. To update StackState use the same command that was used during installation of StackState and make sure to include the same configuration files including the changes that have been made:

* [Kubernetes](/setup/install-stackstate/kubernetes_openshift/kubernetes_install.md#deploy-stackstate-with-helm)
* [OpenShift](/setup/install-stackstate/kubernetes_openshift/openshift_install.md#deploy-stackstate-with-helm):

## Resizing storage

In most clusters it's possible to resize a persistent volume after it has been created and without interrupting the operation of applications at all. However this can't be done by simply changing the configured storage size in the values.yaml of the StackState Helm chart. Instead several steps are needed:

1. Verify the used storage class can be resized
2. Resize the volumes
3. Update values.yaml and apply change (optional but recommended)

The examples below use the VictoriaMetrics storage as an example. StackState is installed in the `stackstate` namespace. The volume is going to be resized to 500Gi.

### Verify the storage class supports resizing

Use the following `kubectl` commands to get the storage class used and check that the `allowVolumeExpansion` is set to true.

```bash
# Get the PVC's for StackState
kubectl get pvc --namespace stackstate

# There is a storage class column in the output, copy it and use it to describe the storage class
kubectl describe storageclass <storage-class-name>
```

Verify that the output contains this line:

```
AllowVolumeExpansion:  True
```

If the line is absent or if it's set to `False` please consult with your Kubernetes administrator if resizing is supported and can be enabled.

### Resize the volumes

The StackState Helm chart creates a stateful set, which has a template to create the persistent volume claim (PVC). This template is only used to create the PVC once, after that it won't be applied anymore and it's also not allowed to change it. So to make the PVC's bigger the PVC itself needs to be edited.

To change the PVC size use the following commands.

```bash
# Get the PVC's for StackState, allows us to check the current size and copy the name of the PVC to modify it with the next command
kubectl get pvc --namespace stackstate

# Patch the PVC's specified size, change it to 500Gi
kubectl patch pvc server-volume-stackstate-victoria-metrics-0-0 -p '{"spec":{"resources": { "requests": { "storage": "500Gi" }}}}'

# Get the PVC's again to verify if it was resized, depending on the provider this can take a while
kubectl get pvc --namespace stackstate
```

### Update values.yaml and apply the change

The change made to the persistent volume claim (PVC) will remain for the lifetime of the PVC, but whenever a clean install is done it will be lost. More importantly however, after resizing the PVC there is now a discrepancy between the cluster state and the definition of the desired state in the values.yaml. Therefore it's recommended to update the values.yaml as well. To circumvent the fact that this change is not allowed, first remove the stateful set (but keep the pods running) to re-create it with the new settings.

{% hint style="info" %}
This step doesn't change the size of the PVC itself, so only doing this step will result in no changes at all to the running environment.
{% endhint %}

First edit your values.yaml to update the volume size for the PVC's you've just resized. See the sections on [Metrics](data_retention.md#retention-of-metrics) or [Events and Logs](data_retention.md#retention-of-events-traces-and-logs).

Now remove the stateful set for the application(s) for which the storage has been changed:

```bash
# List all stateful sets, check that all are ready, if not please troubleshoot that first
kubectl get statefulset --namespace stackstate

# Delete the 
kubectl delete statefulset --namespace stackstate stackstate-victoria-metrics-0 --cascade=orphan
```

Finally [update StackState](./data_retention.md#update-stackstate) with the new settings.