# Subjects

{% hint style="warning" %}
**This page describes StackState version 4.4.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Link your existing authentication provider to StackState RBAC

StackState is configured by default with file based authentication with predefined roles for Guests \(very limited permission level\), Power Users and Administrators \(full permission level\). To change the configuration to use LDAP authentication, see [authentication docs](../authentication/).

## How to make a new user, or a group, with scopes?

To create a new subject \(a group or a username\), you must follow the StackState CLI route below. When you create a subject, it has no permissions at first. All custom subjects need a scope by design, so they do not have access to the full topology. This is a security requirement that makes sure that users have access only to what they need.

## Examples

To create the `stackstate` subject with a scope that allows the user to see all elements with the "StackState" label, use the following command:

```text
sts subject save stackstate 'label = "StackState"'
```

To give more context and specific limitations you can create the subject called `stackstateManager` that also has the scope of `StackState` label and has access to Business Applications within that label, command looks like this:

```text
sts subject save stackstateManager 'label = "StackState" AND type = "Business Application"'
```

Please note that when passing a STQL query in a CLI command, all operators\( like `=`, `<`,`AND`, and so on\) need to be surrounded by spaces, as in the above example.

Please note that if you are using LDAP authentication, then the subject needs to be provided with a name that exactly matches the username or a group name that is configured in LDAP, as it is case sensitive.

