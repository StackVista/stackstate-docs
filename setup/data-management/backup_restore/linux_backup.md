---
description: StackState Self-hosted v4.6.x
---

# Linux backup

{% hint style="warning" %}
**This page describes StackState version 4.6.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/setup/data-management/backup_restore/linux_backup).
{% endhint %}

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

To restore previously backed up topology data:

1. Make sure that StackGraph is up and running.
2. Stop the StackState node using `sudo systemctl stop stackstate.service`.
3. Run the restore form a specified backup file:

   ```text
   /opt/stackstate/bin/sts-standalone.sh import \
   --file <path_to_backup_file> \
   --graph default
   ```

4. Track progress of the restore in the StackState log file `<stackstate_installation_path>/var/log/stackstate.log`.
5. When the restore has successfully completed, start the StackState node using `sudo systemctl start stackstate.service`.

## Telemetry data

StackState telemetry data is stored in Elasticsearch. To backup and restore Elasticsearch data we recommend to follow the [Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/7.3/modules-snapshots.html).

