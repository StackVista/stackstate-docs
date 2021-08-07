---
title: StackPacks & integrations
kind: documentation
description: What is a StackPack?
---

# About StackPacks

{% hint style="warning" %}
**This page describes StackState version 4.0.**

The StackState 4.0 version range is End of Life \(EOL\) and **no longer supported**. We encourage customers still running the 4.0 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is a StackPack?

A StackPack is a complete configuration package for StackState that simplifies the setup of deep integrations with various external services. It can be easily installed and uninstalled.

### What is the difference between a StackPack and an integration?

StackPacks are plugins for StackState which extend the functionality of StackState. StackPacks provide a way to configure StackState in an automated way to integrate with specific systems.

Some StackPacks are designed to connect StackState to external systems. These StackPacks may come with a companion integration that translates data from the external system to data that StackState understands.

### StackPack instances

Some StackPacks make it possible to connect to multiple accounts on an external system. Each account is configured in a separate _instance_ of the StackPack.

For example, the AWS StackPack makes it possible to connect to multiple AWS accounts and combine information from all accounts in StackState. For each account, a separate StackState instance is configured that specifies the information StackState needs to receive data from that AWS account.

### StackPack configuration locking

StackPacks contain configuration information for StackState that is installed when the StackPack \(instance\) is installed. StackPacks can contain component templates, functions, component actions and views among other things. When a StackPack is upgraded to a newer version, **the configuration items installed by the previous version of the StackPack will be overwritten by those from the newer StackPack.**

To prevent a user from making changes to configuration items installed by a StackPack and potentially losing them in an upgrade, the configuration items are initially **locked**. This means that they are protected from being changed by the user. Configuration items must explicitly be **unlocked** before they can be changed.

### Which StackPacks are available?

Navigate to the **StackPacks** section inside StackState or check this page for a list of [available StackPacks](available_stackpacks/).

## Installing StackPacks

Available StackPacks are listed on the StackPacks page in StackState. Before installing a StackPack, please make sure you meet all listed prerequisites.

The following steps describe how to install a StackPack:

* If the StackPack is a multi-instance StackPack, press the **Add New Instance** button.
* Some StackPacks require information such as access credentials for installation. An explanation for each of the required parameters will be provided on the StackPack page.
* Click the **Install** button. The installation process starts and you will see a loading indicator while the installation is in progress.
* If the StackPack connects to an external system, the StackPack may display a screen indicating it is waiting to receive data from the external system. Follow the instructions on the screen to configure the external system to successfully communicate with StackState. When StackState receives the data that it expects, the installation process will complete successfully.
* The StackPack \(instance\) is now successfully installed.

{% hint style="info" %}
The StackPack may require **manual** installation steps or configuration of the external system. Please read the instructions carefully.
{% endhint %}

## Uninstalling StackPacks

{% hint style="danger" %}
When a single-instance StackPack is uninstalled, or when an instance from a multi-instance StackPack is uninstalled, **all data that was received via the StackPack \(instance\) is removed from StackState.**
{% endhint %}

The following steps describe how to uninstall a StackPack:

* Click the **Uninstall** button. The uninstallation process starts and you will see a loading indicator while the uninstallation is in progress.
* The StackPack \(instance\) is now successfully uninstalled.

{% hint style="info" %}
Any \(manual\) configuration or installation of StackPack components in an external system may still need to be uninstalled.
{% endhint %}

