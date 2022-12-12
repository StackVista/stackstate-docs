---
description: StackState Self-hosted v5.1.x
---

# Subjects

## Link your existing authentication provider to StackState RBAC

StackState is configured by default with file based authentication with predefined roles for Guests \(very limited permission level\), Power Users and Administrators \(full permission level\). To change the configuration to use LDAP authentication, see [authentication docs](../authentication/).

## How to make a new user or group with scopes

To create a new subject \(a group or a username\), you must follow the `stac` CLI route below. When you create a subject, it has no permissions at first. All custom subjects need a scope by design, so they don't have access to the full topology. This is a security requirement that makes sure that users have access only to what they need.

**Examples**

* Create the `stackstate` subject with a scope that allows the user to see all elements with the `StackState` label:

{% tabs %}
{% tab title="CLI: sts" %}
{% hint style="info" %}
From StackState v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endhint %}

```text
sts rbac create-subject --subject stackstate --scope 'label = "StackState"'
```

{% endtab %}
{% tab title="CLI: stac (deprecated)" %}
{% hint style="warning" %}
**From StackState v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")
{% endhint %}

```text
stac subject save stackstate 'label = "StackState"'
```
{% endtab %}
{% endtabs %}


* Give more context and specific limitations, create the subject `stackstateManager` with the same scope of the `StackState` label and additional access to Business Applications within that label:

{% tabs %}
{% tab title="CLI: sts" %}
{% hint style="info" %}
From StackState v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endhint %}

```text
sts rbac create-subject --subject stackstateManager --scope 'label = "StackState" AND type = "Business Applications"'
```

{% endtab %}
{% tab title="CLI: stac (deprecated)" %}
{% hint style="warning" %}
**From StackState v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")
{% endhint %}

```text
stac subject save stackstateManager 'label = "StackState" AND type = "Business Applications"'
```
{% endtab %}
{% endtabs %}


{% hint style="info" %}
**NOTE:**

* When passing an STQL query in a `stac` or `sts` CLI command, all operators \( such as `=`, `<`,`AND`, and so on\) need to be surrounded by spaces, as in the above example.
* For LDAP authentication, the subject name must exactly match the username or group name configured in LDAP (case-sensitive).
{% endhint %}
