---
description: StackState Self-hosted v5.0.x 
---

# Manually created topology backup

This page describes the process of exporting and importing manual topology data, i.e. components and relations that are not synchronized via StackPacks.

**Requirements**

* [StackState CLI](/setup/cli/README.md)
* Unix shell

## Export manually created topology

To export all manually created components and relations to a file `manual_topo.stj` using the [StackState CLI](/setup/cli/README.md):

{% tabs %}
{% tab title="CLI: stac" %}

1. Create the export file:

   ```text
   stac graph list --manual --ids Component Relation \
   | xargs \
   stac graph export --ids \
   > manual_topo.stj
   ```

2. Check the generated file `manual_topo.stj` to make sure it contains a correct export of all your topology.

Breakdown of the export command used in the example above:

* `stac graph list --manual --ids Component Relation` lists all ids of manually created components and relations.
* `| xargs` connects the `graph list` and `graph export` commands.
* `stac graph export --ids` exports all graph nodes by ids.
* `> manual_topo.stj` dumps the results in the file `manual_topo.stj`.

**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
{% endtab %}
{% tab title="CLI: sts (new)" %}

Command not currently available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% endtabs %}

## Import manually created topology

{% hint style="info" %}
Manually created relations to synchronized components may fail on import if these synchronized components do not exist anymore.
{% endhint %}

To import topology and relation data from a file `manual_topo.stj` using the [StackState CLI](/setup/cli/README.md):

```text
sts graph import < manual_topo.stj
```

