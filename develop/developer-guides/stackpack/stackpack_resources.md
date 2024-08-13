---
description: Rancher Observability Self-hosted v5.1.x 
---

# Resources in a StackPack

The resources reside in `<your-stackpack>/src/main/stackpack/resources` directory. This folder has files to be used mostly as display assets in the Rancher Observability UI as steps during the StackPack installation process. Some of the files are required for a StackPack to be displayed correctly:

* `logo.png` - an image file with the StackPack logo that's displayed on the StackPacks page in Rancher Observability.
* `overview.md` - a Markdown text file with general information about the StackPack.
* `configuration.md` - a Markdown text file with information about how to configure a StackPack instance.

  This is a piece of information the user is going to see in the first step of the installation process.

* `waitingfordata.md` - a Markdown text file with information about user actions required for the StackPack instance to start receiving data.

  This is a piece of information the user is going to see in the second step of the installation process.

* `enabled.md` - a Markdown text file explaining that the StackPack instance has been installed successfully.

  Should also contain information on how to uninstall the instance.

  This is a piece of information the user is going to see in the final step of the installation process.

* `detailed-overview.md` - a Markdown text file with general information the user needs to know to use a StackPack instance, for example, prerequisites or access rights. To achieve a two-column layout, there is a special `[comment]: # (split)` tag. Inserting this tag in a particular place will cause the text to be split into two columns in this place.
* `provisioning.md` - a Markdown text file with a piece of information the user is going to see during the installation process.
* `deprovisioning.md` - a Markdown text file with a piece of information the user is going to see during the uninstallation process.
* `error.md` - a Markdown text file with an error message to show when an error occurred during provisioning of the StackPack.

