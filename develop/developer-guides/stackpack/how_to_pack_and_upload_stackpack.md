---
description: StackState Self-hosted v5.1.x 
---

# Upload a StackPack file

The `.sts` file is a zip archive that contains the [StackPack file structure](prepare_package.md). When all files are in place, archive your StackPack directory into a `.zip` file and change its extension to `.sts`.

To upload the `.sts` file to StackState use the [StackState CLI](../../../setup/cli/README.md) with the following command: `

{% tabs %}
{% tab title="CLI: sts (new)" %}

```commandline
sts stackpack upload --file <PATH_TO_FILE.sts>
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI has been renamed to`stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}
{% tab title="CLI: stac" %}

```text
stac stackpack upload <PATH_TO_FILE.sts>
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% endtabs %}

