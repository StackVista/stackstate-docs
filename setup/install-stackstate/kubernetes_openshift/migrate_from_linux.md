---
description: StackState Self-hosted v5.1.x 
---

# Migrate from Linux install

## Overview

This document describes how to migrate data from the Linux install of StackState to the Kubernetes or OpenShift install.

## High level steps

To migrate from the Linux install to the Kubernetes or OpenShift install of StackState, the following high level steps need to be performed:

1. [Install StackState](kubernetes_install.md) on Kubernetes.
2. [Migrate StackState configuration and topology data \(StackGraph\)](migrate_from_linux.md#step-2-migrate-stackstate-configuration-and-topology-data-stackgraph) from the Linux install to the Kubernetes or OpenShift install.
3. [Migrate telemetry data \(Elasticsearch\)](migrate_from_linux.md#step-3-migrate-telemetry-data-elasticsearch) from the Linux install to the Kubernetes or OpenShift install.

Incoming data from agents \(Kafka\) and node synchronisation data \(Zookeeper\) will not be copied.

**After the migration:**

1. Run both instances of StackState side by side for a number of days to ensure that the new instance runs correctly.
2. Stop the Linux install for StackState.
3. Remove the Linux install for StackState.

## Step 2 - Migrate StackState configuration and topology data \(StackGraph\)

### Prerequisites

Before you start the migration procedure, make sure you have the following information and tools available:

* Access to:
  * The Linux machines running your old StackState installation.
  * The Kubernetes/OpenShift cluster running your new StackState installation.
  * The `values.yaml` file used to install your StackState installation on Kubernetes/OpenShift.
  * The restore scripts that are part of the [StackState Helm chart \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/restore).
* Tools:
  * [helm \(helm.sh\)](https://helm.sh/)
  * [mc - the MinIO client \(docs.min.io\)](https://min.io/docs/minio/linux/reference/minio-mc.html?ref=docs-redirect)

### Export StackGraph data

To export the StackGraph data, execute the regular StackState Linux backup procedures as described below.

1. Ensure that the StackGraph node is up and running.
2. Login to the StackState node as user `root`.
3. Stop the StackState service:

   ```bash
    systemctl stop stackstate.service
   ```

4. Create a directory to store the exported data:

   ```bash
    sudo -u stackstate mkdir -p /opt/stackstate/migration
   ```

5. Export the StackGraph data by creating a backup:

   ```bash
    sudo -u stackstate /opt/stackstate/bin/sts-standalone.sh export \
        --file /opt/stackstate/migration/sts-export.graph --graph default
   ```

6. Copy the file `/opt/stackstate/migration/sts-export.graph` to a safe location.
7. Start the StackState service:

   ```bash
    systemctl start stackstate.service
   ```

### Import StackGraph data

To import the StackGraph data into the Kubernetes/OpenShift installation, the same [MinIO \(min.io\)](https://min.io/) component that is used for the backup/restore functionality will be used.

{% hint style="info" %}
Note that the [StackState automatic Kubernetes backup functionality](../../data-management/backup_restore/kubernetes_backup.md) should not be enabled until after the migration procedure has completed.
{% endhint %}

1. Enable the MinIO component by adding the following YAML fragment to the `values.yaml` file that is used to install StackState

   ```yaml
    backup:
      enabled: true
      stackGraph:
        scheduled:
          enabled: false
      elasticsearch:
        restore:
          enabled: false
        scheduled:
          enabled: false
    minio:
      accessKey: MINIO_ACCESS_KEY
      secretKey: MINIO_SECRET_KEY
      persistence:
        enabled: true
   ```

   Include the credentials to access the MinIO instance:

   * Replace `MINIO_ACCESS_KEY` with 5 to 20 alphanumerical characters.
   * Replace `MINIO_SECRET_KEY` with 8 to 40 alphanumerical characters.

```text
The Helm values `backup.stackGraph.scheduled.enabled`, `backup.elasticsearch.restore.enabled` and `backup.elasticsearch.scheduled.enabled` have been set to `false` to prevent scheduled backups from overwriting the backups that we will upload to MinIO.
```

1. Run the appropriate `helm upgrade` command for your installation to enable MinIO.
2. Start a port-forward to the MinIO service in your StackState instance:

   ```bash
    kubectl port-forward service/stackstate-minio 9000:9000
   ```

3. In a new terminal window, configure the MinIO client to connect to that MinIO service:

   ```bash
    mc alias set minio-backup http://localhost:9000 ke9Dm7eFhk9kP53rXlUI mNOWCpoYrhwati7QcOrEwnI7Mtcf0jxg2JzNOMk6
   ```

4. Verify that access has been configured correctly:

   ```bash
    mc ls minio-backup
   ```

   The output should be empty, as we have not created any buckets yet.

   If the output is not empty, the automatic backup functionality has been enabled. Disable the automatic backup functionality and configure MinIO as described above \(i.e. not as a gateway to AWS S3 or Azure Blob Storage and without any local storage\).

5. Create the bucket that is used to store StackGraph buckets:

   ```bash
    mc mb minio-backup/sts-stackgraph-backup
   ```

   The output should look like this:

   ```text
    Bucket created successfully `minio-backup/sts-stackgraph-backup`.
   ```

6. Upload the backup file created in the previous step when [StackGraph data was exported](migrate_from_linux.md#export-stackgraph-data) from the Linux install:

   ```bash
    mc cp sts-export.graph minio-backup/sts-stackgraph-backup/
   ```

   The output should look like this:

   ```text
    sts-export.graph:                             15.22 KiB / 15.22 KiB  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  42.61 KiB/s 0s
   ```

7. Verify that the backup file was uploaded to the correct location:

   ```bash
    ./restore/list-stackgraph-backups.sh
   ```

   The output should look like this:

   ```text
    job.batch/stackgraph-list-backups-20210222t122522 created
    Waiting for job to start...
    Waiting for job to start...
    === Listing StackGraph backups in bucket "sts-stackgraph-backup"...
    sts-export.graph
    ===
    job.batch "stackgraph-list-backups-20210222t122522" deleted
   ```

   Most importantly, the backup file uploaded in the previous step should be listed here.

8. Restore the backup:

   ```bash
    ./restore/restore-stackgraph-backup.sh sts-export.graph
   ```

   The output should look like this:

   ```text
    job.batch/stackgraph-restore-20210222t171035 created
    Waiting for job to start...
    Waiting for job to start...
    === Downloading StackGraph backup "sts-export.graph" from bucket "sts-stackgraph-backup"...
    download: s3://sts-stackgraph-backup/sts-export.graph to ../../tmp/sts-export.graph
    === Importing StackGraph data from "sts-export.graph"...
    WARNING: An illegal reflective access operation has occurred
    WARNING: Illegal reflective access by org.codehaus.groovy.vmplugin.v7.Java7$1 (file:/opt/docker/lib/org.codehaus.groovy.groovy-2.5.4.jar) to constructor java.lang.invoke.MethodHandles$Lookup(java.lang.Class,int)
    WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.vmplugin.v7.Java7$1
    WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
    WARNING: All illegal access operations will be denied in a future release
    ===
    job.batch "stackgraph-restore-20210222t171035" deleted
   ```

9. Remove the YAML snippet added in step 1 and run the appropriate `helm upgrade` command for your installation to disable MinIO.

## Step 3 - Migrate telemetry data \(Elasticsearch\)

To migrate Elasticsearch data from the Linux install to the Kubernetes or OpenShift install, use the functionality [reindex from remote \(elastic.co\)](https://www.elastic.co/guide/en/elasticsearch/reference/7.6/reindex-upgrade-remote.html).

Notes:

* To access the Elasticsearch instance that runs as part of the Kubernetes or OpenShift installation for StackState, execute the following command:

  ```bash
    kubectl port-forward service/stackstate-elasticsearch-master 9200:9200
  ```

  and access it on `http://localhost:9200`.

* To modify the `elasticsearch.yml` configuration file, use the Helm chart value `stackstate.elasticsearch.esConfig`.

  For example:

  ```yaml
    stackstate:
        elasticsearch:
            esConfig:
                elasticsearch.yml: |
                    reindex.remote.whitelist: oldhost:9200
  ```

## See also

* [Install StackState on Kubernetes](kubernetes_install.md)
* [Install StackState on OpenShift](openshift_install.md)
* [StackState Helm chart \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/restore)
* [StackState Linux backup](../../data-management/backup_restore/linux_backup.md)

