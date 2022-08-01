---
description: StackState Self-hosted v5.0.x
---

# StackState Agent images

## Overview

This page describes the images used by the StackState Cluster Agent helm chart and how to configure the registry, repository, and tag used to pull them.  It additionally includes a description of the process of importing images into an air-gapped private image registry.

## Serve images from a different image registry, not air-gapped

Please see the process for [StackState Images here](image_configuration.md)

The StackState Agent (cluster-agent) helm chart has a similar installation script to the one mentioned in the StackState images page linked above, with an identical script in a different directory, see [copy-images.sh (github.com)](https://github.com/StackVista/helm-charts/blob/master/stable/cluster-agent/installation/copy_images.sh)

## Serve images from a different image registry that is air-gapped

If the requirement is to run the StackState agent in an environment that does not have a direct connection to the Internet, the following procedure can be used to transfer the images:

### Back up the images from StackState (Internet connection required)

There is an installation backup script, [backup.sh (github.com)](https://github.com/StackVista/helm-charts/blob/master/stable/cluster-agent/installation/backup.sh), that pulls all images required for the cluster-agent chart to run, and backs them up to individual tar archives, and finally all tars are added to a single tar.gz archive.

The usage of the script is given as:
```text
Back up helm chart images to a tar.gz archive for easy transport via an external storage device.

Arguments:
    -c : Helm chart (default: stackstate/cluster-agent)
    -h : Show this help text
    -r : Helm repository (default: https://helm.stackstate.io)
    -t : Dry-run
```

Under normal operating conditions, this script requires no input, and can simply be executed as ```./backup.sh```

Supplying the `-t` (dry-run) parameter to the script will give a predictive output of what work will be performed, as can be seen below:
```text
./backup.sh -t
Backing up quay.io/stackstate/stackstate-agent-2:2.17.1 to stackstate/stackstate-agent-2__2.17.1.tar (dry-run)
Backing up quay.io/stackstate/stackstate-process-agent:4.0.7 to stackstate/stackstate-process-agent__4.0.7.tar (dry-run)
Backing up quay.io/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032 to stackstate/kube-state-metrics__2.3.0-focal-20220316-r61.20220418.2032.tar (dry-run)
Backing up quay.io/stackstate/stackstate-cluster-agent:2.17.1 to stackstate/stackstate-cluster-agent__2.17.1.tar (dry-run)
Backing up quay.io/stackstate/stackstate-agent-2:2.17.1 to stackstate/stackstate-agent-2__2.17.1.tar (dry-run)
Images have been backed up to stackstate.tar.gz
```

### Transport of images to the destination

Once the backup script has been executed, the images will be in a tar.gz archive in the same folder as the working directory where the script was executed.
Copy the tar.gz (when pulling from StackState registry, this will be stackstate.tar.gz) to a storage device for transportation.

Copy the tar.gz archive to a working folder of choice on the destination system, along with the [import.sh (github.com)](https://github.com/StackVista/helm-charts/blob/master/stable/cluster-agent/installation/import.sh) script.

### Import images to the system, and optionally to a registry.

From the previous step, in the directory where the archive and script were placed, the import script can be executed. Its usage is given as follows:

```text
Import previously exported docker images to an environment with a docker installation, optionally push to the new registry.

Arguments:
    -b : Path to backed up images (tar.gz) file
    -d : Destination Docker image registry (required)
    -h : Show this help text
    -p : Push images to (destination) repository
    -t : Dry-run
```

Example usage:
`./import.sh -b stackstate.tar.gz -d localhost -p`

In the above example, the StackState agent images will be extracted from the archive, imported by docker, and re-tagged to the registry given by the `-d` flag, in this example, `localhost`.

Example output from the `-t`, or dry-run command:

```text
./import.sh -b stackstate.tar.gz -d localhost -t
Unzipping archive stackstate.tar.gz
x stackstate/
x stackstate/stackstate-process-agent__4.0.7.tar
x stackstate/stackstate-agent-2__2.17.1.tar
x stackstate/kube-state-metrics__2.3.0-focal-20220316-r61.20220418.2032.tar
x stackstate/stackstate-cluster-agent__2.17.1.tar
Restoring stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032 from kube-state-metrics__2.3.0-focal-20220316-r61.20220418.2032.tar (dry-run)
Imported quay.io/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032
Tagged quay.io/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032 as localhost/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032
Untagged: quay.io/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032
Restoring stackstate/stackstate-agent-2:2.17.1 from stackstate-agent-2__2.17.1.tar (dry-run)
Imported quay.io/stackstate/stackstate-agent-2:2.17.1
Tagged quay.io/stackstate/stackstate-agent-2:2.17.1 as localhost/stackstate/stackstate-agent-2:2.17.1
Untagged: quay.io/stackstate/stackstate-agent-2:2.17.1
Restoring stackstate/stackstate-cluster-agent:2.17.1 from stackstate-cluster-agent__2.17.1.tar (dry-run)
Imported quay.io/stackstate/stackstate-cluster-agent:2.17.1
Tagged quay.io/stackstate/stackstate-cluster-agent:2.17.1 as localhost/stackstate/stackstate-cluster-agent:2.17.1
Untagged: quay.io/stackstate/stackstate-cluster-agent:2.17.1
Restoring stackstate/stackstate-process-agent:4.0.7 from stackstate-process-agent__4.0.7.tar (dry-run)
Imported quay.io/stackstate/stackstate-process-agent:4.0.7
Tagged quay.io/stackstate/stackstate-process-agent:4.0.7 as localhost/stackstate/stackstate-process-agent:4.0.7
Untagged: quay.io/stackstate/stackstate-process-agent:4.0.7
Images have been imported up to localhost
```

## Images

The agent chart images listed below are used in StackState v5.0.0:


* quay.io/stackstate/kube-state-metrics:2.3.0-focal-20220316-r61.20220418.2032
* quay.io/stackstate/stackstate-agent-2:2.17.1
* quay.io/stackstate/stackstate-cluster-agent:2.17.1
* quay.io/stackstate/stackstate-process-agent:4.0.7
