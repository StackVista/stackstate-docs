---
title: File Based Import and Export
kind: Documentation
---

# File-based backup

To backup and restore StackState configuration and topology information we can use StackState's import and export functionality. StackState's configuration and topology data is stored in StackGraph. Telemetry information is stored in Elasticsearch.

## StackState configuration and topology data

### Backup

In order to backup StackGraph's data on a [production setup](../installation/production-installation.md) you need to: 1. Have StackGraph up and running 2. Stop StackState node [Starting and Stopping StackState](https://github.com/StackVista/stackstate-docs/tree/3d23242fb63725889415e9d55f980c437c47e7d9/setup/installation/production-installation/README.md#starting-and-stopping-stackstate) `sudo systemctl stop stackstate.service` 3. Use one of the following commands to start the backup process:

* `/opt/stackstate/bin/sts-standalone.sh export --file <path to backup file> --graph default` where the path to the backup file needs to be writable by the `stackstate` user/group
* Alternatively, `/opt/stackstate/bin/sts-backup.sh` can be used to create a backup that will be written to `/opt/stackstate/backups/`.

### Restore

In order to restore topology information by importing a previous made backup you need to: 1. Have StackGraph up and running 2. Stop StackState node [Starting and Stopping StackState](https://github.com/StackVista/stackstate-docs/tree/3d23242fb63725889415e9d55f980c437c47e7d9/setup/installation/production-installation/README.md#starting-and-stopping-stackstate) 3. `/opt/stackstate/bin/sts-standalone.sh import --file <path to backup file> --graph default` 4. All progress and end result of the process is logged at `<stackstate installation path>/var/log/stackstate.log`. Verify that the process finished and what the outcome was before trying to [Starting and Stopping StackState](https://github.com/StackVista/stackstate-docs/tree/3d23242fb63725889415e9d55f980c437c47e7d9/setup/installation/production-installation/README.md#starting-and-stopping-stackstate) `sudo systemctl start stackstate.service`

## StackState telemetry data

StackState's telemetry data is stored in Elasticsearch. To backup and restore Elasticsearch data we recommend to follow Elasticsearch's [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/7.3/modules-snapshots.html).

