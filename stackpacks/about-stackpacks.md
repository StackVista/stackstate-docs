---
title: StackPacks & integrations
kind: documentation
description: What is a StackPack?
---

# What is a StackPack?

StackPacks are plugins for StackState that extend functionality and provide automated integration with external systems. They can be easily installed and uninstalled from the StackPacks page in StackState.

There are two types of Stackpack:

* [Add-ons](add-ons/) extend the functionality of StackState.
* [Integrations](integrations/) allow deep integrations with various external services. These may come with a companion integration that translates data from the external system to data that StackState understands.

## StackPack instances

Some StackPacks allow you to connect to multiple accounts on an external system. Each account is configured in a separate instance of the StackPack.

For example, the AWS StackPack can connect to multiple AWS accounts and combine information from all accounts in StackState. For each account, a separate StackState instance is configured with the information required to receive data from that AWS account.

## Configuration locking

StackPacks contain configuration information for StackState that is installed when the StackPack \(instance\) is installed. StackPacks can contain component templates, functions, component actions and views amongst other things. When a StackPack is upgraded to a newer version, **the configuration items installed by the previous version of the StackPack will be overwritten by those from the newer StackPack.** This means that any manual change made to these configuration items will be overwritten when the StackPack is upgraded.

To prevent a user from making changes to configuration items installed by a StackPack that will be overwritten on upgrade, the configuration items are **locked** by default. This means that they are protected from being changed by the user. Configuration items must explicitly be **unlocked** before they can be changed.

## Which StackPacks are available?

The available StackPack add-ons and integrations can be found on the **StackPacks** page in StackState. You can also find details on these pages:

* [add-ons](add-ons/)
* [integrations](integrations/)

## Install and uninstall StackPacks

StackPacks can be installed and uninstalled from the **StackPacks** page in StackState. Full install and uninstall instructions are provided.

{% hint style="info" %}
* A StackPack may require **manual** installation steps or configuration of the external system. Please read the instructions provided carefully.
* When a StackPack or StackPack instance is uninstalled, **all data received via the StackPack \(instance\) will be removed from StackState.**
* Any \(manual\) configuration or installation of StackPack components in an external system may need to be uninstalled separately.
{% endhint %}

