---
description: StackState Self-hosted v5.0.x 
---

# About StackPacks

{% hint style="warning" %}
**This page describes StackState version 5.0.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/stackpacks/about-stackpacks).
{% endhint %}

## Overview

StackPacks extend StackState functionality and provide automated integration with external systems. They can be easily installed and uninstalled from the StackPacks page in StackState.

There are two types of StackPack - Add-ons and Integrations. The available StackPack add-ons and integrations can be found on the **StackPacks** page in the StackState UI. You can also find details on these pages:

* [Add-ons](add-ons/) extend the functionality of StackState.
* [Integrations](integrations/) allow deep integrations with various external services. These may come with a companion integration that translates data from the external system to data that StackState understands.

{% hint style="success" "self-hosted info" %}

A full list of the StackPacks shipped with each supported version of StackState is available on the [StackPack versions](../setup/upgrade-stackstate/stackpack-versions.md) page.
{% endhint %}

## Install or uninstall a StackPack

StackPacks can be installed and uninstalled from the **StackPacks** page in StackState. Full instructions to install and uninstall the StackPack are provided.

{% hint style="info" %}
**Note that:**

* A StackPack may require **manual** installation steps or configuration of the external system. Please read the instructions provided carefully.
* When a StackPack or StackPack instance is uninstalled, **all data received via the StackPack \(instance\) will be removed from StackState.**
* Any \(manual\) configuration or installation of StackPack components in an external system may need to be uninstalled separately.

{% endhint %}

### StackPack instances

Some StackPacks allow you to connect to multiple accounts on an external system. Each account is configured in a separate instance of the StackPack.

For example, the AWS StackPack can connect to multiple AWS accounts and combine information from all accounts in StackState. For each account, a separate StackState instance is configured with the information required to receive data from that AWS account.

## Upgrade a StackPack

{% hint style="warning" %}
When a StackPack is upgraded, **any changes made to configuration items from that StackPack will be overwritten**. For details, see [locked configuration items](about-stackpacks.md#locked-configuration-items).
{% endhint %}

If a new StackPack version is available, an alert will be displayed on the StackState UI StackPack page and you will have the option to view the upgrade details and read the release notes. If the new release is a minor upgrade from the currently installed version, you can also upgrade the StackPack from here.

{% hint style="success" "self-hosted info" %}

A full list of the StackPacks shipped with each supported version of StackState is available on the [StackPack versions](../setup/upgrade-stackstate/stackpack-versions.md) page.
{% endhint %}

### New minor StackPack version

To upgrade to a new minor version of a StackPack, click **UPGRADE NOW** on the StackPack page in the StackState UI.

Note that all StackPack configuration items will be overwritten when you upgrade. To continue using any changes made to these, choose to **KEEP** the existing configuration when you upgrade the StackPack. For details, see [locked configuration items](about-stackpacks.md#locked-configuration-items).

### New major StackPack version

{% hint style="warning" %}
When a StackPack is upgraded, **any changes made to configuration items from that StackPack will be overwritten**. For details, see [locked configuration items](about-stackpacks.md#locked-configuration-items).
{% endhint %}

To upgrade to a new major version of a StackPack, [uninstall and reinstall](about-stackpacks.md#install-or-uninstall-a-stackpack) the StackPack.

{% hint style="success" "self-hosted info" %}

Continue using changes made to customized StackPack configuration items after upgrade:

1. Before you upgrade, export each customized item:
   * Go to the **Settings** page in the StackState UI.
   * Click **Export** in the **...** menu for each customized item.
2. Upgrade the StackPack \(uninstall and reinstall\).
3. Change the `name` and `identifier` for each exported item:
   * Open the export file in a text editor.
   * Edit the top-level `name` and `identifier` fields.
   * Save the export.
4. [Import](../setup/data-management/backup_restore/configuration_backup.md#import-configuration) the updated export file\(s\).
5. The customized configuration items will now be available in StackState and can be copied to the newly installed StackPack configuration items.

{% endhint %}

## Locked configuration items

StackPacks contain configuration information for StackState that is installed when the StackPack \(instance\) is installed. Amongst other things, this could be component templates, functions, component actions and views. When a StackPack is upgraded, **the configuration items installed by the previous version of the StackPack will be overwritten by those from the newer StackPack.** This means that any manual change made to these configuration items will be overwritten when the StackPack is upgraded.

To prevent a user from making changes to configuration items installed by a StackPack that will be overwritten on upgrade, these configuration items are **locked** by default. This means that they are protected from being changed by the user and must explicitly be **unlocked** before they can be changed.

{% hint style="success" "self-hosted info" %}

You can [make a back-up of configuration items](../setup/data-management/backup_restore/configuration_backup.md). Note that the lock status of configuration items will not be exported as part of a configuration backup.
{% endhint %}
