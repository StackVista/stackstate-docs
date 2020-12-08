---
description: What is a StackPack?
---

# What is a StackPack?

StackPacks are plugins for StackState that extend functionality and provide automated integration with external systems. They can be easily installed and uninstalled from the StackPacks page in StackState.

There are two types of Stackpack:

* [Add-ons](/stackpacks/add-ons/README.md) extend the functionality of StackState.
* [Integrations](/stackpacks/integrations/README.md) allow deep integrations with various external services. These may come with a companion integration that translates data from the external system to data that StackState understands.

## StackPack instances

Some StackPacks allow you to connect to multiple accounts on an external system. Each account is configured in a separate instance of the StackPack.

For example, the AWS StackPack can connect to multiple AWS accounts and combine information from all accounts in StackState. For each account, a separate StackState instance is configured with the information required to receive data from that AWS account.

## Locked configuration items

StackPacks contain configuration information for StackState that is installed when the StackPack \(instance\) is installed. StackPacks can contain component templates, functions, component actions and views amongst other things. When a StackPack is upgraded to a newer version, **the configuration items installed by the previous version of the StackPack will be overwritten by those from the newer StackPack.** This means that any manual change made to these configuration items will be overwritten when the StackPack is upgraded.

To prevent a user from making changes to configuration items installed by a StackPack that will be overwritten on upgrade, the configuration items are **locked** by default. This means that they are protected from being changed by the user. Configuration items must explicitly be **unlocked** before they can be changed.

Note that the lock status of configuration items will not be exported as part of a [configuration backup](/setup/data-management/backup_restore/configuration_backup.md). 

## Which StackPacks are available?

The available StackPack add-ons and integrations can be found on the **StackPacks** page in StackState. You can also find details on these pages:

* [Add-ons](/stackpacks/add-ons/README.md)
* [Integrations](/stackpacks/integrations/README.md)

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
When upgrading a StackPack, **any changes you have made to configuration items from that StackPack will be overwritten**. For details, see [locked configuration items](#locked-configuration-items).
{% endhint %}

StackPacks can be upgraded from the **StackPacks** page in StackState. If a new version is available, the **UPGRADE** button will be available and you will have the option to read the release notes.

If you have customized configuration, this will be overwritten when the StackPack is upgraded. To continue using your customized configuration after upgrade:

1. During the upgrade process choose to **KEEP** the existing configuration. StackState will create a new configuration file for the upgraded StackPack version alongside the existing (old) configuration file.
2. Custom configuration items can be copied from the old configuration file to the newly created configuration file.

Check the list of [StackPack versions](/setup/upgrade-stackstate/stackpack-versions.md) to see if a new StackPack version is available in the latest release of StackState. 