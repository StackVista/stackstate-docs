---
description: StackState SaaS
---

# Kubernetes backup

## Overview

The Kubernetes setup for StackState has a built-in backup and restore mechanism that can be configured to store backups to the local clusters, to AWS S3 or to Azure Blob Storage.

### Backup scope

The following data can be automatically backed up:

* **Configuration and topology data** stored in StackGraph is backed up when the Helm value `backup.stackGraph.enabled` is set to `true`.
* **Telemetry data** stored in StackState's Elasticsearch instance is backed up when the Helm value `backup.elasticsearch.enabled` is set to `true`.

The following data will NOT be backed up:

* In transit topology and telemetry updates stored in Kafka - these only have temporary value and would be of no use when a backup is restored
* Master node negotiations state stored in ZooKeeper - this runtime state would be incorrect when restored and will be automatically determined at runtime
* Kubernetes configuration state and raw persistent volume state - this state can be rebuilt by re-installing StackState and restoring the backups.
* Kubernetes logs - these are ephemeral.

### Storage options

StackGraph and Elasticsearch backups are sent to an instance of [MinIO \(min.io\)](https://min.io/), which is automatically started by the `stackstate` Helm chart when automatic backups are enabled. MinIO is an object storage system with the same API as AWS S3. It can store its data locally or act as a gateway to [AWS S3 \(min.io\)](https://docs.min.io/docs/minio-gateway-for-s3.html), [Azure BLob Storage \(min.io\)](https://docs.min.io/docs/minio-gateway-for-azure.html) and other systems.

The built-in MinIO instance can be configured to store the backups in three locations:

* AWS S3
* Azure Blob Storage
* Kubernetes storage

## Enable backups

### Backup to AWS S3

To enable scheduled backups to AWS S3 buckets, add the following YAML fragment to the Helm `values.yaml` file used to install StackState:

```yaml
backup:
  enabled: true
  stackGraph:
    bucketName: AWS_STACKGRAPH_BUCKET
  elasticsearch:
    bucketName: AWS_ELASTICSEARCH_BUCKET
minio:
  accessKey: YOUR_ACCESS_KEY
  secretKey: YOUR_SECRET_KEY
  s3gateway:
    enabled: true
    accessKey: AWS_ACCESS_KEY
    secretKey: AWS_SECRET_KEY
```

Replace the following values:
* `YOUR_ACCESS_KEY` and `YOUR_SECRET_KEY` are the credentials that will be used to secure the MinIO system. These credentials are set on the MinIO system and used by the automatic backup jobs and the restore jobs. They are also required if you want to manually access the MinIO system.
  * YOUR_ACCESS_KEY should contain 5 to 20 alphanumerical characters.
  * YOUR_SECRET_KEY should contain 8 to 40 alphanumerical characters.
* `AWS_ACCESS_KEY` and `AWS_SECRET_KEY` are the AWS credentials for the IAM user that has access to the S3 buckets where the backups will be stored. See below for the permission policy that needs to be attached to that user.
* `AWS_STACKGRAPH_BUCKET` and `AWS_ELASTICSEARCH_BUCKET` are the names of the S3 buckets where the backups should be stored. Note: The names of AWS S3 buckets are global across the whole of AWS, therefore the S3 buckets with the default name \(`sts-elasticsearch-backup` and `sts-stackgraph-backup`\) will probably not be available.

The IAM user identified by `AWS_ACCESS_KEY` and `AWS_SECRET_KEY` must be configured with the following permission policy to access the S3 buckets:

```javascript
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListMinioBackupBuckets",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::AWS_STACKGRAPH_BUCKET",
                "arn:aws:s3:::AWS_ELASTICSEARCH_BUCKET"
            ]
        },
        {
            "Sid": "AllowWriteMinioBackupBuckets",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::AWS_STACKGRAPH_BUCKET/*",
                "arn:aws:s3:::AWS_ELASTICSEARCH_BUCKET/*"
            ]
        }
    ]
}
```

### Backup to Azure Blob Storage

To enable backups to an Azure Blob Storage account, add the following YAML fragment to the Helm `values.yaml` file used to install StackState:

```yaml
backup:
  enabled: true
minio:
  accessKey: AZURE_STORAGE_ACCOUNT_NAME
  secretKey: AZURE_STORAGE_ACCOUNT_KEY
  azuregateway:
    enabled: true
```

Replace `AZURE_STORAGE_ACCOUNT_NAME` with the [Azure storage account name \(microsoft.com\)](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-portal) and replace `AZURE_STORAGE_ACCOUNT_KEY` with the [Azure storage account key \(microsoft.com\)](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-keys-manage?tabs=azure-portal) where the backups should be stored.

The StackGraph and Elasticsearch backups are stored in BLOB containers called `sts-stackgraph-backup` and `sts-elasticsearch-backup` respectively. These names can be changed by setting the Helm values `backup.stackGraph.bucketName` and `backup.elasticsearch.bucketName` respectively.

### Backup to Kubernetes storage

{% hint style="warning" %}
If MinIO is configured to store its data in Kubernetes storage, a PersistentVolumeClaim (PVC) is used to request storage from the Kubernetes cluster. The kind of storage that is allocated depends on the configuration of the cluster.

It is advised to use AWS S3 for clusters running on Amazon AWS and Azure Blob Storage for clusters running on Azure for the following reasons:

1. Kubernetes clusters running in a cloud provider usually map PVCs to block storage, such as Elastic Block Storage for AWS or Azure Block Storage. Block storage is expensive, especially for large data volumes.
2. Persistent Volumes are destroyed when the cluster that created them is destroyed. That means an (accidental) deletion of your cluster will also destroy all backups stored in Persistent Volumes.
3. Persistent Volumes cannot be accessed from another cluster. That means that it is not possible to restore StackState from a backup taken on another cluster.
{% endhint %}

To enable backups to cluster-local storage, enable MinIO by adding the following YAML fragment to the Helm `values.yaml` file used to install StackState:

```yaml
backup:
  enabled: true
minio:
  accessKey: YOUR_ACCESS_KEY
  secretKey: YOUR_SECRET_KEY
  persistence:
    enabled: true
```

Replace `YOUR_ACCESS_KEY` and `YOUR_SECRET_KEY` with the credentials that will be used to secure the MinIO system. The automatic backup jobs and the restore jobs will use them. They are also required to manually access the MinIO storage. `YOUR_ACCESS_KEY` should contain 5 to 20 alphanumerical characters and `YOUR_SECRET_KEY` should contain 8 to 40 alphanumerical characters.

## Configuration and topology data \(StackGraph\)

Configuration and topology data \(StackGraph\) backups are full backups, stored in a single file with the extension `.graph`. Each file contains a full backup and can be moved, copied or deleted as required.

### Disable scheduled backups

When `backup.enabled` is set to `true`, scheduled StackGraph backups are enabled by default. To disable scheduled StackGraph backups only, set the Helm value `backup.stackGraph.scheduled.enabled` to `false`.

### Disable restores

When `backup.enabled` is set to `true`, StackGraph restores are enabled by default. To disable StackGraph restore functionality only, set the Helm value `backup.stackGraph.restore.enabled` to `false`.

### Backup schedule

By default, the StackGraph backups are created daily at 03:00 AM server time.

The backup schedule can be configured using the Helm value `backup.stackGraph.scheduled.schedule`, specified in [Kubernetes cron schedule syntax \(kubernetes.io\)](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#cron-schedule-syntax).

### Backup retention

By default, the StackGraph backups are kept for 30 days. As StackGraph backups are full backups, this can require a lot of storage.

The backup retention delta can be configured using the Helm value `backup.stackGraph.scheduled.backupRetentionTimeDelta`, specified in [Python timedelta format \(python.org\)](https://docs.python.org/3/library/datetime.html#timedelta-objects).

## Telemetry data \(Elasticsearch\)

The telemetry data \(Elasticsearch\) snapshots are incremental and stored in files with the extension `.dat`. The files in the Elasticsearch backup storage location should be treated as a single whole and can only be moved, copied or deleted as a whole.

The configuration snippets provided in the section [enable backups](kubernetes_backup.md#enable-backups) will enable daily Elasticsearch snapshots.

### Disable scheduled snapshots

When `backup.enabled` is set to `true`, scheduled Elasticsearch snapshots are enabled by default. To disable scheduled Elasticsearch snapshots only, set the Helm value `backup.elasticsearch.scheduled.enabled` to `false`.

### Disable restores

When `backup.enabled` is set to `true`, Elasticsearch restores are enabled by default. To disable Elasticsearch restore functionality only, set the Helm value `backup.elasticsearch.restore.enabled` to `false`.

### Snapshot schedule

By default, Elasticsearch snapshots are created daily at 03:00 AM server time.

The backup schedule can be configured using the Helm value `backup.elasticsearch.scheduled.schedule`, specified in [Elasticsearch cron schedule syntax \(elastic.co\)](https://www.elastic.co/guide/en/elasticsearch/reference/7.6/cron-expressions.html).

### Snapshot retention

By default, Elasticsearch snapshots are kept for 30 days, with a minimum of 5 snapshots and a maximum of 30 snapshots.

The retention time and number of snapshots kept can be configured using the following Helm values:

* `backup.elasticsearch.scheduled.snapshotRetentionExpireAfter`, specified in [Elasticsearch time units \(elastic.co\)](https://www.elastic.co/guide/en/elasticsearch/reference/7.6/common-options.html#time-units).
* `backup.elasticsearch.scheduled.snapshotRetentionMinCount` 
* `backup.elasticsearch.scheduled.snapshotRetentionMaxCount`

{% hint style="info" %}
By default, the retention task itself [runs daily at 1:30 AM UTC \(elastic.co\)](https://www.elastic.co/guide/en/elasticsearch/reference/7.6/slm-settings.html#slm-retention-schedule). If you set snapshots to expire faster than within a day, for example for testing purposes, you will need to change the schedule for the retention task.
{% endhint %}

### Snapshot indices

By default, a snapshot is created for all Elasticsearch indices.

This indices for which a snapshot is created can be configured using the Helm value `backup.elasticsearch.scheduled.indices`, specified in [JSON array format \(w3schools.com\)](https://www.w3schools.com/js/js_json_arrays.asp).

## Restore backups and snapshots

Scripts to list and restore backups and snapshots can be found in the [restore directory of the StackState Helm chart repository \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/restore). To use the scripts, download them from the GitHub site or check out the repository.

Before you use the scripts, ensure that:

1. The `kubectl` binary is installed and configured to connect to:
    1. the Kubernetes cluster where StackState has been installed.
    1. the namespace within that cluster where StackState has been installed.
1. The following Helm values have been correctly set:
    1. `backup.enabled` is set to `true`.
    1. `backup.stackGraph.restore.enabled` is not set to `false` \(to access StackGraph backups\).
    1. `backup.elasticsearch.restore.enabled` is not set to `false` \(to access Elasticsearch snapshots\).

### List StackGraph backups

To list the StackGraph backups, execute the following command:

```bash
./restore/list-stackgraph-backups.sh
```

The output should look like this:

```bash
job.batch/stackgraph-list-backups-20210222t111942 created
Waiting for job to start...
=== Listing StackGraph backups in bucket "sts-stackgraph-backup"...
sts-backup-20210215-0300.graph
sts-backup-20210216-0300.graph
sts-backup-20210217-0300.graph
sts-backup-20210218-0300.graph
sts-backup-20210219-0300.graph
sts-backup-20210220-0300.graph
sts-backup-20210221-0300.graph
sts-backup-20210222-0300.graph
===
job.batch "stackgraph-list-backups-20210222t111942" deleted
```

The timestamp when the backup was taken is part of the backup name.

{% hint style="info" %}
Lines in the output that start with `Error from server (BadRequest):` are expected. They appear when the script is waiting for the pod to start.
{% endhint %}

### Restore a StackGraph backup

{% hint style="warning" %}
**When a backup is restored, the existing data in the StackGraph database will be overwritten.**

Only execute the restore command when you are sure that you want to restore the backup.
{% endhint %}

To restore a StackGraph backup, select a backup name and pass it as the first parameter in the following command:

```bash
./restore/restore-stackgraph-backup.sh sts-backup-20210216-0300.graph
```

The output should look like this:

```bash
job.batch/stackgraph-restore-20210222t112142 created
Waiting for job to start...
=== Downloading StackGraph backup "sts-backup-20210216-0300.graph" from bucket "sts-stackgraph-backup"...
download: s3://sts-stackgraph-backup/sts-backup-20210216-1252.graph to ../../tmp/sts-backup-20210216-0300.graph
=== Importing StackGraph data from "sts-backup-20210216-0300.graph"...
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.codehaus.groovy.vmplugin.v7.Java7$1 (file:/opt/docker/lib/org.codehaus.groovy.groovy-2.5.4.jar) to constructor java.lang.invoke.MethodHandles$Lookup(java.lang.Class,int)
WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.vmplugin.v7.Java7$1
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
===
job.batch "stackgraph-restore-20210222t112142" deleted
```

{% hint style="info" %}
Lines that starts with `WARNING:` are expected. They are generated by Groovy running in JDK 11 and can be ignored.
{% endhint %}

### List Elasticsearch snapshots

To list the Elasticsearch snapshots, execute the following command:

```bash
./restore/list-elasticsearch-snapshos.sh
```

The output should look like this:

```bash
job.batch/elasticsearch-list-snapshots-20210224t133115 created
Waiting for job to start...
Waiting for job to start...
=== Listing Elasticsearch snapshots in snapshot repository "sts-backup" in bucket "sts-elasticsearch-backup"...
sts-backup-20210219-0300-mref7yrvrswxa02aqq213w
sts-backup-20210220-0300-yrn6qexkrdgh3pummsrj7e
sts-backup-20210221-0300-p481sih8s5jhre9zy4yw2o
sts-backup-20210222-0300-611kxendsvh4hhkoosr4b7
sts-backup-20210223-0300-ppss8nx40ykppss8nx40yk
===
job.batch "elasticsearch-list-snapshots-20210224t133115" deleted
```

The timestamp when the backup was taken is part of the backup name.

### Restore an Elasticsearch snapshot

{% hint style="danger" %}
When a snapshot is restored, existing indices will NOT be overwritten. Use the Elasticsearch [delete index API \(elastic.co\)](https://www.elastic.co/guide/en/elasticsearch/reference/7.6/indices-delete-index.html) to remove them first. 

See [delete Elasticsearch indices](kubernetes_backup.md#delete-elasticsearch-indices).
{% endhint %}

To restore an Elasticsearch snapshot, select a snapshot name and pass it as the first parameter in the following command line:

```bash
./restore/restore-elasticsearch-snapshot.sh sts-backup-20210223-0300-ppss8nx40ykppss8nx40yk
```

The output should look like this:

```text
job.batch/elasticsearch-restore-20210229t152530 created
Waiting for job to start...
Waiting for job to start...
=== Restoring Elasticsearch snapshot "sts-backup-20210223-0300-ppss8nx40ykppss8nx40yk" from snapshot repository "sts-backup" in bucket "sts-elasticsearch-backup"...
{
  "snapshot" : {
    "snapshot" : "sts-backup-20210223-0300-ppss8nx40ykppss8nx40yk",
    "indices" : [
      ".slm-history-1-000001",
      "ilm-history-1-000001",
      "sts_internal_events-2021.02.19"
    ],
    "shards" : {
      "total" : 3,
      "failed" : 0,
      "successful" : 3
    }
  }
}
===
job.batch "elasticsearch-restore-20210229t152530" deleted
```

The indices restored are listed in the output, as well as the number of failed and successful restore actions.

After the indices have been restored, scale up all `*2es` deployments:

   ```bash
   kubectl scale --replicas=1 deployment/e2es
   kubectl scale --replicas=1 deployment/mm2es
   kubectl scale --replicas=1 deployment/trace2es
   ```

### Delete Elasticsearch indices

To delete existing Elasticsearch indices so that a snapshot can be restored, follow these steps.

1. Stop indexing - scale down all `*2es` deployments to 0:

   ```bash
   kubectl scale --replicas=0 deployment/e2es
   kubectl scale --replicas=0 deployment/mm2es
   kubectl scale --replicas=0 deployment/trace2es
   ```

2. Open a port-forward to the Elasticsearch master:

   ```bash
   kubectl port-forward service/stackstate-elasticsearch-master 9200:9200
   ```

3. Delete an index with a following command:

   ```bash
   curl -X DELETE "http://localhost:9200/INDEX_NAME?pretty"
   ```

   Replace `INDEX_NAME` with the name of the index to delete, for example:

   ```bash
   curl -X DELETE "http://localhost:9200/sts_internal_events-2021.02.19?pretty"
   ```

4. The output should be:

   ```javascript
   {
   "acknowledged" : true
   }
   ```