---
description: Rancher Observability Self-hosted v5.1.x
---

# StackPack - script API

The StackPack script API provides handy operations to get the status of a StackPack or resources that are provided by a StackPack.

## Function: `StackPack.isInstalled(name: String)`

Returns a flag indicating if the StackPack is installed

### Args

* `name` - the name of a StackPack. This much match exactly \(case-sensitive\). The name of a StackPack can be found in the breadcrumb trail of the StackPack in the Rancher Observability UI or can be retrieved using [Rancher Observability CLI](../../../../setup/cli/README.md) command:

{% tabs %}
{% tab title="CLI: sts" %}

```sh
sts stackpack list
```

From Rancher Observability v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "Rancher Observability Self-Hosted only")
{% endtab %}
{% tab title="CLI: stac (deprecated)" %}

```text
stac stackpack list
```

⚠️ **From Rancher Observability v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "Rancher Observability Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "Rancher Observability Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "Rancher Observability Self-Hosted only")

{% endtab %}
{% endtabs %}

### Examples

The example below will return an `AsyncScriptResult` of a boolean indicating if the `agent` StackPack is installed

```text
StackPack.isInstalled("agent")
```

## Function: `StackPack.getResources(stackPackNamespace: String, nodeType: String)`

Returns resources originating from the StackPack.

### Args

* `stackPackNamespace` - the name of the URN namespace of the StackPack. For example `aad` checks for resources in the namespace `urn:stackpack:aad`.
* `nodeType` - the type of node, for example `CheckFunction` or `QueryView`. You can get a full listing of all using the [Rancher Observability CLI](../../../../setup/cli/README.md) command:

{% tabs %}
{% tab title="CLI: sts" %}

```sh
sts settings list-types
```

From Rancher Observability v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "Rancher Observability Self-Hosted only")
{% endtab %}
{% tab title="CLI: stac (deprecated)" %}

```text
stac graph list-types
```

⚠️ **From Rancher Observability v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "Rancher Observability Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "Rancher Observability Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "Rancher Observability Self-Hosted only")

{% endtab %}
{% endtabs %}

### Examples

The example below will return an `AsyncScriptResult` of an array of resources with type `QueryView` from the `agent` StackPack.

```text
StackPack.getResources("agent", "QueryView")
```

