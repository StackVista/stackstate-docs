---
description: StackState Self-hosted v4.6.x
---

# Upload a StackPack file

{% hint style="warning" %}
**This page describes StackState version 4.6.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/develop/developer-guides/stackpack/how_to_pack_and_upload_stackpack).
{% endhint %}

The `.sts` file is a zip archive that contains the [StackPack file structure](prepare_package.md). When all files are in place, archive your StackPack directory into a `.zip` file and change its extension to `.sts`.

To upload the `.sts` file to StackState use the [StackState CLI](../../../setup/cli-install.md) with the following command: `sts stackpack upload path/to/file.sts`

