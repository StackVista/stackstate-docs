---
description: StackState Self-hosted v5.0.x 
---

# StackPack - script API

{% hint style="warning" %}
**This page describes StackState version 5.0.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/develop/reference/scripting/script-apis/stackpack).
{% endhint %}

The StackPack script API provides handy operations to get the status of a StackPack or resources that are provided by a StackPack.

## Function: `isInstalled`

Returns a flag indicating if the StackPack is installed

### Args

* `name` - the name of a StackPack. This much match exactly \(case sensitive\). The name of a StackPack can be found in the breadcrumb trail of the StackPack in the StackState UI or can be retrieved using [StackState CLI](../../../../setup/cli/README.md) command: 

{% tabs %}
{% tab title="CLI: sts (new)" %}

```commandline
sts stackpack list
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI has been renamed to`stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}
{% tab title="CLI: stac" %}

```text
stac stackpack list
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% endtabs %}

### Examples

The example below will return an `AsyncScriptResult` of a boolean indicating if the `agent` StackPack is installed

```text
StackPack.isInstalled("agent")
```

## Function: `getResources`

Returns resources originating from the StackPack.

### Args

* `stackPackNamespace` - the name of the URN namespace of the StackPack. For example `aad` checks for resources in the namespace `urn:stackpack:aad`.
* `nodeType` - the type of node, for example `CheckFunction` or `QueryView`. You can get a full listing of all using the [StackState CLI](../../../../setup/cli/README.md) command:

{% tabs %}
{% tab title="CLI: sts (new)" %}

```commandline
sts settings list-types
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI has been renamed to`stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
{% endtab %}
{% tab title="CLI: stac" %}

```text
stac graph list-types
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% endtabs %}

### Examples

The example below will return an `AsyncScriptResult` of an array of resources with type `QueryView` from the `agent` StackPack.

```text
StackPack.getResources("agent", "QueryView")
```

