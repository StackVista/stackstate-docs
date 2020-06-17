---
title: Upgrading
kind: Documentation
---

# Upgrading StackState

This document describes the upgrade procedure for StackState.

For instructions on how to upgrade StackPacks, see [the StackPacks documentation](../integrations/introduction.md).

### Upgrade considerations

When executing a StackState upgrade, please be aware of the following:

{% hint style="warning" %}
**Always read the version-specific upgrade notes at the end of this document before upgrading StackState.**
{% endhint %}

{% hint style="warning" %}
When upgrading a StackPack, **any changes you have made to the templates in that StackPack will be overwritten**.
{% endhint %}

{% hint style="danger" %}
If there are **hotfixes** installed in your StackState installation, contact StackState technical support prior to upgrading.
{% endhint %}

### Upgrading to a new minor StackState release

If you are upgrading to a new **minor** StackState release, StackState itself and the StackPacks will be compatible with the current installation.

A minor upgrade consists of the following steps:

* Create a backup
* Upgrade StackState
* Verify the new installation

### Upgrading to a new major StackState release

If you are upgrading to a new **major** StackState release, StackState and/or the installed StackPacks may be incompatible with the current installation.
For details, check the version-specific upgrade instructions.

A major upgrade consists of the following steps:

* Create a backup
* Uninstall StackPacks (optional, check the version-specific upgrade instructions)
* Upgrade StackState
* Install StackPacks (optional, check the version-specific upgrade instructions)
* Verify the new installation

## Create a backup

Before upgrading StackState it is recommended to backup your configuration and topology data. The script `bin/sts-backup.sh` will create a backup and store it inside the `backups/` directory.

{% hint style="info" %}
The StackState backup can only be restored in the StackState and StackPack versions prior to the upgrade.
{% endhint %}

## Uninstall StackPacks

StackPacks that are going to be upgraded must first be uninstalled. This removes all StackPack configuration from StackState.

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

StackPacks that have been upgraded can now be installed again. This provisions StackState with configuration information from the new StackPack.

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

### Upgrade to 1.15.0

* Upgrading to 1.15.0 will require you to reregister your license information. See the instructions for registering your license key [here](installation/configuration.md).
* Configuration files for the processmanager \(`processmanager.conf` and `processmanager-properties.conf`\) have changed. If the current StackState installation has changes \(or if these are templated in tools like Puppet or Ansible\) they will need to be updated.
* The old Elasticsearch data will remain available but is not automatically migrated and will not be available in StackState. This will result in missing history for stackstate events and all telemetry stored in StackState \(events and metrics\). After upgrading the data can be restored if needed. Please contact support for the details or use this knowledge base article [https://support.stackstate.com/hc/en-us/articles/360010136040](https://support.stackstate.com/hc/en-us/articles/360010136040). If there is no need to restore the data please manually remove the data to recover the disk space used by completely removing the `/opt/stackstate/var/lib/elasticsearch` directory.

### Upgrade to 1.14.9

* As of this version, the concept of "valid guest groups" is deprecated by newly introduced Role Based Access Control. For more information please follow our [RBAC documentation pages](../concepts/role_based_access_control.md)
* Upgrading from version 1.14.3 or earlier to this release requires a clean installation including removing the complete `/opt/stackstate` directory.

Please note that permissions are stored in StackGraph, so performing an upgrade with clear all data will also remove permission setup. Because permissions exist in StackGraph, in order to completely remove the user it needs to be removed from LDAP and from StackGraph manually.

### Upgrade to 1.14.6

* `stackstate.api.authentication.adminRoles` renamed to `stackstate.api.authentication.adminGroups`
* The `guestGroups` configuration was removed from `stackstate.api.authentication.ldapAuthServer.guestGroups` and is now present and mandatory under `stackstate.api.authentication`. Just like before, this configuration is used to specify which groups have the guest role in StackState.
* In case of `stackstateAuthServer` the `roles` field in the `stackstate.api.authentication.stackstateAuthServer.logins` is now mandatory. Just like the adminGroups, it should contain all the groups that automatically get guest permissions.

### Upgrade to 1.14.4

* CLEAN UPGRADE: For version 1.14.4 a clean installation is required, including removing the complete `/opt/stackstate` directory.

### Upgrade to 1.14.3

* In version 1.14.3 the LDAP query prefix for users and groups was changed. If you are using LDAP authentication, then there are some changes you need to apply to your `application_stackstate.conf`. For detailed information check the [configuring-the-ldap-authentication-server](../configure/how_to_configure_ldap_authentication.md) section.

### Upgrade to 1.14.2

* Before version 1.14.2 some of the temporary files weren’t properly removed. This has been fixed in 1.14.2 but some of the older files before 1.14.2 need to cleaned up. In order to remove them run rm -rfv /tmp/_.sts_
