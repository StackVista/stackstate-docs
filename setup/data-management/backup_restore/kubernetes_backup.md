# Kubernetes backup

{% hint style="warning" %}
**This page describes StackState version 4.1. **

The StackState 4.1 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.1 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

Several mechanisms can be used for backups. When running in EKS or AKS, the easiest setup is to periodically make snapshots of all the volumes attached to the StackState processes \(i.e. in the same namespace\). A tool that can automate this for you is [Velero \(velero.io\)](https://velero.io/).

See also:

* [Manually created topology backup](manual_topology_backup.md)
* [Configuration backup](configuration_backup.md)

