---
description: StackState Self-hosted v5.0.x 
---

# Linux backup

{% hint style="info" %}
StackState prefers Kubernetes!  
In the future we will move away from Linux support. Read how to [migrate from the Linux install of StackState to the Kubernetes install](/setup/install-stackstate/kubernetes_install/migrate_from_linux.md).
{% endhint %}

## Overview

To backup and restore StackState configuration and topology information we can use StackState's import and export functionality. StackState's configuration and topology data is stored in StackGraph. Telemetry information is stored in Elasticsearch.

## Configuration and topology data

### Backup

StackState topology and configuration data are stored in StackGraph. To create a backup of StackGraph data on a [production setup](../../install-stackstate/linux_install/production-installation.md):

1. Make sure that StackGraph is up and running.
2. Stop the StackState node using `sudo systemctl stop stackstate.service`.
3. Use one of the following commands to start the backup process:

   ```text
   # Backup to the default location `/opt/stackstate/backups/`:
   /opt/stackstate/bin/sts-backup.sh

   # Specify a backup location:
   /opt/stackstate/bin/sts-standalone.sh export \
    --file <path_to_store_backup> \
    --graph default

   # Note that the specified path must be writable for user/group `stackstate`.
   ```

### Restore

{% hint style="warning" %}
**To avoid the unexpected loss of existing data, a backup can only be restored on a clean environment by default.**
If you are completely sure that any existing data can be overwritten, you can override this safety feature by using the command `-force`.
Only execute the restore command when you are sure that you want to restore the backup.
{% endhint %}

To restore previously backed up topology data:

1. Make sure that StackGraph is up and running.
2. Stop the StackState node using `sudo systemctl stop stackstate.service`.
3a. Run the restore from a specified backup file on a clean environment:

   ```text
   /opt/stackstate/bin/sts-standalone.sh import \
   --file <path_to_backup_file> \
   --graph default
   ```
3b. Run the restore from a specified backup file on on an **environment with existing data**:

   ```text
   /opt/stackstate/bin/sts-standalone.sh import \
   --file <path_to_backup_file> \
   --graph default
   --force
   ```
4. Track progress of the restore in the StackState log file `<stackstate_installation_path>/var/log/stackstate.log`.
5. When the restore has successfully completed, start the StackState node using `sudo systemctl start stackstate.service`.

## Telemetry data

StackState telemetry data is stored in Elasticsearch. To backup and restore Elasticsearch data we recommend to follow the [Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/7.3/modules-snapshots.html).

