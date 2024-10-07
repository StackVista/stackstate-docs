---
description: SUSE Observability Self-hosted
---

# Kubernetes backup

## Overview

The Kubernetes setup for SUSE Observability has a built-in backup and restore mechanism that can be configured to store backups to the local clusters, to AWS S3 or to Azure Blob Storage.

### Backup scope

The following data can be automatically backed up:

* **Configuration and topology data** stored in StackGraph is backed up when the Helm value `backup.stackGraph.enabled` is set to `true`.
* **Metrics** stored in SUSE Observability's Victoria Metrics instance(s) is backed up when the Helm value `victoria-metrics-0.backup.enabled` and `victoria-metrics-1.backup.enabled` are set to `true`.
* **Telemetry data** stored in SUSE Observability's Elasticsearch instance is backed up when the Helm value `backup.elasticsearch.enabled` is set to `true`.
* **OpenTelemetry data** stored in SUSE Observability's ClickHouse instance is backed up when the Helm value `clickhouse.backup.enabled` is set to `true`.

The following data will **not** be backed up:

* In transit topology and telemetry updates stored in Kafka - these only have temporary value and would be of no use when a backup is restored
* Master node negotiations state stored in ZooKeeper - this runtime state would be incorrect when restored and will be automatically determined at runtime
* Kubernetes configuration state and raw persistent volume state - this state can be rebuilt by re-installing SUSE Observability and restoring the backups.
* Kubernetes logs - these are ephemeral.

### Storage options

Backups are sent to an instance of [MinIO \(min.io\)](https://min.io/), which is automatically started by the `stackstate` Helm chart when automatic backups are enabled. MinIO is an object storage system with the same API as AWS S3. It can store its data locally or act as a gateway to [AWS S3 \(min.io\)](https://docs.min.io/docs/minio-gateway-for-s3.html), [Azure BLob Storage \(min.io\)](https://docs.min.io/docs/minio-gateway-for-azure.html) and other systems.

The built-in MinIO instance can be configured to store the backups in three locations:

* [AWS S3](#aws-s3)
* [Azure Blob Storage](#azure-blob-storage)
* [Kubernetes storage](#kubernetes-storage)

## Enable backups

### AWS S3

{% hint style="warning" %}

**Encryption**

Amazon S3-managed keys (SSE-S3) should be used when encrypting S3 buckets that store the backups. 

⚠️ Encryption with AWS KMS keys stored in AWS Key Management Service (SSE-KMS) isn't supported. This will result in errors such as this one in the Elasticsearch logs:

`Caused by: org.elasticsearch.common.io.stream.NotSerializableExceptionWrapper: sdk_client_exception: Unable to verify integrity of data upload. Client calculated content hash (contentMD5: ZX4D/ZDUzZWRhNDUyZTI1MTc= in base 64) didn't match hash (etag: c75faa31280154027542f6530c9e543e in hex) calculated by Amazon S3. You may need to delete the data stored in Amazon S3. (metadata.contentMD5: null, md5DigestStream: com.amazonaws.services.s3.internal.MD5DigestCalculatingInputStream@5481a656, bucketName: stackstate-elasticsearch-backup, key: tests-UG34QIV9s32tTzQWdPsZL/master.dat)",`
{% endhint %}

To enable scheduled backups to AWS S3 buckets, add the following YAML fragment to the Helm `values.yaml` file used to install SUSE Observability:

```yaml
backup:
  enabled: true
  stackGraph:
    bucketName: AWS_STACKGRAPH_BUCKET
  elasticsearch:
    bucketName: AWS_ELASTICSEARCH_BUCKET
  configuration:
    bucketName: AWS_CONFIGURATION_BUCKET
victoria-metrics-0:
  backup:
    bucketName: AWS_VICTORIA_METRICS_BUCKET
victoria-metrics-1:
  backup:
    bucketName: AWS_VICTORIA_METRICS_BUCKET
clickhouse:
  backup:
    enabled: true
    bucketName: AWS_CLICKHOUSE_BUCKET
minio:
  accessKey: YOUR_ACCESS_KEY
  secretKey: YOUR_SECRET_KEY
  s3gateway:
    enabled: true
    accessKey: AWS_ACCESS_KEY
    secretKey: AWS_SECRET_KEY
```

Replace the following values:
* `YOUR_ACCESS_KEY` and `YOUR_SECRET_KEY` are the credentials that will be used to secure the MinIO system. These credentials are set on the MinIO system and used by the automatic backup jobs and the restore jobs. They're also required if you want to manually access the MinIO system.
  * YOUR_ACCESS_KEY should contain 5 to 20 alphanumerical characters.
  * YOUR_SECRET_KEY should contain 8 to 40 alphanumerical characters.
* `AWS_ACCESS_KEY` and `AWS_SECRET_KEY` are the AWS credentials for the IAM user that has access to the S3 buckets where the backups will be stored. See below for the permission policy that needs to be attached to that user.
* `AWS_STACKGRAPH_BUCKET`, `AWS_CONFIGURATION_BUCKET`, `AWS_ELASTICSEARCH_BUCKET`, `AWS_VICTORIA_METRICS_BUCKET` and `AWS_CLICKHOUSE_BUCKET` are the names of the S3 buckets where the backups should be stored. Note: The names of AWS S3 buckets are global across the whole of AWS, therefore the S3 buckets with the default name \(`sts-elasticsearch-backup`, `sts-configuration-backup`, `sts-stackgraph-backup`, `sts-victoria-metrics-backup` and `sts-clickhouse-backup` \) will probably not be available.

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
                "arn:aws:s3:::AWS_ELASTICSEARCH_BUCKET",
                "arn:aws:s3:::AWS_VICTORIA_METRICS_BUCKET",
                "arn:aws:s3:::AWS_CLICKHOUSE_BUCKET",
                "arn:aws:s3:::AWS_CONFIGURATION_BUCKET"
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
                "arn:aws:s3:::AWS_ELASTICSEARCH_BUCKET/*",
                "arn:aws:s3:::AWS_VICTORIA_METRICS_BUCKET/*",
                "arn:aws:s3:::AWS_CLICKHOUSE_BUCKET/*",
                "arn:aws:s3:::AWS_CONFIGURATION_BUCKET"
            ]
        }
    ]
}
```

### Azure Blob Storage

To enable backups to an Azure Blob Storage account, add the following YAML fragment to the Helm `values.yaml` file used to install SUSE Observability:

```yaml
backup:
  enabled: true
minio:
  accessKey: AZURE_STORAGE_ACCOUNT_NAME
  secretKey: AZURE_STORAGE_ACCOUNT_KEY
  azuregateway:
    enabled: true
```

Replace the following values:

* `AZURE_STORAGE_ACCOUNT_NAME` - the [Azure storage account name \(learn.microsoft.com\)](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-portal) 
* `AZURE_STORAGE_ACCOUNT_KEY` - the [Azure storage account key \(learn.microsoft.com\)](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-keys-manage?tabs=azure-portal) where the backups should be stored.

The StackGraph, Elasticsearch and Victoria Metrics backups are stored in BLOB containers called `sts-stackgraph-backup`, `sts-configuration-backup`, `sts-elasticsearch-backup`, `sts-victoria-metrics-backup`, `sts-clickhouse-backup` respectively. These names can be changed by setting the Helm values `backup.stackGraph.bucketName`, `backup.elasticsearch.bucketName`, `victoria-metrics-0.backup.bucketName`, `victoria-metrics-1.backup.bucketName` and `clickhouse.backup.bucketName` respectively.

### Kubernetes storage

{% hint style="warning" %}
If MinIO is configured to store its data in Kubernetes storage, a PersistentVolumeClaim (PVC) is used to request storage from the Kubernetes cluster. The kind of storage allocated depends on the configuration of the cluster.

It's advised to use AWS S3 for clusters running on Amazon AWS and Azure Blob Storage for clusters running on Azure for the following reasons:

1. Kubernetes clusters running in a cloud provider usually map PVCs to block storage, such as Elastic Block Storage for AWS or Azure Block Storage. Block storage is expensive, especially for large data volumes.
2. Persistent Volumes are destroyed when the cluster that created them is destroyed. That means an (accidental) deletion of your cluster will also destroy all backups stored in Persistent Volumes.
3. Persistent Volumes can't be accessed from another cluster. That means that it isn't possible to restore SUSE Observability from a backup taken on another cluster.
{% endhint %}

To enable backups to cluster-local storage, enable MinIO by adding the following YAML fragment to the Helm `values.yaml` file used to install SUSE Observability:

```yaml
backup:
  enabled: true
minio:
  accessKey: YOUR_ACCESS_KEY
  secretKey: YOUR_SECRET_KEY
  persistence:
    enabled: true
```

Replace the following values:

* `YOUR_ACCESS_KEY` and `YOUR_SECRET_KEY` - the credentials that will be used to secure the MinIO system. The automatic backup jobs and the restore jobs will use them. They're also required to manually access the MinIO storage. `YOUR_ACCESS_KEY` should contain 5 to 20 alphanumerical characters and `YOUR_SECRET_KEY` should contain 8 to 40 alphanumerical characters.

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

## Metrics \(Victoria Metrics\)

{% hint style="danger" %}
Victoria Metrics use incremental backups without versioning of a bucket, it means that the new backup **replaces completely the previous one**.

In case you run into one of the following situations:
- mount an empty volume to `/storage` directory of Victoria Metrics instances
- delete the `/storage` directory or files inside from Victoria Metrics instances

The next (empty) backup created will be labeled with a new version and the previous one, before the volume was emptied, will be preserved.
Both backups will be from that moment on [listed as available for restore](#list-victoria-metrics-backups). 
{% endhint %}

Metrics \(Victoria Metrics\) use instant snapshots to store data in incremental backups. Many instances of Victoria Metrics can store backups to the same bucket, each of them will be stored in separated directory. All files located in the directory should be treated as a single whole and can only be moved, copied or deleted as a whole.

{% hint style="info" %}
High Available deployments should be deployed with two instances of Victoria Metrics. Backups are enabled/configured independently for each of them.

The following code snippets/commands are provided for the first instance of Victoria Metric `victoria-metrics-0`. To backup/configure the second instance you should use `victoria-metrics-1`
{% endhint %}

### Enable scheduled backups

Backups of Victoria Metrics are disabled by default. To enabled scheduled Victoria Metrics backups, set the Helm value `victoria-metrics-0.backup.enabled` to `true`.

{% hint style="warning" %}
Victoria Metrics backups requires to [enable backups](#enable-backups).
{% endhint %}

### Enable restores

Restore functionality of Victoria Metrics are disabled by default. To enabled restore functionality of Victoria Metrics, set the Helm value `victoria-metrics-0.restore.enabled` to `true`.

{% hint style="warning" %}
Victoria Metrics restore functionality requires to [enable backups](#enable-backups).
{% endhint %}

### Backup schedule

By default, the Victoria Metrics backups are created every 1h:
- `victoria-metrics-0` - 25 minutes past the hour
- `victoria-metrics-1` - 35 minutes past the hour

The backup schedule can be configured using the Helm value `victoria-metrics-0.backup.scheduled.schedule` according [cronexpr format](https://github.com/aptible/supercronic/tree/master/cronexpr)

## OpenTelemetry \(ClickHouse\)

ClickHouse uses both incremental and full backups. By default, full backups are executed daily at 00:45 am, and incremental backups are performed every hour. Each backup creates a new directory, old backups (directories) are deleted automatically. All files located in a backup directory should be treated as a single whole and can only be moved, copied or deleted as a whole. We recommend to uses `clickhouse-backup` tool to manage backups. The tool is available on the `stackstate-clickhouse-shard0-0` Pod.

### Enable scheduled backups

Backups of the ClickHouse are disabled by default. To enabled scheduled ClickHouse backups, set the Helm value `clickhouse.backup.enabled` to `true`.

{% hint style="warning" %}
ClickHouse backups requires to [enable backups](#enable-backups).
{% endhint %}

### Enable restores

Restore functionality of the ClickHouse are disabled by default. To enabled restore functionality of the ClickHouse, set the Helm value `clickhouse.restore.enabled` to `true`.

{% hint style="warning" %}
ClickHouse restore functionality requires to [enable backups](#enable-backups).
{% endhint %}

### Backup schedule

By default, the ClickHouse backups are created:
- Full Backup - at 00:45 every day
- Incremental Backup - 45 minutes past the hour (from 3 am to 12 am)

{% hint style="warning" %}
Backups struggle with parallel execution. If a second backup starts before the first one completes, it will disrupt the first backup. Therefore, it's crucial to avoid parallel execution. For instance, the first incremental backup should be executed three hours after the full one.
{% endhint %}

The backup schedule can be configured using the Helm value `clickhouse.backup.scheduled.full_schedule` and `clickhouse.backup.scheduled.incremental_schedule` according [cronexpr format](https://github.com/aptible/supercronic/tree/master/cronexpr)

### Backup retention

By default, the tooling keeps last 308 backups (full and incremental) what is equal to ~14 days.

The backup retention can be configured using the Helm value `clickhouse.backup.config.keep_remote`.

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

By default, a snapshot is created for Elasticsearch indices with names that start with `sts`.

The indices for which a snapshot is created can be configured using the Helm value `backup.elasticsearch.scheduled.indices`, specified in [JSON array format \(w3schools.com\)](https://www.w3schools.com/js/js_json_arrays.asp).

## Restore backups and snapshots

Scripts to list and restore backups and snapshots can be found in the [restore directory of the SUSE Observability Helm chart repository \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/suse-observability/restore). To use the scripts, download them from GitHub or checkout the repository.

{% hint style="info" %}
**Before you use the scripts, ensure that:**

* The `kubectl` binary is installed and configured to connect to:
    1. The Kubernetes cluster where SUSE Observability has been installed.
    2. The namespace within that cluster where SUSE Observability has been installed.
* The following Helm values have been correctly set:
    1. `backup.enabled` is set to `true`.
    2. `backup.stackGraph.restore.enabled` isn't set to `false` \(to access StackGraph backups\).
    3. `backup.elasticsearch.restore.enabled` isn't set to `false` \(to access Elasticsearch snapshots\).
    4. `victoria-metrics-0.restore.enabled` or `victoria-metrics-1.restore.enabled` isn't set to `false` \(to access Victoria Metrics snapshots\).
{% endhint %}

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
**To avoid the unexpected loss of existing data, a backup can only be restored on a clean environment by default.**
If you are completely sure that any existing data can be overwritten, you can override this safety feature by using the command `-force`.
Only execute the restore command when you are sure that you want to restore the backup.
{% endhint %}

To restore a StackGraph backup on a clean environment, select a backup name and pass it as the first parameter in the following command:

```bash
./restore/restore-stackgraph-backup.sh sts-backup-20210216-0300.graph
```

To restore a StackGraph backup on an **environment with existing data**, select a backup name and pass it as the first parameter in the following command next to a second parameter `-force`:
{% hint style="info" %}
**Note that existing data will be overwritten when the backup is restored.**

Only do this if you are completely sure that any existing data can be overwritten.
{% endhint %}

```bash
./restore/restore-stackgraph-backup.sh sts-backup-20210216-0300.graph -force
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

In case you are running a restore command missing the `-force` flag on a non-empty database the output will contain an error like this:

```bash
ERROR com.stackvista.graph.migration.Restore - Restore isn't possible in a non empty.
```

{% hint style="info" %}
Lines that starts with `WARNING:` are expected. They're generated by Groovy running in JDK 11 and can be ignored.
{% endhint %}

### List Victoria Metrics backups

To list the Victoria Metrics backups, execute the following command:

```bash
./restore/list-victoria-metrics-backups.sh
```

The output should look like this:

```bash
job.batch/victoria-metrics-list-backups-20231016t125557 created
Waiting for job to start...
Waiting for job to start...
=== Fetching timestamps of last completed incremental backups
victoria-metrics-0 victoria-metrics-0-20231128160000 "Wed, 29 Nov 2023 07:36:00 GMT"
victoria-metrics-0 victoria-metrics-0-20231129092200 "Wed, 29 Nov 2023 10:56:00 GMT"

===
job.batch "victoria-metrics-list-backups-20231016t125557" deleted
```
where you can see the Victoria metrics instance, the specific backup version and the last time a backup was completed.

### Restore a Victoria Metrics backup

{% hint style="warning" %}
**Restore functionality always overrides data. You must be careful to avoid the unexpected loss of existing data.**
{% endhint %}

{% hint style="warning" %}
**Restore functionality requires to stop an instance of Victoria Metric while the process.** 

All new metrics will be cached by `vmagent` while the restore process, please ensure the `vmagent` has enough memory to cache metrics.
{% endhint %}

To restore a Victoria Metrics backup, select an instance name and a backup version and pass them as parameters in the following command:

```bash
./restore/restore-victoria-metrics-backup.sh victoria-metrics-0 victoria-metrics-0-20231128160000
```

The output should look like this:

```bash
=== Scaling down the Victoria Metrics instance
statefulset.apps/stackstate-victoria-metrics-0 scaled
=== Allowing pods to terminate
=== Starting restore job
job.batch/victoria-metrics-restore-backup-20231017t092607 created
=== Restore job started. Follow the logs with the following command:
kubectl logs --follow job/victoria-metrics-restore-backup-20231017t092607
=== After the job has completed clean up the job and scale up the Victoria Metrics instance pods again with the following commands:
kubectl delete job victoria-metrics-restore-backup-20231017t092607
kubectl scale statefulsets stackstate-victoria-metrics-0 --replicas=1
```

Then follow logs to check the job status
```
2023-10-17T07:26:42.564Z	info	VictoriaMetrics/lib/backup/actions/restore.go:194	restored 53072307269 bytes from backup in 0.445 seconds; deleted 639118752 bytes; downloaded 1204539 bytes
2023-10-17T07:26:42.564Z	info	VictoriaMetrics/app/vmrestore/main.go:64	gracefully shutting down http server for metrics at ":8421"
2023-10-17T07:26:42.564Z	info	VictoriaMetrics/app/vmrestore/main.go:68	successfully shut down http server for metrics in 0.000 seconds
```

After completion (**ensure if the backup has been restored successfully**), it's needed to follow commands printed by the earlier command:
- delete the restore job
- scale up the Victoria Metrics instance

### List ClickHouse backups

{% hint style="info" %}
The following script needs permission to execute the `kubectl exec` command.
{% endhint %}

To list ClickHouse backups, execute the following command:

```bash
./restore/list-clickhouse-backups.sh
```

The output should look like this:

```bash
full_2024-06-17T18-50-00          34.41KiB   17/06/2024 18:50:00   remote                                      tar, regular
incremental_2024-06-17T18-51-00   7.29KiB    17/06/2024 18:51:00   remote   +full_2024-06-17T18-50-00          tar, regular
incremental_2024-06-17T18-54-00   7.29KiB    17/06/2024 18:54:00   remote   +incremental_2024-06-17T18-51-00   tar, regular
incremental_2024-06-17T18-57-00   7.29KiB    17/06/2024 18:57:00   remote   +incremental_2024-06-17T18-54-00   tar, regular
full_2024-06-17T19-00-00          26.41KiB   17/06/2024 19:00:00   remote                                      tar, regular
incremental_2024-06-17T19-00-00   6.52KiB    17/06/2024 19:00:00   remote   +incremental_2024-06-17T18-57-00   tar, regular
incremental_2024-06-17T19-03-00   25.37KiB   17/06/2024 19:03:00   remote   +incremental_2024-06-17T19-00-00   tar, regular
incremental_2024-06-17T19-06-00   7.29KiB    17/06/2024 19:06:00   remote   +incremental_2024-06-17T19-03-00   tar, regular
```
where is printed:
- name, the name started with `full_` - it is a full backup, `incremental_` - it is an incremental backup 
- size,
- creation date,
- `remote` - a backup is upload to a remote storage like S3
- parent backup - used by incremental backups
- format and compression

### Restore a ClickHouse backup

{% hint style="warning" %}
**Restore functionality always overrides data (all tables in the `otel` database). You must be careful to avoid the unexpected loss of existing data.**
{% endhint %}

{% hint style="info" %}
The following script needs permission to execute the `kubectl exec` command.
{% endhint %}

{% hint style="warning" %}
**Restore functionality requires stopping all producers (like OpenTelemetry exporters). The script scales the StatefulSet down and then back up afterward.**
{% endhint %}


To restore a ClickHouse backup, select a backup version and pass them as a parameter in the following command:

```bash
./restore/restore-clickhouse-backup.sh incremental_2024-06-17T18-57-00
```

The output should look like this:

```bash
...
2024/06/17 19:14:19.509498  info download object_disks start backup=incremental_2024-06-17T19-06-00 operation=restore_data table=otel.otel_traces_trace_id_ts_mv
2024/06/17 19:14:19.509530  info download object_disks finish backup=incremental_2024-06-17T19-06-00 duration=0s operation=restore_data size=0B table=otel.otel_traces_trace_id_ts_mv
2024/06/17 19:14:19.509549  info done                      backup=incremental_2024-06-17T19-06-00 duration=0s operation=restore_data progress=12/12 table=otel.otel_traces_trace_id_ts_mv
2024/06/17 19:14:19.509574  info done                      backup=incremental_2024-06-17T19-06-00 duration=66ms operation=restore_data
2024/06/17 19:14:19.509591  info done                      backup=incremental_2024-06-17T19-06-00 duration=167ms operation=restore version=2.5.13
2024/06/17 19:14:19.509684  info clickhouse connection closed logger=clickhouse
Data restored
```

{% hint style="info" %}
**Error: error can't create table …. code: 57, message: Directory for table data store/…/ already exists**

ClickHouse does not permanently delete tables when the `DROP DATABASE/TABLE ...` command is executed. Instead, the database is marked as deleted and will be permanently removed after 8 minutes. This delay provides additional time to undo the operation. More details can be found at [UNDROP TABLE](https://clickhouse.com/docs/en/sql-reference/statements/undrop). If you attempt to restore data during this period, it will fail and produce the aforementioned error. Available solutions:
- wait 8 minutes (check table `select * from system.dropped_tables;` )
- configure `database_atomic_delay_before_drop_table_sec`
{% endhint %}

### List Elasticsearch snapshots

To list the Elasticsearch snapshots, execute the following command:

```bash
./restore/list-elasticsearch-snapshots.sh
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


### Delete Elasticsearch indices

To delete existing Elasticsearch indices so that a snapshot can be restored, follow these steps.

1. Stop indexing - scale down all `*2es` deployments to 0:

   ```bash
   kubectl scale --replicas=0 deployment/e2es
   ```

2. Open a port-forward to the Elasticsearch master:

   ```bash
   kubectl port-forward service/stackstate-elasticsearch-master 9200:9200
   ```

3. Get a list of all indices:

   ```bash
   curl "http://localhost:9200/_cat/indices?v=true"
   ```
   
   The output should look like this:

   ```bash
   health status index                          uuid                   pri rep docs.count docs.deleted store.size pri.store.size
   green  open   sts_internal_events-2022.09.20 fTk7iEYtQI6ruVFuwNnbPw   1   0        125            0     71.7kb         71.7kb
   green  open   .geoip_databases               GYA_c3i6QKenfFehnwBcAA   1   0         41            0     38.8mb         38.8mb
   green  open   sts_multi_metrics-2022.09.20   MT1DceQPTDWVIfBJdl7qUg   3   0       1252            0    550.1kb        550.1kb
   ```

5. Delete an index with a following command:

   ```bash
   curl -X DELETE "http://localhost:9200/INDEX_NAME?pretty"
   ```

   Replace `INDEX_NAME` with the name of the index to delete, for example:

   ```bash
   curl -X DELETE "http://localhost:9200/sts_internal_events-2021.02.19?pretty"
   ```

6. The output should be:

   ```javascript
   {
   "acknowledged" : true
   }
   ```

### Restore an Elasticsearch snapshot

{% hint style="danger" %}
**When a snapshot is restored, existing indices won't be overwritten.**

See [delete Elasticsearch indices](kubernetes_backup.md#delete-elasticsearch-indices).
{% endhint %}

To restore an Elasticsearch snapshot, select a snapshot name and pass it as the first parameter in the following command line. You can optionally specify a second parameter with a comma-separated list of the indices that should be restored. If not specified, all indices that match the Helm value `backup.elasticsearch.scheduled.indices` will be restored (default `"sts*"`):

```bash
./restore/restore-elasticsearch-snapshot.sh \
  sts-backup-20210223-0300-ppss8nx40ykppss8nx40yk \
  "<INDEX_TO_RESTORE>,<INDEX_TO_RESTORE>"
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
   ```
