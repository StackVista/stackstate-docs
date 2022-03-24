---
description: StackState Self-hosted v4.6.x
---

# Steps to upgrade

## Overview

This document describes the upgrade procedure for StackState.

For instructions on how to upgrade StackPacks, see [the StackPacks documentation](../../stackpacks/about-stackpacks.md#upgrade-a-stackpack).

## Before you upgrade

When executing a StackState upgrade, be aware of the following:

{% hint style="warning" %}
**Always read the** [**version-specific upgrade notes**](version-specific-upgrade-instructions.md) **before upgrading StackState.**
{% endhint %}

{% hint style="warning" %}
When upgrading a StackPack, **any changes you have made to configuration items from that StackPack will be overwritten**. See [Configuration Locking](../../stackpacks/about-stackpacks.md#locked-configuration-items) for more information.
{% endhint %}

{% hint style="danger" %}
If there are **hotfixes** installed in your StackState installation, contact StackState technical support prior to upgrading.
{% endhint %}

## Steps to upgrade

### Minor or maintenance StackState release

A minor release of StackState is indicated by a change in the second digit of the version number, for example 4.1.0. Maintenance releases are identified by a change in the third digit of the version number, for example 4.1.1.

If you are upgrading to a new **minor** StackState release or a **maintenance** release, StackState itself and the StackPacks will be compatible with the current installation.

A minor upgrade consists of the following steps:

1. [Create a backup](steps-to-upgrade.md#create-a-backup)
2. [Upgrade StackState](steps-to-upgrade.md#upgrade-stackstate)
3. [Verify the new installation](steps-to-upgrade.md#verify-the-new-installation)
4. [Check if any installed StackPacks require an upgrade](stackpack-versions.md)

### Major StackState release

A major release of StackState is indicated by a change in the first digit of the version number, for example 4.0.0.

If you are upgrading to a new **major** StackState release, StackState and/or the installed StackPacks may be incompatible with the current installation. For details, check the [version-specific upgrade notes](version-specific-upgrade-instructions.md).

A major upgrade consists of the following steps:

1. [Create a backup](steps-to-upgrade.md#create-a-backup)
2. Optional: [Uninstall StackPacks](steps-to-upgrade.md#uninstall-stackpacks-optional)
3. [Upgrade StackState](steps-to-upgrade.md#upgrade-stackstate)
4. Optional: [Install StackPacks](steps-to-upgrade.md#install-stackpacks-optional)
5. [Verify the new installation](steps-to-upgrade.md#verify-the-new-installation)

## Walkthrough of an upgrade

### Create a backup

Before upgrading StackState it is recommended to backup your configuration and topology data.

{% tabs %}
{% tab title="Kubernetes" %}
To create a backup on Kubernetes, see:

* [Kubernetes backup](../data-management/backup_restore/kubernetes_backup.md)
* [Configuration backup](../data-management/backup_restore/configuration_backup.md)
* [Manually created topology backup](../data-management/backup_restore/manual_topology_backup.md)
{% endtab %}

{% tab title="Linux" %}
To create a backup on Linux, see:

* [Linux backup](../data-management/backup_restore/linux_backup.md)
* [Configuration backup](../data-management/backup_restore/configuration_backup.md)
* [Manually created topology backup](../data-management/backup_restore/manual_topology_backup.md)
{% endtab %}
{% endtabs %}

{% hint style="info" %}
Note that it will not be possible to restore the backup on the upgraded version of StackState. The StackState backup can only be restored in the StackState and StackPack versions prior to the upgrade.
{% endhint %}

### Uninstall StackPacks (optional)

See [Uninstalling StackPacks](../../stackpacks/about-stackpacks.md#install-or-uninstall-a-stackpack) for more information.

{% hint style="warning" %}
When uninstalling StackPacks, the version of StackState prior to the upgrade must be used since this version can contain different installation logic from the new StackPack version.
{% endhint %}

### Upgrade StackState

{% hint style="info" %}
Remember to check the [version specific upgrade notes](version-specific-upgrade-instructions.md) for specific changes that need to be made for the new StackState version you will upgrade to.
{% endhint %}

Instructions to upgrade a StackState Kubernetes or Linux setup can be found below.Be sure to check the release notes and any optional upgrade notes before running the upgrade.

{% tabs %}

{% tab title="Linux" %}
1. Download the upgrade file from [https://download.stackstate.com](https://download.stackstate.com).
2. Depending on your platform, use one of the following commands to upgrade:
   * **Fedora, RedHat, CentOS:**
     * using RPM: `rpm -U <stackstate>.rpm`
     * using yum: `yum localinstall <stackstate>.rpm`
   * **Debian, Ubuntu:**
     * using dpkg: `dpkg -i <stackstate>.deb`
     * using apt: `apt-get upgrade <stackstate>.deb`
{% endtab %}

{% tab title="Kubernetes" %}
1. Get the latest helm chart by running `helm repo update`.
2. Check the [version specific upgrade notes](version-specific-upgrade-instructions.md) for all changes between your current version and the version that you will upgrade to. If there have been changes made to configuration items specified in your `values.yaml` file, the file should be updated accordingly.
3. To upgrade, use the same helm command as for the [first time Kubernetes installation](../install-stackstate/kubernetes_install/install_stackstate.md#deploy-stackstate-with-helm). The new helm chart will pull newer versions of Docker images and handle the upgrade.
{% endtab %}

{% tab title="OpenShift" %}
1. Get the latest helm chart by running `helm repo update`.
2. Check the [version specific upgrade notes](version-specific-upgrade-instructions.md) for all changes between your current version and the version that you will upgrade to. If there have been changes made to configuration items specified in your `values.yaml` file, the file should be updated accordingly.
3. [Update the `openshift-values.yaml`](/setup/install-stackstate/openshift_install.md#additional-openshift-values-file) file.
4. To upgrade, use the same helm command as for the [first time OpenShift installation](/setup/install-stackstate/openshift_install.md#deploy-stackstate-with-helm). The new helm chart will pull newer versions of Docker images and handle the upgrade.
{% endtab %}   

{% tab title="KOTS" %}
1. In the admin console, go to the Version History tab and click **Check For Updates**
2. Click the **View preflight checks** logo to view or re-run the preflight checks
3. To update the application, return to the Version History tab and click **Deploy** next to the target version
{% endtab %}   

{% endtabs %}

### Install StackPacks (optional)

See [Installing StackPacks](../../stackpacks/about-stackpacks.md#install-or-uninstall-a-stackpack) for more information.

### Verify the new installation

Once StackState has been upgraded and started, verify that the new installation of StackState is reachable and that the application is running.

## See also

* [Manually upgrade a StackPack](../../stackpacks/about-stackpacks.md#upgrade-a-stackpack)
* [StackPack versions shipped with each StackState release](stackpack-versions.md)
* [Version-specific upgrade notes](version-specific-upgrade-instructions.md)

