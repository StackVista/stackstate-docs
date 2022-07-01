---
description: StackState Self-hosted v5.0.x 
---

# How to get a template file

## Export the StackState configuration

You can get a complete dump of all configuration using the StackState CLI:

{% tabs %}
{% tab title="CLI: sts (new)" %}

```commandline
sts settings describe --file <PATH_TO_FILE.stj>
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)

Command not currently available in the new `sts` CLI.
{% endtab %}
{% tab title="CLI: stac" %}
```text
stac graph export > <PATH_TO_FILE.stj>
```

**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
{% endtab %}
{% endtabs %}

Follow the preparation steps below to prepare the `.stj` file, such that it contains only configuration nodes pertaining to your StackPack.

If all of your configuration nodes already have been assigned to the right namespace you can get all the nodes of your StackPack using the command: 

{% tabs %}
{% tab title="CLI: sts (new)" %}

```commandline
sts settings describe --namespace <NAMESPACE> --file <PATH_TO_FILE.stj>
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)

Command not currently available in the new `sts` CLI.
{% endtab %}
{% tab title="CLI: stac" %}

```text
stac graph export --namespace <namespace> > <PATH_TO_FILE.stj>
```

**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
{% endtab %}
{% endtabs %}



## Prepare the template file

A `.stj` file contains a number of configuration nodes. Each of the configuration nodes represents a configuration item in StackState, for example Layer, Domain and Environment. This file contains all of the configuration of your StackState instance, which means you have to take out configuration nodes that are unnecessary for your StackPack. Take the steps below to prepare your template file:

* Remove all configuration nodes that are owned by another StackPack. They all have a field called `ownedBy`.
* Items that are extended from the `Custom Synchronization` StackPack, will have their urn `identifier` field with the following structure: `urn:stackpack:autosync:{type_name}:{object_name}`.
* StackState uses an urn-based identifiers, you can go ahead and define an urn for each of your configuration objects.
  * Typical `identifier` pattern that you can find across our StackPacks configuration is: `urn:stackpack:{stackpack_name}:{type_name}:{object_name}`
  * For StackPacks that can have multiple instances, the identifier has a slightly different pattern: `urn:stackpack:{stackpack_name}:instance:{{instanceId}}:{type_name}:{object_name}` where `{{instanceId}}` is uniquely generated for every instance of the StackPack.

The only way to add/modify the identifiers is the manual edit of the configuration file. This option will be available also through the UI starting from the 1.15 release.

