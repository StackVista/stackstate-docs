---
title: Splunk Topology Integration
kind: documentation
---

## Overview

The StackState Agent can execute Splunk queries and convert the result to topology elements, which are then synchronized to StackState. The StackState Agent expects the `saved searches` to return the latest snapshot of the topology.

In order for the StackState Agent to be able to convert the results to topology elements, the output of the query has to be according to the format below. The format describes specific columns in the output that, when present, are used for the topology element. Other columns that are present in the output format, not defined in the query
format, are available as key-value-pairs in StackState inside the `data` map. The column names are used as keys and the content as value. Splunk internal fields are filtered out by the StackState Agent)

### Components Query Format

<table class="table">
<tr><td><strong>id</strong></td><td>string</td><td>The unique identifier for this component.</td></tr>
<tr><td><strong>type</strong></td><td>string</td><td>The type of the component.</td></tr>
<tr><td><strong>name</strong></td><td>string</td><td>The value will be used as component name.</td></tr>
<tr><td><strong>identifier.&lt;identifier name></strong></td><td>string</td><td>The value will be included as identifier of the component.</td></tr>
<tr><td><strong>label.&lt;label name></strong></td><td>string</td><td>The value will appear as label of the component.</td></tr>
</table>

\* This format assumes you use the default Splunk mapping function and identity extractor in StackState. By customizing these you can create your own format.

Example Splunk query:

```
| loadjob savedsearch=:servers
| search OrganizationPart="*" OrgGrp="*" company="*"
| table name | dedup name
| eval name = upper(name)
| eval id = 'name', type="vm"
| table id type name
```

### Relations Query Format

<table class="table">
<tr><td><strong>type</strong></td><td>string</td><td>The type of the relation.</td></tr>
<tr><td><strong>sourceId</strong></td><td>string</td><td>The id of the component that is the source of this relation.</td></tr>
<tr><td><strong>targetId</strong></td><td>string</td><td>The id of the component that is the target of this relation.</td></tr>
</table>

Example Splunk query:

```
index=cmdb_icarus source=cmdb_ci_rel earliest=-3d
| eval VMName=lower(VMName)
| rename Application as sourceId, VMName as targetId
| eval type="is-hosted-on"
| table sourceId targetId type
```

## Configuration

There is an attribute `ignore_saved_search_errors` inside the `Splunk_topology.yaml` which is set to `true` by default. This flag makes the agent less strict and allows for saved searches which might be missing or fail when running. If this flag is set to `false` and one of the saved searches don't exist, it will produce an error.

1.  Edit your conf.d/Splunk_topology.yaml file.
2.  Restart the agent

{{< insert-example-links >}}
