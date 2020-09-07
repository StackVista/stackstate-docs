# Backup and restore

Several mechanisms can be used for backups. When running in EKS or AKS the easiest setup is to periodically make snapshots of all the volumes attached to the StackState processes \(i.e. in the same namespace\). A tool that can automate this for you is [Velero \(velero.io\)](https://velero.io/).

## Import and export configuration

StackState has the ability to export its configuration. This configuration can then be imported again at a later time, in a clean StackState instance or it can be used as a starting point to setup a new StackState environment. The most convenient way to create an export and later ipmort it again is to use the [StackState CLI](../cli.md) import and export commands.

Exporting is as simple as running:

```text
sts-cli graph export stackstate_settings.stj
```

Importing can also be done with the CLI, however, this only advised on an empty StackState \(i.e. a new deployment\). If StackState is not empty, the import will very likely fail. To import, run this command:

```text
cat stackstate_settings.stj | sts-cli graph import
```

