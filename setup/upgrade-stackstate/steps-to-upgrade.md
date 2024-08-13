---
description: Rancher Observability Self-hosted
---

# Steps to upgrade

## Overview

This document describes the upgrade procedure for Rancher Observability.

## Before you upgrade

When executing a Rancher Observability upgrade, be aware of the following:

{% hint style="warning" %}
**Always read the** [**version-specific upgrade notes**](version-specific-upgrade-instructions.md) **before upgrading Rancher Observability.**
{% endhint %}

{% hint style="warning" %}
When upgrading a StackPack, **any changes you have made to configuration items from that StackPack will be overwritten**. See [Configuration Locking](../../stackpacks/about-stackpacks.md#locked-configuration-items) for more information.
{% endhint %}

{% hint style="danger" %}
If there are **hotfixes** installed in your Rancher Observability installation, contact Rancher Observability technical support prior to upgrading.
{% endhint %}

## Steps to upgrade

### Minor or maintenance Rancher Observability release

A minor release of Rancher Observability is indicated by a change in the second digit of the version number, for example 4.1.0. Maintenance releases are identified by a change in the third digit of the version number, for example 4.1.1.

If you are upgrading to a new **minor** Rancher Observability release or a **maintenance** release, Rancher Observability itself and the StackPacks will be compatible with the current installation.

A minor upgrade consists of the following steps:

1. [Create a backup](#create-a-backup)
2. [Upgrade Rancher Observability](#upgrade-stackstate)
3. [Verify the new installation](#verify-the-new-installation)
4. Check if any installed StackPacks require an upgrade

### Major Rancher Observability release

A major release of Rancher Observability is indicated by a change in the first digit of the version number, for example 4.0.0.

If you upgrade to a new **major** Rancher Observability release, Rancher Observability and the installed StackPacks may be incompatible with the current installation. For details, check the [version-specific upgrade notes](version-specific-upgrade-instructions.md).

A major upgrade consists of the following steps:

1. [Create a backup](steps-to-upgrade.md#create-a-backup)
2. Optional: [Uninstall StackPacks](steps-to-upgrade.md#uninstall-stackpacks-optional)
3. [Upgrade Rancher Observability](steps-to-upgrade.md#upgrade-stackstate)
4. Optional: [Install StackPacks](steps-to-upgrade.md#install-stackpacks-optional)
5. [Verify the new installation](steps-to-upgrade.md#verify-the-new-installation)

## Walkthrough of an upgrade

### Create a backup

Before upgrading Rancher Observability it's recommended to back up your configuration and topology data:

* [Kubernetes backup](../data-management/backup_restore/kubernetes_backup.md)
* [Configuration backup](../data-management/backup_restore/configuration_backup.md)

{% hint style="info" %}
Note that it won't be possible to restore the backup on the upgraded version of Rancher Observability. The Rancher Observability backup can only be restored in the Rancher Observability version before the upgrade.
{% endhint %}

### Upgrade Rancher Observability

Be sure to check the release notes and any optional upgrade notes before running the upgrade.

{% tabs %}

{% tab title="Kubernetes" %}

1. Get the latest helm chart by running `helm repo update`.
2. Check the [version specific upgrade notes](version-specific-upgrade-instructions.md) for all changes between your current version and the version that you will upgrade to. If there have been changes made to configuration items specified in your `values.yaml` file, the file should be updated.
3. To upgrade, use the same helm command as for the [first time Kubernetes installation](../install-stackstate/kubernetes_openshift/kubernetes_install.md#deploy-stackstate-with-helm). The new helm chart will pull newer versions of Docker images and handle the upgrade.
{% endtab %}

{% tab title="OpenShift" %}

2. Get the latest helm chart by running `helm repo update`.
3. Check the [version specific upgrade notes](version-specific-upgrade-instructions.md) for all changes between your current version and the version that you will upgrade to. If there have been changes made to configuration items specified in your `values.yaml` file, the file should be updated.
4. [Update the `openshift-values.yaml`](/setup/install-stackstate/kubernetes_openshift/openshift_install.md#additional-openshift-values-file) file.
5. To upgrade, use the same helm command as for the [first time OpenShift installation](/setup/install-stackstate/kubernetes_openshift/openshift_install.md#deploy-stackstate-with-helm). The new helm chart will pull newer versions of Docker images and handle the upgrade.
{% endtab %}

{% endtabs %}

### Verify the new installation

Once Rancher Observability has been upgraded and started, verify that the new installation of Rancher Observability is reachable and that the application is running.

## See also

* [Manually upgrade a StackPack](../../stackpacks/about-stackpacks.md#upgrade-a-stackpack)
* [Version-specific upgrade notes](version-specific-upgrade-instructions.md)

