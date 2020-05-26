---
title: How to pack and upload a StackPack
kind: Documentation
---

# StackPack file upload

The `.sts` file is a zip archive that contains the [StackPack file structure](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/develop/stackpack/prepare_package/README.md). When all files are in place, archive your StackPack directory into a `.zip` file and change its extension to `.sts`.

To upload the `.sts` file to StackState use the [StackState CLI](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/cli/README.md) with the following command: `sts stackpack upload path/to/file.sts`

