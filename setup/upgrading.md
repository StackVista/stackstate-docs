---
title: Upgrading
kind: Documentation
description: Performing major and minor upgrades of StackState.
---

# Upgrading StackState

{% hint style="warning" %}
This page describes StackState version 4.0.  
Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

This document describes the upgrade procedure for StackState.

For instructions on how to upgrade StackPacks, see [the StackPacks documentation](../integrations/introduction.md).

### Upgrade considerations

When executing a StackState upgrade, please be aware of the following:

{% hint style="warning" %}
**Always read the version-specific upgrade notes at the end of this document before upgrading StackState.**
{% endhint %}

{% hint style="warning" %}
When upgrading a StackPack, **any changes you have made to configuration items from that StackPack will be overwritten**. See [Configuration Locking](../integrations/introduction.md#stackpack-configuration-locking) for more information.
{% endhint %}

{% hint style="danger" %}
If there are **hotfixes** installed in your StackState installation, contact StackState technical support prior to upgrading.
{% endhint %}

### Upgrading to a new minor StackState release

A minor release of StackState is indicated by a change in the second or third digits of the version number, for example 1.15.3. or 1.16.0.

If you are upgrading to a new **minor** StackState release, StackState itself and the StackPacks will be compatible with the current installation.

A minor upgrade consists of the following steps:

* Create a backup
* Upgrade StackState
* Verify the new installation

### Upgrading to a new major StackState release

A major release of StackState is indicated by a change in the first digit of the version number, for example 4.0.0.

If you are upgrading to a new **major** StackState release, StackState and/or the installed StackPacks may be incompatible with the current installation. For details, check the version-specific upgrade instructions.

A major upgrade consists of the following steps:

* Create a backup
* Uninstall StackPacks \(optional, check the version-specific upgrade instructions\)
* Upgrade StackState
* Install StackPacks \(optional, check the version-specific upgrade instructions\)
* Verify the new installation

## Create a backup

Before upgrading StackState it is recommended to backup your configuration and topology data. See [Backup and Restore](backup_restore/) for more information.

{% hint style="info" %}
The StackState backup can only be restored in the StackState and StackPack versions prior to the upgrade.
{% endhint %}

## Uninstall StackPacks

See [Uninstalling StackPacks](../integrations/introduction.md#uninstalling-stackpacks) for more information.

{% hint style="warning" %}
The StackPacks must be uninstalled using the version of StackState prior to the upgrade since this version can contain different installation logic from the new StackPack version.
{% endhint %}

## Upgrade StackState

Depending on your platform, you can use one of the following commands to upgrade StackState:

* Fedora, RedHat, CentOS:
  * using RPM: `rpm -U <stackstate>.rpm`
  * using yum: `yum localinstall <stackstate>.rpm`
* Debian, Ubuntu:
  * using dpkg: `dpkg -i <stackstate>.deb`
  * using apt: `apt-get upgrade <stackstate>.deb`

## Install StackPacks

See [Installing StackPacks](../integrations/introduction.md#installing-stackpacks) for more information.

## Verify the new installation

Once StackState has been upgraded and started, verify that the new installation of StackState is reachable and that the application is running.

## Version-specific upgrade instructions

### Upgrade to 4.0.0

* With this version the minimal system requirements for the StackState node of the production setup raised from 16GB to 20GB
* The configuration `processmanager-properties.conf` was merged into `processmanager.conf` for both StackState and StackGraph. If you have changes to either one of those configuration files, you changes will need to be reapplied after upgrade.
* For trace processing StackState Agent needs an upgrade to version 2.5.0.
* This release deprecates the `withCauseOf` topology query filter, in favor of the \`Root

  Cause Analysis\` topology visualization setting. Stored views

  which require make use of the `withCauseOf` construct will need to be manually adapted.

  New versions of StackPacks already contain these changes, for custom views, the following

  script can be used in the StackState Analytics panel to list the views that need

  migrating.

  `Graph.query { it.V().hasLabel("QueryView").forceLoadBarrier().filter(__.has("query", TextP.containing('withCauseOf'))).properties("name").value() }`

* In this release a new way of scripting [propagation functions](../configure/propagation.md#propagation-function) has been introduced so that the script APIs can be used. Propagation functions using the old script style will still work, but have been made read-only via the UI. Old style propagation functions can still be created via StackPacks, the CLI and API.

