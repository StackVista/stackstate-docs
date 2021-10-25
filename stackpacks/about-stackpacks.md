---
description: What is a StackPack?
---

# What is a StackPack?

StackPacks are plugins for StackState that extend functionality and provide automated integration with external systems. They can be easily installed and uninstalled from the StackPacks page in StackState.

There are two types of StackPack:

* [Add-ons](add-ons/) extend the functionality of StackState.
* [Integrations](integrations/) allow deep integrations with various external services. These may come with a companion integration that translates data from the external system to data that StackState understands.

## StackPack instances

Some StackPacks allow you to connect to multiple accounts on an external system. Each account is configured in a separate instance of the StackPack.

For example, the AWS StackPack can connect to multiple AWS accounts and combine information from all accounts in StackState. For each account, a separate StackState instance is configured with the information required to receive data from that AWS account.

## Locked configuration items

StackPacks contain configuration information for StackState that is installed when the StackPack \(instance\) is installed. Amongst other things, this could be component templates, functions, component actions and views. When a StackPack is upgraded, **the configuration items installed by the previous version of the StackPack will be overwritten by those from the newer StackPack.** This means that any manual change made to these configuration items will be overwritten when the StackPack is upgraded.

To prevent a user from making changes to configuration items installed by a StackPack that will be overwritten on upgrade, these configuration items are **locked** by default. This means that they are protected from being changed by the user and must explicitly be **unlocked** before they can be changed.

{% hint style="info" %}
**StackState Self-Hosted**

Note that the lock status of configuration items will not be exported as part of a [configuration backup](../setup/data-management/backup_restore/configuration_backup.md).
{% endhint %}

## Which StackPacks are available?

The available StackPack add-ons and integrations can be found on the **StackPacks** page in StackState. You can also find details on these pages:

* [Add-ons](add-ons/)
* [Integrations](integrations/)

{% hint style="info" %}
**StackState Self-Hosted**

The StackPack versions shipped with each supported release of StackState can be found on the page [StackPack versions](../setup/upgrade-stackstate/stackpack-versions.md).
{% endhint %}

## Install or uninstall a StackPack

StackPacks can be installed and uninstalled from the **StackPacks** page in StackState. Full install and uninstall instructions are provided.

{% hint style="info" %}
**Note that**

* A StackPack may require **manual** installation steps or configuration of the external system. Please read the instructions provided carefully.
* When a StackPack or StackPack instance is uninstalled, **all data received via the StackPack \(instance\) will be removed from StackState.**
* Any \(manual\) configuration or installation of StackPack components in an external system may need to be uninstalled separately.
{% endhint %}

## Upgrade a StackPack

{% hint style="warning" %}
When a StackPack is upgraded, **any changes made to configuration items from that StackPack will be overwritten**. For details, see [locked configuration items](about-stackpacks.md#locked-configuration-items).
{% endhint %}

If a new StackPack version is available, an alert will be displayed on the StackState UI StackPack page and you will have the option to view the upgrade details and read the release notes. If the new release is a minor upgrade from the currently installed version, you can also upgrade the StackPack from here.

{% hint style="info" %}
**StackState Self-Hosted**

A full list of the StackPacks shipped with each supported version of StackState is available on the [StackPack versions](../setup/upgrade-stackstate/stackpack-versions.md) page.
{% endhint %}

### New Minor StackPack version

To upgrade to a new minor version of a StackPack, click **UPGRADE NOW** on the StackPack page in the StackState UI.

Note that all StackPack configuration items will be overwritten when you upgrade. To continue using any changes made to these, choose to **KEEP** the existing configuration when you upgrade the StackPack. For details, see [locked configuration items](about-stackpacks.md#locked-configuration-items).

### New Major StackPack version

{% hint style="info" %}
Note that all StackPack configuration items will be overwritten after a major StackPack upgrade. Before you upgrade, export any customized items. For details, see [locked configuration items](about-stackpacks.md#locked-configuration-items).
{% endhint %}

To upgrade to a new major version of a StackPack, [uninstall and reinstall](about-stackpacks.md#install-or-uninstall-a-stackpack) the StackPack.

{% hint style="info" %}
**StackState Self-Hosted**

Note that all customized StackPack configuration items will be overwritten when you upgrade. Follow the steps below to continue using any changes made to these items.

1. Before you upgrade, export each customized item:
   * Go to the **Settings** page in the StackState UI.
   * Click on **Export** in the **...** menu for each customized item.
2. Upgrade the StackPack \(uninstall and reinstall\).
3. Change the `name` and `identifier` for each exported item:
   * Open the export file in a text editor.
   * Edit the top-level `name` and `identifier` fields.
   * Save the export.
4. [Import](../setup/data-management/backup_restore/configuration_backup.md#import-configuration) the updated export file\(s\).
5. The customized configuration items will now be available in StackState and can be copied to the newly installed StackPack configuration items.

{% endhint %}
