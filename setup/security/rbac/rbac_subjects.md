---
description: StackState for Kubernetes troubleshooting Self-hosted
---

# Subjects

## Link your existing authentication provider to StackState RBAC

StackState is configured by default with file based authentication with predefined roles for Guests \(very limited permission level\), Power Users and Administrators \(full permission level\). To change the configuration to use an external authentication provider, see [authentication docs](../authentication/).

## How to make a new user or group with scopes

To create a new subject \(a group or a username\), you must follow the `sts` CLI route below. When you create a subject, it has no permissions at first. All custom subjects need a scope by design, so they don't have access to the full topology. This is a security requirement that makes sure that users have access only to what they need.

**Examples**

* Create the `stackstate` subject with a scope that allows the user to see all elements with the `StackState` label:

```text
sts rbac create-subject --subject stackstate --scope 'label = "StackState"'
```

* Give more context and specific limitations, create the subject `stackstateManager` with the same scope of the `StackState` label and additional access to Business Applications within that label:

```text
sts rbac create-subject --subject stackstateManager --scope 'label = "StackState" AND type = "Business Applications"'
```

{% hint style="info" %}
**NOTE:**

* When passing an STQL query in a `sts` CLI command, all operators \( such as `=`, `<`,`AND`, and so on\) need to be surrounded by spaces, as in the above example.
* For LDAP authentication, the subject name must exactly match the username or group name configured in LDAP (case-sensitive).
{% endhint %}
