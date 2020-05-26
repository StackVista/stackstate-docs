---
title: File Based Import and Export
kind: Documentation
---

# File-based backup

To backup and restore StackState configuration and topology information we can use StackState's import and export functionality. StackState's configuration and topology data is stored in StackGraph. Telemetry information is stored in Elasticsearch.

## StackState configuration and topology data

To back up StackGraph's data on a running StackState instance:

`/opt/stackstate/bin/sts-standalone.sh export --file <path to backup file> --graph default`

**Note**: the path to the backup file needs to be writable by the `stackstate` user/group.

Alternatively, `/opt/stackstate/bin/sts-backup.sh` can be used to create a backup that will be written to `/opt/stackstate/backups/`.

To restore topology information by importing a previous made backup on a running StackState instance:

`/opt/stackstate/bin/sts-standalone.sh import --file <path to backup file> --graph default`

**Note**: additional log messages can be found in `<stackstate installation path>/var/log/stackstate.log`

## StackState telemetry data

StackState's telemetry data is stored in Elasticsearch. To backup and restore Elasticsearch data we recommend to follow Elasticsearch's [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/5.3/modules-snapshots.html).

