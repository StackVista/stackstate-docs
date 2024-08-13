---
description: Rancher Observability Self-hosted
---

# Override default configuration

A number of values can be set in the [Rancher Observability Helm chart](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate-k8s). For example, it's possible to customize the `tolerations` and `nodeSelectors` for each of the components. You can also add customized configuration and include environment variables

## Custom configuration for Rancher Observability `api`

For the Rancher Observability `api` service, custom configuration can be dropped directly into the Helm chart. This is the advised way to override the default configuration that Rancher Observability ships with and is especially convenient for customizing authentication. Configuration set in this way will be available to the Rancher Observability configuration file in [HOCON](https://github.com/lightbend/config/blob/master/HOCON.md) format.

For example, you can set a custom "forgot password link" for the Rancher Observability login page:

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

The configuration for all of the Rancher Observability services \(`receiver`, `k2es-*`, `correlation` and `api`\) can be customized using environment variables. Environment variables are specified in the `values.yaml` file and can be either `secret` \(such as passwords\) or `open` \(for normal values\). To convert a configuration item to an environment variable name, replace `.` with `_` and add the prefix `CONFIG_FORCE_`.

```text
# configuration item
stackstate.api.authentication.forgotPasswordLink

# environment variable name
CONFIG_FORCE_stackstate_api_authentication_forgotPasswordLink
```

For example, you can set a custom "forgot password link" for the Rancher Observability login page:

{% tabs %}
{% tab title="values.yaml" %}
```text
stackstate:
  components:
    api:
      extraEnv:
        # The value for open env vars is defined on the deployment
        open:
          CONFIG_FORCE_stackstate_api_authentication_forgotPasswordLink: "https://www.stackstate.com/forgotPassword.html"
        # The value for secret env vars is defined in a secret and referenced from the deployment
        secret:
          CONFIG_FORCE_stackstate_authentication_adminPassword: "d8e8fca2dc0f896fd7cb4cb0031ba249"
```
{% endtab %}
{% endtabs %}

{% hint style="info" %}
For the Rancher Observability `api` service, environment variables will override [custom configuration set using `config`](customize_config.md#custom-configuration-for-stackstate-api).
{% endhint %}

* Full details on the naming of all the different services can be found in the [Rancher Observability Helm chart readme](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate-k8s).
* Find more details on [customizing authentication](../../security/authentication/README.md).

