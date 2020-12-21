# Migrate from Linux install to Kubernetes install

This document describes how to migrate data from the Linux install of StackState to the Kubernetes install.

## High level steps

To migrate from the Linux install to the Kubernetes install of StackState, the following high level steps will need to be performed:

1. Install StackState on Kubernetes by following [the installation manual](install_stackstate.md).
1. Copy StackState configuration and topology data (StackGraph) and Telemetry data (ElasticSearch) from the Linux install to the Kubernetes install. Incoming data from agents (Kafka) and node synchronisation data (Zookeeper) is not copied. See below for the instruction to step 2.
1. Run both instances of StackState side by side for a number of days to ensure 
1. Stop the Linux install for StackState.
1. Remove the Linux install for StackState.

## Step 2 - Migrate StackState configuration and topology data (StackGraph) and telemetry data (ElasticSearch)

Follow these steps to copy the StackGraph and ElasticSearch data from the Linux install to the Kubernetes install.

### Step 2.0 - Prerequisites

Before you start this migration procedure, make sure you have the following information and tools available:

* Access to the Linux machines running your old StackState installation
* Access to the Kubernetes cluster running your new StackState installation
* Access to the `values.yaml` file used to install your StackState installation on Kubernetes
* The following tools:
    * [curl](https://curl.se/)
    * [helm](https://helm.sh/)
    * [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### Step 2.1 - Export the StackGraph data

<a name="export_stackgraph_data"></a>To export the StackGraph data, execute the [regular backup procedures](../../data-management/backup_restore/linux_backup.md) as described below.

1. Ensure that the StackGraph node is up and running.

1. Login to the StackState node as user `root`.

1. Stop the StackState service using

    ``` bash
    systemctl stop stackstate.service
    ```

1. Create a directory to store the exported data:

    ```bash
    sudo -u stackstate mkdir -p /opt/stackstate/migration
    ```

1. Export the StackGraph data by creating a backup:

    ```bash
    sudo -u stackstate /opt/stackstate/bin/sts-standalone.sh export \
        --file /opt/stackstate/migration/sts-export.graph --graph default
    ```

1. Copy the file `/opt/stackstate/migration/sts-export.graph` to a safe location

### Step 2.2 - Export the ElasticSearch data

<a name="export_elasticsearch_data"></a>To export the ElasticSearch data, follow the instruction below to create a "snapshot".

1. Login to the StackState node as user `root`.

1. Ensure that the StackState service is stopped:

    ```bash
    systemctl status stackstate.service
    ```

1. Edit the file `/opt/stackstate/etc/elasticsearch7/elasticsearch.yml` and add the following line:

    ```yaml
    path.repo: ["/opt/stackstate/migration" ]
    ```

1. Start the StackState service using

    ``` bash
    systemctl start stackstate.service
    ```

1. Create a directory to store the exported ElasticSearch data:

    ```bash
    sudo -u stackstate mkdir -p /opt/stackstate/migration/elastic
    ```

1. Configure an ElasticSearch snapshot repository:

    ```bash
    curl -X PUT 'localhost:9200/_snapshot/migration?pretty' -H 'Content-Type: application/json' -d'
    {
        "type": "fs",
        "settings": {
            "location": "/opt/stackstate/migration/elastic"
        }
    }'
    ```

1. Export the ElasticSearch data by creating a snapshot:

    ```bash
    curl -X PUT 'localhost:9200/_snapshot/migration/export?wait_for_completion=true&pretty'
    ```

    The output should look like this:

    ```json
    {
      "snapshot" : {
        "snapshot" : "export",
        "uuid" : "yYVNJj5GQSSACrf34nIErg",
        "version_id" : 7030299,
        "version" : "7.3.2",
        "indices" : [
          "sts_internal_events-2020.11.12",
          "sts_internal_events-2020.12.16",
          "sts_internal_events-2020.12.18",
          "sts_internal_events-2020.11.10"
        ],
        "include_global_state" : true,
        "state" : "SUCCESS",
        "start_time" : "2020-12-18T07:51:36.686Z",
        "start_time_in_millis" : 1608277896686,
        "end_time" : "2020-12-18T07:51:36.771Z",
        "end_time_in_millis" : 1608277896771,
        "duration_in_millis" : 85,
        "failures" : [ ],
        "shards" : {
          "total" : 4,
          "failed" : 0,
          "successful" : 4
        }
      }
    }
    ```

    The number behind `failed` in the `shards` section should be 0.

1. Verify that the data was written to the directory `opt/stackstate/migration/elastic` looks like this:

    ```text
    -rw-r--r--. 1 stackstate stackstate  503 Dec 18 11:48 index-0
    -rw-r--r--. 1 stackstate stackstate    8 Dec 18 11:48 index.latest
    drwxr-xr-x. 6 stackstate stackstate  126 Dec 18 11:48 indices
    -rw-r--r--. 1 stackstate stackstate 5259 Dec 18 11:48 meta-_JK4DXqgSYKOs49XkvM1gA.dat
    -rw-r--r--. 1 stackstate stackstate  366 Dec 18 11:48 snap-_JK4DXqgSYKOs49XkvM1gA.dat
    ```

1. Copy the directory `/opt/stackstate/migration/elastic` to a safe location.

1. Remove the snapshot repository:

    ```bash
    curl -X DELETE 'localhost:9200/_snapshot/migration?pretty'
    ```

1. Edit the file `/opt/stackstate/etc/elasticsearch7/elasticsearch.yml` and remove the following line:

    ```yaml
    path.repo: ["/opt/stackstate/migration" ]
    ```

1. Restart the StackState service:

    ```bash
    systemctl stop stackstate.service
    systemctl start stackstate.service
    ```

### Step 2.3 - Import the StackGraph data

To import the StackGraph data into the Kubernetes installation, create a Kubernetes job to run the import command as decribed below.

1. *StackState 4.1.x only:* In the Kubernetes setup, stop the `stackstate-server-0` pod:

    ```bash
    kubectl scale statefulset stackstate-server --replicas 0
    ```

1. Wait for the `stackstate-server-0` pod to be terminated.

1. Save the following YAML fragment that creates a Kubernetes job to a file called `import-stackgraph-data.yaml`:
    ```yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
    name: import-stackgraph-data
    spec:
    backoffLimit: 0
    ttlSecondsAfterFinished: 600
    template:
        spec:
        containers:
        - name: import-stackgraph
            image: quay.io/stackstate/stackstate-server-stable:sts-v4.1.2
            command:
            - '/bin/sh'
            - '-c'
            - 'echo "$(date): Waiting for backup file to be uploaded..."; while [ ! -f /tmp/sts-export.uploaded ]; do sleep 1; done; echo "$(date): Starting import..."; /sbin/tini  -- /opt/docker/bin/stackstate-server -import /tmp/sts-export.graph'
        restartPolicy: Never
    ```
1. Create the import job:

    ```bash
    kubectl create -f import-stackgraph-data.yaml
    ```

1. Determine which pod runs the job:

    ```bash
    export STS_IMPORT_POD=$(kubectl get pod --selector=job-name=import-stackgraph-data -o jsonpath='{.items[*].metadata.name}')
    ```

1. Verify that exactly one pod was selected:
    ```bash
    echo $STS_IMPORT_POD
    ```

    The output should look like this:
    ```text
    import-stackgraph-data-p624n
    ```

1. Copy the export file created in [step 2.1](#export_stackgraph_data) to the pod:
    ```bash
    kubectl cp sts-export.graph ${STS_IMPORT_POD}:/tmp/sts-export.graph
    ```

1. Create a marker file that includes the name of the uploaded file: 
    ```bash
    echo "ready" > /tmp/sts-export.uploaded
    ```

1. Copy the marker file to the pod:
    ```bash
    kubectl cp /tmp/sts-export.uploaded ${STS_IMPORT_POD}:/tmp/sts-export.uploaded
    ```

1. Follow the logs of the job to see the progress of the import:
    ```bash
    kubectl logs -f job/import-stackstate-data
    ```

1. The logs should start like this:
    ```text
    Wed Nov 18 10:58:14 UTC 2020: Waiting for backup file to be uploaded...
    Wed Nov 18 10:59:46 UTC 2020: Starting import...
    WARNING: An illegal reflective access operation has occurred
    WARNING: Illegal reflective access by org.codehaus.groovy.vmplugin.v7.Java7$1 (file:/opt/docker/lib/org.codehaus.groovy.groovy-2.5.4.jar) to constructor java.lang.invoke.MethodHandles$Lookup(java.lang.Class,int)
    WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.vmplugin.v7.Java7$1
    WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
    WARNING: All illegal access operations will be denied in a future release
    2020-11-18 10:59:49,514 [main] INFO  com.stackvista.graph.migration.Restore - Restoring graph default from /tmp/sts-backup.graph.
    2020-11-18 10:59:49,524 [main] INFO  com.stackvista.graph.migration.Restore - Contains changes till 1605024748407000000 Tue Nov 10 16:12:28 GMT 2020. With epoch Optional[TransactionId(id=1604333540368000000)]
    ```

1. Wait for the job to complete.

1. *StackState 4.1.x only:* Start the `stackstate-server-0` pod:

    ```bash
    kubectl scale statefulset stackstate-server --replicas 1
    ```

### Step 2.4 - Import the ElasticSearch data

To import the ElasticSearch data, install [MinIO](https://min.io/) in the Kubernetes cluster, copy the snapshot created in step 2.2 into the MinIO pod, configure ElasticSearch to connect to Minio, and then tell ElasticSearch to import the snapshot.

1. In the Kubernetes setup, install minio into the namespace where you installed StackState:

    ```bash
    helm install minio minio --repo https://helm.min.io/ --version '8.0.8' \
        --set 'persistence.enabled=false' \
        --set 'buckets[0].name=elastic,buckets[0].policy=none,buckets[0].purge=false'
    ```

1. Determine which pod runs MinIO:

    ```bash
    export STS_MINIO_POD=$(kubectl get pod --selector=app=minio -o jsonpath='{.items[*].metadata.name}')
    ```

1. Verify that exactly one pod was selected:
    ```bash
    echo $STS_MINIO_POD
    ```

    The output should look like this:
    ```text
    minio-6bd7bc5bf8-srwm2
    ```

1. Copy the exported data from [step 2.2](#export_elasticsearch_data) into the pod:

    ```bash
    kubectl cp ./elastic ${STS_MINIO_POD}:/export
    ```

1. Verify that the data has been copied correctly:

    ```bash
    kubectl exec ${STS_MINIO_POD} -- ls -l /export/elastic
    ```

    The output should look like the output of the similar command in step 2.2:

    ```text
    -rw-r--r--    1 501      dialout        416 Dec 21 08:03 index-0
    -rw-r--r--    1 501      dialout          8 Dec 21 08:03 index.latest
    drwxr-xr-x    5 root     root            96 Dec 21 08:03 indices
    -rw-r--r--    1 501      dialout       5274 Dec 21 08:03 meta--eEQ0gyGRdyi6jxhXwkEpw.dat
    -rw-r--r--    1 501      dialout        352 Dec 21 08:03 snap--eEQ0gyGRdyi6jxhXwkEpw.dat
    ```

1. Retrieve the access key and secret key to access MinIO:

    ```bash
    MINIO_ACCESS_KEY=$(kubectl get secret minio -o jsonpath="{.data.accesskey}" | base64 --decode)
    MINIO_SECRET_KEY=$(kubectl get secret minio -o jsonpath="{.data.secretkey}" | base64 --decode)
    ```

1. Create secrets to refer to from the ElasticSearch configuration:

    ```bash
    kubectl create secret generic minio-keys \
        --from-literal=access_key=${MINIO_ACCESS_KEY} \
        --from-literal=secret_key=${MINIO_SECRET_KEY}
    ```

1. <a name="add_minio_keys_to_values"></a>Modify the `values.yaml` file you use to start StackState and add the following YAML fragment:

    ```yaml
    elasticsearch:
        keystore:
        - secretName: minio-keys
          items:
            - key: access_key
              path: s3.client.minio.access_key
            - key: secret_key
              path: s3.client.minio.secret_key
    ```

    **Note:** If you have an existing `elasticsearch` fragment, merge the `keystore` fragment.

1. Reinstall StackState and wait for the pods to come back up:

    ```bash
    helm upgrade stackstate stackstate/stackstate --values values.yaml
    ```

    **Note:** This command assumes you named the Helm release `stackstate` when you installed StackState on Kubernetes. If you used a different name for the Helm release, change the first parameter to the `helm upgrade` command appropiately.

1. Expose the ElasticSearch master port:

    ```bash
    kubectl port-forward service/stackstate-elasticsearch-master 9200:9200
    ```

    **Note:** This command assumes you named the Helm release `stackstate` when you installed StackState on Kubernetes. If you used a different name for the Helm release, substitute the right service name.

1. In a new terminal window, configure an ElasticSearch snapshot repository

    ```bash
    curl -X PUT 'localhost:9200/_snapshot/migration?pretty' -H 'Content-Type: application/json' -d'
    {
        "type": "s3",
        "settings": {
            "bucket": "elastic",
            "endpoint": "minio:9000",
            "client": "minio",
            "protocol": "http",
            "path_style_access": "true"
        }
    }'
    ```

1. Import the snapshot:

    ```bash
    curl -X POST 'localhost:9200/_snapshot/migration/export/_restore?wait_for_completion=true&pretty'
    ```

    The output should look like this:
    ```bash
    {
      "snapshot" : {
        "snapshot" : "export",
        "indices" : [
          "sts_internal_events-2020.12.18",
          "sts_internal_events-2020.11.10",
          "sts_internal_events-2020.11.12",
          "sts_internal_events-2020.12.16"
        ],
        "shards" : {
          "total" : 4,
          "failed" : 0,
          "successful" : 4
        }
      }
    }
    ```

    The number behind `failed` in the `shards` section should be 0.

1. Remove the YAML fragment that was added to the `values.yaml` file for this StackState installation that was added in [a previous step](#add_minio_keys_to_values).

1. Reinstall StackState and wait for the pods to come back up:

    ```bash
    helm upgrade stackstate stackstate/stackstate --values values.yaml
    ```

    **Note:** This command assumes you named the Helm release `stackstate` when you installed StackState on Kubernetes. If you used a different name for the Helm release, change the first parameter to the `helm upgrade` command appropiately.

1. Remove the secrets created to store the MinIO keys:

    ```bash
    kubectl delete secret minio-keys
    ```

1. Uninstall MinIO:

    ```bash
    helm delete minio
    ```

