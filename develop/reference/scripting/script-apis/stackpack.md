---
description: StackState Self-hosted v5.0.x 
---

# StackPack - script API

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

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)

Command not currently available in the new `sts` CLI.
{% endtab %}
{% tab title="CLI: stac" %}

```text
stac stackpack list
```

**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
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

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)

Command not currently available in the new `sts` CLI.
{% endtab %}
{% tab title="CLI: stac" %}

```text
stac graph list-types
```

**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
{% endtab %}
{% endtabs %}

### Examples

The example below will return an `AsyncScriptResult` of an array of resources with type `QueryView` from the `agent` StackPack.

```text
StackPack.getResources("agent", "QueryView")
```

