# Kubernetes backup

Several mechanisms can be used for backups. When running in EKS or AKS, the easiest setup is to periodically make snapshots of all the volumes attached to the StackState processes \(i.e. in the same namespace\). A tool that can automate this for you is [Velero \(velero.io\)](https://velero.io/).

See also:

* [Manually created topology backup](manual_topology.md)
* [Configuration backup](configuration.md)

