---
description: Rancher Observability Self-hosted v5.1.x
---

# Upload a StackPack file

The `.sts` file is a zip archive that contains the [StackPack file structure](prepare_package.md). When all files are in place, archive your StackPack directory into a `.zip` file and change its extension to `.sts`.

To upload the `.sts` file to Rancher Observability use the [Rancher Observability CLI](../../../setup/cli/README.md) with the following command: `

{% tabs %}
{% tab title="CLI: sts" %}

```sh
sts stackpack upload --file <PATH_TO_FILE.sts>
```

From Rancher Observability v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "Rancher Observability Self-Hosted only")
{% endtab %}
{% tab title="CLI: stac (deprecated)" %}

```text
stac stackpack upload <PATH_TO_FILE.sts>
```

⚠️ **From Rancher Observability v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "Rancher Observability Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "Rancher Observability Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "Rancher Observability Self-Hosted only")

{% endtab %}
{% endtabs %}

