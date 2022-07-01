---
description: StackState Self-hosted v5.0.x 
---

# Upload a StackPack file

The `.sts` file is a zip archive that contains the [StackPack file structure](prepare_package.md). When all files are in place, archive your StackPack directory into a `.zip` file and change its extension to `.sts`.

To upload the `.sts` file to StackState use the [StackState CLI](../../../setup/cli/README.md) with the following command: `

{% tabs %}
{% tab title="CLI: sts (new)" %}

```commandline
sts stackpack upload --file <PATH_TO_FILE.sts>
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)

Command not currently available in the new `sts` CLI.
{% endtab %}
{% tab title="CLI: stac" %}

```text
stac stackpack upload <PATH_TO_FILE.sts>
```

**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
{% endtab %}
{% endtabs %}

