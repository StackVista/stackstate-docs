---
title: StackPacks & integrations
kind: documentation
---

# introduction

## What is a StackPack?

A StackPack is a complete configuration package for StackState that simplifies the setup of deep integrations with various external services. It can be easily installed and uninstalled.

### What is the difference between a StackPack and an integration?

StackPacks are plugins for StackState which extend the functionality of StackState. For now all StackPack's provide a way to configure StackState in an automated way to integrate with specific systems.

### Which StackPacks are available?

Navigate to the **StackPacks** section inside StackState or check this page for a list of [available StackPacks](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/integrations/available_stackpacks/README.md).

## How to install a StackPack or an Integration

Choose the desired StackPack or Integration and proceed to its page. There you can see the overview of the StackPack or an Integration, list of already installed Instances \(if any\) and helpful resources and FAQs. Integrations are provided by a StackPack. To install a specific Integration you will need to install the StackPack that provides it.

Before installation of a StackPack or an Integration please make sure you meet all prerequisites listed on the page.

To install an instance of a StackPack:

* Press **Add new Configuration** button.
* Fill in all the required fields - some of the StackPacks may require such data as credentials, access keys, passwords or any other configuration parameters that can be necessary during installation. An explanation for each of the required parameters will be provided on the StackPack page.
* Click the **Install** button.
* Provisioning of a StackPack may take some time as it potentially installs and configures many different objects for you. You will see a loading indicator while the provisioning is still in-progress.
* After the provisioning is done you may be presented with additional installation instructions to be executed outside of StackState. During this time the StackPack is provisioned but _waiting for data_ so it is not considered installed yet. Follow the instructions to finalize the installation.
* When the Instance receives the data that it expects, it will register itself as installed and the StackPack will be ready to go.

