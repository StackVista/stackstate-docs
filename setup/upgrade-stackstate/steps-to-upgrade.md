---
description: Perform a major or minor upgrade of StackState.
---

# Steps to upgrade

## Overview

This document describes the upgrade procedure for StackState.

For instructions on how to upgrade StackPacks, see [the StackPacks documentation](/stackpacks/about-stackpacks.md#upgrade-a-stackpack).

## Before you upgrade

When executing a StackState upgrade, please be aware of the following:

{% hint style="warning" %}
**Always read the [version-specific upgrade notes](/setup/upgrade-stackstate/version-specific-upgrade-instructions.md) before upgrading StackState.**
{% endhint %}

{% hint style="warning" %}
When upgrading a StackPack, **any changes you have made to configuration items from that StackPack will be overwritten**. See [Configuration Locking](/stackpacks/about-stackpacks.md#locked-configuration-items) for more information.
{% endhint %}

{% hint style="danger" %}
If there are **hotfixes** installed in your StackState installation, contact StackState technical support prior to upgrading.
{% endhint %}

## Steps to upgrade
 
### Minor or maintenance StackState release

A minor release of StackState is indicated by a change in the second digit of the version number, for example 4.1.0. Maintenance releases are identified by a change in the third digit of the version number, for example 4.1.1.

If you are upgrading to a new **minor** StackState release or a **maintenance** release, StackState itself and the StackPacks will be compatible with the current installation.

A minor upgrade consists of the following steps:

1. [Create a backup](#create-a-backup)
2. [Upgrade StackState](#upgrade-stackstate)
3. [Verify the new installation](#verify-the-new-installation)
4. [Check if any installed StackPacks require an upgrade](/setup/upgrade-stackstate/stackpack-versions.md)

### Major StackState release

A major release of StackState is indicated by a change in the first digit of the version number, for example 4.0.0.

If you are upgrading to a new **major** StackState release, StackState and/or the installed StackPacks may be incompatible with the current installation. For details, check the [version-specific upgrade notes](/setup/upgrade-stackstate/version-specific-upgrade-instructions.md).

A major upgrade consists of the following steps:

1. [Create a backup](#create-a-backup)
2. Optional: [Uninstall StackPacks](#uninstall-stackpacks)
3. [Upgrade StackState](#upgrade-stackstate)
4. Optional: [Install StackPacks](#install-stackpacks)
5. [Verify the new installation](#verify-the-new-installation)

## Walkthrough of an upgrade

### Create a backup

Before upgrading StackState it is recommended to backup your configuration and topology data.

{% tabs %}
{% tab title="Kubernetes" %}
To create a backup on Kubernetes, see:

* [Kubernetes backup](/setup/data-management/backup_restore/kubernetes_backup.md)
* [Configuration backup](/setup/data-management/backup_restore/configuration_backup.md)
* [Manually created topology backup](/setup/data-management/backup_restore/manual_topology_backup.md)
{% endtab %}

{% tab title="Linux" %}
To create a backup on Linux, see:

* [Linux backup](/setup/data-management/backup_restore/linux_backup.md)
* [Configuration backup](/setup/data-management/backup_restore/configuration_backup.md)
* [Manually created topology backup](/setup/data-management/backup_restore/manual_topology_backup.md)
{% endtab %}
{% endtabs %}

{% hint style="info" %}
Note that it will not be possible to restore the backup on the upgraded version of StackState. The StackState backup can only be restored in the StackState and StackPack versions prior to the upgrade.
{% endhint %}

### Uninstall StackPacks

See [Uninstalling StackPacks](/stackpacks/about-stackpacks.md#install-or-uninstall-a-stackpack) for more information.

{% hint style="warning" %}
StackPacks must be uninstalled using the version of StackState prior to the upgrade since this version can contain different installation logic from the new StackPack version.
{% endhint %}

### Upgrade StackState

{% hint style="info" %}
Remember to check the [version specific upgrade notes](/setup/upgrade-stackstate/version-specific-upgrade-instructions.md) for specific changes that need to be made for the new StackState version you will upgrade to.
{% endhint %}

Instructions to upgrade a StackState Kubernetes or Linux setup can be found below. 

{% tabs %}
{% tab title="Kubernetes" %}
For upgrading, the same command can be used as for the [first time Kubernetes installation](/setup/installation/kubernetes_install/install_stackstate.md). Be sure to check the release notes and any optional upgrade notes before running the upgrade.
{% endtab %}

{% tab title="Linux" %}
Depending on your platform, you can use one of the following commands to upgrade.

* **Fedora, RedHat, CentOS:**
  * using RPM: `rpm -U <stackstate>.rpm`
  * using yum: `yum localinstall <stackstate>.rpm`
* **Debian, Ubuntu:**
  * using dpkg: `dpkg -i <stackstate>.deb`
  * using apt: `apt-get upgrade <stackstate>.deb`
{% endtab %}
{% endtabs %}

### Install StackPacks

See [Installing StackPacks](/stackpacks/about-stackpacks.md#install-or-uninstall-a-stackpack) for more information.

### Verify the new installation

Once StackState has been upgraded and started, verify that the new installation of StackState is reachable and that the application is running.


## See also

- [Manually upgrade a StackPack](/stackpacks/about-stackpacks.md#upgrade-a-stackpack)
- [StackPack versions shipped with each StackState release](/setup/upgrade-stackstate/stackpack-versions.md)
- [Version-specific upgrade notes](/setup/upgrade-stackstate/version-specific-upgrade-instructions.md)