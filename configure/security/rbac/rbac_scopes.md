# Scopes

{% hint style="warning" %}
**This page describes StackState version 4.1. **

The StackState 4.1 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.1 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## How do scopes work?

The scope is an [STQL query](../../../develop/reference/stql_reference.md) that is added as a prefix to every query executed in StackState. Whenever a user wants to select a view or pass a query in StackState, this prefix query is executed as a part of the user's query, limiting the results accordingly to the user's role.

Note: Please note that function calls like `withCauseOf` and `withNeighborsOf` are not supported as they would not be performant in this context.

If a user belongs to multiple groups, then this user can have multiple scopes, which translates to multiple prefixes. In this situation, the prefix is executed as an OR of all scopes that this user has.

Users need to log out and authenticate again to StackState whenever any changes to roles or permissions are made.

## Why scopes?

Scopes are introduced as a security feature that is mandatory for every subject within StackState. Only predefined Admin and Guest roles have no scope defined.

It is possible to provide a scope as a query wildcard which will result in access to everything, however, it is not recommended. If there is a need for access without a scope it is recommended to use Admin or Guest roles instead.

## Examples

The below example shows the same topology view called "All Infrastructure" for four users with different permission levels.

### This user is a part of StackState Admin group, so there is no scope:

![Full view permissions](../../../.gitbook/assets/allperm.png)

The query for this view is the same as for the others, but without any prefix:

```text
'layer = "Infrastructure" AND domain IN ("Customer1", "Customer2")'
```

### Below user is in a group with configured subject X with the following scope:

```text
'domain = "Customer1"'
```

![Limited view](../../../.gitbook/assets/v42_esx1perm%20%282%29.png)

Query with the prefix for this view is:

```text
'(domain = "Customer1") AND (layer = "Infrastructure" AND domain IN ("Customer1", "Customer2"))'
```

### Another user who is a part of a group with a configured subject Y that has the following scope:

```text
'domain = "Customer2"'
```

gets this topology:

![Limited view](../../../.gitbook/assets/esx2perm.png)

Query with the prefix for this view is:

```text
'(domain = "Customer2") AND (layer = "Infrastructure" AND domain IN ("Customer1", "Customer2"))'
```

### User with multiple prefixes

It is possible to assign a subject to more than just one group. In this example, you can see an Infrastructure Manager who can see the whole view presented above. This user has to be in both groups that have configured subjects as X and Y. In this case, the prefix for the user query will look like the following:

```text
'(domain = "Customer1" OR domain = "Customer2")'
```

Query with prefix for this user is then:

```text
'(domain = "Customer1" OR domain = "Customer2") AND (layer = "Infrastructure" AND domain IN ("Customer1", "Customer2"))'
```

Which results in a following view:

![Full view permissions](../../../.gitbook/assets/allperm.png)

