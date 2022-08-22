---
description: StackState Self-hosted v5.0.x 
---

# Subjects

## Link your existing authentication provider to StackState RBAC

StackState is configured by default with file based authentication with predefined roles for Guests \(very limited permission level\), Power Users and Administrators \(full permission level\). To change the configuration to use LDAP authentication, see [authentication docs](../authentication/).

## How to make a new user, or a group, with scopes?

To create a new subject \(a group or a username\), you must follow the `stac` CLI route below. When you create a subject, it has no permissions at first. All custom subjects need a scope by design, so they do not have access to the full topology. This is a security requirement that makes sure that users have access only to what they need.

## Examples

To create the `stackstate` subject with a scope that allows the user to see all elements with the "StackState" label, use the following command:

{% tabs %}
{% tab title="CLI: stac" %}

```text
sts subject save stackstate 'label = "StackState"'
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="CLI: sts (new)" %}

Command not currently available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% endtabs %}

To give more context and specific limitations you can create the subject called `stackstateManager` that also has the scope of `StackState` label and has access to Business Applications within that label, command looks like this:

{% tabs %}
{% tab title="CLI: stac" %}

```text
stac subject save stackstateManager 'label = "StackState" AND type = "Business Application"'
```

⚠️ **PLEASE NOTE -** from StackState v5.0, the old `sts` CLI is called `stac`.

In a future release of StackState, the new `sts` CLI will fully replace the `stac` CLI. It is advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="CLI: sts (new)" %}

Command not currently available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% endtabs %}

Please note that when passing a STQL query in a `stac` CLI command, all operators\( like `=`, `<`,`AND`, and so on\) need to be surrounded by spaces, as in the above example.

Please note that if you are using LDAP authentication, then the subject needs to be provided with a name that exactly matches the username or a group name that is configured in LDAP, as it is case-sensitive.

