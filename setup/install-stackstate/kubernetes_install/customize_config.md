---
description: StackState Self-hosted v4.6.x
---

# Override default configuration

{% hint style="warning" %}
**This page describes StackState version 4.6.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/setup/install-stackstate/kubernetes_install/customize_config).
{% endhint %}

A number of values can be set in the [StackState Helm chart](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate). For example, it is possible to customize the `tolerations` and `nodeSelectors` for each of the components. You can also add customized configuration and include environment variables

## Custom configuration for StackState `api`

For the StackState `api` service, custom configuration can be dropped directly into the Helm chart. This is the advised way to override the default configuration that StackState ships with and is especially convenient for customizing authentication. Configuration set in this way will be available to the StackState configuration file in [HOCON](https://github.com/lightbend/config/blob/master/HOCON.md) format.

For example, you can set a custom "forgot password link" for the StackState login page:

{% tabs %}
{% tab title="values.yaml" %}
```text
stackstate:
  components:
    api:
      config: |
        stackstate.api.authentication.forgotPasswordLink =
        "https://www.stackstate.com/forgotPassword.html"
```
{% endtab %}
{% endtabs %}

{% hint style="info" %}
Note that custom configuration set here will be overridden by [environment variables](customize_config.md#environment-variables).
{% endhint %}

## Environment variables

The configuration for all of the StackState services \(`receiver`, `k2es-*`, `correlation` and `api`\) can be customized using environment variables. Environment variables are specified in the `values.yaml` file and can be either `secret` \(such as passwords\) or `open` \(for normal values\). To convert a configuration item to an environment variable name, replace `.` with `_` and add the prefix `CONFIG_FORCE_`.

```text
# configuration item
stackstate.api.authentication.forgotPasswordLink

# environment variable name
CONFIG_FORCE_stackstate_api_authentication_forgotPasswordLink
```

For example, you can set a custom "forgot password link" for the StackState login page:

{% tabs %}
{% tab title="values.yaml" %}
```text
stackstate:
  components:
    api:
      extraEnv:
        # Use 'secret:' to add configuration that should be stored as a secret
        open:
          CONFIG_FORCE_stackstate_api_authentication_forgotPasswordLink:
          "https://www.stackstate.com/forgotPassword.html"
```
{% endtab %}
{% endtabs %}

{% hint style="info" %}
For the StackState `api` service, environment variables will override [custom configuration set using `config`](customize_config.md#custom-configuration-for-stackstate-api).
{% endhint %}

* Full details on the naming of all the different services can be found in the in the [StackState Helm chart readme](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate).
* Find more details on [customizing authentication](../../../configure/security/authentication/).

