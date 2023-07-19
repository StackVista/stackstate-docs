---
description: StackState for Kubernetes troubleshooting
---

# Install StackState Agent from custom image registry

## Overview

This page describes how to use a custom image registry to install the StackState Agent. There are many reasons why you might want to do this, for example:

- You want to use an image registry that is behind a firewall or on-premises.
- You have specific security requirements that prevent you from using public image registries like Docker Hub.

In this guide you can find how to copy the required Docker images to your own registry, and how to configure the Helm chart to pull images from the custom registry.

## Copying images to another registry

This section describes how to copy the images used by the StackState Agent to another registry. The images are listed in the [Images](#images) section.

### Prerequisites

The following prerequisites are required to copy the images:

- Setup a registry if you don't have one available. You can use [Amazon Elastic Container Registry \(ECR\)](https://aws.amazon.com/ecr/) or [Azure Container Registry \(ACR\)](https://azure.microsoft.com/en-us/products/container-registry/) for example.
- Have the access credentials for your newly setup registry available.
- Have the `docker` command line tool installed.
- Install the `copy_images.sh` script from the [StackState Agent Helm Chart](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate-k8s-agent/installation/copy_images.sh)

### Copying the images

To copy the images, execute the following steps:

```
> docker login -u <username> --password-stdin <registry>
Password: ********
Login Succeeded
> ./copy_images.sh -d <registry>
```

* The script will detect when an ECR registry is used and automatically create the required repositories. Most other registries will automatically create repositories when the first image is pushed to it.
* The script has a dry-run option that can be activated with the `-t` flag. This will show the images that will be copied without actually copying them, for example:
* Additional optional flags can be used when running the script:
  * `-c` specify a different chart to use.
  * `-r` specify a different repository to use.

### Images

The images listed below are used in the StackState Agent Helm Chart:

- [quay.io/stackstate/stackstate-k8s-agent](https://quay.io/repository/stackstate/stackstate-k8s-agent)
- [quay.io/stackstate/stackstate-k8s-process-agent](https://quay.io/repository/stackstate/stackstate-k8s-process-agent)
- [quay.io/stackstate/stackstate-k8s-cluster-agent](https://quay.io/repository/stackstate/stackstate-k8s-cluster-agent)

## Configuring the Helm Chart to use a custom registry

This section describes the values that need to be configured in the StackState Agent Helm Chart to use a custom registry.

The following values need to be configured:

* **global.imageRegistry** - the registry to use.
* **all.image.pullSecretUsername** and **all.image.pullSecretPassword** The authentication details required for the `global.imageRegistry`.

For example:

```yaml
global:
  imageRegistry: 57413481473.dkr.ecr.eu-west-1.amazonaws.com
all:
  image:
    pullSecretUsername: johndoe
    pullSecretPassword: my_secret-p@ssw0rd
```
