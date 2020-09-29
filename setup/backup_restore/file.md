# Linux backup

{% hint style="info" %}
StackState prefers Kubernetes!  
In the future we will move away from Linux support. Read about [installing StackState on Kubernetes](/setup/kubernetes_install/README.md).
{% endhint %}

To backup and restore StackState configuration and topology information we can use StackState's import and export functionality. StackState's configuration and topology data is stored in StackGraph. Telemetry information is stored in Elasticsearch.

## StackState configuration and topology data

### Backup

In order to backup StackGraph's data on a [production setup](/setup/linux_install/production-installation.md) you need to:

1. Have StackGraph up and running.
2. Stop the StackState node using `sudo systemctl stop stackstate.service`.
3. Use one of the following commands to start the backup process:

```
# Backup to the default location `/opt/stackstate/backups/`:
/opt/stackstate/bin/sts-backup.sh

# Specify a backup location:
/opt/stackstate/bin/sts-standalone.sh export \
  --file <path_to_store_backup> \
  --graph default

# Note that the specified path must be writable for user/group `stackstate`.
```

### Restore

In order to restore topology information by importing a previous made backup you need to:

1. Have StackGraph up and running.
2. Stop StackState node using `sudo systemctl stop stackstate.service`.
3. Restore a backup from a specified file:
```
/opt/stackstate/bin/sts-standalone.sh import \
  --file <path_to_backup_file> \
  --graph default
```
4. Progress and the end result of the restore process is logged at `<stackstate_installation_path>/var/log/stackstate.log`.
5. Check the log to verify that the restore process completed successfully.
6. Start the StackState node using `sudo systemctl start stackstate.service`.

## StackState telemetry data

StackState's telemetry data is stored in Elasticsearch. To backup and restore Elasticsearch data we recommend to follow the [Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/7.3/modules-snapshots.html).
