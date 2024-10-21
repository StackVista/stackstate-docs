---
description: SUSE Observability Self-hosted
---

# Configuration backup

## Overview

SUSE Observability has a backup mechanism specifically for configuration (also referred to as settings). This includes installed stackpacks with their configuration, but also any other customizations created by the user. For example monitors that have been disabled or customized, custom views, service tokens, etc.

The main advantage of the configuration backup is that it is very small (usually only several megabytes) and easy and quick to restore with minimal downtime. After the configuration backup is restored new data will be processed as before, recreating topology, health states and alerts. Topology history (including health) are however not preserved. For that purpose there is the [StackGraph backup](kubernetes_backup.md), however those backups are a lot bigger, and take much longer to create and restore.

The configuration backup is enabled by default. In its default setup it will make a backup every night, but backups are stored only on a persistent volume in its own namespace and a maximum of the 10 most recent backups are kept.

## Working with configuration backups

Scripts to work with configuration backups (but also all other backups)  can be found in the [restore directory of the SUSE Observability Helm chart repository \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/suse-observability/restore). To use the scripts, download them from GitHub or checkout the repository.

**Before you use the scripts, ensure that** the `kubectl` binary is installed and it is configured with the context and namespace where SUSE Observability is installed. For example run this command to connect to the context `observability-cluster` and namespace `suse-observablity`:
```
kubectl config use-context observability-cluster
kubectl config set-context --current --namespace=suse-observablity
```

The command line tools to interact with the backups all work by creating a Kubernetes job in the cluster and interacting with that job. After the tool is done the job is automatically removed. Starting the job can take some time (pulling the docker image, scheduling the job in the cluster, etc, all take some time), so the commands will not produce a result immediately.

### Restore a backup

{% hint style="warning" %}
Restoring a configuration backup will remove all topology, including health states, alerts and the topology history. It also will remove all previous configuration and requires down-time for the API, UI, monitors, notifications and topology synchronization (can be limited to a few minutes). Data collection and ingestion stays active during the restore.
{% endhint %}

To restore a backup:

1. Make sure to connect to the context and namespace for SUSE Observability, [see here](#working-with-configuration-backups)
2. Get the list of available backups using
   ```
   ./list-configuration-backups.sh
   ```
3. From the list of backup files choose the backup you want to restore
4. The restore will first scale down deployments that interact with StackGraph, then the backup will be restored. This can be followed via the output of the restore command. Restore the backup with the command below (answer `yes` to confirm erasing all topology and settings from SUSE Observability):
   ```
   ./restore-configuration-backup.sh sts-backup-your-choice.sty
   ```
5. After the restore has finished the deployments need to be scaled up manually:
   ```
   ./scale-up.sh
   ```
6. After a short while all deployments are running and ready and SUSE Observability can be used again


### Trigger a manual backup

A backup can be created at any time without any service interruption. The `backup-configuration-now.sh` script in the Github repostiroy can be used to trigger a backup at any time. The backup will follow the standard naming convention, including the date/time of the backup.

### Customizing configuration backups

Configuration backups can be stored in object storage, this happens automatically when configuring MinIO and enabling backups for topology, metrics, events and logs. Please follow the instructions for the [Kubernetes backup](./kubernetes_backup.md#enable-backups).

By default 365 days of backups are retained, this can be modified via the Helm values. It is also possible to disable the configuration backup entirely or customize the backup schedule. Some other parts of the backup can also be customized:

```yaml
backup:
  configuration:
    # backup.configuration.bucketName -- Name of the bucket to store configuration backups (needs to be a globally unique bucket when using Amazon S3).
    bucketName: 'sts-configuration-backup'
    # backup.configuration.maxLocalFiles -- The maximum number of configuration backup files stored on the PVC for the configuration backup (which is only of limited size, see backup.configuration.scheduled.pvc.size)
    maxLocalFiles: 10
    scheduled:
      # backup.configuration.scheduled.enabled -- Enable scheduled configuration backups (if `backup.enabled` is set to `true`).
      enabled: true
      # backup.configuration.scheduled.schedule -- Cron schedule for automatic configuration backups in [Kubernetes cron schedule syntax](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#cron-schedule-syntax).
      schedule: '0 4 * * *'
      # backup.configuration.scheduled.backupRetentionTimeDelta -- Time to keep configuration backups in object storage. The value is passed to GNU date tool to determine a specific date, and files older than this date will be deleted.
      backupRetentionTimeDelta: '365 days ago'
      pvc:
        # backup.configuration.scheduled.pvc.size -- Size of volume for settings backup in the cluster
        size: '1Gi'
```